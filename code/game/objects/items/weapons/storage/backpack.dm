
/*
 * Backpack
 */

/obj/item/storage/backpack
	name = "backpack"
	desc = "You wear this on your back and put items into it."
	icon = 'icons/obj/items/storage/backpack/backpack.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	max_w_class = ITEM_SIZE_LARGE
	max_storage_space = DEFAULT_BACKPACK_STORAGE
	open_sound = 'sound/effects/storage/unzip.ogg'
	material = /decl/material/solid/leather/synth

//Cannot be washed :(
/obj/item/storage/backpack/can_contaminate()
	return FALSE

/obj/item/storage/backpack/equipped()
	if(!has_extension(src, /datum/extension/appearance))
		set_extension(src, /datum/extension/appearance/cardborg)
	..()

/obj/item/storage/backpack/attackby(obj/item/W, mob/user)
	if (src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	return ..()

/obj/item/storage/backpack/equipped(var/mob/user, var/slot)
	if (slot == slot_back_str && src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	..(user, slot)

/*
 * Backpack Types
 */

/obj/item/storage/backpack/holding
	name = "bag of holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	origin_tech = "{'wormholes':4}"
	icon = 'icons/obj/items/storage/backpack/backpack_holding.dmi'
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 56
	material = /decl/material/solid/metal/gold
	matter = list(
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_TRACE,
		/decl/material/solid/plastic = MATTER_AMOUNT_TRACE
	)

/obj/item/storage/backpack/holding/singularity_act(S, current_size)
	var/dist = max((current_size - 2), 1)
	explosion(src.loc,(dist),(dist*2),(dist*4))
	return 1000

/obj/item/storage/backpack/holding/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/storage/backpack/holding) || istype(W, /obj/item/storage/bag/trash/advanced))
		to_chat(user, "<span class='warning'>The spatial interfaces of the two devices conflict and malfunction.</span>")
		qdel(W)
		return 1
	return ..()

	//Please don't clutter the parent storage item with stupid hacks.
/obj/item/storage/backpack/holding/can_be_inserted(obj/item/W, stop_messages = 0)
	if(istype(W, /obj/item/storage/backpack/holding))
		return 1
	return ..()

/obj/item/storage/backpack/holding/duffle
	name = "dufflebag of holding"
	icon = 'icons/obj/items/storage/backpack/dufflebag_holding.dmi'
	material = /decl/material/solid/metal/gold
	matter = list(
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_TRACE,
		/decl/material/solid/plastic = MATTER_AMOUNT_TRACE
	)

/obj/item/storage/backpack/santabag
	name = "\improper Santa's gift bag"
	desc = "Space Santa uses this to deliver toys to all the nice children in space for Christmas! Wow, it's pretty big!"
	icon = 'icons/obj/items/storage/backpack/giftbag.dmi'
	w_class = ITEM_SIZE_HUGE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 400 // can store a ton of shit!

/obj/item/storage/backpack/cultpack
	name = "trophy rack"
	desc = "It's useful for both carrying extra gear and proudly declaring your insanity."
	icon = 'icons/obj/items/storage/backpack/backpack_cult.dmi'

/obj/item/storage/backpack/clown
	name = "Giggles von Honkerton"
	desc = "It's a backpack made by Honk! Co."
	icon = 'icons/obj/items/storage/backpack/backpack_clown.dmi'

/obj/item/storage/backpack/medic
	name = "medical backpack"
	desc = "It's a backpack especially designed for use in a sterile environment."
	icon = 'icons/obj/items/storage/backpack/backpack_med.dmi'

/obj/item/storage/backpack/security
	name = "security backpack"
	desc = "It's a very robust backpack."
	icon = 'icons/obj/items/storage/backpack/backpack_sec.dmi'

/obj/item/storage/backpack/captain
	name = "captain's backpack"
	desc = "It's a special backpack made exclusively for officers."
	icon = 'icons/obj/items/storage/backpack/backpack_cap.dmi'

/obj/item/storage/backpack/industrial
	name = "industrial backpack"
	desc = "It's a tough backpack for the daily grind of industrial life."
	icon = 'icons/obj/items/storage/backpack/backpack_eng.dmi'

/obj/item/storage/backpack/toxins
	name = "science backpack"
	desc = "It's a stain-resistant light backpack modeled for use in laboratories and other scientific institutions."
	icon = 'icons/obj/items/storage/backpack/backpack_sci.dmi'

