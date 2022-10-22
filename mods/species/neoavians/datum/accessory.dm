//hair
/decl/sprite_accessory/hair/avian
	name = "Avian Plumage"
	icon_state = "avian_default"
	icon = 'mods/species/neoavians/icons/hair.dmi'
	species_allowed = list(SPECIES_AVIAN)
	blend = ICON_MULTIPLY

/decl/sprite_accessory/hair/avian/mohawk
	name = "Avian Mohawk"
	icon_state = "avian_mohawk"

/decl/sprite_accessory/hair/avian/spiky
	name = "Avian Spiky"
	icon_state = "avian_spiky"

/decl/sprite_accessory/hair/avian/crest
	name = "Avian Crest"
	icon_state = "avian_crest"

/decl/sprite_accessory/hair/avian/mane
	name = "Avian Mane"
	icon_state = "avian_mane"

/decl/sprite_accessory/hair/avian/upright
	name = "Avian Upright"
	icon_state = "avian_upright"

/decl/sprite_accessory/hair/avian/fluffymohawk
	name = "Avian Fluffy Mohawk"
	icon_state = "avian_fluffymohawk"

/decl/sprite_accessory/hair/avian/twies
	name = "Avian Twies"
	icon_state = "avian_twies"

/decl/sprite_accessory/hair/avian/alt
	name = "Avian Plumage Alt"
	icon_state = "avian_default_alt"
	blend = ICON_ADD

/decl/sprite_accessory/hair/avian/alt/ears
	name = "Avian Ears"
	icon_state = "avian_ears"

/decl/sprite_accessory/hair/avian/alt/excited
	name = "Avian Spiky Alt"
	icon_state = "avian_spiky_alt"

/decl/sprite_accessory/hair/avian/alt/hedgehog
	name = "Avian Hedgehog"
	icon_state = "avian_hedge"

/decl/sprite_accessory/hair/avian/alt/unpruned
	name = "Avian Unpruned"
	icon_state = "avian_unpruned"

/decl/sprite_accessory/hair/avian/alt/sunburst
	name = "Avian Sunburst"
	icon_state = "avian_burst_short"

/decl/sprite_accessory/hair/avian/alt/mohawk
	name = "Avian Mohawk Alt"
	icon_state = "avian_mohawk_alt"

/decl/sprite_accessory/hair/avian/alt/pointy
	name = "Avian Pointy"
	icon_state = "avian_pointy"

/decl/sprite_accessory/hair/avian/alt/upright
	name = "Avian Upright Alt"
	icon_state = "avian_upright_alt"

/decl/sprite_accessory/hair/avian/alt/mane_beardless
	name = "Avian Large Ears"
	icon_state = "avian_mane_beardless"

/decl/sprite_accessory/hair/avian/alt/droopy
	name = "Avian Droopy"
	icon_state = "avian_droopy"

/decl/sprite_accessory/hair/avian/alt/neon
	name = "Avian Neon"
	icon_state = "avian_neon"

/decl/sprite_accessory/hair/avian/alt/backstrafe
	name = "Avian Backstrafe"
	icon_state = "avian_backstrafe"

/decl/sprite_accessory/hair/avian/alt/longway
	name = "Avian Long way"
	icon_state = "avian_longway"

//markings

/decl/sprite_accessory/marking/avian
	name = "Beak (Head)"
	icon_state = "beak"
	body_parts = list(BP_HEAD)
	icon = 'mods/species/neoavians/icons/markings.dmi'
	species_allowed = list(SPECIES_AVIAN)
	blend = ICON_MULTIPLY

/decl/sprite_accessory/marking/avian/avian
	name = "Raptor Ears (Head)"
	icon_state = "ears"

/decl/sprite_accessory/marking/avian/wing_feathers
	name = "Wing Feathers (Left)"
	body_parts = list(BP_L_HAND)
	icon_state = "wing_feathers"

/decl/sprite_accessory/marking/avian/wing_feathers/right
	name = "Wing Feathers (Right)"
	body_parts = list(BP_R_HAND)

/decl/sprite_accessory/marking/avian/additive
	name = "Beak, Additive (Head)"
	icon_state = "beak-add"
	blend = ICON_ADD

/decl/sprite_accessory/marking/avian/resomi/additive
	name = "Raptor Ears, Additive (Head)"
	icon_state = "ears-add"
	blend = ICON_ADD

/decl/sprite_accessory/marking/avian/wing_feathers/additive
	name = "Wing Feathers, Additive (Left)"
	icon_state = "wing_feathers-add"
	blend = ICON_ADD

/decl/sprite_accessory/marking/avian/wing_feathers/right/additive
	name = "Wing Feathers, Additive (Right)"
	icon_state = "wing_feathers-add"
	blend = ICON_ADD

/decl/sprite_accessory/hair/bald/Initialize()
	. = ..()
	LAZYADD(species_allowed, SPECIES_AVIAN)
