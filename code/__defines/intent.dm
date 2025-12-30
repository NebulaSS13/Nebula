// Intent bitflags for use in check_intent()
#define I_FLAG_HELP   BITFLAG(0)
#define I_FLAG_DISARM BITFLAG(1)
#define I_FLAG_GRAB   BITFLAG(2)
#define I_FLAG_HARM   BITFLAG(3)
#define I_FLAG_ALL    (I_FLAG_HELP|I_FLAG_DISARM|I_FLAG_GRAB|I_FLAG_HARM)

//NOTE: INTENT_HOTKEY_* defines are not actual intents!
//they are here to support hotkeys
#define INTENT_HOTKEY_LEFT  "left"
#define INTENT_HOTKEY_RIGHT "right"