/obj/item/storage/backpack/hydroponics
	name = "herbalist's backpack"
	desc = "It's a green backpack with many pockets to store plants and tools in."
	icon = 'icons/obj/items/storage/backpack/backpack_hydro.dmi'

/obj/item/storage/backpack/genetics
	name = "geneticist backpack"
	desc = "It's a backpack fitted with slots for diskettes and other workplace tools."
	icon = 'icons/obj/items/storage/backpack/backpack_genetics.dmi'

/obj/item/storage/backpack/virology
	name = "sterile backpack"
	desc = "It's a sterile backpack able to withstand different pathogens from entering its fabric."
	icon = 'icons/obj/items/storage/backpack/backpack_viro.dmi'

/obj/item/storage/backpack/chemistry
	name = "pharmacist's backpack"
	desc = "It's an orange backpack which was designed to hold beakers, pill bottles and bottles."
	icon = 'icons/obj/items/storage/backpack/backpack_chem.dmi'

/obj/item/storage/backpack/rucksack
	name = "black rucksack"
	desc = "A sturdy military-grade backpack with low-profile straps. Designed to work well with armor."
	icon = 'icons/obj/items/storage/backpack/rucksack.dmi'

/obj/item/storage/backpack/rucksack/blue
	name = "blue rucksack"
	icon = 'icons/obj/items/storage/backpack/rucksack_blue.dmi'

/obj/item/storage/backpack/rucksack/green
	name = "green rucksack"
	icon_state = "rucksack_green"
	icon = 'icons/obj/items/storage/backpack/rucksack_green.dmi'

/obj/item/storage/backpack/rucksack/navy
	name = "navy rucksack"
	icon_state = "rucksack_navy"
	icon = 'icons/obj/items/storage/backpack/rucksack_navy.dmi'

/obj/item/storage/backpack/rucksack/tan
	name = "tan rucksack"
	icon_state = "rucksack_tan"
	icon = 'icons/obj/items/storage/backpack/rucksack_tan.dmi'

/*
 * Duffle Types
 */

/obj/item/storage/backpack/dufflebag
	name = "dufflebag"
	desc = "A large dufflebag for holding extra things."
	icon = 'icons/obj/items/storage/backpack/dufflebag.dmi'
	w_class = ITEM_SIZE_HUGE
	max_storage_space = DEFAULT_BACKPACK_STORAGE + 10

/obj/item/storage/backpack/dufflebag/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_back_str, 3)
	LAZYSET(slowdown_per_slot, BP_L_HAND, 1)
	LAZYSET(slowdown_per_slot, BP_R_HAND, 1)

/obj/item/storage/backpack/dufflebag/syndie
	name = "black dufflebag"
	desc = "A large dufflebag for holding extra tactical supplies."
	icon = 'icons/obj/items/storage/backpack/dufflebag_syndie.dmi'

/obj/item/storage/backpack/dufflebag/syndie/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_back_str, 1)

/obj/item/storage/backpack/dufflebag/syndie/med
	name = "medical dufflebag"
	desc = "A large dufflebag for holding extra tactical medical supplies."
	icon_state = "duffle_syndiemed"
	icon = 'icons/obj/items/storage/backpack/dufflebag_synd_med.dmi'

/obj/item/storage/backpack/dufflebag/syndie/ammo
	name = "ammunition dufflebag"
	desc = "A large dufflebag for holding extra weapons ammunition and supplies."
	icon = 'icons/obj/items/storage/backpack/dufflebag_ammo.dmi'

/obj/item/storage/backpack/dufflebag/captain
	name = "captain's dufflebag"
	desc = "A large dufflebag for holding extra captainly goods."
	icon = 'icons/obj/items/storage/backpack/dufflebag_cap.dmi'

/obj/item/storage/backpack/dufflebag/med
	name = "medical dufflebag"
	desc = "A large dufflebag for holding extra medical supplies."
	icon = 'icons/obj/items/storage/backpack/dufflebag_med.dmi'

/obj/item/storage/backpack/dufflebag/sec
	name = "security dufflebag"
	desc = "A large dufflebag for holding extra security supplies and ammunition."
	icon = 'icons/obj/items/storage/backpack/dufflebag_sec.dmi'

/obj/item/storage/backpack/dufflebag/eng
	name = "industrial dufflebag"
	desc = "A large dufflebag for holding extra tools and supplies."
	icon = 'icons/obj/items/storage/backpack/dufflebag_eng.dmi'

