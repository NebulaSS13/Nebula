/datum/event/meteor_wave
	startWhen		= 30	// About one minute early warning
	endWhen 		= 60	// Adjusted automatically in tick()
	has_skybox_image = TRUE
	var/alarmWhen   = 30
	var/next_meteor = 40
	var/waves = 1
	var/start_side
	var/next_meteor_lower = 10
	var/next_meteor_upper = 20

/datum/event/meteor_wave/get_skybox_image()
	return overlay_image('icons/skybox/rockbox.dmi', "rockbox", COLOR_ASTEROID_ROCK, RESET_COLOR)

/datum/event/meteor_wave/setup()
	waves = 0
	for(var/n in 1 to severity)
		waves += rand(5,15)

	start_side = pick(global.cardinal)
	endWhen = worst_case_end()

/datum/event/meteor_wave/announce()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce(replacetext(global.using_map.meteor_detected_message, "%STATION_NAME%", location_name()), "[location_name()] Sensor Array", new_sound = global.using_map.meteor_detected_sound, zlevels = affecting_z)
		else
			command_announcement.Announce("The [location_name()] is now in a meteor shower.", "[location_name()] Sensor Array", zlevels = affecting_z)

/datum/event/meteor_wave/tick()
	// Begin sending the alarm signals to shield diffusers so the field is already regenerated (if it exists) by the time actual meteors start flying around.
	if(alarmWhen < activeFor)
		for(var/obj/machinery/shield_diffuser/SD in SSmachines.machinery)
			if(isStationLevel(SD.z))
				SD.meteor_alarm(10)

	if(waves && activeFor >= next_meteor)
		send_wave()

/datum/event/meteor_wave/proc/worst_case_end()
	return activeFor + ((30 / severity) * waves) + 30

/datum/event/meteor_wave/proc/send_wave()
	var/pick_side = prob(80) ? start_side : (prob(50) ? turn(start_side, 90) : turn(start_side, -90))
	spawn() spawn_meteors(get_wave_size(), get_meteors(), pick_side, pick(affecting_z))
	next_meteor += rand(next_meteor_lower, next_meteor_upper) / severity
	waves--
	endWhen = worst_case_end()

/datum/event/meteor_wave/proc/get_wave_size()
	return severity * rand(2,4)

/datum/event/meteor_wave/end()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce("The [location_name()] has cleared the meteor storm.", "[location_name()] Sensor Array", zlevels = affecting_z)
		else
			command_announcement.Announce("The [location_name()] has cleared the meteor shower.", "[location_name()] Sensor Array", zlevels = affecting_z)

/datum/event/meteor_wave/proc/get_meteors()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			return meteors_major
		if(EVENT_LEVEL_MODERATE)
			return meteors_moderate
		else
			return meteors_minor

var/global/list/meteors_minor = list(
	/obj/effect/meteor/medium     = 80,
	/obj/effect/meteor/dust       = 30,
	/obj/effect/meteor/irradiated = 30,
	/obj/effect/meteor/big        = 30,
	/obj/effect/meteor/flaming    = 10,
	/obj/effect/meteor/golden     = 10,
	/obj/effect/meteor/silver     = 10,
)

var/global/list/meteors_moderate = list(
	/obj/effect/meteor/medium     = 80,
	/obj/effect/meteor/big        = 30,
	/obj/effect/meteor/dust       = 30,
	/obj/effect/meteor/irradiated = 30,
	/obj/effect/meteor/flaming    = 10,
	/obj/effect/meteor/golden     = 10,
	/obj/effect/meteor/silver     = 10,
	/obj/effect/meteor/emp        = 10,
)

var/global/list/meteors_major = list(
	/obj/effect/meteor/medium     = 80,
	/obj/effect/meteor/big        = 30,
	/obj/effect/meteor/dust       = 30,
	/obj/effect/meteor/irradiated = 30,
	/obj/effect/meteor/emp        = 30,
	/obj/effect/meteor/flaming    = 10,
	/obj/effect/meteor/golden     = 10,
	/obj/effect/meteor/silver     = 10,
	/obj/effect/meteor/tunguska   = 1,
)

/datum/event/meteor_wave/overmap
	next_meteor_lower = 5
	next_meteor_upper = 10
	next_meteor = 0
	var/obj/effect/overmap/visitable/ship/victim

/datum/event/meteor_wave/overmap/Destroy()
	victim = null
	. = ..()

