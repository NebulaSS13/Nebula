/obj/item/clothing/suit/shouldercape
	name = "shoulder cape"
	desc = "A simple-looking cape with a couple of runes woven into the fabric."
	icon = 'icons/clothing/accessories/clothing/cape_grunt.dmi'
	accessory_slot = ACCESSORY_SLOT_INSIGNIA // Adding again in case we want to change it in the future.

/obj/item/clothing/suit/shouldercape/officer
	name = "officer's cape"
	desc = "A decorated cape. Runed patterns have been woven into the fabric."
	icon = 'icons/clothing/accessories/clothing/cape_officer.dmi'

/obj/item/clothing/suit/shouldercape/command
	name = "command cape"
	desc = "A heavily decorated cape with rank emblems on the shoulders signifying prestige. An ornate runed design has been woven into the fabric of it"
	icon = 'icons/clothing/accessories/clothing/cape_commander.dmi'

/obj/item/clothing/suit/shouldercape/general
	name = "general's cape"
	desc = "An extremely decorated cape with an intricately runed design has been woven into the fabric of this cape with great care."
	icon = 'icons/clothing/accessories/clothing/cape_leader.dmi'
	matter = list(/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE)