/obj/item/storage/backpack/dufflebag/firefighter/WillContain()
	return list(
		/obj/item/storage/belt/fire_belt/full,
		/obj/item/clothing/suit/fire,
		/obj/item/chems/spray/extinguisher,
		/obj/item/clothing/gloves/fire,
		/obj/item/clothing/accessory/fire_overpants,
		/obj/item/tank/emergency/oxygen/double/red,
		/obj/item/clothing/head/hardhat/firefighter,
		/obj/item/chems/spray/extinguisher
	)
/*
 * Satchel Types
 */

/obj/item/storage/backpack/satchel
	name = "satchel"
	desc = "A trendy looking satchel."
	icon = 'icons/obj/items/storage/backpack/satchel.dmi'

/obj/item/storage/backpack/satchel/grey
	name = "grey satchel"

/obj/item/storage/backpack/satchel/grey/withwallet/WillContain()
	return /obj/item/storage/wallet/random

/obj/item/storage/backpack/satchel/leather //brown, master type
	name = "brown leather satchel"
	desc = "A very fancy satchel made of some kind of leather."
	color = "#3d2711"

/obj/item/storage/backpack/satchel/leather/khaki
	name = "khaki leather satchel"
	color = "#baa481"

/obj/item/storage/backpack/satchel/leather/black
	name = "black leather satchel"
	color = "#212121"

/obj/item/storage/backpack/satchel/leather/navy
	name = "navy leather satchel"
	color = "#1c2133"

/obj/item/storage/backpack/satchel/leather/olive
	name = "olive leather satchel"
	color = "#544f3d"

/obj/item/storage/backpack/satchel/leather/reddish
	name = "auburn leather satchel"
	color = "#512828"

/obj/item/storage/backpack/satchel/pocketbook //black, master type
	name = "black pocketbook"
	desc = "A neat little folding clasp pocketbook with a shoulder sling."
	icon = 'icons/obj/items/storage/backpack/pocketbook.dmi'

	w_class = ITEM_SIZE_HUGE // to avoid recursive backpacks
	slot_flags = SLOT_BACK
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_LARGEBOX_STORAGE
	color = "#212121"

/obj/item/storage/backpack/satchel/pocketbook/brown
	name = "brown pocketbook"
	color = "#3d2711"

/obj/item/storage/backpack/satchel/pocketbook/reddish
	name = "auburn pocketbook"
	color = "#512828"

/obj/item/storage/backpack/satchel/eng
	name = "industrial satchel"
	desc = "A tough satchel with extra pockets."
	icon = 'icons/obj/items/storage/backpack/satchel_eng.dmi'

/obj/item/storage/backpack/satchel/med
	name = "medical satchel"
	desc = "A sterile satchel used in medical departments."
	icon = 'icons/obj/items/storage/backpack/satchel_med.dmi'

/obj/item/storage/backpack/satchel/vir
	name = "virologist satchel"
	desc = "A sterile satchel with virologist colours."
	icon = 'icons/obj/items/storage/backpack/satchel_viro.dmi'

/obj/item/storage/backpack/satchel/chem
	name = "pharmacist satchel"
	desc = "A sterile satchel with pharmacist colours."
	icon = 'icons/obj/items/storage/backpack/satchel_chem.dmi'

/obj/item/storage/backpack/satchel/gen
	name = "geneticist satchel"
	desc = "A sterile satchel with geneticist colours."
	icon = 'icons/obj/items/storage/backpack/satchel_genetics.dmi'

/obj/item/storage/backpack/satchel/sec
	name = "security satchel"
	desc = "A robust satchel for security related needs."
	icon = 'icons/obj/items/storage/backpack/satchel_sec.dmi'

/obj/item/storage/backpack/satchel/hyd
	name = "hydroponics satchel"
	desc = "A green satchel for plant related work."
	icon = 'icons/obj/items/storage/backpack/satchel_hydro.dmi'

/obj/item/storage/backpack/satchel/cap
	name = "captain's satchel"
	desc = "An exclusive satchel for officers."
	icon = 'icons/obj/items/storage/backpack/satchel_cap.dmi'

//Smuggler's satchel
/obj/item/storage/backpack/satchel/flat
	name = "smuggler's satchel"
	desc = "A very slim satchel that can easily fit into tight spaces."
	level = 1
	w_class = ITEM_SIZE_NORMAL //Can fit in backpacks itself.
	storage_slots = 5
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 15
	cant_hold = list(/obj/item/storage/backpack/satchel/flat) //muh recursive backpacks

/obj/item/storage/backpack/satchel/flat/WillContain()
	return list(
		/obj/item/stack/tile/floor,
		/obj/item/crowbar
	)

