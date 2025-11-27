//hair
/decl/sprite_accessory/hair/teshari
	name = "Avian Plumage"
	icon_state = "avian_default"
	icon = 'mods/species/teshari/icons/hair.dmi'
	species_allowed = list(/decl/species/teshari::uid)
	color_blend = ICON_MULTIPLY
	uid = "acc_hair_tesh_plumage"

/decl/sprite_accessory/hair/teshari/get_hidden_substitute()
	if(accessory_flags & HAIR_VERY_SHORT)
		return src
	return GET_DECL(/decl/sprite_accessory/hair/bald)

/decl/sprite_accessory/hair/teshari/mohawk
	name = "Avian Mohawk"
	icon_state = "avian_mohawk"
	uid = "acc_hair_tesh_mohawk"

/decl/sprite_accessory/hair/teshari/spiky
	name = "Avian Spiky"
	icon_state = "avian_spiky"
	uid = "acc_hair_tesh_spiky"

/decl/sprite_accessory/hair/teshari/crest
	name = "Avian Crest"
	icon_state = "avian_crest"
	uid = "acc_hair_tesh_crest"

/decl/sprite_accessory/hair/teshari/mane
	name = "Avian Mane"
	icon_state = "avian_mane"
	uid = "acc_hair_tesh_mane"

/decl/sprite_accessory/hair/teshari/upright
	name = "Avian Upright"
	icon_state = "avian_upright"
	uid = "acc_hair_tesh_upright"

/decl/sprite_accessory/hair/teshari/fluffymohawk
	name = "Avian Fluffy Mohawk"
	icon_state = "avian_fluffymohawk"
	uid = "acc_hair_tesh_fluffymohawk"

/decl/sprite_accessory/hair/teshari/twies
	name = "Avian Twies"
	icon_state = "avian_twies"
	uid = "acc_hair_tesh_twies"

/decl/sprite_accessory/hair/teshari/alt
	name = "Avian Plumage Alt"
	icon_state = "avian_default_alt"
	color_blend = ICON_ADD
	uid = "acc_hair_tesh_plumage_alt"

/decl/sprite_accessory/hair/teshari/alt/ears
	name = "Avian Ears"
	icon_state = "avian_ears"
	uid = "acc_hair_tesh_ears_alt"

/decl/sprite_accessory/hair/teshari/alt/excited
	name = "Avian Spiky Alt"
	icon_state = "avian_spiky_alt"
	uid = "acc_hair_tesh_excited"

/decl/sprite_accessory/hair/teshari/alt/hedgehog
	name = "Avian Hedgehog"
	icon_state = "avian_hedge"
	uid = "acc_hair_tesh_hedgehog"

/decl/sprite_accessory/hair/teshari/alt/unpruned
	name = "Avian Unpruned"
	icon_state = "avian_unpruned"
	uid = "acc_hair_tesh_unpruned"

/decl/sprite_accessory/hair/teshari/alt/sunburst
	name = "Avian Sunburst"
	icon_state = "avian_burst_short"
	uid = "acc_hair_tesh_sunburst"

/decl/sprite_accessory/hair/teshari/alt/mohawk
	name = "Avian Mohawk Alt"
	icon_state = "avian_mohawk_alt"
	uid = "acc_hair_tesh_mohawk_alt"

/decl/sprite_accessory/hair/teshari/alt/pointy
	name = "Avian Pointy"
	icon_state = "avian_pointy"
	uid = "acc_hair_tesh_pointy"

/decl/sprite_accessory/hair/teshari/alt/upright
	name = "Avian Upright Alt"
	icon_state = "avian_upright_alt"
	uid = "acc_hair_tesh_upright_alt"

/decl/sprite_accessory/hair/teshari/alt/mane_beardless
	name = "Avian Large Ears"
	icon_state = "avian_mane_beardless"
	uid = "acc_hair_tesh_large_ears"

/decl/sprite_accessory/hair/teshari/alt/droopy
	name = "Avian Droopy"
	icon_state = "avian_droopy"
	uid = "acc_hair_tesh_droopy"

/decl/sprite_accessory/hair/teshari/alt/neon
	name = "Avian Neon"
	icon_state = "avian_neon"
	uid = "acc_hair_tesh_neon"

/decl/sprite_accessory/hair/teshari/alt/backstrafe
	name = "Avian Backstrafe"
	icon_state = "avian_backstrafe"
	uid = "acc_hair_tesh_backstrafe"

/decl/sprite_accessory/hair/teshari/alt/longway
	name = "Avian Long way"
	icon_state = "avian_longway"
	uid = "acc_hair_tesh_longway"

//markings
/decl/sprite_accessory/marking/teshari
	name = "Beak (Head)"
	icon_state = "beak"
	body_parts = list(BP_HEAD)
	icon = 'mods/species/teshari/icons/markings.dmi'
	species_allowed = list(/decl/species/teshari::uid)
	color_blend = ICON_MULTIPLY
	uid = "acc_marking_tesh_beak"

/decl/sprite_accessory/marking/teshari/teshari
	name = "Raptor Ears (Head)"
	icon_state = "ears"
	uid = "acc_marking_tesh_raptorears"

/decl/sprite_accessory/marking/teshari/wing_feathers
	name = "Wing Feathers (Left)"
	body_parts = list(BP_L_HAND)
	icon_state = "wing_feathers"
	uid = "acc_marking_tesh_wingfeathers_left"

/decl/sprite_accessory/marking/teshari/wing_feathers/right
	name = "Wing Feathers (Right)"
	body_parts = list(BP_R_HAND)
	uid = "acc_marking_tesh_wingfeathers_right"

/decl/sprite_accessory/marking/teshari/additive
	name = "Beak, Additive (Head)"
	icon_state = "beak-add"
	color_blend = ICON_ADD
	uid = "acc_marking_tesh_beak_alt"

/decl/sprite_accessory/marking/teshari/resomi
	name = "Raptor Ears, Additive (Head)"
	icon_state = "ears-add"
	color_blend = ICON_ADD
	uid = "acc_marking_tesh_raptorears_alt"

/decl/sprite_accessory/marking/teshari/wing_feathers/additive
	name = "Wing Feathers, Additive (Left)"
	icon_state = "wing_feathers-add"
	color_blend = ICON_ADD
	uid = "acc_marking_tesh_wingfeathers_left_alt"

/decl/sprite_accessory/marking/teshari/wing_feathers/right/additive
	name = "Wing Feathers, Additive (Right)"
	icon_state = "wing_feathers-add"
	color_blend = ICON_ADD
	uid = "acc_marking_tesh_wingfeathers_right_alt"
