#define TOPIC_NOACTION       0
#define TOPIC_HANDLED        BITFLAG(0)
#define TOPIC_REFRESH        BITFLAG(1)
#define TOPIC_UPDATE_PREVIEW BITFLAG(2)
/// Return this to force a browse() call, unblocking some rsc operations
#define TOPIC_HARD_REFRESH   BITFLAG(3)
/// Return this to indicate the window associated with this Topic() call should be closed.
#define TOPIC_CLOSE          BITFLAG(4)
#define TOPIC_REFRESH_UPDATE_PREVIEW (TOPIC_HARD_REFRESH|TOPIC_UPDATE_PREVIEW)
