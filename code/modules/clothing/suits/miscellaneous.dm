/*
 * Contains:
 *		Lasertag
 *		Costume
 *		Misc
 */

/*
 * Lasertag
 */
/obj/item/clothing/suit/bluetag
	name = "blue laser tag armour"
	desc = "Blue Pride, Galaxy Wide."
	icon = 'icons/clothing/suit/bluetag.dmi'
	blood_overlay_type = "armor"
	body_parts_covered = SLOT_UPPER_BODY
	allowed = list (/obj/item/gun/energy/lasertag/blue)
	siemens_coefficient = 3.0

/obj/item/clothing/suit/redtag
	name = "red laser tag armour"
	desc = "Reputed to go faster."
	icon = 'icons/clothing/suit/redtag.dmi'
	blood_overlay_type = "armor"
	body_parts_covered = SLOT_UPPER_BODY
	allowed = list (/obj/item/gun/energy/lasertag/red)
	siemens_coefficient = 3.0

/*
 * Costume
 */
/obj/item/clothing/suit/pirate
	name = "pirate coat"
	desc = "Yarr."
	icon = 'icons/clothing/suit/pirate.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS

/obj/item/clothing/suit/hgpirate
	name = "pirate captain coat"
	desc = "Yarr."
	icon = 'icons/clothing/suit/pirate_captain.dmi'
	flags_inv = HIDEJUMPSUIT
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS|SLOT_LEGS

/obj/item/clothing/suit/judgerobe
	name = "judge's robe"
	desc = "This robe commands authority."
	icon = 'icons/clothing/suit/judge.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	allowed = list(/obj/item/storage/fancy/cigarettes,/obj/item/cash)
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/apron/overalls
	name = "coveralls"
	desc = "A set of denim overalls."
	icon = 'icons/clothing/suit/overalls.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS

/obj/item/clothing/suit/syndicatefake
	name = "red space suit replica"
	desc = "A plastic replica of the syndicate space suit, you'll look just like a real murderous syndicate agent in this! This is a toy, it is not made for use in space!"
	icon = 'icons/clothing/suit/space/syndicate/red.dmi'
	w_class = ITEM_SIZE_NORMAL
	allowed = list(/obj/item/flashlight,/obj/item/tank/emergency,/obj/item/toy)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS|SLOT_HANDS|SLOT_LEGS|SLOT_FEET

/obj/item/clothing/suit/hastur
	name = "Hastur's Robes"
	desc = "Robes not meant to be worn by man."
	icon = 'icons/clothing/suit/hastur.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/imperium_monk
	name = "Imperium monk"
	desc = "Have YOU killed a xenos today?"
	icon = 'icons/clothing/suit/w40k.dmi'
	body_parts_covered = SLOT_HEAD|SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS
	flags_inv = HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/chickensuit
	name = "Chicken Suit"
	desc = "A suit made long ago by the ancient empire KFC."
	icon = 'icons/clothing/suit/chicken.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET
	flags_inv = HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 2.0

/obj/item/clothing/suit/monkeysuit
	name = "Monkey Suit"
	desc = "A suit that looks like a primate."
	icon = 'icons/clothing/suit/monkey.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 2.0

/obj/item/clothing/suit/holidaypriest
	name = "Holiday Priest"
	desc = "This is a nice holiday my son."
	icon = 'icons/clothing/suit/holidaypriest.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/cardborg
	name = "cardborg suit"
	desc = "An ordinary cardboard box with holes cut in the sides."
	icon = 'icons/clothing/suit/cardborg.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/cardborg/Initialize()
	. = ..()
	set_extension(src, /datum/extension/appearance/cardborg)

/*
 * Misc
 */

/obj/item/clothing/suit/straight_jacket
	name = "straitjacket"
	desc = "A suit that completely restrains the wearer."
	icon = 'icons/clothing/suit/straightjacket.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL

/obj/item/clothing/suit/straight_jacket/equipped(var/mob/user, var/slot)
	if(slot == slot_wear_suit_str)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.drop_from_inventory(C.handcuffed)
		user.drop_held_items()

/obj/item/clothing/suit/ianshirt
	name = "worn shirt"
	desc = "A worn out, curiously comfortable t-shirt with a picture of Ian. You wouldn't go so far as to say it feels like being hugged when you wear it, but it's pretty close. Good for sleeping in."
	icon = 'icons/clothing/suit/ianshirt.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS

//pyjamas
//originally intended to be pinstripes >.>

/obj/item/clothing/under/bluepyjamas
	name = "blue pyjamas"
	desc = "Slightly old-fashioned sleepwear."
	icon_state = "blue_pyjamas"
	item_state = "blue_pyjamas"
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS|SLOT_LEGS

/obj/item/clothing/under/redpyjamas
	name = "red pyjamas"
	desc = "Slightly old-fashioned sleepwear."
	icon_state = "red_pyjamas"
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS|SLOT_LEGS

//coats
/obj/item/clothing/suit/leathercoat
	name = "longcoat"
	icon = 'icons/clothing/suit/leathercoat.dmi'
	material = /decl/material/solid/leather
	applies_material_colour = TRUE
	applies_material_name = TRUE
	material_armor_multiplier = 0.8
	var/shine 
	var/artificial_shine

/obj/item/clothing/suit/leathercoat/set_material(var/new_material)
	..()
	if(material)
		if(material.reflectiveness >= MAT_VALUE_DULL)
			shine = material.reflectiveness
		desc = "A long, thick [material.use_name] coat."

