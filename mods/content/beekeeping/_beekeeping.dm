#define FRAME_RESERVE_COST        30
#define SWARM_AGITATION_PER_FRAME 25
#define FRAME_MATERIAL_COST       20
#define SWARM_GROWTH_COST         10
#define FRAME_FILL_MATERIAL_COST   5
#define HIVE_REPAIR_MATERIAL_COST  5

/decl/modpack/beekeeping
	name = "Beekeeping and Insects Content"

/datum/storage/hopper/industrial/centrifuge/New()
	..()
	can_hold |= /obj/item/hive_frame
