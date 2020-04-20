#ifndef __XGA_ANDROIDVIDEO_H__
#define __XGA_ANDROIDVIDEO_H__

#include "ga-common.h"
#include "vsource.h"
#include <Minicap.hpp>

Minicap *ga_androidvideo_init();
int ga_androidvideo_capture(Minicap *minicap, vsource_frame_t *vframe);
void ga_androidvideo_deinit(Minicap *minicap);
#endif
