#define RAISE_EVENT(OBS, args...) UNLINT((GET_DECL(OBS))?.raise_event(args));
