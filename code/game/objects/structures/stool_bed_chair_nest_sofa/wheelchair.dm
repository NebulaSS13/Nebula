/obj/structure/bed/chair/wheelchair
	name = "wheelchair"
	desc = "Now we're getting somewhere."
	icon_state = "wheelchair"
	anchored = FALSE
	buckle_movable = TRUE
	movement_handlers = list(
		/datum/movement_handler/deny_multiz,
		/datum/movement_handler/delay = list(5),
		/datum/movement_handler/move_relay_self
	)

	var/item_form_type = /obj/item/wheelchair_kit
	var/bloodiness

/obj/structure/bed/chair/wheelchair/Initialize()
	. = ..()

	if(!item_form_type)
		verbs -= .verb/collapse

/obj/structure/bed/chair/wheelchair/on_update_icon()
	set_overlays(image(icon = 'icons/obj/furniture.dmi', icon_state = "w_overlay", layer = ABOVE_HUMAN_LAYER))

/obj/structure/bed/chair/wheelchair/attackby(obj/item/W, mob/user)
	if(IS_WRENCH(W) || istype(W,/obj/item/stack) || IS_WIRECUTTER(W))
		return
	..()

/obj/structure/bed/chair/wheelchair/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_SIMPLE_MACHINES, TRUE))
		return ..()
	user_unbuckle_mob(user)
	return TRUE

/obj/structure/bed/chair/wheelchair/Bump(atom/A)
	..()
	if(!buckled_mob)
		return

	if(!propelled)
		return

	var/mob/living/occupant = unbuckle_mob()
	occupant.throw_at(A, 3, 3)

	var/def_zone = ran_zone()
	var/blocked = 100 * occupant.get_blocked_ratio(def_zone, BRUTE, damage = 10)
	occupant.throw_at(A, 3, 3)
	occupant.apply_effect(6, STUN, blocked)
	occupant.apply_effect(6, WEAKEN, blocked)
	occupant.apply_effect(6, STUTTER, blocked)
	occupant.apply_damage(10, BRUTE, def_zone)
	playsound(src.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
	if(istype(A, /mob/living))
		var/mob/living/victim = A
		def_zone = ran_zone()
		blocked = 100 * victim.get_blocked_ratio(def_zone, BRUTE, damage = 10)
		victim.apply_effect(6, STUN, blocked)
		victim.apply_effect(6, WEAKEN, blocked)
		victim.apply_effect(6, STUTTER, blocked)
		victim.apply_damage(10, BRUTE, def_zone)
	occupant.visible_message(SPAN_DANGER("\The [occupant] crashed into \the [A]!"))

/obj/structure/bed/chair/wheelchair/proc/create_track()
	var/obj/effect/decal/cleanable/blood/tracks/B = new(loc)
	var/newdir = get_dir(get_step(loc, dir), loc)
	if(newdir == dir)
		B.set_dir(newdir)
	else
		newdir = newdir | dir
		if(newdir == 3)
			newdir = 1
		else if(newdir == 12)
			newdir = 4
		B.set_dir(newdir)
	bloodiness--

/proc/equip_wheelchair(mob/living/carbon/human/H) //Proc for spawning in a wheelchair if a new character has no legs. Used in new_player.dm
	var/obj/structure/bed/chair/wheelchair/W = new(get_turf(H))
	if(isturf(H.loc))
		W.buckle_mob(H)

/obj/structure/bed/chair/wheelchair/verb/collapse()
	set name = "Collapse Wheelchair"
	set category = "Object"
	set src in oview(1)

	if(!item_form_type)
		return

	if(!CanPhysicallyInteract(usr))
		return

	if(!ishuman(usr))
		return

	if(usr.incapacitated())
		return

	if(buckled_mob)
		to_chat(usr, SPAN_WARNING("You can't collapse \the [src.name] while it is still in use."))
		return

	usr.visible_message("<b>[usr]</b> starts to collapse \the [src.name].")
	if(do_after(usr, 4 SECONDS, src))
		var/obj/item/wheelchair_kit/K = new item_form_type(get_turf(src))
		visible_message(SPAN_NOTICE("<b>[usr]</b> collapses \the [src.name]."))
		K.add_fingerprint(usr)
		qdel(src)

/obj/structure/bed/chair/wheelchair/handle_buckled_relaymove(var/datum/movement_handler/mh, var/mob/mob, var/direction, var/mover)
	if(isspaceturf(loc))
		return // No wheelchair driving in space
	. = MOVEMENT_HANDLED
	if(!mob.has_held_item_slot())
		return // No hands to drive your chair? Tough luck!
	//drunk wheelchair driving
	direction = mob.AdjustMovementDirection(direction, mover)
	DoMove(direction, mob)

/obj/structure/bed/chair/wheelchair/relaymove(mob/user, direction)
	if(user)
		user.glide_size = glide_size
	step(src, direction)
	set_dir(direction)

/obj/item/wheelchair_kit
	name = "compressed wheelchair kit"
	desc = "Collapsed parts, prepared to immediately spring into the shape of a wheelchair."
	icon = 'icons/obj/items/wheelchairkit.dmi'
	icon_state = "wheelchair-item"
	item_state = "rbed"
	w_class = ITEM_SIZE_LARGE
	max_health = 50
	var/structure_form_type = /obj/structure/bed/chair/wheelchair

/obj/item/wheelchair_kit/attack_self(mob/user)
	if(!structure_form_type)
		return

	user.visible_message("<b>[user]</b> starts to lay out \the [src.name].")
	if(do_after(user, 4 SECONDS, src))
		var/obj/structure/bed/chair/wheelchair/W = new structure_form_type(get_turf(user))
		user.visible_message(SPAN_NOTICE("<b>[user]</b> lays out \the [W.name]."))
		W.add_fingerprint(user)
		qdel(src)

/obj/item/wheelchair_kit/physically_destroyed(skip_qdel)
	//Make sure if the kit is destroyed to drop the same stuff as the actual wheelchair
	var/obj/structure/S = new structure_form_type(get_turf(src))
	S.physically_destroyed()
	. = ..()