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
	icon_state = "bluetag"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO
	allowed = list (/obj/item/gun/energy/lasertag/blue)
	siemens_coefficient = 3.0

/obj/item/clothing/suit/redtag
	name = "red laser tag armour"
	desc = "Reputed to go faster."
	icon_state = "redtag"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO
	allowed = list (/obj/item/gun/energy/lasertag/red)
	siemens_coefficient = 3.0

/*
 * Costume
 */
/obj/item/clothing/suit/pirate
	name = "pirate coat"
	desc = "Yarr."
	icon_state = "pirate"
	body_parts_covered = UPPER_TORSO|ARMS


/obj/item/clothing/suit/hgpirate
	name = "pirate captain coat"
	desc = "Yarr."
	icon_state = "hgpirate"
	flags_inv = HIDEJUMPSUIT
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS


/obj/item/clothing/suit/cyborg_suit
	name = "cyborg suit"
	desc = "Suit for a cyborg costume."
	icon_state = "death"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	fire_resist = T0C+5200
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/greatcoat
	name = "great coat"
	desc = "A heavy great coat."
	icon_state = "nazi"


/obj/item/clothing/suit/johnny_coat
	name = "johnny~~ coat"
	desc = "Johnny~~"
	icon_state = "johnny"


/obj/item/clothing/suit/justice
	name = "justice suit"
	desc = "This pretty much looks ridiculous."
	icon_state = "justice"
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET


/obj/item/clothing/suit/judgerobe
	name = "judge's robe"
	desc = "This robe commands authority."
	icon_state = "judge"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/storage/fancy/cigarettes,/obj/item/cash)
	flags_inv = HIDEJUMPSUIT


/obj/item/clothing/suit/apron/overalls
	name = "coveralls"
	desc = "A set of denim overalls."
	icon_state = "overalls"
	item_state = "overalls"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS


/obj/item/clothing/suit/syndicatefake
	name = "red space suit replica"
	icon_state = "syndicate"
	desc = "A plastic replica of the syndicate space suit, you'll look just like a real murderous syndicate agent in this! This is a toy, it is not made for use in space!"
	w_class = ITEM_SIZE_NORMAL
	allowed = list(/obj/item/flashlight,/obj/item/tank/emergency,/obj/item/toy)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET

/obj/item/clothing/suit/hastur
	name = "Hastur's Robes"
	desc = "Robes not meant to be worn by man."
	icon_state = "hastur"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/imperium_monk
	name = "Imperium monk"
	desc = "Have YOU killed a xenos today?"
	icon_state = "imperium_monk"
	body_parts_covered = HEAD|UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	flags_inv = HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/chickensuit
	name = "Chicken Suit"
	desc = "A suit made long ago by the ancient empire KFC."
	icon_state = "chickensuit"
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS|FEET
	flags_inv = HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 2.0


/obj/item/clothing/suit/monkeysuit
	name = "Monkey Suit"
	desc = "A suit that looks like a primate."
	icon_state = "monkeysuit"
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS|FEET|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 2.0


/obj/item/clothing/suit/holidaypriest
	name = "Holiday Priest"
	desc = "This is a nice holiday my son."
	icon_state = "holidaypriest"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT


/obj/item/clothing/suit/cardborg
	name = "cardborg suit"
	desc = "An ordinary cardboard box with holes cut in the sides."
	icon_state = "cardborg"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
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
	icon_state = "straight_jacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL

/obj/item/clothing/suit/straight_jacket/equipped(var/mob/user, var/slot)
	if(slot == slot_wear_suit)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.drop_from_inventory(C.handcuffed)
		user.drop_l_hand()
		user.drop_r_hand()

/obj/item/clothing/suit/ianshirt
	name = "worn shirt"
	desc = "A worn out, curiously comfortable t-shirt with a picture of Ian. You wouldn't go so far as to say it feels like being hugged when you wear it, but it's pretty close. Good for sleeping in."
	icon_state = "ianshirt"
	body_parts_covered = UPPER_TORSO|ARMS

