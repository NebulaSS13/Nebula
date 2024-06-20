//Helper object for picking creatures up.
/obj/item/holder
	name = "holder"
	desc = "You shouldn't ever see this."
	icon = 'icons/obj/items/holder.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_HEAD | SLOT_HOLSTER
	pixel_y = 8
	origin_tech = @'{"biotech":1}'
	use_single_icon = TRUE
	item_state = null
	is_spawnable_type = FALSE
	max_health = ITEM_HEALTH_NO_DAMAGE
	var/last_holder

/obj/item/holder/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/holder/on_update_icon()
	SHOULD_CALL_PARENT(FALSE)
	clear_vis_contents()
	for(var/atom/movable/AM in src)
		AM.vis_flags |= (VIS_INHERIT_ID|VIS_INHERIT_LAYER|VIS_INHERIT_PLANE)
		add_vis_contents(AM)

// No scooping mobs and handing them to people who can't scoop them.
/obj/item/holder/equipped(mob/user, slot)
	. = ..()
	for(var/mob/living/mob in contents)
		if(!mob.scoop_check(user))
			to_chat(user, SPAN_DANGER("You are unable to keep hold of \the [src]!"))
			user.drop_from_inventory(src)
			break

// Grab our inhands from the mob we're wrapping, if they have any.
/obj/item/holder/get_mob_overlay(mob/user_mob, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_adjustment = FALSE)
	var/mob/M = locate() in contents
	if(istype(M))
		icon =  M.get_holder_icon()
	var/image/ret = ..()
	if(ret)
		if(istype(M))
			ret.color = M.get_holder_color()
		. = ret
	icon = initial(icon)

/obj/item/holder/Exited(atom/movable/am, atom/new_loc)
	am.vis_flags = initial(am.vis_flags)
	. = ..()

/obj/item/holder/proc/destroy_all()
	for(var/atom/movable/AM in src)
		qdel(AM)
	qdel(src)

/obj/item/holder/physically_destroyed()
	SHOULD_CALL_PARENT(FALSE)
	destroy_all()

/obj/item/holder/Destroy()
	clear_vis_contents()
	for(var/atom/movable/AM in src)
		unregister_all_movement(last_holder, AM)
		AM.vis_flags = initial(AM.vis_flags)
		AM.forceMove(get_turf(src))
	last_holder = null
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/holder/Process()
	update_state()

/obj/item/holder/dropped()
	..()
	update_state(1)

/obj/item/holder/throw_impact(atom/hit_atom, datum/thrownthing/TT)
	..()
	update_state(1)

/obj/item/holder/proc/update_state(var/delay)
	set waitfor = 0

	for(var/mob/M in contents)
		unregister_all_movement(last_holder, M)

	if(delay)
		sleep(delay)

	if(QDELETED(src) || throwing)
		return

	if(istype(loc,/turf) || !contents.len)
		for(var/mob/M in contents)
			var/atom/movable/mob_container = M
			mob_container.dropInto(loc)
			M.reset_view()
		qdel(src)
	else if(last_holder != loc)
		for(var/mob/M in contents)
			register_all_movement(loc, M)
		update_icon()
	last_holder = loc

/obj/item/holder/onDropInto(var/atom/movable/AM)
	if(ismob(loc))   // Bypass our holding mob and drop directly to its loc
		return loc.loc
	return ..()

/obj/item/holder/GetIdCards(list/exceptions)
	. = ..()
	for(var/mob/M in contents)
		var/list/cards = M.GetIdCards(exceptions)
		if(length(cards))
			LAZYDISTINCTADD(., cards)

/obj/item/holder/attack_self()
	for(var/mob/M in contents)
		M.show_stripping_window(usr)

/obj/item/holder/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	// Devour on click on self with holder
	if(target == user && isliving(user))
		var/mob/living/M = user
		for(var/mob/victim in src.contents)
			M.devour(victim)
		update_state()
		return TRUE

	return ..()

/obj/item/holder/proc/sync(var/mob/living/M)
	SetName(M.name)
	desc = M.desc
	var/mob/living/human/H = loc
	if(istype(H))
		last_holder = H
		register_all_movement(H, M)
	update_icon()
	update_held_icon()

/obj/item/holder/attackby(obj/item/W, mob/user)
	for(var/mob/M in src.contents)
		M.attackby(W,user)
