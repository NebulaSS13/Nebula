var/global/list/areas = list()

/area

	level = null
	name = "Unknown"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	plane = DEFAULT_PLANE
	layer = BASE_AREA_LAYER
	luminosity =    0
	mouse_opacity = 0

	var/proper_name /// Automatically set by SetName and Initialize; cached result of strip_improper(name).
	var/holomap_color	// Color of this area on the holomap. Must be a hex color (as string) or null.

	var/fire
	var/party
	var/eject

	var/lightswitch =         TRUE
	var/requires_power =      TRUE
	var/always_unpowered =    FALSE //this gets overriden to 1 for space in area/New()

	var/atmosalm =            0
	var/power_equip =         1 // Status
	var/power_light =         1
	var/power_environ =       1
	var/used_equip =          0  // Continuous drain; don't mess with these directly.
	var/used_light =          0
	var/used_environ =        0
	var/oneoff_equip   =      0 //Used once and cleared each tick.
	var/oneoff_light   =      0
	var/oneoff_environ =      0
	var/has_gravity =         TRUE
	var/air_doors_activated = FALSE

	var/obj/machinery/power/apc/apc
	var/list/all_doors		//Added by Strumpetplaya - Alarm Change - Contains a list of doors adjacent to this area
	var/list/ambience = list('sound/ambience/ambigen1.ogg','sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambigen12.ogg','sound/ambience/ambigen14.ogg')
	var/list/forced_ambience
	var/sound_env = STANDARD_STATION
	var/description //A text-based description of what this area is for.

	var/base_turf // The base turf type of the area, which can be used to override the z-level's base turf
	var/open_turf // The base turf of the area if it has a turf below it in multizi. Overrides turf-specific open type

	var/static/global_uid = 0
	var/uid
	var/area_flags = 0

	//all air alarms in area are connected via magic
	var/list/air_vent_names = list()
	var/list/air_scrub_names = list()
	var/list/air_vent_info = list()
	var/list/air_scrub_info = list()
	var/list/blurbed_stated_to = list() //This list of names is here to make sure we don't state our descriptive blurb to a person more than once.

	var/tmp/is_outside = OUTSIDE_NO

	var/tmp/saved_map_hash // Used for cleanup when loaded via map templates.

/area/New()
	icon_state = ""
	uid = ++global_uid
	proper_name = strip_improper(name)
	luminosity = !dynamic_lighting
	..()

/area/Initialize()
	. = ..()
	global.areas += src
	if(!requires_power || !apc)
		power_light =   0
		power_equip =   0
		power_environ = 0
	power_change()		// all machines set to current power level, also updates lighting icon

	icon = 'icons/turf/areas.dmi'
	icon_state = "white"
	color = null
	blend_mode = BLEND_MULTIPLY

// qdel(area) should not be attempted on an area with turfs in contents. ChangeArea every turf in it first.

/area/Destroy()
	global.areas -= src
	var/failure = FALSE
	for(var/atom/A in contents)
		if(isturf(A))
			failure = TRUE
			contents.Remove(A) // note: A.loc == null after this
		else
			qdel(A)
	if(failure)
		PRINT_STACK_TRACE("Area [log_info_line(src)] was qdeleted with turfs in contents.")
	area_repository.clear_cache()
	..()
	return QDEL_HINT_HARDDEL

// Changes the area of T to A. Do not do this manually.
// Area is expected to be a non-null instance.
/proc/ChangeArea(var/turf/T, var/area/A)
	if(!istype(A))
		CRASH("Area change attempt failed: invalid area supplied.")
	var/old_outside = T.is_outside()
	var/area/old_area = get_area(T)
	if(old_area == A)
		return
	A.contents.Add(T)
	if(old_area)
		old_area.Exited(T, A)
		for(var/atom/movable/AM in T)
			old_area.Exited(AM, A)  // Note: this _will_ raise exited events.
	A.Entered(T, old_area)
	for(var/atom/movable/AM in T)
		A.Entered(AM, old_area) // Note: this will _not_ raise moved or entered events. If you change this, you must also change everything which uses them.

	for(var/obj/machinery/M in T)
		M.area_changed(old_area, A) // They usually get moved events, but this is the one way an area can change without triggering one.

	T.update_registrations_on_adjacent_area_change()
	for(var/direction in global.cardinal)
		var/turf/adjacent_turf = get_step(T, direction)
		if(adjacent_turf)
			adjacent_turf.update_registrations_on_adjacent_area_change()

	T.last_outside_check = OUTSIDE_UNCERTAIN
	if(T.is_outside == OUTSIDE_AREA && T.is_outside() != old_outside)
		T.update_weather()

