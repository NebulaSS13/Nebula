/decl/sprite_accessory/marking/avian
	name = "Beak (Head)"
	icon_state = "beak"
	body_parts = list(BP_HEAD)
	icon = 'mods/species/neoavians/icons/markings.dmi'
	species_allowed = list(/decl/species/neoavian::uid)
	color_blend = ICON_MULTIPLY
	uid = "acc_marking_avian_beak"

/decl/sprite_accessory/marking/avian/wing_feathers
	name = "Wing Feathers (Left)"
	body_parts = list(BP_L_HAND)
	icon_state = "wing_feathers"
	uid = "acc_marking_avian_wingfeathers_left"

/decl/sprite_accessory/marking/avian/wing_feathers/right
	name = "Wing Feathers (Right)"
	body_parts = list(BP_R_HAND)
	uid = "acc_marking_avian_wingfeathers_right"

/decl/sprite_accessory/marking/avian/additive
	name = "Beak, Additive (Head)"
	icon_state = "beak-add"
	color_blend = ICON_ADD
	uid = "acc_marking_avian_beak_alt"

/decl/sprite_accessory/marking/avian/wing_feathers/additive
	name = "Wing Feathers, Additive (Left)"
	icon_state = "wing_feathers-add"
	color_blend = ICON_ADD
	uid = "acc_marking_avian_wingfeathers_left_alt"

/decl/sprite_accessory/marking/avian/wing_feathers/right/additive
	name = "Wing Feathers, Additive (Right)"
	icon_state = "wing_feathers-add"
	color_blend = ICON_ADD
	uid = "acc_marking_avian_wingfeathers_right_alt"