//pyjamas
//originally intended to be pinstripes >.>

/obj/item/clothing/under/bluepyjamas
	name = "blue pyjamas"
	desc = "Slightly old-fashioned sleepwear."
	icon_state = "blue_pyjamas"
	item_state = "blue_pyjamas"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS

/obj/item/clothing/under/redpyjamas
	name = "red pyjamas"
	desc = "Slightly old-fashioned sleepwear."
	icon_state = "red_pyjamas"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS

//coats
/obj/item/clothing/suit/leathercoat
	name = "longcoat"
	icon_state = "world"
	icon = 'icons/clothing/suit/leathercoat.dmi'
	on_mob_icon = 'icons/clothing/suit/leathercoat.dmi'
	material = MAT_LEATHER_GENERIC
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
		var/mutable_appearance/S = get_mutable_overlay(I.icon, "shine")
		S.alpha = max(shine, artificial_shine)/100 * 255
		I.overlays += S
	return I

/obj/item/clothing/suit/leathercoat/synth
	material = MAT_LEATHER_SYNTH
	artificial_shine = 80

//stripper
/obj/item/clothing/under/stripper
	body_parts_covered = 0

/obj/item/clothing/under/stripper/mankini
	name = "mankini"
	desc = "No honest man would wear this abomination."
	icon_state = "mankini"
	siemens_coefficient = 1

/obj/item/clothing/suit/xenos
	name = "xenos suit"
	desc = "A suit made out of chitinous alien hide."
	icon_state = "xenos"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 2.0
//swimsuit
/obj/item/clothing/under/swimsuit/
	siemens_coefficient = 1
	body_parts_covered = 0

/obj/item/clothing/under/swimsuit/black
	name = "black swimsuit"
	desc = "An oldfashioned black swimsuit."
	icon_state = "swim_black"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/blue
	name = "blue swimsuit"
	desc = "An oldfashioned blue swimsuit."
	icon_state = "swim_blue"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/purple
	name = "purple swimsuit"
	desc = "An oldfashioned purple swimsuit."
	icon_state = "swim_purp"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/green
	name = "green swimsuit"
	desc = "An oldfashioned green swimsuit."
	icon_state = "swim_green"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/red
	name = "red swimsuit"
	desc = "An oldfashioned red swimsuit."
	icon_state = "swim_red"
	siemens_coefficient = 1

/obj/item/clothing/suit/storage/toggle/bomber
	name = "bomber jacket"
	desc = "A thick, well-worn WW2 leather bomber jacket."
	icon_state = "bomber"
	icon_open = "bomber_open"
	icon_closed = "bomber"
	body_parts_covered = UPPER_TORSO|ARMS
	cold_protection = UPPER_TORSO|ARMS
	min_cold_protection_temperature = T0C - 20
	siemens_coefficient = 0.7

/obj/item/clothing/suit/storage/leather_jacket
	name = "black leather jacket"
	desc = "A black leather coat."
	icon_state = "leather_jacket"
	body_parts_covered = UPPER_TORSO|ARMS

//This one has buttons for some reason
/obj/item/clothing/suit/storage/toggle/brown_jacket
	name = "leather jacket"
	desc = "A brown leather coat."
	icon_state = "brown_jacket"
	icon_open = "brown_jacket_open"
	icon_closed = "brown_jacket"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/agent_jacket
	name = "agent jacket"
	desc = "A black leather jacket belonging to an agent of the Sol Federal Police."
	icon_state = "agent_jacket"
	icon_open = "agent_jacket_open"
	icon_closed = "agent_jacket"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/hoodie
	name = "hoodie"
	desc = "A warm sweatshirt."
	icon_state = "hoodie"
	icon_open = "hoodie_open"
	icon_closed = "hoodie"
	min_cold_protection_temperature = T0C - 20
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/hoodie/cti
	name = "\improper CTI hoodie"
	desc = "A warm, black sweatshirt.  It bears the letters 'CTI' on the back, a lettering to the prestigious university in Tau Ceti, Ceti Technical Institute.  There is a blue supernova embroidered on the front, the emblem of CTI."
	icon_state = "cti_hoodie"
	icon_open = "cti_hoodie_open"
	icon_closed = "cti_hoodie"

