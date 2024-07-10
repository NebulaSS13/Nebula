/*
While these computers can be placed anywhere, they will only function if placed on either a non-space, non-shuttle turf
with an /obj/effect/overmap/visitable/ship present elsewhere on that z level, or else placed in a shuttle area with an /obj/effect/overmap/visitable/ship
somewhere on that shuttle. Subtypes of these can be then used to perform ship overmap movement functions.
*/
/obj/machinery/computer/ship
	var/obj/effect/overmap/visitable/ship/linked
	var/list/viewers // Weakrefs to mobs in direct-view mode.
	var/extra_view = 0 // how much the view is increased by when the mob is in overmap mode.
	var/overmap_id = OVERMAP_ID_SPACE

// A late init operation called in SSshuttle, used to attach the thing to the right ship.
/obj/machinery/computer/ship/proc/attempt_hook_up(obj/effect/overmap/visitable/ship/sector)
	if(!istype(sector))
		return
	if(sector.check_ownership(src))
		linked = sector
		linked.register_machine(src, /obj/machinery/computer/ship)
		return 1

/obj/machinery/computer/ship/Destroy()
	if(linked)
		linked.unregister_machine(src, /obj/machinery/computer/ship)
		linked = null
	. = ..()

/obj/machinery/computer/ship/proc/sync_linked()
	var/obj/effect/overmap/visitable/ship/sector = get_owning_overmap_object()
	if(!istype(sector))
		return
	attempt_hook_up(sector)
	return linked

/obj/machinery/computer/ship/proc/display_reconnect_dialog(var/mob/user, var/flavor)
	var/datum/browser/written_digital/popup = new (user, "[src]", "[src]")
	popup.set_content("<center><strong><font color = 'red'>Error</strong></font><br>Unable to connect to [flavor].<br><a href='byond://?src=\ref[src];sync=1'>Reconnect</a></center>")
	popup.open()

/obj/machinery/computer/ship/interface_interact(var/mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/computer/ship/OnTopic(var/mob/user, var/list/href_list)
	if(..())
		return TOPIC_HANDLED
	if(href_list["sync"])
		sync_linked()
		return TOPIC_REFRESH
	if(href_list["close"])
		unlook(user)
		user.unset_machine()
		return TOPIC_HANDLED
	return TOPIC_NOACTION

// Management of mob view displacement. look to shift view to the ship on the overmap; unlook to shift back.
/obj/machinery/computer/ship/on_user_login(var/mob/M)
	unlook(M)

/obj/machinery/computer/ship/proc/look(var/mob/user)
	if(linked)
		user.reset_view(linked)
	if(user.client)
		if(istext(user.client.view))
			var/list/retrieved_view = splittext(user.client.view, "x")
			user.client.view = "[text2num(retrieved_view[1]) + extra_view]x[text2num(retrieved_view[2]) + extra_view]"
		else
			user.client.view = user.client.view + extra_view
	if(linked)
		for(var/obj/machinery/computer/ship/sensors/sensor in linked.get_linked_machines_of_type(/obj/machinery/computer/ship))
			sensor.reveal_contacts(user)

	events_repository.register(/decl/observ/moved, user, src, TYPE_PROC_REF(/obj/machinery/computer/ship, unlook))
	if(isliving(user))
		events_repository.register(/decl/observ/stat_set, user, src, TYPE_PROC_REF(/obj/machinery/computer/ship, unlook))
	LAZYDISTINCTADD(viewers, weakref(user))
	if(linked)
		LAZYDISTINCTADD(linked.navigation_viewers, weakref(user))

/obj/machinery/computer/ship/proc/unlook(var/mob/user)
	user.reset_view()
	if(user.client)
		user.client.OnResize()
	if(linked)
		for(var/obj/machinery/computer/ship/sensors/sensor in linked.get_linked_machines_of_type(/obj/machinery/computer/ship))
			sensor.hide_contacts(user)

	events_repository.unregister(/decl/observ/moved, user, src, TYPE_PROC_REF(/obj/machinery/computer/ship, unlook))
	if(isliving(user))
		events_repository.unregister(/decl/observ/stat_set, user, src, TYPE_PROC_REF(/obj/machinery/computer/ship, unlook))
	LAZYREMOVE(viewers, weakref(user))
	if(linked)
		LAZYREMOVE(linked.navigation_viewers, weakref(user))

/obj/machinery/computer/ship/proc/viewing_overmap(mob/user)
	return (weakref(user) in viewers) || (linked && (weakref(user) in linked.navigation_viewers))

/obj/machinery/computer/ship/CouldNotUseTopic(mob/user)
	. = ..()
	unlook(user)

/obj/machinery/computer/ship/CouldUseTopic(mob/user)
	. = ..()
	if(viewing_overmap(user))
		look(user)

/obj/machinery/computer/ship/check_eye(var/mob/user)
	if (!get_dist(user, src) > 1 || user.is_blind() || !linked )
		unlook(user)
		return -1
	else
		return 0

/obj/machinery/computer/ship/sensors/Destroy()
	sensor_ref = null
	if(LAZYLEN(viewers))
		for(var/weakref/W in viewers)
			var/M = W.resolve()
			if(M)
				INVOKE_ASYNC(PROC_REF(unlook), M)
				if(linked)
					LAZYREMOVE(linked.navigation_viewers, W)
	. = ..()
