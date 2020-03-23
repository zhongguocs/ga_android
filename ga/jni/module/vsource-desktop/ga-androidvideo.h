#ifndef __XGA_ANDROIDVIDEO_H__
#define __XGA_ANDROIDVIDEO_H__

#include "ga-common.h"

#ifdef __cplusplus
extern "C" {
#endif
int ga_androidvideo_init(struct gaImage *image);
void ga_androidvideo_capture(char *buf, int buflen);
void ga_androidvideo_deinit();

inline int ga_androidvideo_init(struct gaImage *image) {return 0;}
inline void ga_androidvideo_capture(char *buf, int buflen){}
inline void ga_androidvideo_deinit(){}
#ifdef __cplusplus
}
#endif

#endif