/datum/event/meteor_wave/overmap/tick()
	if(!victim)
		return
	if (victim.is_still() || victim.get_helm_skill() >= SKILL_ADEPT) //Unless you're standing or good at your job..
		start_side = pick(global.cardinal)
	else //..Meteors mostly fly in your face
		start_side = prob(90) ? victim.fore_dir : pick(global.cardinal)
	..()

/datum/event/meteor_wave/overmap/get_wave_size()
	. = ..()
	if (!victim)
		return
	var/skill = victim.get_helm_skill()
	var/speed = victim.get_speed()
	if (skill < SKILL_EXPERT)
		if(victim.is_still() || speed < SHIP_SPEED_SLOW) //Standing still or being slow means less shit flies your way
			. = round(. * 0.7)
		if(speed > SHIP_SPEED_FAST) //Sanic stahp
			. *= 2
	else if (skill == SKILL_EXPERT)
		if (victim.is_still())
			. = round(. * 0.2)
		if (speed < SHIP_SPEED_SLOW)
			. = round(. * 0.5)
		else if (speed > SHIP_SPEED_SLOW && speed < SHIP_SPEED_FAST)
			. = round(. * 0.7)
		if (speed > SHIP_SPEED_FAST)
			. = round(. * 1.2)
	else if (skill > SKILL_EXPERT)
		if (victim.is_still())
			. = round(. * 0.1)
		if (speed < SHIP_SPEED_SLOW)
			. = round(. * 0.2)
		else if (speed > SHIP_SPEED_SLOW && speed < SHIP_SPEED_FAST)
			. = round(. * 0.5)

	//Smol ship evasion
	if(victim.vessel_size < SHIP_SIZE_LARGE && speed < SHIP_SPEED_FAST)
		var/skill_needed = SKILL_PROF
		if(speed < SHIP_SPEED_SLOW)
			skill_needed = SKILL_ADEPT
		if(victim.vessel_size < SHIP_SIZE_SMALL)
			skill_needed = skill_needed - 1
		if(skill >= max(skill_needed, victim.skill_needed))
			return 0

///////////////////////////////
//Meteor spawning global procs
///////////////////////////////

/proc/spawn_meteors(var/number = 10, var/list/meteortypes, var/startSide, var/zlevel)
	for(var/i = 0; i < number; i++)
		spawn_meteor(meteortypes, startSide, zlevel)

/proc/spawn_meteor(var/list/meteortypes, var/startSide, var/zlevel)
	var/turf/pickedstart = spaceDebrisStartLoc(startSide, zlevel)
	var/turf/pickedgoal = spaceDebrisFinishLoc(startSide, zlevel)

	var/Me = pickweight(meteortypes)
	var/obj/effect/meteor/M = new Me(pickedstart)
	M.dest = pickedgoal
	spawn(0)
		walk_towards(M, M.dest, 3)
	return

/proc/spaceDebrisStartLoc(startSide, Z)
	var/starty
	var/startx
	switch(startSide)
		if(NORTH)
			starty = world.maxy-(TRANSITIONEDGE+1)
			startx = rand((TRANSITIONEDGE+1), world.maxx-(TRANSITIONEDGE+1))
		if(EAST)
			starty = rand((TRANSITIONEDGE+1),world.maxy-(TRANSITIONEDGE+1))
			startx = world.maxx-(TRANSITIONEDGE+1)
		if(SOUTH)
			starty = (TRANSITIONEDGE+1)
			startx = rand((TRANSITIONEDGE+1), world.maxx-(TRANSITIONEDGE+1))
		if(WEST)
			starty = rand((TRANSITIONEDGE+1), world.maxy-(TRANSITIONEDGE+1))
			startx = (TRANSITIONEDGE+1)
	var/turf/T = locate(startx, starty, Z)
	return T

/proc/spaceDebrisFinishLoc(startSide, Z)
	var/endy
	var/endx
	switch(startSide)
		if(NORTH)
			endy = TRANSITIONEDGE
			endx = rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE)
		if(EAST)
			endy = rand(TRANSITIONEDGE, world.maxy-TRANSITIONEDGE)
			endx = TRANSITIONEDGE
		if(SOUTH)
			endy = world.maxy-TRANSITIONEDGE
			endx = rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE)
		if(WEST)
			endy = rand(TRANSITIONEDGE,world.maxy-TRANSITIONEDGE)
			endx = world.maxx-TRANSITIONEDGE
	var/turf/T = locate(endx, endy, Z)
	return T

