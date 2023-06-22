#define SPECIES_MANTID_ALATE   "Kharmaan Alate"
#define SPECIES_MANTID_GYNE    "Kharmaan Gyne"
#define SPECIES_MANTID_NYMPH   "Kharmaan Nymph"

#define BODYTYPE_MANTID_SMALL "small mantid body"
#define BODYTYPE_MANTID_LARGE "large mantid body"

#define BODY_FLAG_ALATE BITFLAG(4)
#define BODY_FLAG_GYNE  BITFLAG(5)

#define BP_L_HAND_UPPER "l_u_hand"
#define BP_R_HAND_UPPER "r_u_hand"
#define BP_M_HAND       "midlimb"

#define MANTIDIFY(_thing, _name, _desc) \
##_thing/ascent/name = _name; \
##_thing/ascent/desc = "Some kind of strange alien " + _desc + " technology."; \
##_thing/ascent/color = COLOR_PURPLE;

#define ALL_ASCENT_SPECIES list(SPECIES_MANTID_ALATE, SPECIES_MANTID_GYNE)

/decl/modpack/ascent
	name = "The Ascent"

/decl/modpack/ascent/pre_initialize()
	. = ..()
	global.all_limb_tags |= BP_L_HAND_UPPER
	global.all_limb_tags |= BP_R_HAND_UPPER
	global.all_limb_tags |= BP_M_HAND
	global.all_limb_tags_by_depth.Insert(global.all_limb_tags_by_depth.Find(BP_L_HAND)+1, BP_L_HAND_UPPER)
	global.all_limb_tags_by_depth.Insert(global.all_limb_tags_by_depth.Find(BP_R_HAND)+1, BP_R_HAND_UPPER)
	global.all_limb_tags_by_depth.Insert(global.all_limb_tags_by_depth.Find(BP_CHEST)+1,  BP_M_HAND)

	global.all_inventory_slots |= BP_L_HAND_UPPER
	global.all_inventory_slots |= BP_R_HAND_UPPER
	global.all_inventory_slots |= BP_M_HAND
