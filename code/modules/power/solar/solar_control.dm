//
// Solar Control Computer
//

/obj/machinery/power/solar_control
	name = "solar panel control"
	desc = "A controller for solar panel arrays."
	icon = 'icons/obj/computer.dmi'
	icon_state = "solar"
	anchored = TRUE
	density = TRUE
	use_power = POWER_USE_IDLE
	idle_power_usage = 250
	construct_state = /decl/machine_construction/default/panel_closed/computer
	base_type = /obj/machinery/power/solar_control
	frame_type = /obj/machinery/constructable_frame/computerframe/deconstruct
	var/cdir = 0
	var/targetdir = 0		// target angle in manual tracking (since it updates every game minute)
	var/gen = 0
	var/lastgen = 0
	var/track = 0			// 0= off  1=timed  2=auto (tracker)
	var/trackrate = 600		// 300-900 seconds
	var/nexttime = 0		// time for a panel to rotate of 1° in manual tracking
	var/obj/machinery/power/tracker/connected_tracker = null
	var/list/connected_panels = list()

/obj/machinery/power/solar_control/drain_power()
	return -1

/obj/machinery/power/solar_control/Destroy()
	for(var/obj/machinery/power/solar/M in connected_panels)
		M.unset_control()
	if(connected_tracker)
		connected_tracker.unset_control()
	return ..()

/obj/machinery/power/solar_control/disconnect_from_network()
	..()
	solars_list.Remove(src)

/obj/machinery/power/solar_control/connect_to_network()
	var/to_return = ..()
	if(powernet) //if connected and not already in solar_list...
		solars_list |= src //... add it
	return to_return

//search for unconnected panels and trackers in the computer powernet and connect them
/obj/machinery/power/solar_control/proc/search_for_connected()
	if(powernet)
		for(var/obj/machinery/power/M in powernet.nodes)
			if(istype(M, /obj/machinery/power/solar))
				var/obj/machinery/power/solar/S = M
				if(!S.control) //i.e unconnected
					if(S.set_control(src))
						connected_panels |= S
			else if(istype(M, /obj/machinery/power/tracker))
				if(!connected_tracker) //if there's already a tracker connected to the computer don't add another
					var/obj/machinery/power/tracker/T = M
					if(!T.control) //i.e unconnected
						if(T.set_control(src))
							connected_tracker = T

//called by the sun controller, update the facing angle (either manually or via tracking) and rotates the panels accordingly
/obj/machinery/power/solar_control/proc/update()
	if(stat & (NOPOWER | BROKEN))
		return

	switch(track)
		if(1)
			if(trackrate) //we're manual tracking. If we set a rotation speed...
				cdir = targetdir //...the current direction is the targetted one (and rotates panels to it)
		if(2) // auto-tracking
			var/datum/sun/sun = get_best_sun()
			if(connected_tracker && sun)
				connected_tracker.set_angle(sun.angle)

	set_panels(cdir)
	updateDialog()

/obj/machinery/power/solar_control/Initialize()
	. = ..()
	if(!connect_to_network()) return
	set_panels(cdir)

/obj/machinery/power/solar_control/on_update_icon()
	if(stat & BROKEN)
		icon_state = "broken"
		return
	if(stat & NOPOWER)
		icon_state = "c_unpowered"
		return
	icon_state = "solar"

/obj/machinery/power/solar_control/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/power/solar_control/interact(mob/user)

	var/datum/sun/sun = get_best_sun()
	var/t = "<B><span class='highlight'>Generated power</span></B> : [round(lastgen)] W<BR>"
	t += "<B><span class='highlight'>Star Orientation</span></B>: [sun?.angle || 0]&deg ([angle2text(sun?.angle || 0)])<BR>"
	t += "<B><span class='highlight'>Array Orientation</span></B>: [rate_control(src,"cdir","[cdir]&deg",1,15)] ([angle2text(cdir)])<BR>"
	t += "<B><span class='highlight'>Tracking:</span></B><div class='statusDisplay'>"
	switch(track)
		if(0)
			t += "<span class='linkOn'>Off</span> <A href='byond://?src=\ref[src];track=1'>Timed</A> <A href='byond://?src=\ref[src];track=2'>Auto</A><BR>"
		if(1)
			t += "<A href='byond://?src=\ref[src];track=0'>Off</A> <span class='linkOn'>Timed</span> <A href='byond://?src=\ref[src];track=2'>Auto</A><BR>"
		if(2)
			t += "<A href='byond://?src=\ref[src];track=0'>Off</A> <A href='byond://?src=\ref[src];track=1'>Timed</A> <span class='linkOn'>Auto</span><BR>"

	t += "Tracking Rate: [rate_control(src,"tdir","[trackrate] deg/h ([trackrate<0 ? "CCW" : "CW"])",1,30,180)]</div><BR>"

	t += "<B><span class='highlight'>Connected devices:</span></B><div class='statusDisplay'>"

	t += "<A href='byond://?src=\ref[src];search_connected=1'>Search for devices</A><BR>"
	t += "Solar panels : [connected_panels.len] connected<BR>"
	t += "Solar tracker : [connected_tracker ? "<span class='good'>Found</span>" : "<span class='bad'>Not found</span>"]</div><BR>"

	t += "<A href='byond://?src=\ref[src];close=1'>Close</A>"

	var/datum/browser/written_digital/popup = new(user, "solar", name)
	popup.set_content(t)
	popup.open()