///////////////////////
//The meteor effect
//////////////////////

/obj/effect/meteor
	name = "meteor"
	desc = "You should probably run instead of gawking at this."
	icon = 'icons/obj/meteor.dmi'
	icon_state = "small"
	density = TRUE
	anchored = TRUE
	var/hits = 4
	var/hitpwr = 2 //Level of ex_act to be called on hit.
	var/dest
	pass_flags = PASS_FLAG_TABLE
	var/heavy = 0
	var/z_original
	var/meteordrop = /obj/item/stack/material/ore/iron
	var/dropamt = 1
	var/ismissile //missiles don't spin

	var/move_count = 0

/obj/effect/meteor/proc/get_shield_damage()
	return max(((max(hits, 2)) * (heavy + 1) * rand(30, 60)) / hitpwr , 0)

/obj/effect/meteor/Initialize()
	. = ..()
	z_original = z

/obj/effect/meteor/Initialize()
	. = ..()
	global.meteor_list += src

/obj/effect/meteor/Move()
	. = ..() //process movement...
	move_count++
	if(loc == dest)
		qdel(src)

/obj/effect/meteor/touch_map_edge(var/overmap_id = OVERMAP_ID_SPACE)
	if(move_count > TRANSITIONEDGE)
		qdel(src)

/obj/effect/meteor/Destroy()
	walk(src,0) //this cancels the walk_towards() proc
	global.meteor_list -= src
	. = ..()

/obj/effect/meteor/Initialize()
	. = ..()
	if(!ismissile)
		SpinAnimation()

/obj/effect/meteor/Bump(atom/A)
	..()
	if(A && !QDELETED(src))	// Prevents explosions and other effects when we were deleted by whatever we Bumped() - currently used by shields.
		ram_turf(get_turf(A))
		get_hit() //should only get hit once per move attempt

/obj/effect/meteor/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return istype(mover, /obj/effect/meteor) ? 1 : ..()

/obj/effect/meteor/proc/ram_turf(var/turf/T)
	//first bust whatever is in the turf
	for(var/atom/A in T)
		if(A != src && !A.CanPass(src, src.loc, 0.5, 0)) //only ram stuff that would actually block us
			A.explosion_act(hitpwr)

	//then, ram the turf if it still exists
	if(T && !T.CanPass(src, src.loc, 0.5, 0))
		T.explosion_act(hitpwr)

//process getting 'hit' by colliding with a dense object
//or randomly when ramming turfs
/obj/effect/meteor/proc/get_hit()
	hits--
	if(hits <= 0)
		make_debris()
		meteor_effect()
		qdel(src)

/obj/effect/meteor/explosion_act()
	SHOULD_CALL_PARENT(FALSE)
	return

/obj/effect/meteor/attackby(obj/item/W, mob/user, params)
	if(IS_PICK(W))
		qdel(src)
		return
	..()

/obj/effect/meteor/proc/make_debris()
	if(meteordrop && dropamt)
		for(var/throws = dropamt, throws > 0, throws--)
			addtimer(CALLBACK(new meteordrop(get_turf(src)), TYPE_PROC_REF(/atom/movable, throw_at), dest, 5, 10), 0)

/obj/effect/meteor/proc/meteor_effect()
	if(heavy)
		for(var/mob/M in global.player_list)
			var/turf/T = get_turf(M)
			if(!T || T.z != src.z)
				continue
			var/dist = get_dist(M.loc, src.loc)
			shake_camera(M, (dist > 20 ? 0.5 SECONDS : 1 SECOND), (dist > 20 ? 1 : 3))


///////////////////////
//Meteor types
///////////////////////

//Dust
/obj/effect/meteor/dust
	name = "space dust"
	icon_state = "dust"
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GRILLE
	hits = 1
	hitpwr = 3
	dropamt = 1
	meteordrop = /obj/item/stack/material/ore/handful/sand

//Medium-sized
/obj/effect/meteor/medium
	name = "meteor"
	dropamt = 2

/obj/effect/meteor/medium/meteor_effect()
	..()
	explosion(src.loc, 0, 1, 2, 3, 0)

//Large-sized
/obj/effect/meteor/big
	name = "large meteor"
	icon_state = "large"
	hits = 6
	heavy = 1
	dropamt = 3

/obj/effect/meteor/big/meteor_effect()
	..()
	explosion(src.loc, 1, 2, 3, 4, 0)

