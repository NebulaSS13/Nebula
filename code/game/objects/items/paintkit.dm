/obj/item/kit
	icon_state = "modkit"
	icon = 'icons/obj/items/modkit.dmi'
	var/new_name = "exosuit"     // What is the variant called?
	var/new_desc = "An exosuit." // How is the new exosuit described?
	var/new_icon                 // What base icon will the new exosuit use?
	var/new_state = "ripley"     // What base icon state with the new exosuit use.
	var/uses = 1                 // Uses before the kit deletes itself.
	var/custom = FALSE

/obj/item/kit/get_single_monetary_worth()
	. = max(round(..()), (custom ? 100 : 750) * uses) // Luxury good, value is entirely artificial.

/obj/item/kit/examine(mob/user)
	. = ..()
	to_chat(user, "It has [uses] use\s left.")

/obj/item/kit/inherit_custom_item_data(var/datum/custom_item/citem)
	custom = TRUE
	new_name =  citem.item_name
	new_desc =  citem.item_desc
	new_state = citem.item_state
	new_icon =  citem.item_icon
	. = src

/obj/item/kit/proc/use(var/amt, var/mob/user)
	uses -= amt
	playsound(get_turf(user), 'sound/items/Screwdriver.ogg', 50, 1)
	if(uses < 1)
		qdel(src)

// Root hardsuit kit defines.
// Icons for modified hardsuits need to be in the proper .dmis because suit cyclers may cock them up.
/obj/item/kit/suit
	name = "voidsuit modification kit"
	desc = "A kit for modifying a voidsuit."
	uses = 2
	var/new_light_overlay

/obj/item/kit/suit/inherit_custom_item_data(var/datum/custom_item/citem)
	. = ..()
	if(citem.additional_data["light_overlay"])
		new_light_overlay = citem.additional_data["light_overlay"]

/obj/item/clothing/head/helmet/space/void/attackby(var/obj/item/O, var/mob/user)

	if(istype(O,/obj/item/kit/suit))
		var/obj/item/kit/suit/kit = O

		to_chat(user, SPAN_NOTICE("You set about modifying \the [src] into \a [kit.new_name] void helmet."))
		SetName("[kit.new_name] void helmet")
		desc = kit.new_desc
		icon = kit.new_icon
		if(kit.new_light_overlay)
			light_overlay = kit.new_light_overlay

		var/mob/living/carbon/human/H = user
		if(istype(H))
			bodytype_equip_flags = H.bodytype.bodytype_flag
		kit.use(1,user)
		reconsider_single_icon()
		return TRUE

	return ..()

/obj/item/clothing/suit/space/void/attackby(var/obj/item/O, var/mob/user)

	if(istype(O, /obj/item/kit/suit))
		var/obj/item/kit/suit/kit = O

		to_chat(user, SPAN_NOTICE("You set about modifying \the [src] into \a [kit.new_name] voidsuit."))
		SetName("[kit.new_name] voidsuit")
		desc = kit.new_desc
		icon = kit.new_icon

		var/mob/living/carbon/human/H = user
		if(istype(H))
			bodytype_equip_flags = H.bodytype.bodytype_flag
		kit.use(1,user)
		reconsider_single_icon()
		return TRUE

	return ..()

// Mechs are handled in their attackby (mech_interaction.dm).
/obj/item/kit/paint
	name = "exosuit decal kit"
	desc = "A kit containing all the needed tools and parts to repaint a exosuit."
	var/removable = null

/obj/item/kit/paint/examine(mob/user)
	. = ..()
	to_chat(user, "This kit will add a '[new_name]' decal to a exosuit'.")

// exosuit kits.
/obj/item/kit/paint/powerloader/flames_red
	name = "\"Firestarter\" exosuit decal kit"
	new_name = "red flames"
	new_state = "flames_red"

/obj/item/kit/paint/powerloader/flames_blue
	name = "\"Burning Chrome\" exosuit decal kit"
	new_name = "blue flames"
	new_state = "flames_blue"
