//hair
/decl/sprite_accessory/hair/avian
	name = "Avian Plumage"
	icon_state = "avian_default"
	icon = 'mods/species/neoavians/icons/hair.dmi'
	species_allowed = list(SPECIES_AVIAN)
	color_blend = ICON_MULTIPLY
	uid = "acc_hair_avian_plumage"

/decl/sprite_accessory/hair/avian/get_hidden_substitute()
	if(accessory_flags & HAIR_VERY_SHORT)
		return src
	return GET_DECL(/decl/sprite_accessory/hair/bald)

/decl/sprite_accessory/hair/avian/mohawk
	name = "Avian Mohawk"
	icon_state = "avian_mohawk"
	uid = "acc_hair_avian_mohawk"

/decl/sprite_accessory/hair/avian/spiky
	name = "Avian Spiky"
	icon_state = "avian_spiky"
	uid = "acc_hair_avian_spiky"

/decl/sprite_accessory/hair/avian/crest
	name = "Avian Crest"
	icon_state = "avian_crest"
	uid = "acc_hair_avian_crest"

/decl/sprite_accessory/hair/avian/mane
	name = "Avian Mane"
	icon_state = "avian_mane"
	uid = "acc_hair_avian_mane"

/decl/sprite_accessory/hair/avian/upright
	name = "Avian Upright"
	icon_state = "avian_upright"
	uid = "acc_hair_avian_upright"

/decl/sprite_accessory/hair/avian/fluffymohawk
	name = "Avian Fluffy Mohawk"
	icon_state = "avian_fluffymohawk"
	uid = "acc_hair_avian_fluffymohawk"

/decl/sprite_accessory/hair/avian/twies
	name = "Avian Twies"
	icon_state = "avian_twies"
	uid = "acc_hair_avian_twies"

/decl/sprite_accessory/hair/avian/alt
	name = "Avian Plumage Alt"
	icon_state = "avian_default_alt"
	color_blend = ICON_ADD
	uid = "acc_hair_avian_plumage_alt"

/decl/sprite_accessory/hair/avian/alt/ears
	name = "Avian Ears"
	icon_state = "avian_ears"
	uid = "acc_hair_avian_ears_alt"

/decl/sprite_accessory/hair/avian/alt/excited
	name = "Avian Spiky Alt"
	icon_state = "avian_spiky_alt"
	uid = "acc_hair_avian_excited"

/decl/sprite_accessory/hair/avian/alt/hedgehog
	name = "Avian Hedgehog"
	icon_state = "avian_hedge"
	uid = "acc_hair_avian_hedgehog"

/decl/sprite_accessory/hair/avian/alt/unpruned
	name = "Avian Unpruned"
	icon_state = "avian_unpruned"
	uid = "acc_hair_avian_unpruned"

/decl/sprite_accessory/hair/avian/alt/sunburst
	name = "Avian Sunburst"
	icon_state = "avian_burst_short"
	uid = "acc_hair_avian_sunburst"

/decl/sprite_accessory/hair/avian/alt/mohawk
	name = "Avian Mohawk Alt"
	icon_state = "avian_mohawk_alt"
	uid = "acc_hair_avian_mohawk_alt"

/decl/sprite_accessory/hair/avian/alt/pointy
	name = "Avian Pointy"
	icon_state = "avian_pointy"
	uid = "acc_hair_avian_pointy"

/decl/sprite_accessory/hair/avian/alt/upright
	name = "Avian Upright Alt"
	icon_state = "avian_upright_alt"
	uid = "acc_hair_avian_upright_alt"

/decl/sprite_accessory/hair/avian/alt/mane_beardless
	name = "Avian Large Ears"
	icon_state = "avian_mane_beardless"
	uid = "acc_hair_avian_large_ears"

/decl/sprite_accessory/hair/avian/alt/droopy
	name = "Avian Droopy"
	icon_state = "avian_droopy"
	uid = "acc_hair_avian_droopy"

/decl/sprite_accessory/hair/avian/alt/neon
	name = "Avian Neon"
	icon_state = "avian_neon"
	uid = "acc_hair_avian_neon"

/decl/sprite_accessory/hair/avian/alt/backstrafe
	name = "Avian Backstrafe"
	icon_state = "avian_backstrafe"
	uid = "acc_hair_avian_backstrafe"

/decl/sprite_accessory/hair/avian/alt/longway
	name = "Avian Long way"
	icon_state = "avian_longway"
	uid = "acc_hair_avian_longway"

//markings
/decl/sprite_accessory/marking/avian
	name = "Beak (Head)"
	icon_state = "beak"
	body_parts = list(BP_HEAD)
	icon = 'mods/species/neoavians/icons/markings.dmi'
	species_allowed = list(SPECIES_AVIAN)
	color_blend = ICON_MULTIPLY
	uid = "acc_marking_avian_beak"

/decl/sprite_accessory/marking/avian/avian
	name = "Raptor Ears (Head)"
	icon_state = "ears"
	uid = "acc_marking_avian_raptorears"

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

/decl/sprite_accessory/marking/avian/resomi
	name = "Raptor Ears, Additive (Head)"
	icon_state = "ears-add"
	color_blend = ICON_ADD
	uid = "acc_marking_avian_raptorears_alt"

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