/obj/item/clothing/suit/leathercoat/apply_overlays(var/mob/user_mob, var/bodytype, var/image/overlay, var/slot)
	var/image/I = ..()
	if(shine > 0 && slot == slot_wear_suit_str)
		var/mutable_appearance/S = mutable_appearance(I.icon, "shine")
		S.alpha = max(shine, artificial_shine)/100 * 255
		I.overlays += S
	return I

/obj/item/clothing/suit/leathercoat/synth
	material = /decl/material/solid/leather/synth
	artificial_shine = 80

//stripper
/obj/item/clothing/under/stripper/mankini
	name = "mankini"
	desc = "No honest man would wear this abomination."
	icon_state = "mankini"
	siemens_coefficient = 1
	body_parts_covered = 0

/obj/item/clothing/suit/xenos
	name = "xenos suit"
	desc = "A suit made out of chitinous alien hide."
	icon = 'icons/clothing/suit/xeno.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 2.0

/obj/item/clothing/suit/storage/toggle/bomber
	name = "bomber jacket"
	desc = "A thick, well-worn WW2 leather bomber jacket."
	icon = 'icons/clothing/suit/leather_jacket/bomber.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS
	cold_protection = SLOT_UPPER_BODY|SLOT_ARMS
	min_cold_protection_temperature = T0C - 20
	siemens_coefficient = 0.7

/obj/item/clothing/suit/storage/leather_jacket
	name = "black leather jacket"
	desc = "A black leather coat."
	icon = 'icons/clothing/suit/leather_jacket/black.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS

//This one has buttons for some reason
/obj/item/clothing/suit/storage/toggle/brown_jacket
	name = "leather jacket"
	desc = "A brown leather coat."
	icon = 'icons/clothing/suit/leather_jacket/brown.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS

/obj/item/clothing/suit/storage/toggle/agent_jacket
	name = "agent jacket"
	desc = "A black leather jacket belonging to an agent of the Sol Federal Police."
	icon = 'icons/clothing/suit/leather_jacket/agent.dmi'
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS

/obj/item/clothing/suit/storage/toggle/hoodie
	name = "hoodie"
	desc = "A warm sweatshirt."
	icon = 'icons/clothing/suit/hoodie.dmi'
	min_cold_protection_temperature = T0C - 20
	cold_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS

/obj/item/clothing/suit/storage/toggle/hoodie/black
	name = "black hoodie"
	desc = "A warm, black sweatshirt."
	color = COLOR_DARK_GRAY

/*
 * Track Jackets
 */
/obj/item/clothing/suit/storage/toggle/track
	name = "track jacket"
	desc = "A track jacket, for the athletic."
	icon = 'icons/clothing/suit/tracksuit/black.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS

/obj/item/clothing/suit/storage/toggle/track/blue
	name = "blue track jacket"
	desc = "A blue track jacket, for the athletic."
	icon = 'icons/clothing/suit/tracksuit/blue.dmi'

/obj/item/clothing/suit/storage/toggle/track/red
	name = "red track jacket"
	desc = "A red track jacket, for the athletic."
	icon = 'icons/clothing/suit/tracksuit/red.dmi'

/obj/item/clothing/suit/storage/toggle/track/navy
	name = "navy track jacket"
	desc = "A navy track jacket, for the athletic."
	icon = 'icons/clothing/suit/tracksuit/navy.dmi'

/obj/item/clothing/suit/rubber
	name = "human suit"
	desc = "A Human suit made out of rubber."
	icon = 'icons/clothing/suit/human_suit.dmi'

/obj/item/clothing/suit/hospital
	name = "hospital gown"
	desc = "A thin, long and loose robe-like garment worn by people undergoing active medical treatment."
	icon = 'icons/clothing/suit/gown.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY
	allowed = null

/obj/item/clothing/suit/hospital/blue
	color = "#99ccff"

/obj/item/clothing/suit/hospital/green
	color = "#8dd7a3"

/obj/item/clothing/suit/hospital/pink
	color = "#ffb7db"

/obj/item/clothing/suit/letterman
	name = "letterman jacket"
	desc = "A letter jacket often given to members of a varsity team."
	color = "#ee1511"
	icon = 'icons/clothing/suit/letterman.dmi'
	markings_icon = "_sleeves"
	markings_color = "#ffffff"

/obj/item/clothing/suit/letterman/red
	name = "red letterman jacket"
	desc = "A red letter jacket often given to members of a varsity team."

/obj/item/clothing/suit/letterman/blue
	name = "blue letterman jacket"
	desc = "A blue letter jacket often given to members of a varsity team."
	color = "#3a64ba"

/obj/item/clothing/suit/letterman/brown
	name = "brown letterman jacket"
	desc = "A brown letter jacket often given to members of a varsity team."
	color = "#553c2f"
	markings_color = "#dfd5cd"

/obj/item/clothing/suit/letterman/green
	name = "green letterman jacket"
	desc = "A green letter jacket often given to members of a varsity team."
	color = "#82e011"

//Space santa outfit suit
/obj/item/clothing/head/santahat
	name = "Santa's hat"
	desc = "Ho ho ho. Merrry X-mas!"
	icon = 'icons/clothing/head/santa.dmi'
	flags_inv = BLOCKHAIR
	body_parts_covered = SLOT_HEAD
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0

/obj/item/clothing/suit/santa
	name = "Santa's suit"
	desc = "Festive!"
	icon = 'icons/clothing/suit/santa.dmi'
	allowed = list(/obj/item) //for stuffing exta special presents
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0