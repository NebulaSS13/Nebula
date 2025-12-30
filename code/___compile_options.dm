// If REFTRACK_IN_CI is defined, the reftracker will run in CI.
#define REFTRACK_IN_CI
#if defined(REFTRACK_IN_CI) && defined(UNIT_TEST) && !defined(SPACEMAN_DMM)
#define REFTRACKING_ENABLED
#define GC_FAILURE_HARD_LOOKUP
#define FIND_REF_NO_CHECK_TICK
#endif

// parity with previous behavior where TESTING enabled reftracking
#ifdef TESTING
#define REFTRACKING_ENABLED
#endif