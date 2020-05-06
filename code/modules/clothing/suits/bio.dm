//Biosuit complete with shoes (in the item sprite)
/obj/item/clothing/head/bio_hood
	name = "bio hood"
	icon = 'icons/clothing/head/biosuit/_biosuit.dmi'
	on_mob_icon = 'icons/clothing/head/biosuit/_biosuit.dmi'
	desc = "A hood that protects the head and face from biological comtaminants."
	permeability_coefficient = 0
	armor = list(
		bio = ARMOR_BIO_SHIELDED, 
		rad = ARMOR_RAD_MINOR
		)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	item_flags = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = HEAD|FACE|EYES
	siemens_coefficient = 0.9

/obj/item/clothing/suit/bio_suit
	name = "bio suit"
	desc = "A suit that protects against biological contamination."
	icon = 'icons/clothing/suit/biosuit/_biosuit.dmi'
	on_mob_icon = 'icons/clothing/suit/biosuit/_biosuit.dmi'
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0
	permeability_coefficient = 0
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/tank/emergency,/obj/item/pen,/obj/item/flashlight/pen,/obj/item/scanner/health,/obj/item/ano_scanner,/obj/item/clothing/head/bio_hood,/obj/item/clothing/mask/gas)
	armor = list(
		bio = ARMOR_BIO_SHIELDED, 
		rad = ARMOR_RAD_MINOR
		)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	item_flags = ITEM_FLAG_THICKMATERIAL
	siemens_coefficient = 0.9

/obj/item/clothing/suit/bio_suit/Initialize()
	. = ..()
	slowdown_per_slot[slot_wear_suit] = 1.0

//Standard biosuit, orange stripe
/obj/item/clothing/head/bio_hood/general
/obj/item/clothing/suit/bio_suit/general

//Virology biosuit, green stripe
/obj/item/clothing/head/bio_hood/virology
	on_mob_icon = 'icons/clothing/head/biosuit/virology.dmi'

/obj/item/clothing/suit/bio_suit/virology
	on_mob_icon = 'icons/clothing/suit/biosuit/virology.dmi'

//Security biosuit, grey with red stripe across the chest
/obj/item/clothing/head/bio_hood/security
	on_mob_icon = 'icons/clothing/head/biosuit/security.dmi'

/obj/item/clothing/suit/bio_suit/security
	on_mob_icon = 'icons/clothing/suit/biosuit/security.dmi'

//Janitor's biosuit, grey with purple arms
/obj/item/clothing/head/bio_hood/janitor
	on_mob_icon = 'icons/clothing/head/biosuit/janitor.dmi'

/obj/item/clothing/suit/bio_suit/janitor
	on_mob_icon = 'icons/clothing/suit/biosuit/janitor.dmi'

//Scientist's biosuit, white with a pink-ish hue
/obj/item/clothing/head/bio_hood/scientist
	on_mob_icon = 'icons/clothing/head/biosuit/scientist.dmi'

/obj/item/clothing/suit/bio_suit/scientist
	on_mob_icon = 'icons/clothing/suit/biosuit/scientist.dmi'

//CMO's biosuit, blue stripe
/obj/item/clothing/head/bio_hood/cmo
	on_mob_icon = 'icons/clothing/head/biosuit/cmo.dmi'

/obj/item/clothing/suit/bio_suit/cmo
	on_mob_icon = 'icons/clothing/suit/biosuit/cmo.dmi'

//Plague Dr mask can be found in clothing/masks/gasmask.dm
/obj/item/clothing/suit/bio_suit/plaguedoctorsuit
	name = "Plague doctor suit"
	desc = "It protected doctors from the Black Death, back then. You bet your arse it's gonna help you against space plague."
	icon = 'icons/clothing/suit/biosuit/plague.dmi'
	on_mob_icon = 'icons/clothing/suit/biosuit/plague.dmi'
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL
