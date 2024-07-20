/obj/item/staff
	name                = "staff"
	desc                = "A long, heavy length of material, purportedly used by wizards."
	icon                = 'icons/obj/items/staff.dmi'
	icon_state          = ICON_STATE_WORLD

	w_class             = ITEM_SIZE_HUGE
	attack_verb         = list("bludgeoned", "whacked", "disciplined", "thrashed")
	material            = /decl/material/solid/organic/wood
	material_alteration = MAT_FLAG_ALTERATION_ALL
	base_parry_chance   = 30
	_base_attack_force = 3

/obj/item/staff/get_stance_support_value()
	return LIMB_UNUSABLE

/obj/item/staff/proc/can_make_broom_with(mob/user, obj/item/thing)
	. = FALSE
	if(istype(thing, /obj/item/stack/material/bundle))
		var/obj/item/stack/material/bristles = thing
		if(!bristles.special_crafting_check())
			return FALSE
		if(bristles.get_amount() < 5)
			to_chat(user, SPAN_WARNING("You need at least 5 [bristles.plural_name] to make a broom."))
			return FALSE
		. = bristles.use(5)
	return . && user.try_unequip(src, get_turf(user))

/obj/item/staff/get_autopsy_descriptors()
	. = ..()
	. += "long"
	. += "narrow"

/obj/item/staff/attackby(obj/item/used_item, mob/user)
	if(user.a_intent != I_HURT)
		var/decl/material/bristles_material = used_item.material
		if(istype(bristles_material) && can_make_broom_with(user, used_item))
			var/obj/item/staff/broom/broom = new(get_turf(user), material?.type, bristles_material?.type)
			user.put_in_hands(broom)
			to_chat(user, SPAN_NOTICE("You secure the [bristles_material.name] to \the [src] to make \a [broom]."))
			qdel(src)
			return TRUE
	return ..()

// TODO: move back into wizard modpack when the timelines converge.
/obj/item/staff/crystal
	name = "wizard's staff"
	icon = 'icons/obj/items/staff_crystal.dmi'

/obj/item/staff/crystal/can_make_broom_with(mob/user, obj/item/thing)
	return FALSE

/obj/item/staff/crystal/Initialize(ml, material_key)
	. = ..()
	update_icon()

/obj/item/staff/crystal/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing)
	if(overlay)
		var/crystal_state = "[overlay.icon_state]-crystal"
		if(check_state_in_icon(crystal_state, overlay.icon))
			overlay.overlays += overlay_image(overlay.icon, crystal_state, COLOR_WHITE, RESET_COLOR)
	. = ..()

/obj/item/staff/crystal/on_update_icon()
	. = ..()
	var/crystal_state = "[icon_state]-crystal"
	if(check_state_in_icon(crystal_state, icon))
		add_overlay(overlay_image(icon, crystal_state, COLOR_WHITE, RESET_COLOR))

/obj/item/staff/crystal/beacon
	icon = 'icons/obj/items/staff_beacon.dmi'
