
/obj/random/masks
	name = "random mask"
	desc = "This is a random face mask."
	icon = 'icons/clothing/mask/gas_mask.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/masks/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/clothing/mask/gas                = 4,
		/obj/item/clothing/mask/gas/half           = 5,
		/obj/item/clothing/mask/gas/swat           = 1,
		/obj/item/clothing/mask/gas/syndicate      = 1,
		/obj/item/clothing/mask/breath             = 6,
		/obj/item/clothing/mask/breath/medical     = 4,
		/obj/item/clothing/mask/balaclava          = 3,
		/obj/item/clothing/mask/balaclava/tactical = 2,
		/obj/item/clothing/mask/surgical           = 4
	)
	return spawnable_choices

/obj/random/shoes
	name = "random footwear"
	desc = "This is a random pair of shoes."
	icon = 'icons/clothing/feet/generic_shoes.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/shoes/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/clothing/shoes/workboots             = 3,
		/obj/item/clothing/shoes/jackboots             = 3,
		/obj/item/clothing/shoes/jackboots/swat        = 1,
		/obj/item/clothing/shoes/jackboots/swat/combat = 1,
		/obj/item/clothing/shoes/galoshes              = 2,
		/obj/item/clothing/shoes/syndigaloshes         = 1,
		/obj/item/clothing/shoes/magboots              = 1,
		/obj/item/clothing/shoes/dress                 = 4,
		/obj/item/clothing/shoes/jackboots/jungleboots = 3,
		/obj/item/clothing/shoes/jackboots/desertboots = 3,
		/obj/item/clothing/shoes/jackboots/duty        = 3,
		/obj/item/clothing/shoes/jackboots/tactical    = 1,
		/obj/item/clothing/shoes/color/black           = 4,
		/obj/item/clothing/shoes/dress                 = 3,
		/obj/item/clothing/shoes/dress/white           = 3,
		/obj/item/clothing/shoes/sandal                = 3,
		/obj/item/clothing/shoes/color/brown           = 4,
		/obj/item/clothing/shoes/color/red             = 4,
		/obj/item/clothing/shoes/color/blue            = 4,
		/obj/item/clothing/shoes/craftable             = 4
	)
	return spawnable_choices

/obj/random/gloves
	name = "random gloves"
	desc = "This is a random pair of gloves."
	icon = 'icons/clothing/hands/gloves_generic.dmi'
	icon_state = ICON_STATE_INV

/obj/random/gloves/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/clothing/gloves                 = 5,
		/obj/item/clothing/gloves/insulated       = 3,
		/obj/item/clothing/gloves/thick           = 6,
		/obj/item/clothing/gloves/thick/botany    = 5,
		/obj/item/clothing/gloves/latex           = 4,
		/obj/item/clothing/gloves/thick/swat      = 3,
		/obj/item/clothing/gloves/thick/combat    = 3,
		/obj/item/clothing/gloves/rainbow         = 1,
		/obj/item/clothing/gloves/thick/duty      = 5,
		/obj/item/clothing/gloves/guards          = 3,
		/obj/item/clothing/gloves/tactical        = 3,
		/obj/item/clothing/gloves/insulated/cheap = 5
	)
	return spawnable_choices

/obj/random/glasses
	name = "random eyewear"
	desc = "This is a random pair of glasses."
	icon = 'icons/clothing/eyes/glasses_prescription.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/glasses/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/clothing/glasses/sunglasses                = 3,
		/obj/item/clothing/glasses/prescription              = 7,
		/obj/item/clothing/glasses/meson                     = 5,
		/obj/item/clothing/glasses/meson/prescription        = 4,
		/obj/item/clothing/glasses/science                   = 6,
		/obj/item/clothing/glasses/material                  = 5,
		/obj/item/clothing/glasses/welding                   = 3,
		/obj/item/clothing/glasses/hud/health                = 4,
		/obj/item/clothing/glasses/hud/health/prescription   = 3,
		/obj/item/clothing/glasses/hud/security              = 4,
		/obj/item/clothing/glasses/hud/security/prescription = 3,
		/obj/item/clothing/glasses/sunglasses/sechud         = 2,
		/obj/item/clothing/glasses/sunglasses/sechud/toggle  = 3,
		/obj/item/clothing/glasses/sunglasses/sechud/goggles = 1,
		/obj/item/clothing/glasses/tacgoggles                = 1
	)
	return spawnable_choices

/obj/random/hat
	name = "random headgear"
	desc = "This is a random hat of some kind."
	icon = 'icons/clothing/head/softcap.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/hat/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/clothing/head/helmet                 = 2,
		/obj/item/clothing/head/helmet/tactical        = 1,
		/obj/item/clothing/head/helmet/space/emergency = 1,
		/obj/item/clothing/head/bio_hood/general       = 1,
		/obj/item/clothing/head/hardhat                = 4,
		/obj/item/clothing/head/hardhat/orange         = 4,
		/obj/item/clothing/head/hardhat/red            = 4,
		/obj/item/clothing/head/hardhat/dblue          = 4,
		/obj/item/clothing/head/ushanka                = 3,
		/obj/item/clothing/head/welding                = 2
	)
	return spawnable_choices

