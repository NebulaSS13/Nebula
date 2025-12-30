// Give borers a paramount rank psi aura, and gives them a ranged psychic attack.
#ifdef CONTENT_PACK_BORERS
#include "psionics/borer_psi.dm"
#endif
// Allows psion blood to be used to create soulstones,
// and lets full soulstones nullify psi and shatter into nullglass.
#ifdef GAMEMODE_PACK_CULT
#include "psionics/cult_psi.dm"
#endif
// Adds psi abilities to the counselor.
#ifdef MODPACK_STANDARD_JOBS
#include "psionics/psi_jobs.dm"
#endif