/obj/item/clothing/suit/storage/toggle/hoodie/mu
	name = "\improper Mariner University hoodie"
	desc = "A warm, gray sweatshirt.  It bears the letters 'MU' on the front, a lettering to the well-known public college, Mariner University."
	icon_state = "mu_hoodie"
	icon_open = "mu_hoodie_open"
	icon_closed = "mu_hoodie"

/obj/item/clothing/suit/storage/toggle/hoodie/smw
	name = "\improper Space Mountain Wind hoodie"
	desc = "A warm, black sweatshirt.  It has the logo for the popular softdrink Space Mountain Wind on both the front and the back."
	icon_state = "smw_hoodie"
	icon_open = "smw_hoodie_open"
	icon_closed = "smw_hoodie"

/obj/item/clothing/suit/storage/toggle/hoodie/black
	name = "black hoodie"
	desc = "A warm, black sweatshirt."
	color = COLOR_DARK_GRAY

/obj/item/clothing/suit/storage/mbill
	name = "shipping jacket"
	desc = "A green jacket bearing the logo of Major Bill's Shipping."
	icon_state = "mbill"

/*
 * Track Jackets
 */
/obj/item/clothing/suit/storage/toggle/track
	name = "track jacket"
	desc = "A track jacket, for the athletic."
	icon_state = "trackjacket"
	icon_open = "trackjacket_open"
	icon_closed = "trackjacket"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/track/blue
	name = "blue track jacket"
	desc = "A blue track jacket, for the athletic."
	icon_state = "trackjacketblue"
	icon_open = "trackjacketblue_open"
	icon_closed = "trackjacketblue"

/obj/item/clothing/suit/storage/toggle/track/red
	name = "red track jacket"
	desc = "A red track jacket, for the athletic."
	icon_state = "trackjacketred"
	icon_open = "trackjacketred_open"
	icon_closed = "trackjacketred"

/obj/item/clothing/suit/storage/toggle/track/navy
	name = "navy track jacket"
	desc = "A navy track jacket, for the athletic."
	icon_state = "trackjacketnavy"
	icon_open = "trackjacketnavy_open"
	icon_closed = "trackjacketnavy"

/obj/item/clothing/suit/rubber
	name = "human suit"
	desc = "A Human suit made out of rubber."
	icon_state = "mansuit"

/obj/item/clothing/suit/hospital
	name = "hospital gown"
	desc = "A thin, long and loose robe-like garment worn by people undergoing active medical treatment."
	icon_state = "hospitalgown"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
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
	var/sleeves_color = "#ffffff"
	icon_state = "letterman"
	item_state = "letterman"

/obj/item/clothing/suit/letterman/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/suit/letterman/on_update_icon()
	cut_overlays()
	var/image/I = image(icon, "letterman_overlay")
	I.appearance_flags |= RESET_COLOR
	I.color = sleeves_color
	add_overlay(I, TRUE)

/obj/item/clothing/suit/letterman/get_mob_overlay(mob/user_mob, slot)
	. = ..()
	if(slot == slot_wear_suit_str)
		var/image/I = .
		I.overlays += overlay_image(I.icon, "letterman_overlay", sleeves_color, RESET_COLOR)

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
	sleeves_color = "#dfd5cd"

/obj/item/clothing/suit/letterman/green
	name = "green letterman jacket"
	desc = "A green letter jacket often given to members of a varsity team."
	color = "#82e011"

//Space santa outfit suit
/obj/item/clothing/head/santahat
	name = "Santa's hat"
	desc = "Ho ho ho. Merrry X-mas!"
	icon_state = "santahat"
	item_state = "santahat"
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0

/obj/item/clothing/suit/santa
	name = "Santa's suit"
	desc = "Festive!"
	icon_state = "santa"
	allowed = list(/obj/item) //for stuffing exta special presents
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0