// Add xenobiology/slimes modpack circuits.
#ifdef CONTENT_PACK_XENOBIO
#include "circuits/xenobio_circuits.dm"
#endif
// Add circuit items to dungeon loot.
#ifdef MODPACK_DUNGEON_LOOT
#include "circuits/loot_circuits.dm"
#endif
// Add augment assembly for circuits.
#ifdef CONTENT_PACK_AUGMENTS
#include "circuits/augment_circuits.dm"
#endif
// Add support for MMIs to the AI manipulator circuit.
#ifdef CONTENT_PACK_BRAIN_INTERFACE
#include "circuits/brain_interface_circuits.dm"
#endif