/turf/proc/update_registrations_on_adjacent_area_change()
	for(var/obj/machinery/door/firedoor/door in src)
		door.update_area_registrations()

/area/proc/alert_on_fall(var/mob/living/carbon/human/H)
	return

/area/proc/get_contents()
	return contents

/area/proc/get_cameras()
	var/list/cameras = list()
	for (var/obj/machinery/camera/C in src)
		cameras += C
	return cameras

/area/proc/is_shuttle_locked()
	return 0

/area/proc/atmosalert(danger_level, var/alarm_source)
	if (danger_level == 0)
		atmosphere_alarm.clearAlarm(src, alarm_source)
	else
		atmosphere_alarm.triggerAlarm(src, alarm_source, severity = danger_level)

	//Check all the alarms before lowering atmosalm. Raising is perfectly fine.
	for (var/obj/machinery/alarm/AA in src)
		if (!(AA.stat & (NOPOWER|BROKEN)) && !AA.shorted && AA.report_danger_level)
			danger_level = max(danger_level, AA.danger_level)

	if(danger_level != atmosalm)
		if (danger_level < 1 && atmosalm >= 1)
			//closing the doors on red and opening on green provides a bit of hysteresis that will hopefully prevent fire doors from opening and closing repeatedly due to noise
			air_doors_open()
		else if (danger_level >= 2 && atmosalm < 2)
			air_doors_close()

		atmosalm = danger_level
		for (var/obj/machinery/alarm/AA in src)
			AA.update_icon()

		update_icon()

		return TRUE
	return FALSE

/area/proc/air_doors_close()
	if(!air_doors_activated)
		air_doors_activated = 1
		if(!all_doors)
			return
		for(var/obj/machinery/door/firedoor/E in all_doors)
			if(!E.blocked)
				if(E.operating)
					E.nextstate = FIREDOOR_CLOSED
				else if(!E.density)
					spawn(0)
						E.close()

/area/proc/air_doors_open()
	if(air_doors_activated)
		air_doors_activated = 0
		if(!all_doors)
			return
		for(var/obj/machinery/door/firedoor/E in all_doors)
			if(!E.blocked)
				if(E.operating)
					E.nextstate = FIREDOOR_OPEN
				else if(E.density)
					spawn(0)
						if(E.can_safely_open())
							E.open()


/area/proc/fire_alert()
	if(!fire)
		fire = 1	//used for firedoor checks
		update_icon()
		mouse_opacity = 0
		if(!all_doors)
			return
		for(var/obj/machinery/door/firedoor/D in all_doors)
			if(!D.blocked)
				if(D.operating)
					D.nextstate = FIREDOOR_CLOSED
				else if(!D.density)
					spawn()
						D.close()

/area/proc/fire_reset()
	if (fire)
		fire = 0	//used for firedoor checks
		update_icon()
		mouse_opacity = 0
		if(!all_doors)
			return
		for(var/obj/machinery/door/firedoor/D in all_doors)
			if(!D.blocked)
				if(D.operating)
					D.nextstate = FIREDOOR_OPEN
				else if(D.density)
					spawn(0)
					D.open()

/area/proc/readyalert()
	if(!eject)
		eject = 1
		update_icon()
	return

/area/proc/readyreset()
	if(eject)
		eject = 0
		update_icon()
	return

/area/proc/partyalert()
	if (!( party ))
		party = 1
		update_icon()
		mouse_opacity = 0
	return

/area/proc/partyreset()
	if (party)
		party = 0
		mouse_opacity = 0
		update_icon()
		for(var/obj/machinery/door/firedoor/D in src)
			if(!D.blocked)
				if(D.operating)
					D.nextstate = FIREDOOR_OPEN
				else if(D.density)
					spawn(0)
					D.open()
	return

#define DO_PARTY(COLOR) animate(color = COLOR, time = 0.5 SECONDS, easing = QUAD_EASING)

