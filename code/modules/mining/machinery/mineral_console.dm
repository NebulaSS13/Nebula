/obj/machinery/computer/mining
	name = "ore processing console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	var/obj/machinery/mineral/connected

// Apparently mapped on walls, so must do this to avoid being hidden behind them.
/obj/machinery/computer/mining/hide()
	return

/obj/machinery/computer/mining/on_update_icon()
	if(panel_open)
		icon_state = "console-open"
	else
		icon_state = "console"

/obj/machinery/computer/mining/interface_interact(var/mob/user)
	interact(user)
	return TRUE

/obj/machinery/computer/mining/interact(var/mob/user)
	var/datum/browser/written/popup = new(user, "mining-[name]", "[src] Control Panel")
	popup.set_content(jointext(connected.get_console_data(), "<br>"))
	popup.open()

/obj/machinery/computer/mining/CanUseTopic(mob/user)
	if(!connected)
		to_chat(user, "<span class='warning'>\The [src] is not connected to a processing machine. <a href='?src=\ref[src];scan_for_machine=1'>Scan</a></span>")
		return STATUS_CLOSE
	. = ..()	

/obj/machinery/computer/mining/Topic(href, href_list)
	if((. = ..()))
		return
	if(href_list["scan_for_machine"])
		for(var/c in GLOB.alldirs)
			var/turf/T = get_step(loc, c)
			if(T)
				var/obj/machinery/mineral/M = locate(/obj/machinery/mineral) in T
				if(M && ispath(M.console) && istype(src, M.console))
					M.console = src
					connected = M
					break
		return TRUE

/obj/machinery/computer/mining/Destroy()
	if(connected)
		if(connected.console == src)
			connected.console = initial(connected.console)
		connected = null
	. = ..()
