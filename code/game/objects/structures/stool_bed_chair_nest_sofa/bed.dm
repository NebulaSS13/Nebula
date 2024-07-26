/* Beds... get your mind out of the gutter, they're for sleeping!
 * Contains:
 * 		Beds
 *		Roller beds
 *		Mattresses
 */

/*
 * Beds
 */
/obj/structure/bed
	name = "bed"
	desc = "A raised, padded platform for sleeping on. This one has straps for ensuring restful snoozing in microgravity."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "bed"
	anchored = TRUE
	can_buckle = TRUE
	buckle_dir = SOUTH
	buckle_lying = TRUE
	buckle_sound = 'sound/effects/buckle.ogg'
	material = DEFAULT_FURNITURE_MATERIAL
	material_alteration = MAT_FLAG_ALTERATION_ALL
	tool_interaction_flags = TOOL_INTERACTION_DECONSTRUCT
	parts_amount = 2
	parts_type = /obj/item/stack/material/strut
	user_comfort = 1
	obj_flags = OBJ_FLAG_SUPPORT_MOB
	var/base_icon = "bed"
	var/padding_color

/obj/structure/bed/user_can_mousedrop_onto(mob/user, atom/being_dropped, incapacitation_flags, params)
	if(user == being_dropped)
		return user.Adjacent(src) && !user.incapacitated(INCAPACITATION_STUNNED|INCAPACITATION_KNOCKOUT)
	return ..()

/obj/structure/bed/get_base_value()
	. = round(..() * 2.5) // Utility structures should be worth more than their matter (wheelchairs, rollers, etc).

/obj/structure/bed/get_surgery_surface_quality(mob/living/victim, mob/living/user)
	return OPERATE_PASSABLE

/obj/structure/bed/get_surgery_success_modifier(delicate)
	return delicate ? -5 : 0

/obj/structure/bed/update_material_name()
	if(reinf_material)
		SetName("[reinf_material.adjective_name] [initial(name)]")
	else if(material)
		SetName("[material.adjective_name] [initial(name)]")
	else
		SetName(initial(name))

/obj/structure/bed/update_material_desc()
	if(reinf_material)
		desc = "[initial(desc)] It's made of [material.use_name] and covered with [reinf_material.use_name]."
	else
		desc = "[initial(desc)] It's made of [material.use_name]."

// Reuse the cache/code from stools, todo maybe unify.
/obj/structure/bed/on_update_icon()
	..()
	icon_state = base_icon
	if(istype(reinf_material))
		if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
			add_overlay(overlay_image(icon, "[icon_state]_padding", padding_color || reinf_material.color, RESET_COLOR))
		else
			add_overlay(overlay_image(icon, "[icon_state]_padding"))

/obj/structure/bed/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1
	return ..()

/obj/structure/bed/explosion_act(severity)
	. = ..()
	if(. && !QDELETED(src) && (severity == 1 || (severity == 2 && prob(50)) || (severity == 3 && prob(5))))
		physically_destroyed()

/obj/structure/bed/proc/can_apply_padding()
	return TRUE

