//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/prisoner
	name = "prisoner management console"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "security_key"
	icon_screen = "explosive"
	light_color = "#a91515"
	initial_access = list(access_armory)
	var/locked = FALSE

/obj/machinery/computer/prisoner/interface_interact(user)
	interact(user)
	return TRUE

/obj/machinery/computer/prisoner/interact(var/mob/user)
	var/dat = list()
	dat += "<B>Prisoner Implant Manager System</B><BR>"
	if(locked)
		dat += "<HR><A href='byond://?src=\ref[src];lock=1'>Unlock Console</A>"
	else
		dat += "<HR>Chemical Implants<BR>"
		for(var/obj/item/implant/chem/chem_implant in global.chem_implants)
			var/turf/implant_turf = get_turf(chem_implant)
			if(implant_turf && !LEVELS_ARE_Z_CONNECTED(implant_turf.z, src.z))
				continue // Out of range
			if(!chem_implant.implanted)
				continue
			dat += "[chem_implant.imp_in.name] | Remaining Units: [chem_implant.reagents.total_volume] | Inject: "
			dat += "<A href='byond://?src=\ref[src];inject=\ref[chem_implant];amount=1'>(<font color=red>(1)</font>)</A>"
			dat += "<A href='byond://?src=\ref[src];inject=\ref[chem_implant];amount=5'>(<font color=red>(5)</font>)</A>"
			dat += "<A href='byond://?src=\ref[src];inject=\ref[chem_implant];amount=10'>(<font color=red>(10)</font>)</A><BR>"
			dat += "********************************<BR>"
		dat += "<HR>Tracking Implants<BR>"
		for(var/obj/item/implant/tracking/tracking_implant in global.tracking_implants)
			var/turf/implant_turf = get_turf(tracking_implant)
			if(implant_turf && !LEVELS_ARE_Z_CONNECTED(implant_turf.z, src.z))
				continue // Out of range
			if(!tracking_implant.implanted)
				continue
			var/area/tracked_area = get_area(tracking_implant)
			var/loc_display = tracked_area.proper_name
			if(tracking_implant.malfunction)
				loc_display = pick(teleportlocs)
			dat += "ID: [tracking_implant.id] | Location: [loc_display]<BR>"
			dat += "<A href='byond://?src=\ref[src];warn=\ref[tracking_implant]'>(<font color=red><i>Message Holder</i></font>)</A> |<BR>"
			dat += "********************************<BR>"
		dat += "<HR><A href='byond://?src=\ref[src];lock=1'>Lock Console</A>"

	show_browser(user, JOINTEXT(dat), "window=computer;size=400x500")
	onclose(user, "computer")

/obj/machinery/computer/prisoner/OnTopic(mob/user, href_list)
	if((. = ..()))
		return

	if(href_list["inject"])
		var/obj/item/implant/chem/chem_implant = locate(href_list["inject"])
		if(!chem_implant)
			return TOPIC_REFRESH // evidently their copy of the UI is out of date
		if(!istype(chem_implant)) // exists but is not a chem implant
			// warn that this is likely an href hacking attempt
			PRINT_STACK_TRACE("Possible HREF hacking attempt, chem implant inject called on non-chem-implant!")
			message_admins("Possible HREF hacking attempt, chem implant inject called on [href_list["inject"]] by [user] (ckey [(user.ckey)])!")
			return TOPIC_HANDLED
		var/amount_to_inject = clamp(text2num(href_list["amount"]), 1, 10) // don't let href hacking give more than 10 units at once
		chem_implant.activate(amount_to_inject)
		return TOPIC_HANDLED

	else if(href_list["lock"])
		if(allowed(user))
			locked = !locked
			return TOPIC_REFRESH
		else
			to_chat(user, "Unauthorized Access.")
			return TOPIC_HANDLED

	else if(href_list["warn"])
		var/warning = sanitize(input(user,"Message:","Enter your message here!",""))
		if(!warning)
			return TOPIC_HANDLED
		var/obj/item/implant/tracking/tracker = locate(href_list["warn"])
		if(!tracker)
			return TOPIC_REFRESH // evidently their copy of the UI is out of date
		if(!istype(tracker)) // exists but is not a tracking implant
			// warn that this is likely an href hacking attempt
			PRINT_STACK_TRACE("Possible HREF hacking attempt, tracking implant warn called on non-tracking-implant!")
			message_admins("Possible HREF hacking attempt, tracking implant warn called on [href_list["warn"]] by [user] (ckey [(user.ckey)])!")
			return TOPIC_HANDLED
		to_chat(tracker.imp_in, SPAN_NOTICE("You hear a voice in your head saying: '[warning]'"))
		return TOPIC_HANDLED
	return TOPIC_NOACTION