/area/on_update_icon()
	if((atmosalm || fire || eject || party) && (!requires_power||power_environ) && !istype(src, /area/space))//If it doesn't require power, can still activate this proc.
		if(fire && !atmosalm && !eject && !party) // FIRE
			color = "#ff9292"
			animate(src)	// stop any current animations.
			animate(src, color = "#ffa5b2", time = 1 SECOND, loop = -1, easing = SINE_EASING)
			animate(color = "#ff9292", time = 1 SECOND, easing = SINE_EASING)
		else if(atmosalm && !fire && !eject && !party) // ATMOS
			color = "#b3dfff"
			animate(src)
			animate(src, color = "#78dfff", time = 3 SECOND, loop = -1, easing = SINE_EASING)
			animate(color = "#b3dfff", time = 3 SECOND, easing = SINE_EASING)
		else if(eject && !atmosalm && !fire && !party) // EJECT
			color = "#ff9292"
			animate(src)
			animate(src, color = "#bc8a81", time = 1 SECOND, loop = -1, easing = EASE_IN|CUBIC_EASING)
			animate(color = "#ff9292", time = 0.5 SECOND, easing = EASE_OUT|CUBIC_EASING)
		else if(party && !atmosalm && !fire && !eject) // PARTY
			color = "#ff728e"
			animate(src)
			animate(src, color = "#7272ff", time = 0.5 SECONDS, loop = -1, easing = QUAD_EASING)
			DO_PARTY("#72aaff")
			DO_PARTY("#ffc68e")
			DO_PARTY("#72c6ff")
			DO_PARTY("#ff72e2")
			DO_PARTY("#72ff8e")
			DO_PARTY("#ffff8e")
			DO_PARTY("#ff728e")
		else
			color = "#ffb2b2"
			animate(src)
			animate(src, color = "#b3dfff", time = 0.5 SECOND, loop = -1, easing = SINE_EASING)
			animate(color = "#ffb2b2", time = 0.5 SECOND, loop = -1, easing = SINE_EASING)
	else
		animate(src, color = "#ffffff", time = 0.5 SECONDS, easing = QUAD_EASING)	// Stop the animation.

#undef DO_PARTY

/area/proc/set_lightswitch(var/new_switch)
	if(lightswitch != new_switch)
		lightswitch = new_switch
		for(var/obj/machinery/light_switch/L in src)
			L.sync_state()
		update_icon()
	for(var/obj/machinery/light/M in src)
		M.delay_and_set_on(M.expected_to_be_on(), 1 SECOND)

/area/proc/set_emergency_lighting(var/enable)
	for(var/obj/machinery/light/M in src)
		M.set_emergency_lighting(enable)


var/global/list/mob/living/forced_ambiance_list = new

/area/Entered(A)
	if(!istype(A,/mob/living))
		return
	var/mob/living/L = A
	if(!L.lastarea)
		L.lastarea = get_area(L.loc)
	var/area/oldarea = L.lastarea
	if(!oldarea || oldarea.has_gravity != has_gravity)
		if(has_gravity == 1 && !MOVING_DELIBERATELY(L)) // Being ready when you change areas allows you to avoid falling.
			thunk(L)
		L.update_floating()
	if(L.ckey)
		play_ambience(L)
		do_area_blurb(L)
	L.lastarea = src


/area/Exited(A)
	if(isliving(A))
		clear_ambience(A)
	return ..()

/area/proc/do_area_blurb(var/mob/living/L)
	if(isnull(description))
		return

	if(L?.get_preference_value(/datum/client_preference/area_info_blurb) != PREF_YES)
		return

	if(!(L.ckey in blurbed_stated_to))
		blurbed_stated_to += L.ckey
		to_chat(L, SPAN_NOTICE(FONT_SMALL("[description]")))

