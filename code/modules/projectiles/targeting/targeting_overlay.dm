/obj/aiming_overlay
	name = ""
	desc = "Stick 'em up!"
	icon = 'icons/effects/Targeted.dmi'
	icon_state = "locking"
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	layer = ABOVE_HUMAN_LAYER
	simulated = 0
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE

	var/mob/living/aiming_at   // Who are we currently targeting, if anyone?
	var/obj/item/aiming_with   // What are we targeting with?
	var/mob/living/owner       // Who do we belong to?
	var/locked =    0          // Have we locked on?
	var/lock_time = 0          // When -will- we lock on?
	var/active =    0          // Is our owner intending to take hostages?
	var/target_permissions = TARGET_CAN_MOVE | TARGET_CAN_CLICK | TARGET_CAN_RADIO	// Permission bitflags.

/obj/aiming_overlay/Initialize()
	. = ..()
	owner = loc
	forceMove(null)
	verbs.Cut()

/obj/aiming_overlay/proc/toggle_permission(var/perm)

	if(target_permissions & perm)
		target_permissions &= ~perm
	else
		target_permissions |= perm

	// Update HUD icons.
	if(owner.gun_move_icon)
		if(!(target_permissions & TARGET_CAN_MOVE))
			owner.gun_move_icon.icon_state = "no_walk0"
			owner.gun_move_icon.SetName("Allow Movement")
		else
			owner.gun_move_icon.icon_state = "no_walk1"
			owner.gun_move_icon.SetName("Disallow Movement")

	if(owner.item_use_icon)
		if(!(target_permissions & TARGET_CAN_CLICK))
			owner.item_use_icon.icon_state = "no_item0"
			owner.item_use_icon.SetName("Allow Item Use")
		else
			owner.item_use_icon.icon_state = "no_item1"
			owner.item_use_icon.SetName("Disallow Item Use")

	if(owner.radio_use_icon)
		if(!(target_permissions & TARGET_CAN_RADIO))
			owner.radio_use_icon.icon_state = "no_radio0"
			owner.radio_use_icon.SetName("Allow Radio Use")
		else
			owner.radio_use_icon.icon_state = "no_radio1"
			owner.radio_use_icon.SetName("Disallow Radio Use")

	var/message = "no longer permitted to "
	var/use_span = "warning"
	if(target_permissions & perm)
		message = "now permitted to "
		use_span = "notice"

	switch(perm)
		if(TARGET_CAN_MOVE)
			message += "move"
		if(TARGET_CAN_CLICK)
			message += "use items"
		if(TARGET_CAN_RADIO)
			message += "use a radio"
		else
			return

	var/aim_message = "<span class='[use_span]'>[aiming_at ? "\The [aiming_at] is" : "Your targets are"] [message].</span>"
	to_chat(owner, aim_message)
	if(aiming_at)
		to_chat(aiming_at, "<span class='[use_span]'>You are [message].</span>")
/obj/aiming_overlay/Process()
	if(!owner)
		qdel(src)
		return
	..()
	update_aiming()

/obj/aiming_overlay/Destroy()
	cancel_aiming(1)
	owner = null
	return ..()

/obj/aiming_overlay/proc/update_aiming_deferred()
	set waitfor = 0
	sleep(0)
	update_aiming()

/obj/aiming_overlay/proc/update_aiming()

	if(!owner)
		qdel(src)
		return

	if(!aiming_at)
		cancel_aiming()
		return

	if(!locked && lock_time >= world.time)
		locked = 1
		update_icon()

	var/cancel_aim = 1

	if(!(aiming_with in owner) || (ishuman(owner) && !(aiming_with in owner.get_held_items())))
		to_chat(owner, SPAN_WARNING("You must keep hold of your weapon!"))
	else if(GET_STATUS(owner, STAT_BLIND))
		to_chat(owner, SPAN_WARNING("You are blind and cannot see your target!"))
	else if(!aiming_at || !isturf(aiming_at.loc))
		to_chat(owner, SPAN_WARNING("You have lost sight of your target!"))
	else if(owner.incapacitated() || owner.current_posture.prone || owner.restrained())
		to_chat(owner, SPAN_WARNING("You must be conscious and standing to keep track of your target!"))
	else if(aiming_at.is_invisible_to(owner))
		to_chat(owner, SPAN_WARNING("Your target has become invisible!"))
	else if(!(aiming_at in view(owner)))
		to_chat(owner, SPAN_WARNING("Your target is too far away to track!"))
	else
		cancel_aim = 0

	forceMove(get_turf(aiming_at))

	if(cancel_aim)
		cancel_aiming()
		return

	if(!owner.incapacitated() && owner.client)
		spawn(0)
			owner.set_dir(get_dir(get_turf(owner), get_turf(src)))

