//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32
/obj/effect/ir_beam
	name = "ir beam"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "ibeam"
	anchored =  TRUE
	simulated = FALSE

/obj/item/assembly/infra
	name = "infrared emitter"
	desc = "Emits a visible or invisible beam and is triggered when the beam is interrupted."
	icon_state = "infrared"
	origin_tech = "{'magnets':2}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/copper = MATTER_AMOUNT_TRACE
	)
	wires = WIRE_PULSE
	secured = 0
	obj_flags = OBJ_FLAG_CONDUCTIBLE | OBJ_FLAG_ROTATABLE

	var/on = 0
	var/visible = 0
	var/list/beams
	var/list/seen_turfs
	var/datum/proximity_trigger/line/proximity_trigger

/obj/item/assembly/infra/Initialize()
	. = ..()
	beams = list()
	seen_turfs = list()
	proximity_trigger = new(src, /obj/item/assembly/infra/proc/on_beam_entered, /obj/item/assembly/infra/proc/on_visibility_change, world.view, proximity_flags = PROXIMITY_EXCLUDE_HOLDER_TURF)

/obj/item/assembly/infra/Destroy()
	qdel(proximity_trigger)
	proximity_trigger = null

	. = ..()

/obj/item/assembly/infra/activate()
	if(!..())
		return 0//Cooldown check
	set_active(!on)
	return 1

/obj/item/assembly/infra/proc/set_active(new_on)
	if(new_on == on)
		return
	on = new_on
	if(on)
		proximity_trigger.register_turfs()
	else
		proximity_trigger.unregister_turfs()
	update_icon()

/obj/item/assembly/infra/toggle_secure()
	secured = !secured
	set_active(secured ? FALSE : on)
	return secured

/obj/item/assembly/infra/on_update_icon()
	. = ..()
	if(on)
		add_overlay("infrared_on")
	if(holder)
		holder.update_icon()
	update_beams()

/obj/item/assembly/infra/interact(mob/user)//TODO: change this this to the wire control panel
	if(!secured)
		return
	if(!CanInteract(user, global.physical_topic_state))
		return

	user.set_machine(src)
	var/dat = list()
	dat += text("<TT><B>Infrared Laser</B>\n<B>Status</B>: []<BR>\n<B>Visibility</B>: []<BR>\n</TT>", (on ? text("<A href='?src=\ref[];state=0'>On</A>", src) : text("<A href='?src=\ref[];state=1'>Off</A>", src)), (src.visible ? text("<A href='?src=\ref[];visible=0'>Visible</A>", src) : text("<A href='?src=\ref[];visible=1'>Invisible</A>", src)))
	dat += "<BR><BR><A href='?src=\ref[src];refresh=1'>Refresh</A>"
	dat += "<BR><BR><A href='?src=\ref[src];close=1'>Close</A>"
	show_browser(user, jointext(dat,null), "window=infra")
	onclose(user, "infra")

/obj/item/assembly/infra/Topic(href, href_list, state = global.physical_topic_state)
	if(..())
		close_browser(usr, "window=infra")
		onclose(usr, "infra")
		return 1

	if(href_list["state"])
		set_active(!on)

	if(href_list["visible"])
		visible = !(visible)
		update_icon()

	if(href_list["close"])
		close_browser(usr, "window=infra")
		return

	if(usr)
		attack_self(usr)

/obj/item/assembly/infra/proc/on_beam_entered(var/atom/enterer)
	if(enterer == src)
		return
	if(enterer.invisibility > INVISIBILITY_LEVEL_TWO)
		return
	if(!secured || !on || cooldown > 0)
		return 0
	if((ismob(enterer) && !isliving(enterer))) // Observers and their ilk don't count even if visible
		return

	pulse(0)
	if(!holder)
		visible_message("[html_icon(src)] *beep* *beep*")
	cooldown = 2
	spawn(10)
		process_cooldown()

/obj/item/assembly/infra/proc/on_visibility_change(var/list/old_turfs, var/list/new_turfs)
	seen_turfs = new_turfs
	update_beams()

/obj/item/assembly/infra/proc/update_beams()
	create_update_and_delete_beams(on, visible, dir, seen_turfs, beams)

/proc/create_update_and_delete_beams(var/active, var/visible, var/dir, var/list/seen_turfs, var/list/existing_beams)
	if(!active)
		for(var/b in existing_beams)
			qdel(b)
		existing_beams.Cut()
		return

	var/list/turfs_that_need_beams = seen_turfs.Copy()

	for(var/b in existing_beams)
		var/obj/effect/ir_beam/beam = b
		if(beam.loc in turfs_that_need_beams)
			turfs_that_need_beams -= beam.loc
			beam.set_invisibility(visible ? 0 : INVISIBILITY_MAXIMUM)
		else
			existing_beams -= beam
			qdel(beam)

	if(!visible)
		return

	for(var/t in turfs_that_need_beams)
		var/obj/effect/ir_beam/beam = new(t)
		existing_beams += beam
		beam.set_dir(dir)
