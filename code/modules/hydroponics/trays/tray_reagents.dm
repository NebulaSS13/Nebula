
/obj/item/plantspray
	icon = 'icons/obj/hydroponics/hydroponics_machines.dmi'
	item_state = "spray"
	item_flags = ITEM_FLAG_NO_BLUDGEON
	slot_flags = SLOT_LOWER_BODY
	throwforce = 4
	w_class = ITEM_SIZE_SMALL
	throw_speed = 2
	throw_range = 10
	material = /decl/material/solid/plastic
	var/toxicity = 4
	var/pest_kill_str = 0
	var/weed_kill_str = 0

/obj/item/plantspray/weeds // -- Skie

	name = "weed-spray"
	desc = "It's a toxic mixture, in spray form, to kill small weeds."
	icon_state = "weedspray"
	weed_kill_str = 6

/obj/item/plantspray/pests
	name = "pest-spray"
	desc = "It's some pest eliminator spray! <I>Do not inhale!</I>"
	icon_state = "pestspray"
	pest_kill_str = 6

/obj/item/plantspray/pests/old
	name = "bottle of pestkiller"
	icon = 'icons/obj/items/chem/bottle.dmi'
	icon_state = "bottle16"

/obj/item/plantspray/pests/old/carbaryl
	name = "bottle of carbaryl"
	icon_state = "bottle16"
	toxicity = 4
	pest_kill_str = 2

/obj/item/plantspray/pests/old/lindane
	name = "bottle of lindane"
	icon_state = "bottle18"
	toxicity = 6
	pest_kill_str = 4

/obj/item/plantspray/pests/old/phosmet
	name = "bottle of phosmet"
	icon_state = "bottle15"
	toxicity = 8
	pest_kill_str = 7

// *************************************
// Weedkiller defines for hydroponics
// *************************************

/obj/item/plantspray/weedkiller
	name = "bottle of weedkiller"
	icon = 'icons/obj/items/chem/bottle.dmi'
	icon_state = "bottle16"
	toxicity = 0
	pest_kill_str = 0
	weed_kill_str = 0
	material = /decl/material/solid/plastic

/obj/item/plantspray/weedkiller/triclopyr
	name = "bottle of glyphosate"
	icon_state = "bottle16"
	toxicity = 4
	weed_kill_str = 2

/obj/item/plantspray/weedkiller/lindane
	name = "bottle of triclopyr"
	icon_state = "bottle18"
	toxicity = 6
	weed_kill_str = 4

/obj/item/plantspray/weedkiller/D24
	name = "bottle of 2,4-D"
	icon_state = "bottle15"
	toxicity = 8
	weed_kill_str = 7