var/global/list/navbeacons = list()

/obj/machinery/navbeacon
	icon = 'icons/obj/objects.dmi'
	icon_state = "navbeacon0-f"
	name = "navigation beacon"
	desc = "A radio beacon used for bot navigation."
	level = LEVEL_BELOW_PLATING
	layer = ABOVE_WIRE_LAYER
	anchored = TRUE

	var/open = 0		// true if cover is open
	var/locked = 1		// true if controls are locked
	var/location = ""	// location response text
	var/list/codes = list()		// assoc. list of transponder codes

	initial_access = list(access_engine)

/obj/machinery/navbeacon/Initialize()

	if(istext(codes)) // Mapping helper.
		codes = cached_json_decode(codes)

	. = ..()

	var/turf/T = loc
	hide(istype(T) && !T.is_plating())

	navbeacons += src

/obj/machinery/navbeacon/hide(var/intact)
	set_invisibility(intact ? INVISIBILITY_ABSTRACT : INVISIBILITY_NONE)
	update_icon()

/obj/machinery/navbeacon/on_update_icon()
	var/state="navbeacon[open]"

	if(invisibility)
		icon_state = "[state]-f"	// if invisible, set icon to faded version
									// in case revealed by T-scanner
	else
		icon_state = "[state]"

/obj/machinery/navbeacon/attackby(var/obj/item/used_item, var/mob/user)
	var/turf/T = loc
	if(!T.is_plating())
		return TRUE // prevent intraction when T-scanner revealed

	if(IS_SCREWDRIVER(used_item))
		open = !open
		user.visible_message("\The [user] [open ? "opens" : "closes"] cover of \the [src].", "You [open ? "open" : "close"] cover of \the [src].")
		update_icon()
		return TRUE

	else if(used_item.GetIdCard())
		if(open)
			if (src.allowed(user))
				src.locked = !src.locked
				to_chat(user, "Controls are now [src.locked ? "locked." : "unlocked."]")
			else
				to_chat(user, "<span class='warning'>Access denied.</span>")
			updateDialog()
		else
			to_chat(user, "You must open the cover first!")
		return TRUE
	return FALSE

/obj/machinery/navbeacon/interface_interact(var/mob/user)
	interact(user)
	return TRUE