//Flaming meteor
/obj/effect/meteor/flaming
	name = "flaming meteor"
	icon_state = "flaming"
	hits = 5
	heavy = 1
	meteordrop = /obj/item/stack/material/ore/phosphorite

/obj/effect/meteor/flaming/meteor_effect()
	..()
	explosion(src.loc, 1, 2, 3, 4, 0, 0, 5)

//Radiation meteor
/obj/effect/meteor/irradiated
	name = "glowing meteor"
	icon_state = "glowing"
	heavy = 1
	meteordrop = /obj/item/stack/material/ore/uranium

/obj/effect/meteor/irradiated/meteor_effect()
	..()
	explosion(src.loc, 0, 0, 4, 3, 0)
	SSradiation.radiate(src, 50)

/obj/effect/meteor/golden
	name = "golden meteor"
	icon_state = "glowing"
	desc = "Shiny! But also deadly."
	meteordrop = /obj/item/stack/material/ore/gold

/obj/effect/meteor/silver
	name = "silver meteor"
	icon_state = "glowing_blue"
	desc = "Shiny! But also deadly."
	meteordrop = /obj/item/stack/material/ore/silver

/obj/effect/meteor/emp
	name = "conducting meteor"
	icon_state = "glowing_blue"
	desc = "Hide your floppies!"
	meteordrop = /obj/item/stack/material/ore/osmium
	dropamt = 2

/obj/effect/meteor/emp/meteor_effect()
	..()
	// Best case scenario: Comparable to a low-yield EMP grenade.
	// Worst case scenario: Comparable to a standard yield EMP grenade.
	empulse(src, rand(2, 4), rand(4, 10))

/obj/effect/meteor/emp/get_shield_damage()
	return ..() * rand(2,4)

//Station buster Tunguska
/obj/effect/meteor/tunguska
	name = "tunguska meteor"
	icon_state = "flaming"
	desc = "Your life briefly passes before your eyes the moment you lay them on this monstrosity."
	hits = 10
	hitpwr = 1
	heavy = 1
	meteordrop = /obj/item/stack/material/ore/diamond	// Probably means why it penetrates the hull so easily before exploding.

/obj/effect/meteor/tunguska/meteor_effect()
	..()
	explosion(src.loc, 3, 6, 9, 20, 0)

// This is the final solution against shields - a single impact can bring down most shield generators.
/obj/effect/meteor/supermatter
	name = "supermatter shard"
	desc = "Oh god, what will be next..?"
	icon = 'icons/obj/supermatter_32.dmi'
	icon_state = "supermatter"

/obj/effect/meteor/supermatter/meteor_effect()
	..()
	explosion(src.loc, 1, 2, 3, 4, 0)
	for(var/obj/machinery/power/apc/A in range(rand(12, 20), src))
		A.energy_fail(round(10 * rand(8, 12)))

/obj/effect/meteor/supermatter/get_shield_damage()
	return ..() * rand(80, 120)

//Missiles, for events and so on
/obj/effect/meteor/supermatter/missile
	name = "photon torpedo"
	desc = "An advanded warhead designed to tactically destroy space installations."
	icon = 'icons/obj/missile.dmi'
	icon_state = "photon"
	meteordrop = null
	ismissile = TRUE
	dropamt = 0

/obj/effect/meteor/medium/missile
	name = "missile"
	desc = "Some kind of missile."
	icon = 'icons/obj/items/grenades/missile.dmi'
	icon_state = ICON_STATE_WORLD
	meteordrop = null
	ismissile = TRUE
	dropamt = 0

/obj/effect/meteor/big/missile
	name = "high-yield missile"
	desc = "Some kind of missile."
	icon = 'icons/obj/items/grenades/missile.dmi'
	icon_state = ICON_STATE_WORLD
	meteordrop = null
	ismissile = TRUE
	dropamt = 0

/obj/effect/meteor/flaming/missile
	name = "incendiary missile"
	desc = "Some kind of missile."
	icon = 'icons/obj/items/grenades/missile.dmi'
	icon_state = ICON_STATE_WORLD
	meteordrop = null
	ismissile = TRUE
	dropamt = 0

/obj/effect/meteor/emp/missile
	name = "ion torpedo"
	desc = "Some kind of missile."
	icon = 'icons/obj/missile.dmi'
	icon_state = "torpedo"
	meteordrop = null
	ismissile = TRUE
	dropamt = 0