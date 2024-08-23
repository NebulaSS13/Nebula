/obj/item/cane
	name                = "cane"
	desc                = "A slender cane, used to keep yourself upright or to thrash rapscallions."
	icon                = 'icons/obj/items/cane.dmi'
	icon_state          = ICON_STATE_WORLD
	force               = 5
	throwforce          = 3
	throw_speed         = 1
	throw_range         = 5
	base_parry_chance   = 10
	w_class             = ITEM_SIZE_SMALL
	material            = /decl/material/solid/organic/wood/ebony
	material_alteration = MAT_FLAG_ALTERATION_ALL

/obj/item/cane/get_stance_support_value()
	return LIMB_UNUSABLE

/obj/item/cane/get_autopsy_descriptors()
	. = ..()
	. += "narrow"

/obj/item/cane/fancy/Initialize(ml, material_key)
	if(tip_material)
		LAZYSET(matter, tip_material, MATTER_AMOUNT_TRACE)
	. = ..()
	if(tip_material)
		update_icon()

/obj/item/cane/fancy/on_update_icon()
	. = ..()
	if(tip_material)
		var/decl/material/tip = GET_DECL(tip_material)
		var/tip_state = "[icon_state]-tip"
		if(check_state_in_icon(tip_state, icon))
			add_overlay(overlay_image(icon, tip_state, tip.color, (RESET_COLOR | RESET_ALPHA)))

/obj/item/cane/aluminium
	material = /decl/material/solid/metal/aluminium

/obj/item/cane/fancy
	desc = "An elegant cane with a reinforced tip."
	var/tip_material = /decl/material/solid/organic/bone //No ivory material :c

/obj/item/cane/fancy/sword
	var/obj/item/concealed_blade = /obj/item/knife/folding/combat/switchblade

/obj/item/cane/fancy/sword/Initialize()
	if(ispath(concealed_blade))
		concealed_blade = new concealed_blade(src)
	. = ..()

/obj/item/cane/fancy/sword/attack_self(var/mob/user)
	if(istype(concealed_blade))
		user.visible_message(
			SPAN_WARNING("\The [user] unsheaths \a [concealed_blade] from \the [src]!"),
			SPAN_NOTICE("You unsheathe \the [concealed_blade] from \the [src].")
		)
		// Calling drop/put in hands to properly call item drop/pickup procs
		playsound(user.loc, 'sound/weapons/flipblade.ogg', 50, 1)
		user.drop_from_inventory(src)
		user.put_in_hands(concealed_blade)
		user.put_in_hands(src)
		concealed_blade = null
		update_icon()
		return TRUE
	return ..()

/obj/item/cane/fancy/sword/attackby(var/obj/item/knife/folding/W, var/mob/user)

	if(!istype(concealed_blade) && istype(W) && user.try_unequip(W, src))
		user.visible_message(
			SPAN_NOTICE("\The [user] has sheathed \a [W] into \the [src]."),
			SPAN_NOTICE("You sheathe \the [W] into \the [src].")
		)
		concealed_blade = W
		update_icon()
		user.update_inhand_overlays()
		return TRUE
	return ..()

/obj/item/cane/fancy/sword/on_update_icon()
	icon_state = get_world_inventory_state()
	if(istype(concealed_blade))
		SetName("[initial(name)] shaft")
	else
		SetName(initial(name))
		icon_state = "[icon_state]-unsheathed"
	. = ..()
