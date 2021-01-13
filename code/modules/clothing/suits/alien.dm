//Primitive clothing.

/obj/item/clothing/suit/robe
	name = "roughspun robes"
	desc = "A simple garment."
	icon = 'icons/clothing/suit/rough_robe.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS

//Misc Xeno clothing.

/obj/item/clothing/head/xeno/scarf
	name = "headscarf"
	desc = "A scarf of coarse fabric. Seems to have ear-holes."
	icon = 'icons/clothing/head/headscarf.dmi'
	body_parts_covered = SLOT_HEAD|SLOT_FACE

/obj/item/clothing/accessory/shouldercape
	name = "shoulder cape"
	desc = "A simple shoulder cape."
	icon_state = "gruntcape"
	slot = ACCESSORY_SLOT_INSIGNIA // Adding again in case we want to change it in the future.

/obj/item/clothing/accessory/shouldercape/grunt
	name = "cape"
	desc = "A simple looking cape with a couple of runes woven into the fabric."
	icon_state = "gruntcape" // Again, just in case it is changed.

/obj/item/clothing/accessory/shouldercape/officer
	name = "officer's cape"
	desc = "A decorated cape. Runed patterns have been woven into the fabric."
	icon_state = "officercape"

/obj/item/clothing/accessory/shouldercape/command
	name = "command cape"
	desc = "A heavily decorated cape with rank emblems on the shoulders signifying prestige. An ornate runed design has been woven into the fabric of it"
	icon_state = "commandcape"

/obj/item/clothing/accessory/shouldercape/general
	name = "general's cape"
	desc = "An extremely decorated cape with an intricately runed design has been woven into the fabric of this cape with great care."
	icon_state = "leadercape"
	matter = list(/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE)