/obj/structure/bed/attackby(obj/item/used_item, mob/user)
	if((. = ..()))
		return

	if(istype(used_item, /obj/item/stack) && can_apply_padding())

		if(reinf_material)
			to_chat(user, SPAN_WARNING("\The [src] is already padded."))
			return TRUE

		var/obj/item/stack/cloth = used_item
		if(cloth.get_amount() < 1)
			to_chat(user, SPAN_WARNING("You need at least one unit of material to pad \the [src]."))
			return TRUE

		var/padding_type
		var/new_padding_color
		if(istype(used_item, /obj/item/stack/tile) || istype(used_item, /obj/item/stack/material/bolt))
			padding_type = used_item.material?.type
			new_padding_color = used_item.paint_color

		if(padding_type)
			var/decl/material/padding_mat = GET_DECL(padding_type)
			if(!istype(padding_mat) || !(padding_mat.flags & MAT_FLAG_PADDING))
				padding_type = null

		if(!padding_type)
			to_chat(user, SPAN_WARNING("You cannot pad \the [src] with that."))
			return TRUE

		cloth.use(1)
		if(!isturf(src.loc))
			src.forceMove(get_turf(src))
		playsound(src.loc, 'sound/effects/rustle5.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You add padding to \the [src]."))
		add_padding(padding_type, new_padding_color)
		return TRUE

	if(IS_WIRECUTTER(used_item))
		if(!reinf_material)
			to_chat(user, SPAN_WARNING("\The [src] has no padding to remove."))
		else
			to_chat(user, SPAN_NOTICE("You remove the padding from \the [src]."))
			playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
			remove_padding()
		return TRUE

	if(istype(used_item, /obj/item/grab))
		var/obj/item/grab/grab = used_item
		var/mob/living/affecting = grab.get_affecting_mob()
		if(affecting)
			user.visible_message(SPAN_NOTICE("\The [user] attempts to put [affecting] onto \the [src]!"))
			if(do_after(user, 2 SECONDS, src) && !QDELETED(affecting) && !QDELETED(user) && !QDELETED(grab) && user_buckle_mob(affecting, user))
				qdel(used_item)
		return TRUE

/obj/structure/bed/proc/add_padding(var/padding_type, var/new_padding_color)
	reinf_material = GET_DECL(padding_type)
	padding_color = new_padding_color
	update_icon()

/obj/structure/bed/proc/remove_padding()
	if(reinf_material)
		var/list/res = reinf_material.create_object(get_turf(src))
		if(padding_color)
			for(var/obj/item/thing in res)
				thing.set_color(padding_color)
	reinf_material = null
	padding_color = null
	update_icon()

/obj/structure/bed/psych
	name = "psychiatrist's couch"
	desc = "For prime comfort during psychiatric evaluations."
	icon_state = "psychbed"
	material = /decl/material/solid/organic/wood/walnut

/obj/structure/bed/psych/leather
	reinf_material = /decl/material/solid/organic/leather

/obj/structure/bed/padded
	material = /decl/material/solid/metal/aluminium
	reinf_material = /decl/material/solid/organic/cloth

/*
 * Travois used to drag mobs in low-tech settings.
 */
/obj/structure/bed/travois
	name = "travois"
	anchored = FALSE
	icon_state = ICON_STATE_WORLD
	base_icon = ICON_STATE_WORLD
	icon = 'icons/obj/structures/travois.dmi'
	buckle_pixel_shift = list("x" = 0, "y" = 0, "z" = 6)
	movable_flags = MOVABLE_FLAG_WHEELED
	user_comfort = 0
	material = /decl/material/solid/organic/wood

/obj/structure/bed/travois/can_apply_padding()
	return FALSE

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
	var/item_form_type = /obj/item/roller	//The folded-up object path.
	var/obj/item/chems/beaker
	var/iv_attached = 0
	var/iv_stand = TRUE

/obj/structure/bed/roller/on_update_icon()
	cut_overlays()
	if(density)
		icon_state = "up"
	else
		icon_state = "down"
	if(beaker)
		var/image/iv = image(icon, "iv[iv_attached]")
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
		if(!user.try_unequip(I, src))
			return
		to_chat(user, "You attach \the [I] to \the [src].")
		beaker = I
		queue_icon_update()
		return 1
	..()

/obj/structure/bed/roller/attack_hand(mob/user)
	if(!beaker || buckled_mob || !user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()
	remove_beaker(user)
	return TRUE

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
	if(!iv_attached || !buckled_mob || !beaker)
		return PROCESS_KILL

	//SSObj fires twice as fast as SSMobs, so gotta slow down to not OD our victims.
	if(SSobj.times_fired % 2)
		return

	if(beaker.volume > 0)
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
/*
 * Mattresses
 */
/obj/structure/mattress
	name = "mattress"
	icon = 'icons/obj/furniture.dmi'
	icon_state = "mattress"
	desc = "A bare mattress. It doesn't look very comfortable."
	anchored = FALSE

/obj/structure/mattress/dirty
	name = "dirty mattress"
	icon_state = "dirty_mattress"
	desc = "A dirty, smelly mattress covered in body fluids. You wouldn't want to touch this."
