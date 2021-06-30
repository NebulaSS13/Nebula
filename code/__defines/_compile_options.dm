// The default value for all uses of set background. Set background can cause gradual lag and is recommended you only turn this on if necessary.
// 1 will enable set background. 0 will disable set background.
#define BACKGROUND_ENABLED 0

#define REQUIRED_DM_VERSION 513

#if DM_VERSION < REQUIRED_DM_VERSION
#warn Nebula is not tested on BYOND versions older than 513. The code may not compile, and if it does compile it may have severe problems.
#endif

// Log the full sendmaps profile on 514.1556+, any earlier and we get bugs or it not existing.
#if DM_VERSION >= 514 && DM_BUILD >= 1556
#define SENDMAPS_PROFILE
#endif