/obj/machinery/navbeacon/interact(var/mob/user)
	var/ai = isAI(user)
	var/turf/T = loc
	if(!T.is_plating())
		return // prevent intraction when T-scanner revealed

	if(!open && !ai) // can't alter controls if not open, unless you're an AI
		to_chat(user, "The beacon's control cover is closed.")
		return

	var/restricted = locked && !ai
	var/list/dat = list({"<TT><B>Navigation Beacon</B><HR><BR>
<i>(swipe card to [locked ? "unlock" : "lock"] controls)</i><BR><HR>
Location: [restricted ? "" : "<A href='byond://?src=\ref[src];locedit=1'>"][location ? location : "(none)"][restricted ? "" : "</A>"]<BR>
Transponder Codes:<UL>"})

	for(var/key in codes)
		dat += "<LI>[key] ... [codes[key]]"
		if(!restricted)
			dat += " <small><A href='byond://?src=\ref[src];edit=1;code=[key]'>(edit)</A>"
			dat += " <A href='byond://?src=\ref[src];delete=1;code=[key]'>(delete)</A></small><BR>"
	if(!restricted)
		dat += "<small><A href='byond://?src=\ref[src];add=1;'>(add new)</A></small><BR>"
	dat += "<UL></TT>"

	show_browser(user, JOINTEXT(dat), "window=navbeacon")
	onclose(user, "navbeacon")
	return

/obj/machinery/navbeacon/OnTopic(mob/user, href_list, datum/topic_state/state)
	if((. = ..()))
		return
	if(!open || locked)
		return TOPIC_NOACTION

	if(href_list["locedit"])
		var/newloc = sanitize(input(user, "Enter New Location", "Navigation Beacon", location) as text|null)
		if(newloc)
			location = newloc
			return TOPIC_REFRESH

	else if(href_list["edit"])
		var/codekey = href_list["code"]

		var/newkey = sanitize(input(user, "Enter Transponder Code Key", "Navigation Beacon", codekey) as text|null)
		if(!newkey)
			return TOPIC_HANDLED

		var/codeval = codes[codekey]
		var/newval = sanitize(input(user, "Enter Transponder Code Value", "Navigation Beacon", codeval || "1") as text|null)
		if(!newval)
			return TOPIC_HANDLED

		codes -= codekey
		codes[newkey] = newval
		return TOPIC_REFRESH

	else if(href_list["delete"])
		var/codekey = href_list["code"]
		codes -= codekey
		return TOPIC_REFRESH

	else if(href_list["add"])

		var/newkey = sanitize(input(user, "Enter New Transponder Code Key", "Navigation Beacon") as text|null)
		if(!newkey)
			return TOPIC_HANDLED

		var/newval = sanitize(input(user, "Enter New Transponder Code Value", "Navigation Beacon", "1") as text|null)
		if(!newval)
			return TOPIC_HANDLED

		codes[newkey] = newval
		return TOPIC_REFRESH

/obj/machinery/navbeacon/Destroy()
	global.navbeacons -= src
	return ..()

// Patrol beacon types below. So many.

/obj/machinery/navbeacon/Security
	location = "Security"
	codes = list("patrol" = 1, "next_patrol" = "EVA")

/obj/machinery/navbeacon/EVA
	location = "EVA"
	codes = list("patrol" = 1, "next_patrol" = "Lockers")

/obj/machinery/navbeacon/Lockers
	location = "Lockers"
	codes = list("patrol" = 1, "next_patrol" = "CHW")

/obj/machinery/navbeacon/CHW
	location = "CHW"
	codes = list("patrol" = 1, "next_patrol" = "QM")

/obj/machinery/navbeacon/QM
	location = "QM"
	codes = list("patrol" = 1, "next_patrol" = "AIW")

/obj/machinery/navbeacon/AIW
	location = "AIW"
	codes = list("patrol" = 1, "next_patrol" = "AftH")

/obj/machinery/navbeacon/AftH
	location = "AftH"
	codes = list("patrol" = 1, "next_patrol" = "AIE")

/obj/machinery/navbeacon/AIE
	location = "AIE"
	codes = list("patrol" = 1, "next_patrol" = "CHE")

/obj/machinery/navbeacon/CHE
	location = "CHE"
	codes = list("patrol" = 1, "next_patrol" = "HOP")

/obj/machinery/navbeacon/HOP
	location = "HOP"
	codes = list("patrol" = 1, "next_patrol" = "Stbd")

/obj/machinery/navbeacon/Stbd
	location = "Stbd"
	codes = list("patrol" = 1, "next_patrol" = "HOP2")

/obj/machinery/navbeacon/HOP2
	location = "HOP2"
	codes = list("patrol" = 1, "next_patrol" = "Dorm")

/obj/machinery/navbeacon/Dorm
	location = "Dorm"
	codes = list("patrol" = 1, "next_patrol" = "EVA2")

/obj/machinery/navbeacon/EVA2
	location = "EVA2"
	codes = list("patrol" = 1, "next_patrol" = "Security") // And the cycle is finished

// Delivery types below.

/obj/machinery/navbeacon/QM1
	location = "QM #1"
	codes = list("delivery" = 1, "dir" = 8)

/obj/machinery/navbeacon/QM2
	location = "QM #2"
	codes = list("delivery" = 1, "dir" = 8)

/obj/machinery/navbeacon/QM3
	location = "QM #3"
	codes = list("delivery" = 1, "dir" = 8)

/obj/machinery/navbeacon/QM4
	location = "QM #4"
	codes = list("delivery" = 1, "dir" = 8)

/obj/machinery/navbeacon/Research
	location = "Research Division"
	codes = list("delivery" = 1, "dir" = 8)

/obj/machinery/navbeacon/Janitor
	location = "Janitor"
	codes = list("delivery" = 1, "dir" = 8)

/obj/machinery/navbeacon/SecurityD
	location = "Security"
	codes = list("delivery" = 1, "dir" = 8)

/obj/machinery/navbeacon/ToolStorage
	location = "Tool Storage"
	codes = list("delivery" = 1, "dir" = 8)

/obj/machinery/navbeacon/Medbay
	location = "Medbay"
	codes = list("delivery" = 1, "dir" = 4)

/obj/machinery/navbeacon/Engineering
	location = "Engineering"
	codes = list("delivery" = 1, "dir" = 4)

/obj/machinery/navbeacon/Bar
	location = "Bar"
	codes = list("delivery" = 1, "dir" = 2)

/obj/machinery/navbeacon/Kitchen
	location = "Kitchen"
	codes = list("delivery" = 1, "dir" = 2)

/obj/machinery/navbeacon/Hydroponics
	location = "Hydroponics"
	codes = list("delivery" = 1, "dir" = 2)
