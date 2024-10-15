/// This interaction requires the user to be adjacent to the target.
#define INTERACTION_NEEDS_ADJACENCY            BITFLAG(0)
/// This interaction requires the user to pass a physical interaction check.
#define INTERACTION_NEEDS_PHYSICAL_INTERACTION BITFLAG(1)
/// This interaction requires the target to be on a turf
#define INTERACTION_NEEDS_TURF                 BITFLAG(2)
/// This interaction requires the target to be in the user's inventory.
#define INTERACTION_NEEDS_INVENTORY            BITFLAG(3)
/// This interaction will always prompt for a selection from the user, even if it is the only available interaction.
#define INTERACTION_NEVER_AUTOMATIC            BITFLAG(4)