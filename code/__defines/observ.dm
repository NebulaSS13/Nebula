// This also works, and removes the need for the _REPEAT variant, but the linter hates it:
//   #define RAISE_EVENT(OBS, args...) (GET_DECL(OBS))?.raise_event(args);
#define RAISE_EVENT(OBS, args...) var/decl/observ/__event = GET_DECL(OBS); __event?.raise_event(args);
#define RAISE_EVENT_REPEAT(OBS, args...) __event = GET_DECL(OBS); __event?.raise_event(args);
