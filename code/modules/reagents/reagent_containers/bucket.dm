/obj/item/chems/glass/bucket
	name = "bucket"
	desc = "It's a bucket."
	icon = 'icons/obj/items/bucket.dmi'
	icon_state = ICON_STATE_WORLD
	center_of_mass = @'{"x":16,"y":9}'
	w_class = ITEM_SIZE_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = @"[10,20,30,60,120,150,180]"
	chem_volume = 180
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	presentation_flags = PRESENTATION_FLAG_NAME
	material = /decl/material/solid/organic/plastic
	slot_flags = SLOT_HEAD
	drop_sound = 'sound/foley/donk1.ogg'
	pickup_sound = 'sound/foley/pickup2.ogg'

/obj/item/chems/glass/bucket/proc/get_handle_overlay()
	return overlay_image(icon, "[icon_state]-handle", COLOR_WHITE, RESET_COLOR)

/obj/item/chems/glass/bucket/update_overlays()
	add_overlay(get_handle_overlay())
	. = ..()

/obj/item/chems/glass/bucket/get_edible_material_amount(mob/eater)
	return 0

/obj/item/chems/glass/bucket/get_utensil_food_type()
	return null

/obj/item/chems/glass/bucket/attackby(var/obj/item/used_item, mob/user)
	if(istype(used_item, /obj/item/mop))
		if(REAGENT_TOTAL_VOLUME(reagents) < 1)
			to_chat(user, SPAN_WARNING("\The [src] is empty!"))
		else if(REAGENTS_FREE_SPACE(used_item.reagents) >= 5)
			reagents.trans_to_obj(used_item, 5)
			to_chat(user, SPAN_NOTICE("You wet \the [used_item] in \the [src]."))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		else
			to_chat(user, SPAN_WARNING("\The [used_item] is saturated."))
		return TRUE
	return ..()

/obj/item/chems/glass/bucket/get_reagents_overlay(state_prefix)
	if(!ATOM_IS_OPEN_CONTAINER(src))
		return null // no overlay while closed!
	if(!reagents || (REAGENT_TOTAL_VOLUME(reagents) / REAGENT_MAXIMUM_VOLUME(reagents)) < 0.8)
		return null // must be at least 80% full to show
	return ..()

/obj/item/chems/glass/bucket/wood
	desc = "It's a wooden bucket. How rustic."
	icon = 'icons/obj/items/wooden_bucket.dmi'
	chem_volume = 200
	material = /decl/material/solid/organic/wood/oak
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_COLOR //  name is already modified
	/// The material used for the chain, belts, and rivets holding the wood together, typically iron or steel.
	/// Mostly used for visual and matter reasons. Initially a typepath, set to a decl on init.
	var/decl/material/rivet_material = /decl/material/solid/metal/iron

/obj/item/chems/glass/bucket/wood/Initialize(ml, material_key)
	rivet_material = GET_DECL(rivet_material)
	. = ..()

// Until a future point where the bucket recipe is redone, the rivet material will be entirely visual.
// At some point, there could be a create_matter override to handle it, but that would require
// the crafting recipe to be changed.
// Also, pre-emptively, the entry needs to be inserted into the matter list BEFORE the parent call.
// You'll thank me later when you don't make the same mistake a second time.

/obj/item/chems/glass/bucket/wood/apply_additional_mob_overlays(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing)
	overlay.add_overlay(overlay_image(icon, "[overlay.icon_state]_overlay", rivet_material.get_reagent_color(), RESET_COLOR | RESET_ALPHA))
	return ..()

/obj/item/chems/glass/bucket/wood/update_overlays()
	. = ..()
	add_overlay(overlay_image(icon, "[icon_state]_overlay", rivet_material.get_reagent_color(), RESET_COLOR | RESET_ALPHA))

/obj/item/chems/glass/bucket/wood/get_handle_overlay()
	return overlay_image(icon, "[icon_state]-handle", rivet_material.get_reagent_color(), RESET_COLOR | RESET_ALPHA)

/obj/item/chems/glass/bucket/wood/can_lid()
	return FALSE // todo: add lid sprite?