/obj/machinery/power/solar_control/Process()
	lastgen = gen
	gen = 0

	if(stat & (NOPOWER | BROKEN))
		return

	if(connected_tracker) //NOTE : handled here so that we don't add trackers to the processing list
		if(connected_tracker.powernet != powernet)
			connected_tracker.unset_control()

	if(track==1 && trackrate) //manual tracking and set a rotation speed
		if(nexttime <= world.time) //every time we need to increase/decrease the angle by 1°...
			targetdir = (targetdir + trackrate/abs(trackrate) + 360) % 360 	//... do it
			nexttime += 36000/abs(trackrate) //reset the counter for the next 1°

	updateDialog()

/obj/machinery/power/solar_control/Topic(href, href_list)
	. = ..()
	if(. == TOPIC_CLOSE)
		close_browser(usr, "window=solcon")

/obj/machinery/power/solar_control/OnTopic(mob/user, href_list)
	if((. = ..()))
		return
	if(href_list["close"])
		return TOPIC_CLOSE

	if(href_list["rate control"])
		if(href_list["cdir"])
			cdir = clamp((360+cdir+text2num(href_list["cdir"]))%360, 0, 359)
			targetdir = cdir
			if(track == 2) //manual update, so losing auto-tracking
				track = 0
			addtimer(CALLBACK(src, PROC_REF(set_panels), cdir), 1)
		if(href_list["tdir"])
			trackrate = clamp(trackrate+text2num(href_list["tdir"]), -7200, 7200)
			if(trackrate) nexttime = world.time + 36000/abs(trackrate)
		return TOPIC_REFRESH

	if(href_list["track"])
		track = text2num(href_list["track"])
		if(track == 2)
			var/datum/sun/sun = get_best_sun()
			if(connected_tracker && sun)
				connected_tracker.set_angle(sun.angle)
				set_panels(cdir)
		else if (track == 1) //begin manual tracking
			targetdir = cdir
			if(trackrate) nexttime = world.time + 36000/abs(trackrate)
			set_panels(targetdir)
		return TOPIC_REFRESH

	if(href_list["search_connected"])
		search_for_connected()
		var/datum/sun/sun = get_best_sun()
		if(connected_tracker && track == 2 && sun)
			connected_tracker.set_angle(sun.angle)
		set_panels(cdir)
		return TOPIC_REFRESH

//rotates the panel to the passed angle
/obj/machinery/power/solar_control/proc/set_panels(var/cdir)
	for(var/obj/machinery/power/solar/S in connected_panels)
		S.adir = cdir //instantly rotates the panel
		S.occlusion()//and
		S.update_icon() //update it
	update_icon()

/obj/machinery/power/solar_control/explosion_act(severity)
	. = ..()
	if(.)
		if(severity == 1)
			physically_destroyed()
		else if((severity == 2 && prob(50)) || (severity == 3 && prob(25)))
			set_broken(TRUE)

// Used for mapping in solar array which automatically starts itself (telecomms, for example)
/obj/machinery/power/solar_control/autostart
	track = 2 // Auto tracking mode

/obj/machinery/power/solar_control/autostart/Initialize()
	search_for_connected()
	var/datum/sun/sun = get_best_sun()
	if(connected_tracker && track == 2 && sun)
		connected_tracker.set_angle(sun.angle)
		set_panels(cdir)
	. = ..()