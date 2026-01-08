/decl/sprite_accessory/hair/avian
	name = "Teshari Plumage"
	icon_state = "avian_default"
	icon = 'mods/species/neoavians/icons/hair.dmi'
	species_allowed = list(/decl/species/neoavian::uid)
	color_blend = ICON_MULTIPLY
	uid = "acc_hair_avian_plumage"

/decl/sprite_accessory/hair/avian/get_hidden_substitute()
	if(accessory_flags & HAIR_VERY_SHORT)
		return src
	return GET_DECL(/decl/sprite_accessory/hair/bald)

/decl/sprite_accessory/hair/avian/mohawk
	name = "Teshari Mohawk"
	icon_state = "avian_mohawk"
	uid = "acc_hair_avian_mohawk"

/decl/sprite_accessory/hair/avian/spiky
	name = "Teshari Spiky"
	icon_state = "avian_spiky"
	uid = "acc_hair_avian_spiky"

/decl/sprite_accessory/hair/avian/crest
	name = "Teshari Crest"
	icon_state = "avian_crest"
	uid = "acc_hair_avian_crest"

/decl/sprite_accessory/hair/avian/mane
	name = "Teshari Mane"
	icon_state = "avian_mane"
	uid = "acc_hair_avian_mane"

/decl/sprite_accessory/hair/avian/upright
	name = "Teshari Upright"
	icon_state = "avian_upright"
	uid = "acc_hair_avian_upright"

/decl/sprite_accessory/hair/avian/fluffymohawk
	name = "Teshari Fluffy Mohawk"
	icon_state = "avian_fluffymohawk"
	uid = "acc_hair_avian_fluffymohawk"

/decl/sprite_accessory/hair/avian/twies
	name = "Teshari Twies"
	icon_state = "avian_twies"
	uid = "acc_hair_avian_twies"

/decl/sprite_accessory/hair/avian/alt
	name = "Teshari Plumage Alt"
	icon_state = "avian_default_alt"
	color_blend = ICON_ADD
	uid = "acc_hair_avian_plumage_alt"

/decl/sprite_accessory/hair/avian/alt/excited
	name = "Teshari Spiky Alt"
	icon_state = "avian_spiky_alt"
	uid = "acc_hair_avian_excited"

/decl/sprite_accessory/hair/avian/alt/hedgehog
	name = "Teshari Hedgehog"
	icon_state = "avian_hedge"
	uid = "acc_hair_avian_hedgehog"

/decl/sprite_accessory/hair/avian/alt/unpruned
	name = "Teshari Unpruned"
	icon_state = "avian_unpruned"
	uid = "acc_hair_avian_unpruned"

/decl/sprite_accessory/hair/avian/alt/sunburst
	name = "Teshari Sunburst"
	icon_state = "avian_burst_short"
	uid = "acc_hair_avian_sunburst"

/decl/sprite_accessory/hair/avian/alt/mohawk
	name = "Teshari Mohawk Alt"
	icon_state = "avian_mohawk_alt"
	uid = "acc_hair_avian_mohawk_alt"

/decl/sprite_accessory/hair/avian/alt/pointy
	name = "Teshari Pointy"
	icon_state = "avian_pointy"
	uid = "acc_hair_avian_pointy"

/decl/sprite_accessory/hair/avian/alt/upright
	name = "Teshari Upright Alt"
	icon_state = "avian_upright_alt"
	uid = "acc_hair_avian_upright_alt"

/decl/sprite_accessory/hair/avian/alt/droopy
	name = "Teshari Droopy"
	icon_state = "avian_droopy"
	uid = "acc_hair_avian_droopy"

/decl/sprite_accessory/hair/avian/alt/neon
	name = "Teshari Neon"
	icon_state = "avian_neon"
	uid = "acc_hair_avian_neon"

/decl/sprite_accessory/hair/avian/alt/backstrafe
	name = "Teshari Backstrafe"
	icon_state = "avian_backstrafe"
	uid = "acc_hair_avian_backstrafe"

/decl/sprite_accessory/hair/avian/alt/longway
	name = "Teshari Long way"
	icon_state = "avian_longway"
	uid = "acc_hair_avian_longway"
