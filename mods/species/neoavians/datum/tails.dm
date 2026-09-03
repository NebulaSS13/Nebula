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

/decl/sprite_accessory/tail/avian/plumeless
	name = "Raptor Tail, Plumeless"
	icon_state = "tail_raptor_plumeless"
	uid = "acc_tail_avian_plumeless"

/decl/sprite_accessory/tail/avian/short
	name = "Raptor Tail, Short"
	icon_state = "tail_raptor_short"
	uid = "acc_tail_avian_short"

/decl/sprite_accessory/tail/avian/stubby
	name = "Raptor Tail, Stubby"
	icon_state = "tail_raptor_stubby"
	uid = "acc_tail_avian_stubby"

/decl/sprite_accessory/tail/avian/raptor_add/plumeless
	name = "Raptor Tail, Plumeless Additive"
	icon_state = "tail_raptor_plumeless_add"
	uid = "acc_tail_avian_raptor_plumeless_add"

/decl/sprite_accessory/tail/avian/raptor_add/short
	name = "Raptor Tail, Short Additive"
	icon_state = "tail_raptor_short_add"
	uid = "acc_tail_avian_raptor_short_add"

/decl/sprite_accessory/tail/avian/raptor_add/stubby
	name = "Raptor Tail, Stubby Additive"
	icon_state = "tail_raptor_stubby_add"
	uid = "acc_tail_avian_raptor_stubby_add"
