#define REQUIRED_DM_VERSION 516

#if DM_VERSION < REQUIRED_DM_VERSION
#warn Nebula is not tested on BYOND versions older than 516. The code may not compile, and if it does compile it may have severe problems.
#endif