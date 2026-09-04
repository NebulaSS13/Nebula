#ifdef GAMEMODE_PACK_MERCENARY
#ifdef GAMEMODE_PACK_HEIST
#include "mixed_gamemodes/crossfire.dm"
#endif // #ifdef GAMEMODE_PACK_HEIST
#ifdef GAMEMODE_PACK_REVOLUTIONARY
#include "mixed_gamemodes/siege.dm"
#endif // #ifdef GAMEMODE_PACK_REVOLUTIONARY
#endif // #ifdef GAMEMODE_PACK_MERCENARY

#if defined(GAMEMODE_PACK_REVOLUTIONARY) && defined(GAMEMODE_PACK_CULT)
#include "mixed_gamemodes/uprising.dm"
#endif