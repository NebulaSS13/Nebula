//Biosuit complete with shoes (in the item sprite)
/obj/item/clothing/head/bio_hood
	name = "bio hood"
	icon = 'icons/clothing/head/biosuit/_biosuit.dmi'
	desc = "A hood that protects the head and face from biological comtaminants."
	permeability_coefficient = 0
	armor = list(
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_MINOR
		)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCK_ALL_HAIR
	item_flags = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES|SLOT_EARS
	siemens_coefficient = 0.9
	origin_tech = @'{"materials":3, "engineering":3}'
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_REINFORCEMENT
	)
	replaced_in_loadout = FALSE

/obj/item/clothing/suit/bio_suit
	name = "bio suit"
	desc = "A suit that protects against biological contamination."
	icon = 'icons/clothing/suits/biosuit/_biosuit.dmi'
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0
	permeability_coefficient = 0
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS|SLOT_TAIL
	allowed = list(/obj/item/tank/emergency,/obj/item/pen,/obj/item/flashlight/pen,/obj/item/scanner/health,/obj/item/scanner/breath,/obj/item/ano_scanner,/obj/item/clothing/head/bio_hood,/obj/item/clothing/mask/gas)
	armor = list(
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_MINOR
		)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	item_flags = ITEM_FLAG_THICKMATERIAL
	siemens_coefficient = 0.9
	origin_tech = @'{"materials":3, "engineering":3}'
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_REINFORCEMENT
	)
	replaced_in_loadout = FALSE

/obj/item/clothing/suit/bio_suit/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 1)

//Standard biosuit, orange stripe
/obj/item/clothing/head/bio_hood/general
/obj/item/clothing/suit/bio_suit/general

//Virology biosuit, green stripe
/obj/item/clothing/head/bio_hood/virology
	icon = 'icons/clothing/head/biosuit/virology.dmi'

/obj/item/clothing/suit/bio_suit/virology
	icon = 'icons/clothing/suits/biosuit/virology.dmi'

//Security biosuit, grey with red stripe across the chest
/obj/item/clothing/head/bio_hood/security
	icon = 'icons/clothing/head/biosuit/security.dmi'

/obj/item/clothing/suit/bio_suit/security
	icon = 'icons/clothing/suits/biosuit/security.dmi'

//Janitor's biosuit, grey with purple arms
/obj/item/clothing/head/bio_hood/janitor
	icon = 'icons/clothing/head/biosuit/janitor.dmi'

/obj/item/clothing/suit/bio_suit/janitor
	icon = 'icons/clothing/suits/biosuit/janitor.dmi'

//Scientist's biosuit, white with a pink-ish hue
/obj/item/clothing/head/bio_hood/scientist
	icon = 'icons/clothing/head/biosuit/scientist.dmi'

/obj/item/clothing/suit/bio_suit/scientist
	icon = 'icons/clothing/suits/biosuit/scientist.dmi'

//CMO's biosuit, blue stripe
/obj/item/clothing/head/bio_hood/cmo
	icon = 'icons/clothing/head/biosuit/cmo.dmi'

/obj/item/clothing/suit/bio_suit/cmo
	icon = 'icons/clothing/suits/biosuit/cmo.dmi'

//Plague Dr mask can be found in clothing/masks/gasmask.dm
/obj/item/clothing/suit/bio_suit/plaguedoctorsuit
	name = "plague doctor suit"
	desc = "It protected doctors from the Black Death, back then. You bet your arse it's gonna help you against space plague."
	icon = 'icons/clothing/suits/biosuit/plague.dmi'
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL
	origin_tech = @'{"materials":1,"engineering":1,"biotech":1}'
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_REINFORCEMENT
	)
