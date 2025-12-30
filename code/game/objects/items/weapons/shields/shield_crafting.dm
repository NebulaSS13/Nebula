// General item for 'proper' shield crafting.
/obj/item/shield_fasteners
	name                = "shield fasteners"
	desc                = "A handful of shaped fasteners used to hold a buckler or shield together."
	icon_state          = ICON_STATE_WORLD
	icon                = 'icons/obj/items/shield_fasteners.dmi'
	material            = /decl/material/solid/metal/iron
	color               = /decl/material/solid/metal/iron::color
	material_alteration = MAT_FLAG_ALTERATION_ALL

// TODO: single-step slapcrafting
/obj/item/shield_base
	w_class = ITEM_SIZE_LARGE
	desc = "An unfinished collection of shield bits, waiting for fastenings."
	icon_state = ICON_STATE_WORLD
	abstract_type = /obj/item/shield_base
	material = /decl/material/solid/organic/wood/oak
	color = /decl/material/solid/organic/wood/oak::color
	material_alteration = MAT_FLAG_ALTERATION_ALL
	var/wooden_icon
	var/fittings_type = /obj/item/shield_fasteners
	var/finished_type
	var/work_skill = SKILL_CONSTRUCTION

/obj/item/shield_base/attackby(obj/item/used_item, mob/user)
	if(fittings_type && istype(used_item, fittings_type) && finished_type && user.try_unequip(used_item))
		to_chat(user, SPAN_NOTICE("You start laying out \the [src] and affixing \the [used_item]."))
		if(user.do_skilled(5 SECONDS, work_skill, src, check_holding = TRUE))
			var/was_held = (loc == user)
			var/obj/item/shield/crafted/shield = new finished_type(get_turf(src), material?.type, used_item.material?.type)
			user.visible_message("\The [user] secures \the [src] with \the [used_item], finishing \a [shield].")
			qdel(src)
			qdel(used_item)
			if(was_held)
				user.put_in_hands(shield)
		return TRUE
	return ..()

/obj/item/shield_base/set_material(new_material)
	. = ..()
	if(wooden_icon)
		if(istype(material, /decl/material/solid/organic/wood))
			set_icon(wooden_icon)
		else
			set_icon(initial(icon))
		update_icon()

// Subtypes below.
/obj/item/shield_base/buckler
	name_prefix   = "unfinished"
	name          = "buckler"
	icon          = 'icons/obj/items/shield/buckler_base_metal.dmi'
	wooden_icon   = 'icons/obj/items/shield/buckler_base_wood.dmi'
	finished_type = /obj/item/shield/crafted/buckler
