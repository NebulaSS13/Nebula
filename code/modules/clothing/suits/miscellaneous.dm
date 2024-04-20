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
	allowed = list(/obj/item/box/fancy/cigarettes,/obj/item/cash)
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
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS|SLOT_HANDS|SLOT_LEGS|SLOT_FEET|SLOT_TAIL

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
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS|SLOT_TAIL
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	matter = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_TRACE)

/obj/item/clothing/suit/straight_jacket/equipped(var/mob/user, var/slot)
	. = ..()
	if(slot == slot_wear_suit_str)
		if(isliving(user))
			var/mob/living/M = user
			var/obj/item/cuffs = M.get_equipped_item(slot_handcuffed_str)
			if(cuffs)
				M.try_unequip(cuffs)
		user.drop_held_items()

/obj/item/clothing/suit/ianshirt
	name = "worn shirt"
	desc = "A worn out, curiously comfortable t-shirt with a picture of Ian. You wouldn't go so far as to say it feels like being hugged when you wear it, but it's pretty close. Good for sleeping in."
	icon = 'icons/clothing/suit/ianshirt.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS

//coats
/obj/item/clothing/suit/leathercoat
	name = "longcoat"
	icon = 'icons/clothing/suit/leathercoat.dmi'
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	material_armor_multiplier = 0.8
	material = /decl/material/solid/organic/leather
	var/shine
	var/artificial_shine

/obj/item/clothing/suit/leathercoat/set_material(var/new_material)
	..()
	if(material)
		if(material.reflectiveness >= MAT_VALUE_DULL)
			shine = material.reflectiveness
		desc = "A long, thick [material.use_name] coat."

/obj/item/clothing/suit/leathercoat/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && shine > 0 && slot == slot_wear_suit_str)
		var/mutable_appearance/S = mutable_appearance(overlay.icon, "shine")
		S.alpha = max(shine, artificial_shine)/100 * 255
		overlay.overlays += S
	. = ..()

/obj/item/clothing/suit/leathercoat/synth
	material = /decl/material/solid/organic/leather/synth
	artificial_shine = 80

//stripper
/obj/item/clothing/under/mankini
	name = "mankini"
	desc = "No honest man would wear this abomination."
	icon = 'icons/clothing/under/mankini.dmi'
	siemens_coefficient = 1
	body_parts_covered = 0

/obj/item/clothing/suit/xenos
	name = "xenos suit"
	desc = "A suit made out of chitinous alien hide."
	icon = 'icons/clothing/suit/xeno.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 2.0

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

//Space santa outfit suit
/obj/item/clothing/head/santahat
	name = "Santa's hat"
	desc = "Ho ho ho. Merrry X-mas!"
	icon = 'icons/clothing/head/santa.dmi'
	flags_inv = BLOCK_ALL_HAIR //Has a fake beard

/obj/item/clothing/suit/santa
	name = "Santa's suit"
	desc = "Festive!"
	icon = 'icons/clothing/suit/santa.dmi'