/obj/aiming_overlay/proc/aim_at(var/mob/target, var/obj/thing)

	if(!owner || !isliving(target))
		return

	if(owner.incapacitated())
		to_chat(owner, SPAN_WARNING("You cannot You cannot threaten \the [target] with \the [thing] in your current state."))
		return
	if(owner.current_posture.prone)
		to_chat(owner, SPAN_WARNING("You cannot threaten \the [target] with \the [thing] while prone."))
		return
	if(owner.restrained())
		to_chat(owner, SPAN_WARNING("You cannot threaten \the [target] with \the [thing] while handcuffed."))
		return

	if(aiming_at)
		if(aiming_at == target)
			return
		cancel_aiming(1)
		owner.visible_message(SPAN_DANGER("\The [owner] turns \the [thing] on \the [target]!"))
	else
		owner.visible_message(SPAN_DANGER("\The [owner] aims \the [thing] at \the [target]!"))

	if(owner.client)
		owner.client.add_gun_icons()
	var/decl/pronouns/pronouns = owner.get_pronouns()
	to_chat(target, FONT_LARGE(SPAN_DANGER("\The [owner] [pronouns.is] menacing you with \a [thing]. No sudden moves!")))
	aiming_with = thing
	aiming_at = target
	if(istype(aiming_with, /obj/item/gun))
		sound_to(aiming_at, sound('sound/weapons/TargetOn.ogg'))
		sound_to(owner, sound('sound/weapons/TargetOn.ogg'))

	forceMove(get_turf(target))
	START_PROCESSING(SSobj, src)

	LAZYDISTINCTADD(aiming_at.aimed_at_by, src)
	toggle_active(1)
	locked = 0

	update_icon()
	lock_time = world.time + 35
	events_repository.register(/decl/observ/moved, owner, src, TYPE_PROC_REF(/obj/aiming_overlay, update_aiming))
	events_repository.register(/decl/observ/moved, aiming_at, src, TYPE_PROC_REF(/obj/aiming_overlay, target_moved))
	events_repository.register(/decl/observ/destroyed, aiming_at, src, TYPE_PROC_REF(/obj/aiming_overlay, cancel_aiming))

/obj/aiming_overlay/on_update_icon()
	if(locked)
		icon_state = "locked"
	else
		icon_state = "locking"

/obj/aiming_overlay/proc/toggle_active(var/force_state = null, var/no_message = FALSE)
	if(!isnull(force_state))
		if(active == force_state)
			return
		active = force_state
	else
		active = !active

	if(!active)
		cancel_aiming(no_message)

	if(owner.client)
		if(active)
			if(!no_message)
				to_chat(owner, "<span class='notice'>You will now aim rather than fire.</span>")
			owner.client.add_gun_icons()
		else
			if(!no_message)
				to_chat(owner, "<span class='notice'>You will no longer aim rather than fire.</span>")
			owner.client.remove_gun_icons()
		owner.gun_setting_icon.icon_state = "gun[active]"

/obj/aiming_overlay/proc/cancel_aiming(var/no_message = 0)
	if(!aiming_with || !aiming_at)
		return
	if(!no_message)
		owner.visible_message("<span class='notice'>\The [owner] lowers \the [aiming_with].</span>")
		if(istype(aiming_with, /obj/item/gun))
			sound_to(aiming_at, sound('sound/weapons/TargetOff.ogg'))
			sound_to(owner, sound('sound/weapons/TargetOff.ogg'))

	events_repository.unregister(/decl/observ/moved, owner, src)
	if(aiming_at)
		events_repository.unregister(/decl/observ/moved, aiming_at, src)
		events_repository.unregister(/decl/observ/destroyed, aiming_at, src)
		LAZYREMOVE(aiming_at.aimed_at_by, src)
		aiming_at = null

	aiming_with = null
	forceMove(null)
	STOP_PROCESSING(SSobj, src)

/obj/aiming_overlay/proc/target_moved()
	update_aiming()
	trigger(TARGET_CAN_MOVE)
