/obj/item/assembly/timer
	name = "timer"
	desc = "Used to time things. Works well with contraptions which have to count down. Tick tock."
	icon_state = "timer"
	origin_tech = @'{"magnets":1}'
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/copper = MATTER_AMOUNT_TRACE
	)

	wires = WIRE_PULSE

	secured = 0

	var/timing = 0
	var/time = 10

/obj/item/assembly/timer/proc/timer_end()


/obj/item/assembly/timer/activate()
	if(!..())	return 0//Cooldown check

	timing = !timing

	update_icon()
	return 0


/obj/item/assembly/timer/toggle_secure()
	secured = !secured
	if(secured)
		START_PROCESSING(SSobj, src)
	else
		timing = 0
		STOP_PROCESSING(SSobj, src)
	update_icon()
	return secured


/obj/item/assembly/timer/timer_end()
	if(!secured)	return 0
	pulse_device(0)
	if(!holder)
		visible_message("[html_icon(src)] *beep* *beep*", "*beep* *beep*")
	cooldown = 2
	spawn(10)
		process_cooldown()
	return


/obj/item/assembly/timer/Process()
	if(timing && (time > 0))
		time--
		playsound(loc, 'sound/items/timer.ogg', 50)
	if(timing && time <= 0)
		timing = 0
		timer_end()
		time = 10
	return


/obj/item/assembly/timer/on_update_icon()
	. = ..()
	LAZYCLEARLIST(attached_overlays)
	if(timing)
		var/image/img = overlay_image(icon, "timer_timing")
		add_overlay(img)
		LAZYADD(attached_overlays, img)
	if(holder)
		holder.update_icon()

/obj/item/assembly/timer/interact(mob/user)//TODO: Have this use the wires
	if(!secured)
		user.show_message("<span class='warning'>\The [name] is unsecured!</span>")
		return 0
	var/second = time % 60
	var/minute = (time - second) / 60
	var/dat = text("<TT><B>Timing Unit</B>\n[] []:[]\n<A href='byond://?src=\ref[];tp=-30'>-</A> <A href='byond://?src=\ref[];tp=-1'>-</A> <A href='byond://?src=\ref[];tp=1'>+</A> <A href='byond://?src=\ref[];tp=30'>+</A>\n</TT>", (timing ? text("<A href='byond://?src=\ref[];time=0'>Timing</A>", src) : text("<A href='byond://?src=\ref[];time=1'>Not Timing</A>", src)), minute, second, src, src, src, src)
	dat += "<BR><BR><A href='byond://?src=\ref[src];refresh=1'>Refresh</A>"
	dat += "<BR><BR><A href='byond://?src=\ref[src];close=1'>Close</A>"
	show_browser(user, dat, "window=timer")
	onclose(user, "timer")
	return


/obj/item/assembly/timer/Topic(href, href_list, state = global.physical_topic_state)
	if((. = ..()))
		close_browser(usr, "window=timer")
		onclose(usr, "timer")
		return

	if(href_list["time"])
		timing = text2num(href_list["time"])
		update_icon()

	if(href_list["tp"])
		var/tp = text2num(href_list["tp"])
		time += tp
		time = min(max(round(time), 0), 600)

	if(href_list["close"])
		close_browser(usr, "window=timer")
		return

	if(usr)
		attack_self(usr)

	return
