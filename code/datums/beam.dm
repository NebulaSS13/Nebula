var/global/list/beam_icon_cache = list() // shut up chinsky I do not have a cache fetish

//Beam Datum and effect
/datum/beam
	var/atom/origin = null
	var/atom/target = null
	var/list/elements = list()
	var/icon/base_icon = null
	var/icon
	var/icon_state = "" //icon state of the main segments of the beam
	var/beam_color = null // Color of the beam segments
	var/max_distance = 0
	var/endtime = 0
	var/sleep_time = 3
	var/finished = 0
	var/target_oldloc = null
	var/origin_oldloc = null
	var/static_beam = 0
	var/beam_type = /obj/effect/ebeam //must be subtype

/datum/beam/New(beam_origin,beam_target,beam_icon='icons/effects/beam.dmi',beam_icon_state="b_beam",time=50,maxdistance=10,btype = /obj/effect/ebeam,beam_sleep_time=3,new_beam_color = null)
	endtime = world.time+time
	origin = beam_origin
	origin_oldloc =	get_turf(origin)
	target = beam_target
	target_oldloc = get_turf(target)
	sleep_time = beam_sleep_time
	if(origin_oldloc == origin && target_oldloc == target)
		static_beam = 1
	max_distance = maxdistance
	base_icon = new(beam_icon,beam_icon_state)
	icon = beam_icon
	icon_state = beam_icon_state
	if(new_beam_color)
		beam_color = new_beam_color
	beam_type = btype

/datum/beam/proc/Start()
	set waitfor = FALSE
	Draw()
	while(!finished && origin && target && world.time < endtime && get_dist(origin,target)<max_distance && origin.z == target.z)
		var/origin_turf = get_turf(origin)
		var/target_turf = get_turf(target)
		if(!static_beam && (origin_turf != origin_oldloc || target_turf != target_oldloc))
			origin_oldloc = origin_turf //so we don't keep checking against their initial positions, leading to endless Reset()+Draw() calls
			target_oldloc = target_turf
			Reset()
			Draw()
		sleep(sleep_time)
	qdel(src)

/datum/beam/proc/Reset()
	for(var/elem in elements)
		qdel(elem)
	elements.Cut()

/datum/beam/Destroy()
	Reset()
	finished = TRUE
	target = null
	origin = null
	return ..()

/datum/beam/proc/Draw()
	if(QDELETED(target) || QDELETED(origin))
		qdel(src)
		return

	var/Angle = round(Get_Angle(origin,target))

	var/matrix/rot_matrix = matrix()
	rot_matrix.Turn(Angle)

	var/turf/T_target = get_turf(target)	//Turfs are referenced instead of the objects directly so that beams will link between 2 objects inside other objects.
	var/turf/T_origin = get_turf(origin)

	//Translation vector for origin and target
	var/DX = (32*T_target.x+target.pixel_x)-(32*T_origin.x+origin.pixel_x)
	var/DY = (32*T_target.y+target.pixel_y)-(32*T_origin.y+origin.pixel_y)
	var/N = 0
	var/length = round(sqrt((DX)**2+(DY)**2)) //hypotenuse of the triangle formed by target and origin's displacement

	for(N in 0 to length-1 step 32)//-1 as we want < not <=, but we want the speed of X in Y to Z and step X
		if(QDELETED(src) || finished)
			break
		var/obj/effect/ebeam/X = new beam_type(origin_oldloc)

		if(beam_color)
			X.color = beam_color

		elements += X

		//Assign icon, for main segments it's base_icon, for the end, it's icon+icon_state
		//cropped by a transparent box of length-N pixel size
		var/beam_cache_key = "[N]-[length]-[base_icon]-[icon]-[icon_state]"
		var/icon/II = global.beam_icon_cache[beam_cache_key]
		if(!II)
			if(N+32>length)
				II = new(icon, icon_state)
				II.DrawBox(null,1,(length-N),32,32)
			else
				II = base_icon
			global.beam_icon_cache[beam_cache_key] = II

		X.icon = II
		X.transform = rot_matrix

		//Calculate pixel offsets (If necessary)
		var/Pixel_x
		var/Pixel_y
		if(DX == 0)
			Pixel_x = 0
		else
			Pixel_x = round(sin(Angle) * (N + 17))
		if(DY == 0)
			Pixel_y = 0
		else
			Pixel_y = round(cos(Angle) * (N + 17))

		//Position the effect so the beam is one continous line
		var/a
		if(abs(Pixel_x)>32)
			a = Pixel_x > 0 ? round(Pixel_x/32) : ceil(Pixel_x/32)
			X.x += a
			Pixel_x %= 32
		if(abs(Pixel_y)>32)
			a = Pixel_y > 0 ? round(Pixel_y/32) : ceil(Pixel_y/32)
			X.y += a
			Pixel_y %= 32

		X.pixel_x = Pixel_x
		X.pixel_y = Pixel_y

/obj/effect/ebeam
	simulated = FALSE
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE

/atom/proc/Beam(atom/BeamTarget, icon_state="b_beam", icon='icons/effects/beam.dmi', time = 5 SECONDS, maxdistance = 10, beam_type = /obj/effect/ebeam, beam_sleep_time = 3, beam_color = null)
	var/datum/beam/newbeam = new(src,BeamTarget,icon,icon_state,time,maxdistance,beam_type,beam_sleep_time,beam_color)
	newbeam.Start()
	return newbeam
