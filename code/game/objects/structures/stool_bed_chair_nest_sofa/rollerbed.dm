/*
 * Roller beds
 */
/obj/structure/bed/roller
	name = "roller bed"
	icon = 'icons/obj/structures/rollerbed.dmi'
	icon_state = "down"
	anchored = 0
	buckle_pixel_shift = list("x" = 0, "y" = 0, "z" = 6)
	movable_flags = MOVABLE_FLAG_WHEELED
	var/item_form_type = /obj/item/roller	//The folded-up object path.
	var/obj/item/chems/beaker
	var/obj/item/organ/external/iv_attached
	var/iv_stand = TRUE

/obj/structure/bed/roller/on_update_icon()
	cut_overlays()
	if(density)
		icon_state = "up"
	else
		icon_state = "down"
	if(beaker)
		var/image/iv = image(icon, "iv[!!iv_attached]")
		var/percentage = round((beaker.reagents.total_volume / beaker.volume) * 100, 25)
		var/image/filling = image(icon, "iv_filling[percentage]")
		filling.color = beaker.reagents.get_color()
		iv.overlays += filling
		if(percentage < 25)
			iv.overlays += image(icon, "light_low")
		if(density)
			iv.pixel_y = 6
		add_overlay(iv)

/obj/structure/bed/roller/attackby(obj/item/I, mob/user)
	if(IS_WRENCH(I) || istype(I, /obj/item/stack) || IS_WIRECUTTER(I))
		return 1
	if(iv_stand && !beaker && istype(I, /obj/item/chems))
		if(!user.unEquip(I, src))
			return
		to_chat(user, "You attach \the [I] to \the [src].")
		beaker = I
		queue_icon_update()
		return 1
	..()

/obj/structure/bed/roller/attack_hand(mob/user)
	if(beaker && !buckled_mob)
		remove_beaker(user)
	else
		..()

/obj/structure/bed/roller/proc/collapse()
	visible_message("[usr] collapses [src].")
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
	if(!iv_attached || !buckled_mob || (buckled_mob != iv_attached.owner) || !beaker)
		return PROCESS_KILL

	//SSObj fires twice as fast as SSMobs, so gotta slow down to not OD our victims.
	if(SSobj.times_fired % 2)
		return

	if(beaker.volume > 0 && buckled_mob.can_inject(null, iv_attached.organ_tag))
		buckled_mob.inject_external_organ(iv_attached, beaker.reagents, beaker.amount_per_transfer_from_this)
		queue_icon_update()

/obj/structure/bed/roller/proc/remove_beaker(mob/user)
	to_chat(user, "You detach \the [beaker] to \the [src].")
	iv_attached = null
	beaker.dropInto(loc)
	beaker = null
	queue_icon_update()

/obj/structure/bed/roller/proc/attach_iv(mob/living/carbon/human/target, mob/user)
	if(!beaker)
		return
	var/target_zone = check_zone(user.zone_sel.selecting, target) // deterministic, so we do it here and in do_IV_hookup
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(target, target_zone)
	if(do_IV_hookup(target, user, beaker))
		iv_attached = affecting
		queue_icon_update()
		START_PROCESSING(SSobj,src)

/obj/structure/bed/roller/proc/detach_iv(mob/living/carbon/human/target, mob/user)
	visible_message("\The [target] is taken off the IV on \the [src].")
	iv_attached = null
	queue_icon_update()
	STOP_PROCESSING(SSobj,src)

/obj/structure/bed/roller/handle_mouse_drop(atom/over, mob/user)
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
		collapse()
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
		/decl/material/solid/plastic = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/cloth = MATTER_AMOUNT_REINFORCEMENT,
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
