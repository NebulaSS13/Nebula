/datum/gear/head/baxxid_hood
	display_name = "baxxid hood"
	path = /obj/item/clothing/head/baxxid/hood/long
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/baxxid_wig
	display_name = "baxxid wig"
	path = /obj/item/clothing/head/baxxid/big_wig
	description = "A large blonde wig"

/obj/item/clothing/head/baxxid
	name = "baxxid head clothing"
	desc = "A parent item for stuff you put on top of a baxxid."
	species_restricted = list(SPECIES_BAXXID)
	icon_state = "world"

/obj/item/clothing/head/baxxid/hood
	name = "short baxxid hood"
	desc = "A large piece of cloth with holes in it, designed to be worn by baxxid."
	icon = 'maps/tradeship/icons/hood_short_baxxid.dmi'
	on_mob_icon = 'maps/tradeship/icons/hood_short_baxxid.dmi'

/obj/item/clothing/head/baxxid/hood/long
	name = "baxxid hood"
	icon = 'maps/tradeship/icons/hood_long_baxxid.dmi'
	on_mob_icon = 'maps/tradeship/icons/hood_long_baxxid.dmi'
	color = COLOR_PURPLE

/obj/item/clothing/head/baxxid/hood/long/on_update_icon()
	. = ..()
	var/image/I = image(icon, "[icon_state]-trim")
	I.appearance_flags |= RESET_COLOR
	overlays = list(I)

/obj/item/clothing/head/baxxid/hood/long/apply_overlays(var/mob/user_mob, var/bodytype, var/image/overlay, var/slot)
	if(slot == slot_head_str)
		var/image/I = image(icon, "[bodytype]-trim")
		I.appearance_flags |= RESET_COLOR
		overlay.overlays = list(I)
	. = ..()

/obj/item/clothing/head/baxxid/big_wig
	name = "big wig"
	desc = "A really cool wig, which is unfortunately too large for a regular human."
	icon = 'maps/tradeship/icons/wig_big_blonde.dmi'
	on_mob_icon = 'maps/tradeship/icons/wig_big_blonde.dmi'