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
	desc = "This is used to lie in, sleep in or strap on."
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
	var/base_icon = "bed"

/obj/structure/bed/user_can_mousedrop_onto(var/mob/user, var/atom/being_dropped, var/incapacitation_flags)
	if(user == being_dropped)
		return user.Adjacent(src) && !user.incapacitated(INCAPACITATION_STUNNED|INCAPACITATION_KNOCKOUT)
	return ..()

/obj/structure/bed/get_base_value()
	. = round(..() * 2.5) // Utility structures should be worth more than their matter (wheelchairs, rollers, etc).

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
	if(istype(reinf_material))
		var/image/I = image(icon, "[icon_state]_padding")
		if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
			I.appearance_flags |= RESET_COLOR
			I.color = reinf_material.color
			add_overlay(I)

/obj/structure/bed/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1
	else
		return ..()

/obj/structure/bed/explosion_act(severity)
	. = ..()
	if(. && !QDELETED(src) && (severity == 1 || (severity == 2 && prob(50)) || (severity == 3 && prob(5))))
		physically_destroyed()

/obj/structure/bed/attackby(obj/item/W, mob/user)
	. = ..()
	if(!.)
		if(istype(W,/obj/item/stack))
			if(reinf_material)
				to_chat(user, "\The [src] is already padded.")
				return
			var/obj/item/stack/C = W
			if(C.get_amount() < 1) // How??
				qdel(C)
				return
			var/padding_type //This is awful but it needs to be like this until tiles are given a material var.
			if(istype(W,/obj/item/stack/tile/carpet))
				padding_type = /decl/material/solid/carpet
			else if(istype(W,/obj/item/stack/material))
				var/obj/item/stack/material/M = W
				if(M.material && (M.material.flags & MAT_FLAG_PADDING))
					padding_type = M.material.type
			if(!padding_type)
				to_chat(user, "You cannot pad \the [src] with that.")
				return
			C.use(1)
			if(!isturf(src.loc))
				src.forceMove(get_turf(src))
			playsound(src.loc, 'sound/effects/rustle5.ogg', 50, 1)
			to_chat(user, "You add padding to \the [src].")
			add_padding(padding_type)
			return

		else if(IS_WIRECUTTER(W))
			if(!reinf_material)
				to_chat(user, "\The [src] has no padding to remove.")
				return
			to_chat(user, "You remove the padding from \the [src].")
			playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
			remove_padding()

		else if(istype(W, /obj/item/grab))
			var/obj/item/grab/G = W
			var/mob/living/affecting = G.get_affecting_mob()
			if(affecting)
				user.visible_message("<span class='notice'>[user] attempts to buckle [affecting] into \the [src]!</span>")
				if(do_after(user, 20, src))
					if(user_buckle_mob(affecting, user))
						qdel(W)

/obj/structure/bed/proc/remove_padding()
	if(reinf_material)
		reinf_material.create_object(get_turf(src))
		reinf_material = null
	update_icon()

/obj/structure/bed/proc/add_padding(var/padding_type)
	reinf_material = GET_DECL(padding_type)
	update_icon()

/obj/structure/bed/psych
	name = "psychiatrist's couch"
	desc = "For prime comfort during psychiatric evaluations."
	icon_state = "psychbed"
	material = /decl/material/solid/wood/walnut

/obj/structure/bed/psych/leather
	reinf_material = /decl/material/solid/leather

/obj/structure/bed/padded
	material = /decl/material/solid/metal/aluminium
	reinf_material = /decl/material/solid/cloth

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
	if(!beaker || buckled_mob || !user.check_dexterity(DEXTERITY_GRIP, TRUE))
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

/obj/structure/bed/roller/proc/attach_iv(mob/living/carbon/human/target, mob/user)
	if(!beaker)
		return
	if(do_IV_hookup(target, user, beaker))
		iv_attached = TRUE
		queue_icon_update()
		START_PROCESSING(SSobj,src)

/obj/structure/bed/roller/proc/detach_iv(mob/living/carbon/human/target, mob/user)
	visible_message("\The [target] is taken off the IV on \the [src].")
	iv_attached = FALSE
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
/*
 * Mattresses
 */
/obj/structure/mattress
	name = "mattress"
	icon = 'icons/obj/furniture.dmi'
	icon_state = "mattress"
	desc = "A bare mattress. It doesn't look very comfortable."
	anchored = 0

/obj/structure/mattress/dirty
	name = "dirty mattress"
	icon_state = "dirty_mattress"
	desc = "A dirty, smelly mattress covered in body fluids. You wouldn't want to touch this."