/obj/random/suit
	name = "random suit"
	desc = "This is a random piece of outerwear."
	icon = 'icons/clothing/suits/firesuit.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/suit/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/clothing/suit/hazardvest              = 4,
		/obj/item/clothing/suit/toggle/labcoat          = 4,
		/obj/item/clothing/suit/space/emergency         = 1,
		/obj/item/clothing/suit/armor/vest              = 4,
		/obj/item/clothing/suit/armor/pcarrier/tactical = 1,
		/obj/item/clothing/suit/armor/vest/heavy        = 3,
		/obj/item/clothing/suit/jacket/bomber           = 3,
		/obj/item/clothing/suit/chef/classic            = 3,
		/obj/item/clothing/suit/surgicalapron           = 2,
		/obj/item/clothing/suit/apron/overalls          = 3,
		/obj/item/clothing/suit/bio_suit/general        = 1,
		/obj/item/clothing/suit/jacket/hoodie/black     = 3,
		/obj/item/clothing/suit/jacket/brown            = 3,
		/obj/item/clothing/suit/jacket/leather          = 3,
		/obj/item/clothing/suit/apron                   = 4
	)
	return spawnable_choices

/obj/random/clothing
	name = "random clothes"
	desc = "This is a random piece of clothing."
	icon = 'icons/clothing/jumpsuits/jumpsuit.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/clothing/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/clothing/shirt/syndicate/tacticool   = 2,
		/obj/item/clothing/shirt/syndicate/combat      = 1,
		/obj/item/clothing/jumpsuit/hazard             = 4,
		/obj/item/clothing/jumpsuit/sterile            = 4,
		/obj/item/clothing/pants/casual/camo           = 2,
		/obj/item/clothing/shirt/flannel/red           = 2,
		/obj/item/clothing/shirt/harness               = 2,
		/obj/item/clothing/jumpsuit/medical/paramedic  = 2,
		/obj/item/clothing/suit/apron/overalls/laborer = 2,
		/obj/item/clothing/head/earmuffs               = 2,
		/obj/item/clothing/jumpsuit/tactical           = 1
	)
	return spawnable_choices

/obj/random/accessory
	name = "random accessory"
	desc = "This is a random utility accessory."
	icon = 'icons/clothing/accessories/ties/tie_horrible.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/accessory/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/clothing/webbing                = 3,
		/obj/item/clothing/webbing/webbing_large  = 3,
		/obj/item/clothing/webbing/vest/black     = 2,
		/obj/item/clothing/webbing/vest/brown     = 2,
		/obj/item/clothing/webbing/vest           = 2,
		/obj/item/clothing/webbing/bandolier      = 1,
		/obj/item/clothing/webbing/holster/thigh  = 1,
		/obj/item/clothing/webbing/holster/hip    = 1,
		/obj/item/clothing/webbing/holster/waist  = 1,
		/obj/item/clothing/webbing/holster/armpit = 1,
		/obj/item/clothing/shoes/kneepads =         3,
		/obj/item/clothing/neck/stethoscope =       2
	)
	return spawnable_choices

/obj/random/voidhelmet
	name = "Random Voidsuit Helmet"
	desc = "This is a random voidsuit helmet."
	icon = 'icons/clothing/spacesuit/generic/helmet.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/voidhelmet/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/clothing/head/helmet/space/void,
		/obj/item/clothing/head/helmet/space/void/engineering,
		/obj/item/clothing/head/helmet/space/void/engineering/alt,
		/obj/item/clothing/head/helmet/space/void/engineering/salvage,
		/obj/item/clothing/head/helmet/space/void/mining,
		/obj/item/clothing/head/helmet/space/void/mining/alt,
		/obj/item/clothing/head/helmet/space/void/security,
		/obj/item/clothing/head/helmet/space/void/security/alt,
		/obj/item/clothing/head/helmet/space/void/atmos,
		/obj/item/clothing/head/helmet/space/void/atmos/alt,
		/obj/item/clothing/head/helmet/space/void/merc,
		/obj/item/clothing/head/helmet/space/void/medical,
		/obj/item/clothing/head/helmet/space/void/medical/alt
	)
	return spawnable_choices

/obj/random/voidsuit
	name = "Random Voidsuit"
	desc = "This is a random voidsuit."
	icon = 'icons/clothing/spacesuit/void/nasa/suit.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/voidsuit/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/clothing/suit/space/void,
		/obj/item/clothing/suit/space/void/engineering,
		/obj/item/clothing/suit/space/void/engineering/alt,
		/obj/item/clothing/suit/space/void/engineering/salvage,
		/obj/item/clothing/suit/space/void/mining,
		/obj/item/clothing/suit/space/void/mining/alt,
		/obj/item/clothing/suit/space/void/security,
		/obj/item/clothing/suit/space/void/security/alt,
		/obj/item/clothing/suit/space/void/atmos,
		/obj/item/clothing/suit/space/void/atmos/alt,
		/obj/item/clothing/suit/space/void/merc,
		/obj/item/clothing/suit/space/void/medical,
		/obj/item/clothing/suit/space/void/medical/alt
	)
	return spawnable_choices

/obj/random/hardsuit
	name = "Random Hardsuit"
	desc = "This is a random hardsuit control module."
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "generic"

/obj/random/hardsuit/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/rig/industrial,
		/obj/item/rig/eva,
		/obj/item/rig/light/hacker,
		/obj/item/rig/light/stealth,
		/obj/item/rig/light
	)
	return spawnable_choices
