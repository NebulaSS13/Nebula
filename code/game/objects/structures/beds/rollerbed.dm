/*
 * Roller beds
 */
/obj/structure/bed/roller
	name = "roller bed"
	icon = 'icons/obj/structures/rollerbed.dmi'
	icon_state = "down"
	anchored = FALSE
	buckle_pixel_shift = list("x" = 0, "y" = 0, "z" = 6)
	movable_flags = MOVABLE_FLAG_WHEELED
	tool_interaction_flags = 0
	padding_extension_type = null // Cannot be padded.
	var/item_form_type = /obj/item/roller	//The folded-up object path.
	var/obj/item/chems/beaker
	var/iv_attached = 0
	var/iv_stand = TRUE

// this completely circumvents normal bed icon updating, does this really even need to be a bed subtype?
/obj/structure/bed/roller/on_update_icon()
	cut_overlays()
	if(density)
		icon_state = "up"
	else
		icon_state = "down"
	if(beaker?.reagents)
		var/image/iv = image(icon, "iv[iv_attached]")
		var/percentage = round((beaker.reagents.total_volume / max(beaker.reagents.maximum_volume, 1)) * 100, 25)
		var/image/filling = image(icon, "iv_filling[percentage]")
		filling.color = beaker.reagents.get_color()
		iv.overlays += filling
		if(percentage < 25)
			iv.overlays += image(icon, "light_low")
		if(density)
			iv.pixel_y = 6
		add_overlay(iv)

/obj/structure/bed/roller/attackby(obj/item/used_item, mob/user)
	if(iv_stand && !beaker && istype(used_item, /obj/item/chems))
		if(!user.try_unequip(used_item, src))
			return TRUE
		to_chat(user, "You attach \the [used_item] to \the [src].")
		beaker = used_item
		queue_icon_update()
		return TRUE
	return ..()

/obj/structure/bed/roller/attack_hand(mob/user)
	if(!beaker || buckled_mob || !user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()
	remove_beaker(user)
	return TRUE

/obj/structure/bed/roller/proc/collapse(mob/user)
	visible_message("[user] collapses [src].")
	new item_form_type(get_turf(src))
	qdel(src)

/obj/structure/bed/roller/post_buckle_mob(mob/living/M)
	. = ..()
	if(M == buckled_mob)
		set_density(1)
		queue_icon_update()
	else
		set_density(0)
		if(iv_attached)
			detach_iv(M, usr)
		queue_icon_update()

/obj/structure/bed/roller/Process()
	if(!iv_attached || !buckled_mob || !beaker)
		return PROCESS_KILL

	//SSObj fires twice as fast as SSMobs, so gotta slow down to not OD our victims.
	if(SSobj.times_fired % 2)
		return

	if(beaker.reagents?.total_volume > 0)
		beaker.reagents.trans_to_mob(buckled_mob, beaker.amount_per_transfer_from_this, CHEM_INJECT)
		queue_icon_update()

/obj/structure/bed/roller/proc/remove_beaker(mob/user)
	to_chat(user, "You detach \the [beaker] to \the [src].")
	iv_attached = FALSE
	beaker.dropInto(loc)
	beaker = null
	queue_icon_update()

/obj/structure/bed/roller/proc/attach_iv(mob/living/human/target, mob/user)
	if(!beaker)
		return
	if(do_IV_hookup(target, user, beaker))
		iv_attached = TRUE
		queue_icon_update()
		START_PROCESSING(SSobj,src)

/obj/structure/bed/roller/proc/detach_iv(mob/living/human/target, mob/user)
	visible_message("\The [target] is taken off the IV on \the [src].")
	iv_attached = FALSE
	queue_icon_update()
	STOP_PROCESSING(SSobj,src)

/obj/structure/bed/roller/handle_mouse_drop(atom/over, mob/user, params)
	if(ishuman(user) || isrobot(user))
		if(over == buckled_mob && beaker)
			if(iv_attached)
				detach_iv(buckled_mob, user)
			else
				attach_iv(buckled_mob, user)
			return TRUE
	if(ishuman(over))
		var/mob/M = over
		if(loc == M.loc && user_buckle_mob(M, user))
			attach_iv(buckled_mob, user)
			return TRUE
	if(beaker)
		remove_beaker(user)
		return TRUE
	if(!buckled_mob)
		collapse(user)
		return TRUE
	. = ..()

/obj/item/roller
	name = "roller bed"
	desc = "A collapsed roller bed that can be carried around."
	icon = 'icons/obj/items/rollerbed.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	pickup_sound = 'sound/foley/pickup2.ogg'
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/organic/cloth = MATTER_AMOUNT_REINFORCEMENT,
	)
	var/structure_form_type = /obj/structure/bed/roller	//The deployed form path.

/obj/item/roller/get_single_monetary_worth()
	. = structure_form_type ? atom_info_repository.get_combined_worth_for(structure_form_type) : ..()

/obj/item/roller/attack_self(mob/user)
	var/obj/structure/bed/roller/R = new structure_form_type(user.loc)
	R.add_fingerprint(user)
	qdel(src)

/obj/item/robot_rack/roller
	name = "roller bed rack"
	desc = "A rack for carrying collapsed roller beds. Can also be used for carrying ironing boards."
	icon = 'icons/obj/items/rollerbed.dmi'
	icon_state = ICON_STATE_WORLD
	object_type = /obj/item/roller
	interact_type = /obj/structure/bed/roller