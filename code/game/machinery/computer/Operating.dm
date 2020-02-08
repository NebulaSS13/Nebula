//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/operating
	name = "patient monitoring console"
	density = 1
	anchored = 1.0
	icon_keyboard = "med_key"
	icon_screen = "crew"
	var/mob/living/carbon/human/victim = null
	var/obj/machinery/optable/table = null

/obj/machinery/computer/operating/Initialize()
	. = ..()
	for(var/D in list(NORTH,EAST,SOUTH,WEST))
		table = locate(/obj/machinery/optable, get_step(src, D))
		if (table)
			table.computer = src
			break

/obj/machinery/computer/operating/interface_interact(user)
	interact(user)
	return TRUE

/obj/machinery/computer/operating/interact(mob/user)
	if ( (get_dist(src, user) > 1 ) || (stat & (BROKEN|NOPOWER)) )
		if (!istype(user, /mob/living/silicon))
			user.unset_machine()
			close_browser(user, "op")
			return
	var/dat = "<HEAD><TITLE>Operating Computer</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += "<A HREF='?src=\ref[user];mach_close=op'>Close</A><br><br>" //| <A HREF='?src=\ref[user];update=1'>Update</A>"
	if(table && (table.check_victim()))
		victim = src.table.victim
		dat += "<B>Patient Information:</B><BR><BR>[medical_scan_results(victim, 1)]"
	else
		victim = null
		dat += "<B>Patient Information:</B><BR><BR><B>No Patient Detected</B>"
	var/datum/browser/written/popup = new(user, "op", "Operating Table")
	popup.set_content(dat)
	popup.open()

/obj/machinery/computer/operating/Process()
	if(!inoperable())
		updateDialog()