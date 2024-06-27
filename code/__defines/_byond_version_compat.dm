#define REQUIRED_DM_VERSION 515

#if DM_VERSION < REQUIRED_DM_VERSION
#warn Nebula is not tested on BYOND versions older than 515. The code may not compile, and if it does compile it may have severe problems.
#endif