#define SOLAR_MAX_DIST 40

// This is just to keep all the overmap solar stuff nice and tidy and not spread across three or four files.

//
// Overmap solars below. It'd be an absolutely pain to add a bunch of if statements and such to try and shoehorn normal function into them.
//


// SOLAR PANELS

/obj/machinery/power/solar/overmap
	var/obj/machinery/power/solar_control/overmap/overmap_control = null

//calculates the fraction of the sunlight that the panel recieves
/obj/machinery/power/solar/overmap/update_solar_exposure()
	if(obscured)
		sunfrac = 0
		return
	//find the smaller angle between the direction the panel is facing and the direction of the sun (the sign is not important here)
	var/p_angle = min(abs(adir - overmap_control.overmap_tracker.get_sun_angle()), 360 - abs(adir - overmap_control.overmap_tracker.get_sun_angle()))

	if(p_angle > 90)			// if facing more than 90deg from sun, zero output
		sunfrac = 0

		return
	//Do distance checks from the star, keep sunfrac at a min of 0 and a max of 1.
	var/obj/effect/overmap/star/star = locate(/obj/effect/overmap/star)
	var/dist = get_dist(star, overmap_control.linked)
	var/dist_penalty = dist * 0.1

	sunfrac = cos(p_angle) ** 2
	sunfrac -= (dist_penalty -= star.star_luminosity)
	//Opacity check.
	var/list/turflist = getline(overmap_control.linked, star)
	for(var/turf/T in turflist)
		var/obj/effect/overmap/overmap_effect = locate(/obj/effect/overmap) in T
		if(overmap_effect && overmap_effect.opacity)
			sunfrac = 0
			break
	if(!star.star_luminosity)
		sunfrac = 0

	sunfrac = Clamp(sunfrac, 0, 1)

/obj/machinery/power/solar/overmap/unset_control()
	if(overmap_control)
		overmap_control.connected_panels.Remove(src)
	overmap_control = null

/obj/machinery/power/solar/overmap/Process()
	if(stat & BROKEN)
		return
	if(!overmap_control) //if there's no sun or the panel is not linked to a solar control computer, no need to proceed
		return

	if(powernet)
		if(powernet == overmap_control.powernet)//check if the panel is still connected to the computer
			if(obscured) //get no light from the sun, so don't generate power
				return
			var/sgen = solar_gen_rate * sunfrac * efficiency
			add_avail(sgen)
			overmap_control.gen += sgen
		else //if we're no longer on the same powernet, remove from control computer
			unset_control()

//set the control of the panel to a given computer if closer than SOLAR_MAX_DIST
/obj/machinery/power/solar/overmap/set_control(var/obj/machinery/power/solar_control/overmap/SC)
	if(SC && (get_dist(src, SC) > SOLAR_MAX_DIST))
		return 0
	overmap_control = SC
	return 1

//set the control of the panel to null and removes it from the control list of the previous control computer if needed
/obj/machinery/power/solar/overmap/unset_control()
	if(overmap_control)
		overmap_control.connected_panels.Remove(src)
	overmap_control = null


//TRACKER

/obj/machinery/power/tracker/overmap
	var/obj/machinery/power/solar_control/overmap/overmap_control

/obj/machinery/power/tracker/overmap/proc/get_sun_angle()
	if(control)
		var/obj/machinery/power/solar_control/overmap/SC = control
		if(SC.linked)
			var/ship = SC.linked
			var/obj/effect/overmap/star/sun = locate()
			var/final_angle = round(Get_Angle(ship,sun))
			return final_angle

/obj/machinery/power/tracker/overmap/unset_control()
	if(overmap_control)
		overmap_control.overmap_tracker = null
	overmap_control = null

// SOLAR CONTROL

/obj/machinery/power/solar_control/overmap
	var/obj/effect/overmap/visitable/ship/linked
	var/obj/machinery/power/tracker/overmap/overmap_tracker //New pathed var because you can't overwrite the old one. Fucking hell.

/obj/machinery/power/solar_control/overmap/proc/attempt_hook_up(obj/effect/overmap/visitable/ship/sector)
	if(!istype(sector))
		return
	if(sector.check_ownership(src))
		linked = sector
		return 1

