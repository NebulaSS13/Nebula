#define GET_STATUS(MOB, COND)          (LAZYACCESS(MOB.status_counters, COND))
#define HAS_STATUS(MOB, COND)          ((LAZYACCESS(MOB.pending_status_counters, COND) || LAZYACCESS(MOB.status_counters, COND)) > 0)
#define ADJ_STATUS(MOB, COND, AMT)     (MOB.set_status(COND, HAS_STATUS(MOB, COND) + AMT))
#define SET_STATUS_MAX(MOB, COND, AMT) (MOB.set_status(COND, max(HAS_STATUS(MOB, COND), AMT)))
