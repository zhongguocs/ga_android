#include <iostream>
#include <condition_variable>
#include <chrono>
#include <mutex>

#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <Minicap.hpp>

#include <string.h>
#include <strings.h>
//#include "ga-avcodec.h"
#include "ga-androidvideo.h"

#include "JpgEncoder.h"

#define DEFAULT_DISPLAY_ID 0

class FrameWaiter: public Minicap::FrameAvailableListener {
public:
  FrameWaiter()
    : mPendingFrames(0),
      mTimeout(std::chrono::milliseconds(100)),
      mStopped(false) {
  }

  int
  waitForFrame() {
    std::unique_lock<std::mutex> lock(mMutex);

    while (!mStopped) {
      if (mCondition.wait_for(lock, mTimeout, [this]{return mPendingFrames > 0;})) {
        return mPendingFrames--;
      }
    }

    return 0;
  }

  void
  reportExtraConsumption(int count) {
    std::unique_lock<std::mutex> lock(mMutex);
    mPendingFrames -= count;
  }

  void
  onFrameAvailable() {
    std::unique_lock<std::mutex> lock(mMutex);
    mPendingFrames += 1;
    mCondition.notify_one();
  }

  void
  stop() {
    mStopped = true;
  }

  bool
  isStopped() {
    return mStopped;
  }

private:
  std::mutex mMutex;
  std::condition_variable mCondition;
  std::chrono::milliseconds mTimeout;
  int mPendingFrames;
  bool mStopped;
};

static FrameWaiter gWaiter;

Minicap *ga_androidvideo_init()
{
	Minicap *minicap = NULL;
	uint32_t displayId = DEFAULT_DISPLAY_ID;
	uint32_t realWidth = 1920;
	uint32_t realHeight = 1080;
	uint32_t virtualWidth = 1920;
	uint32_t virtualHeight = 1080;
	uint32_t rotation = 0;

	// Start Android's thread pool so that it will be able to serve our requests.
	minicap_start_thread_pool();

	// Set real display size.
	Minicap::DisplayInfo realInfo;
	realInfo.width = realWidth;
	realInfo.height = realHeight;

	// Figure out desired display size.
	Minicap::DisplayInfo desiredInfo;
	desiredInfo.width = virtualWidth;
	desiredInfo.height = virtualHeight;
	desiredInfo.orientation = rotation;

	// Set up minicap.
	minicap = minicap_create(displayId);
	if (minicap == NULL) {
		return NULL;
	}

	if (minicap->setRealInfo(realInfo) != 0) {
		ga_error("Minicap did not accept real display info");
		goto disaster;
	}

	if (minicap->setDesiredInfo(desiredInfo) != 0) {
		ga_error("Minicap did not accept desired display info");
		goto disaster;
	}

	minicap->setFrameAvailableListener(&gWaiter);

	if (minicap->applyConfigChanges() != 0) {
		ga_error("Unable to start minicap with current config");
		goto disaster;
	}

	return minicap;

disaster:
	minicap_free(minicap);

	return NULL;
}

static AVPixelFormat convertFormat(Minicap::Format format) {
  switch (format) {
  case Minicap::FORMAT_RGBA_8888:
    return AV_PIX_FMT_RGBA;
  case Minicap::FORMAT_RGBX_8888:
    return AV_PIX_FMT_RGB0;
  case Minicap::FORMAT_BGRA_8888:
    return AV_PIX_FMT_BGRA;
  case Minicap::FORMAT_RGB_888:
    return AV_PIX_FMT_RGB24;
  default:
    //throw std::runtime_error("Unsupported pixel format");
    return AV_PIX_FMT_NONE;
  }
}

static int
pumpf(int fd, unsigned char* data, size_t length) {
  do {
    int wrote = write(fd, data, length);

    if (wrote < 0) {
      return wrote;
    }

    data += wrote;
    length -= wrote;
  }
  while (length > 0);

  return 0;
}

int ga_androidvideo_capture(Minicap *minicap, vsource_frame_t *vframe)
{
	int err;
	Minicap::Frame frame;

	if (!gWaiter.waitForFrame()) {
		ga_error("Unable to wait for frame");
		return EXIT_FAILURE;
	}

	if ((err = minicap->consumePendingFrame(&frame)) != 0) {
		ga_error("Unable to consume pending frame");
		return EXIT_FAILURE;
	}

	vframe->realwidth = frame.width;
	vframe->realheight = frame.height;
	vframe->realstride = frame.width << 2;
	vframe->realsize = frame.size;
	vframe->linesize[0] = vframe->realstride;
	vframe->pixelformat = convertFormat(frame.format);

	//ga_error("%s:size=%d, frame.data=%p, imgbuf=%p\n", __func__, frame.size, frame.data, vframe->imgbuf);
	bcopy(frame.data, vframe->imgbuf, frame.size);
#if 0
    static int capture_static = 0;
    int fd1, fd2;
    JpgEncoder encoder(4, 0);

    if (!capture_static) {
    JpgEncoder encoder(4, 0);
    if (!encoder.reserveData(1920, 1080)) {
      ga_error("Unable to reserve data for JPG encoder");
    }

    fd1 = open("/data/GA/capture.jpg", O_CREAT | O_RDWR, 0644);
    if (fd1 < 0) {
      ga_error("Unable to open file\n");
    }
    fd2 = open("/data/GA/capture.rgb", O_CREAT | O_RDWR, 0644);
    if (fd2 < 0) {
      ga_error("Unable to open file\n");
    }

    if (!encoder.encode(&frame, 80)) {
      ga_error("Unable to encode frame\n");
    }

    if (pumpf(fd1, encoder.getEncodedData(), encoder.getEncodedSize()) < 0) {
      ga_error("Unable to output encoded frame data\n");
    }

    if (pumpf(fd2, vframe->imgbuf, frame.size) < 0) {
      ga_error("Unable to output encoded frame data\n");
    }

    capture_static++;
    close(fd1);
    close(fd2);
    }
#endif
	minicap->releaseConsumedFrame(&frame);

	return EXIT_SUCCESS;
}

void ga_androidvideo_deinit(Minicap *minicap)
{
	minicap_free(minicap);
}