/obj/machinery/power/solar_control/overmap/Destroy()
	linked = null
	for(var/obj/machinery/power/solar/overmap/M in connected_panels)
		M.unset_control()
	if(overmap_tracker)
		overmap_tracker.unset_control()
	..()

/obj/machinery/power/solar_control/overmap/update()
	if(stat & (NOPOWER | BROKEN))
		return

	if(!powernet) // no powernet
		return

	switch(track)
		if(1)
			if(trackrate) //we're manual tracking. If we set a rotation speed...
				cdir = targetdir //...the current direction is the targetted one (and rotates panels to it)
		if(2) // auto-tracking
			if(overmap_tracker)
				var/obj/machinery/power/tracker/overmap/tracker = overmap_tracker
				tracker.set_angle(tracker.get_sun_angle())

	set_panels(cdir)
	updateDialog()

/obj/machinery/power/solar_control/overmap/Process()
	lastgen = gen
	gen = 0

	if(stat & (NOPOWER | BROKEN))
		return

	if(overmap_tracker) //NOTE : handled here so that we don't add trackers to the processing list
		if(overmap_tracker.powernet != powernet)
			overmap_tracker.unset_control()
		else
			update()

	if(track==1 && trackrate) //manual tracking and set a rotation speed
		if(nexttime <= world.time) //every time we need to increase/decrease the angle by 1°...
			targetdir = (targetdir + trackrate/abs(trackrate) + 360) % 360 	//... do it
			nexttime += 36000/abs(trackrate) //reset the counter for the next 1°

	updateDialog()

/obj/machinery/power/solar_control/overmap/search_for_connected()
	if(powernet)
		for(var/obj/machinery/power/M in powernet.nodes)
			if(istype(M, /obj/machinery/power/solar/overmap))
				var/obj/machinery/power/solar/overmap/S = M
				if(!S.overmap_control) //i.e unconnected
					if(S.set_control(src))
						connected_panels |= S
			else if(istype(M, /obj/machinery/power/tracker/overmap))
				if(!overmap_tracker) //if there's already a tracker connected to the computer don't add another
					var/obj/machinery/power/tracker/overmap/T = M
					if(!T.overmap_control) //i.e unconnected
						if(T.set_control(src))
							overmap_tracker = T

/obj/machinery/power/solar_control/overmap/interact(mob/user)
	var/sun_angle = 0
	if(overmap_tracker)
		sun_angle = overmap_tracker.get_sun_angle()

	var/t = "<B><span class='highlight'>Generated power</span></B> : [round(lastgen)] W<BR>"
	t += "<B><span class='highlight'>Star Orientation</span></B>: [sun_angle]&deg ([angle2text(sun_angle)])<BR>"
	t += "<B><span class='highlight'>Array Orientation</span></B>: [rate_control(src,"cdir","[cdir]&deg",1,15)] ([angle2text(cdir)])<BR>"
	t += "<B><span class='highlight'>Tracking:</span></B><div class='statusDisplay'>"
	switch(track)
		if(0)
			t += "<span class='linkOn'>Off</span> <A href='?src=\ref[src];track=1'>Timed</A> <A href='?src=\ref[src];track=2'>Auto</A><BR>"
		if(1)
			t += "<A href='?src=\ref[src];track=0'>Off</A> <span class='linkOn'>Timed</span> <A href='?src=\ref[src];track=2'>Auto</A><BR>"
		if(2)
			t += "<A href='?src=\ref[src];track=0'>Off</A> <A href='?src=\ref[src];track=1'>Timed</A> <span class='linkOn'>Auto</span><BR>"

	t += "Tracking Rate: [rate_control(src,"tdir","[trackrate] deg/h ([trackrate<0 ? "CCW" : "CW"])",1,30,180)]</div><BR>"

	t += "<B><span class='highlight'>Connected devices:</span></B><div class='statusDisplay'>"

	t += "<A href='?src=\ref[src];search_connected=1'>Search for devices</A><BR>"
	t += "Solar panels : [connected_panels.len] connected<BR>"
	t += "Solar tracker : [overmap_tracker ? "<span class='good'>Found</span>" : "<span class='bad'>Not found</span>"]</div><BR>"

	t += "<A href='?src=\ref[src];close=1'>Close</A>"

	var/datum/browser/written/popup = new(user, "solar", name)
	popup.set_content(t)
	popup.open()

#undef SOLAR_MAX_DIST