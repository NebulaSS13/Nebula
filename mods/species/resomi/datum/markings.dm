/decl/sprite_accessory/marking/resomi
	icon = 'mods/species/resomi/icons/markings.dmi'
	species_allowed = list(SPECIES_RESOMI)
	do_colouration = 1

/decl/sprite_accessory/marking/resomi/feathers
	name       = "Feathers"
	icon_state = "feathers"
	body_parts = list(BP_R_HAND,BP_L_HAND)
	blend = ICON_MULTIPLY

/decl/sprite_accessory/marking/resomi/resomi_fluff
	name = "Resomi underfluff"
	icon_state = "resomi_fluff"
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_GROIN,BP_CHEST,BP_HEAD)
	blend = ICON_MULTIPLY

/decl/sprite_accessory/marking/resomi/feet_feathers
	name = "Resomi feet feathers"
	icon_state = "feet_feathers"
	body_parts = list(BP_L_FOOT,BP_R_FOOT)
	blend = ICON_MULTIPLY