/area/proc/play_ambience(var/mob/living/L)
	// Ambience goes down here -- make sure to list each area seperately for ease of adding things in later, thanks! Note: areas adjacent to each other should have the same sounds to prevent cutoff when possible.- LastyScratch
	if(!(L && L.client && L.get_preference_value(/datum/client_preference/play_ambiance) == PREF_YES))	return

	var/turf/T = get_turf(L)

	if(LAZYLEN(forced_ambience) && !(L in forced_ambiance_list))
		forced_ambiance_list += L
		L.playsound_local(T,sound(pick(forced_ambience), repeat = 1, wait = 0, volume = 25, channel = sound_channels.lobby_channel))
	if(LAZYLEN(ambience) && prob(5) && (world.time >= L.client.played + 3 MINUTES))
		L.playsound_local(T, sound(pick(ambience), repeat = 0, wait = 0, volume = 15, channel = sound_channels.ambience_channel))
		L.client.played = world.time

/area/proc/clear_ambience(var/mob/living/L)
	if(L in forced_ambiance_list)
		sound_to(L, sound(null, channel = sound_channels.lobby_channel))
		forced_ambiance_list -= L

/area/proc/gravitychange(var/gravitystate = 0)
	has_gravity = gravitystate

	for(var/mob/M in src)
		if(has_gravity)
			thunk(M)
		M.update_floating()

/area/proc/thunk(mob/mob)
	if(isspaceturf(get_turf(mob))) // Can't fall onto nothing.
		return

	if(mob.Check_Shoegrip())
		return

	if(istype(mob,/mob/living/carbon/human/))
		var/mob/living/carbon/human/H = mob
		if(prob(H.skill_fail_chance(SKILL_EVA, 100, SKILL_ADEPT)))
			if(!MOVING_DELIBERATELY(H))
				ADJ_STATUS(H, STAT_STUN, 6)
				ADJ_STATUS(H, STAT_WEAK, 6)
			else
				ADJ_STATUS(H, STAT_STUN, 3)
				ADJ_STATUS(H, STAT_WEAK, 3)
			to_chat(mob, "<span class='notice'>The sudden appearance of gravity makes you fall to the floor!</span>")

/area/proc/throw_unbuckled_occupants(var/maxrange, var/speed, var/direction)
	for(var/mob/M in src)
		addtimer(CALLBACK(src, .proc/throw_unbuckled_occupant, M, maxrange, speed, direction), 0)

/area/proc/throw_unbuckled_occupant(var/mob/M, var/maxrange, var/speed, var/direction)
	if(iscarbon(M))
		if(M.buckled)
			to_chat(M, SPAN_WARNING("Sudden acceleration presses you into your chair!"))
			shake_camera(M, 3, 1)
		else
			shake_camera(M, 10, 1)
			M.visible_message(SPAN_WARNING("[M.name] is tossed around by the sudden acceleration!"), SPAN_WARNING("The floor lurches beneath you!"))
			if(!direction)
				M.throw_at_random(FALSE, maxrange, speed)
			else
				var/turf/T = get_ranged_target_turf(M, direction, maxrange)
				M.throw_at(T, maxrange, speed)

/area/proc/prison_break()
	var/obj/machinery/power/apc/theAPC = get_apc()
	if(theAPC && theAPC.operating)
		for(var/obj/machinery/power/apc/temp_apc in src)
			temp_apc.overload_lighting(70)
		for(var/obj/machinery/door/airlock/temp_airlock in src)
			temp_airlock.prison_open()
		for(var/obj/machinery/door/window/temp_windoor in src)
			temp_windoor.open()

/area/has_gravity()
	return has_gravity

/atom/proc/has_gravity()
	var/area/A = get_area(src)
	if(A && A.has_gravity())
		return 1
	return 0

/mob/has_gravity()
	if(!lastarea)
		lastarea = get_area(src)
	if(!lastarea || !lastarea.has_gravity())
		return 0

	return 1

/turf/has_gravity()
	var/area/A = loc
	if(A && A.has_gravity())
		return 1
	return 0

/area/proc/get_dimensions()
	var/list/res = list("x"=1,"y"=1)
	var/list/min = list("x"=world.maxx,"y"=world.maxy)
	for(var/turf/T in src)
		res["x"] = max(T.x, res["x"])
		res["y"] = max(T.y, res["y"])
		min["x"] = min(T.x, min["x"])
		min["y"] = min(T.y, min["y"])
	res["x"] = res["x"] - min["x"] + 1
	res["y"] = res["y"] - min["y"] + 1
	return res

/area/proc/has_turfs()
	return !!(locate(/turf) in src)

/area/SetName(new_name)
	. = ..()
	proper_name = strip_improper(new_name)