// Make whetstones available for the fantasy modpack/
#ifdef MODPACK_ITEM_SHARPENING
#include "fantasy/whetstone_fantasy.dm"
#endif

#ifdef MODPACK_BLACKSMITHY
#include "fantasy/forging_fantasy.dm"
#endif

#ifdef MODPACK_UNDEAD
#include "fantasy/undead_fantasy.dm"
#endif

// Override hawk handling skill.
#ifdef MODPACK_BIRDS
#include "fantasy/bird_fantasy.dm"
#endif
