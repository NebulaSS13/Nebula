#define LANDMARK_IS_UNIQUE       BITFLAG(0) // There may be at most 1 instance of this landmark
#define LANDMARK_IS_MANDATORY    BITFLAG(1) // There must be more than 0 instances of this landmark
#define LANDMARK_HAS_UNIQUE_AREA BITFLAG(2) // This landmark may not share area with other landmarks which also have this flag
