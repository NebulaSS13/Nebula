/decl/sprite_accessory/tail/avian
	name = "Raptor Tail"
	icon = 'mods/species/neoavians/icons/tail.dmi'
	icon_state = "tail_raptor"
	uid = "acc_tail_avian"
	accessory_metadata_types = list(SAM_COLOR, SAM_COLOR_INNER)
	species_allowed = list(/decl/species/neoavian::uid)

/decl/sprite_accessory/tail/avian/add
	name = "Avian Tail, Additive"
	icon_state = "tail_avian_add"
	uid = "acc_tail_avian_add"
	color_blend = ICON_ADD
	accessory_metadata_types = list(SAM_COLOR)

/decl/sprite_accessory/tail/avian/raptor_add
	name = "Raptor Tail, Additive"
	uid = "acc_tail_avian_raptor_add"
	icon_state = "tail_raptor_add"
	color_blend = ICON_ADD
