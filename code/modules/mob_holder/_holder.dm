//Helper object for picking creatures up.
/obj/item/holder
	name = "holder"
	desc = "You shouldn't ever see this."
	icon = 'icons/obj/items/holder.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_HEAD | SLOT_HOLSTER
	origin_tech = null
	pixel_y = 8
	origin_tech = "{'biotech':1}"
	use_single_icon = TRUE
	item_state = null
	is_spawnable_type = FALSE
	var/last_holder

/obj/item/holder/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/holder/on_update_icon()
	SHOULD_CALL_PARENT(FALSE)
	clear_vis_contents(src)
	for(var/atom/movable/AM in src)
		AM.vis_flags |= (VIS_INHERIT_ID|VIS_INHERIT_LAYER|VIS_INHERIT_PLANE)
		add_vis_contents(src, AM)

// Grab our inhands from the mob we're wrapping, if they have any.
/obj/item/holder/get_mob_overlay(mob/user_mob, slot, bodypart)
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
	clear_vis_contents(src)
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

/obj/item/holder/GetIdCards()
	. = ..()
	for(var/mob/M in contents)
		LAZYDISTINCTADD(., M.GetIdCards())

/obj/item/holder/attack_self()
	for(var/mob/M in contents)
		M.show_stripping_window(usr)

/obj/item/holder/attack(mob/target, mob/user)
	// Devour on click on self with holder
	if(target == user && istype(user,/mob/living/carbon))
		var/mob/living/carbon/M = user
		for(var/mob/victim in src.contents)
			M.devour(victim)
		update_state()
	..()

/obj/item/holder/proc/sync(var/mob/living/M)
	SetName(M.name)
	desc = M.desc
	var/mob/living/carbon/human/H = loc
	if(istype(H))
		last_holder = H
		register_all_movement(H, M)
	update_icon()
	update_held_icon()

/obj/item/holder/attackby(obj/item/W, mob/user)
	for(var/mob/M in src.contents)
		M.attackby(W,user)
