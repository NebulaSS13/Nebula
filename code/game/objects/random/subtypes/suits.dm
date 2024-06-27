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

/obj/random/voidsuit_and_helmet
	name = "Random Voidsuit and Helmet"
	desc = "This is a random basic voidsuit."
	icon = 'icons/clothing/spacesuit/void/nasa/suit.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/voidsuit_and_helmet/spawn_choices()
	var/static/list/spawnable_choices = list(
		list(
			/obj/item/clothing/suit/space/void,
			/obj/item/clothing/head/helmet/space/void
		) = 10,
		list(
			/obj/item/clothing/suit/space/void/engineering,
			/obj/item/clothing/head/helmet/space/void/engineering
		) = 2,
		list(
			/obj/item/clothing/suit/space/void/atmos,
			/obj/item/clothing/head/helmet/space/void/atmos
		) = 2,
		list(
			/obj/item/clothing/suit/space/void/expedition,
			/obj/item/clothing/head/helmet/space/void/expedition
		) = 1
	)
	return spawnable_choices

/obj/random/voidsuit/mining
	name = "Random Mining Voidsuit"
	desc = "This is a random mining voidsuit."

/obj/random/voidsuit/mining/spawn_choices()
	var/static/list/spawnable_choices = list(
		list(
			/obj/item/clothing/suit/space/void/mining,
			/obj/item/clothing/head/helmet/space/void/mining
		) = 5,
		list(
			/obj/item/clothing/suit/space/void/mining/alt,
			/obj/item/clothing/head/helmet/space/void/mining/alt
		) = 1
	)
	return spawnable_choices
