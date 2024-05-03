// Language flags.
#define LANG_FLAG_WHITELISTED  BITFLAG(0)  // Language is available if the speaker is whitelisted.
#define LANG_FLAG_RESTRICTED   BITFLAG(1)  // Language can only be acquired by spawning or an admin.
#define LANG_FLAG_NONVERBAL    BITFLAG(2)  // Language has a significant non-verbal component. Speech is garbled without line-of-sight.
#define LANG_FLAG_SIGNLANG     BITFLAG(3)  // Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define LANG_FLAG_HIVEMIND     BITFLAG(4)  // Broadcast to all mobs with this language.
#define LANG_FLAG_NONGLOBAL    BITFLAG(5)  // Do not add to general languages list.
#define LANG_FLAG_INNATE       BITFLAG(6)  // All mobs can be assumed to speak and understand this language. (audible emotes)
#define LANG_FLAG_NO_TALK_MSG  BITFLAG(7)  // Do not show the "\The [speaker] talks into \the [radio]" message
#define LANG_FLAG_NO_STUTTER   BITFLAG(8)  // No stuttering, slurring, or other speech problems
#define LANG_FLAG_ALT_TRANSMIT BITFLAG(9)  // Language is not based on vision or sound (Todo: add this into the say code and use it for the rootspeak languages)
#define LANG_FLAG_FORBIDDEN    BITFLAG(10) // Language is not to be granted to a mob under any circumstances.