/obj/item/storage/backpack/satchel/flat/handle_mouse_drop(var/atom/over, var/mob/user)
	var/turf/T = get_turf(src)
	if(hides_under_flooring() && isturf(T) && !T.is_plating())
		return TRUE
	. = ..()

/obj/item/storage/backpack/satchel/flat/hide(var/i)
	set_invisibility(i ? 101 : 0)
	anchored = i ? TRUE : FALSE
	alpha = i ? 128 : initial(alpha)

/obj/item/storage/backpack/satchel/flat/attackby(obj/item/W, mob/user)
	var/turf/T = get_turf(src)
	if(hides_under_flooring() && isturf(T) && !T.is_plating())
		to_chat(user, "<span class='warning'>You must remove the plating first.</span>")
		return 1
	return ..()

//ERT backpacks.
/obj/item/storage/backpack/ert
	name = "emergency response team backpack"
	desc = "A spacious backpack with lots of pockets, used by members of the Emergency Response Team."
	icon = 'icons/obj/items/storage/backpack/backpack_ert.dmi'
	var/marking_state
	var/marking_colour

/obj/item/storage/backpack/ert/on_update_icon()
	. = ..()
	if(marking_state)
		var/image/I = image(icon, marking_state)
		I.color = marking_colour
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)

/obj/item/storage/backpack/ert/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay && slot == slot_back_str && marking_state)
		var/image/I = image(overlay.icon, "[overlay.icon_state]-[marking_state]")
		I.color = marking_colour
		I.appearance_flags |= RESET_COLOR
		overlay.add_overlay(I)
	. = ..()

/obj/item/storage/backpack/ert/commander
	name = "emergency response team commander backpack"
	desc = "A spacious backpack with lots of pockets, worn by the commander of an Emergency Response Team."
	marking_colour = COLOR_BLUE_GRAY
	marking_state = "com"

/obj/item/storage/backpack/ert/security
	name = "emergency response team security backpack"
	desc = "A spacious backpack with lots of pockets, worn by security members of an Emergency Response Team."
	marking_colour = COLOR_NT_RED
	marking_state = "sec"

/obj/item/storage/backpack/ert/engineer
	name = "emergency response team engineer backpack"
	desc = "A spacious backpack with lots of pockets, worn by engineering members of an Emergency Response Team."
	marking_colour = COLOR_GOLD
	marking_state = "eng"

/obj/item/storage/backpack/ert/medical
	name = "emergency response team medical backpack"
	desc = "A spacious backpack with lots of pockets, worn by medical members of an Emergency Response Team."
	marking_colour = COLOR_OFF_WHITE
	marking_state = "med"

/*
 * Messenger Bags
 */

/obj/item/storage/backpack/messenger
	name = "messenger bag"
	desc = "A sturdy backpack worn over one shoulder."
	icon = 'icons/obj/items/storage/backpack/messenger.dmi'

/obj/item/storage/backpack/messenger/chem
	name = "pharmacy messenger bag"
	desc = "A serile backpack worn over one shoulder. This one is in Chemistry colors."
	icon = 'icons/obj/items/storage/backpack/messenger_chem.dmi'

/obj/item/storage/backpack/messenger/med
	name = "medical messenger bag"
	desc = "A sterile backpack worn over one shoulder used in medical departments."
	icon = 'icons/obj/items/storage/backpack/messenger_med.dmi'

/obj/item/storage/backpack/messenger/viro
	name = "virology messenger bag"
	desc = "A sterile backpack worn over one shoulder. This one is in Virology colors."
	icon = 'icons/obj/items/storage/backpack/messenger_viro.dmi'

/obj/item/storage/backpack/messenger/com
	name = "captain's messenger bag"
	desc = "A special backpack worn over one shoulder. This one is made specifically for officers."
	icon = 'icons/obj/items/storage/backpack/messenger_cap.dmi'

/obj/item/storage/backpack/messenger/engi
	name = "engineering messenger bag"
	desc = "A strong backpack worn over one shoulder. This one is designed for industrial work."
	icon = 'icons/obj/items/storage/backpack/messenger_eng.dmi'

/obj/item/storage/backpack/messenger/hyd
	name = "hydroponics messenger bag"
	desc = "A backpack worn over one shoulder.  This one is designed for plant-related work."
	icon = 'icons/obj/items/storage/backpack/messenger_hydro.dmi'

/obj/item/storage/backpack/messenger/sec
	name = "security messenger bag"
	desc = "A tactical backpack worn over one shoulder. This one is in Security colors."
	icon = 'icons/obj/items/storage/backpack/messenger_sec.dmi'
