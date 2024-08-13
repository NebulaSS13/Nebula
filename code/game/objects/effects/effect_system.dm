/* This is an attempt to make some easily reusable "particle" type effect, to stop the code
constantly having to be rewritten. An item like the jetpack that uses the ion_trail_follow system, just has one
defined, then set up when it is created with New(). Then this same system can just be reused each time
it needs to create more trails.A beaker could have a steam_trail_follow system set up, then the steam
would spawn and follow the beaker, even if it is carried or thrown.
*/


/obj/effect/effect
	name = "effect"
	icon = 'icons/effects/effects.dmi'
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GRILLE

/datum/effect/effect/system
	var/number = 3
	var/cardinals = 0
	var/turf/location
	var/atom/holder
	var/setup = 0

/datum/effect/effect/system/proc/set_up(n = 3, c = 0, turf/loc)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	location = loc
	setup = 1

/datum/effect/effect/system/proc/attach(atom/atom)
	holder = atom

/datum/effect/effect/system/proc/start()

/datum/effect/effect/system/proc/spread()


/////////////////////////////////////////////
// GENERIC STEAM SPREAD SYSTEM

//Usage: set_up(number of bits of steam, use North/South/East/West only, spawn location)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like a smoking beaker, so then you can just call start() and the steam
// will always spawn at the items location, even if it's moved.

/* Example:
var/global/datum/effect/system/steam_spread/steam = new /datum/effect/system/steam_spread() -- creates new system
steam.set_up(5, 0, mob.loc) -- sets up variables
OPTIONAL: steam.attach(mob)
steam.start() -- spawns the effect
*/
/////////////////////////////////////////////
/obj/effect/effect/steam
	name = "steam"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	density = FALSE

/datum/effect/effect/system/steam_spread

/datum/effect/effect/system/steam_spread/set_up(n = 3, c = 0, turf/loc)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	location = loc

/datum/effect/effect/system/steam_spread/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/effect/effect/system, spread), i), 0)

/datum/effect/effect/system/steam_spread/spread(var/i)
	set waitfor = 0
	if(holder)
		src.location = get_turf(holder)
	var/obj/effect/effect/steam/steam = new /obj/effect/effect/steam(location)
	var/direction
	if(src.cardinals)
		direction = pick(global.cardinal)
	else
		direction = pick(global.alldirs)
	for(i=0, i<pick(1,2,3), i++)
		sleep(5)
		step(steam,direction)
	QDEL_IN(steam, 2 SECONDS)

/////////////////////////////////////////////
//SPARK SYSTEM (like steam system)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like the RCD, so then you can just call start() and the sparks
// will always spawn at the items location.
/////////////////////////////////////////////

/obj/effect/sparks
	name = "sparks"
	icon_state = "sparks"
	icon = 'icons/effects/effects.dmi'
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	pass_flags = PASS_FLAG_TABLE
	var/spark_sound = "sparks"
	var/lit_light_range = 1
	var/lit_light_power = 0.5
	var/lit_light_color = COLOR_MUZZLE_FLASH

/obj/effect/sparks/struck
	spark_sound = "light_bic"

/obj/effect/sparks/Initialize()
	. = ..()
	// this is 2 seconds so that it doesn't appear to freeze after its last move, which ends up making it look like timers are broken
	// if you change the number of or delay between moves in spread(), this may need to be changed
	QDEL_IN(src, 2 SECONDS)
	playsound(loc, spark_sound, 100, 1)
	set_light(lit_light_range, lit_light_power, lit_light_color)
	if(isturf(loc))
		var/turf/T = loc
		T.spark_act()

/obj/effect/sparks/Destroy()
	if(isturf(loc))
		var/turf/T = loc
		T.spark_act()
	return ..()

/obj/effect/sparks/Move()
	. = ..()
	if(. && isturf(loc))
		var/turf/T = loc
		T.spark_act()

/proc/spark_at(turf/location, amount = 3, cardinal_only = FALSE, holder = null, spark_type = /datum/effect/effect/system/spark_spread)
	var/datum/effect/effect/system/spark_spread/sparks = new spark_type
	sparks.set_up(amount, cardinal_only, location)
	if(holder)
		sparks.attach(holder)
	sparks.start()

/datum/effect/effect/system/spark_spread
	var/spark_type = /obj/effect/sparks

/datum/effect/effect/system/spark_spread/non_electrical
	spark_type = /obj/effect/sparks/struck

/datum/effect/effect/system/spark_spread/set_up(n = 3, c = 0, loca)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)

/datum/effect/effect/system/spark_spread/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/effect/effect/system, spread), i), 0)

/datum/effect/effect/system/spark_spread/spread(var/i)
	set waitfor = 0
	if(holder)
		src.location = get_turf(holder)
	var/obj/effect/sparks/sparks = new spark_type(location)
	var/direction
	if(src.cardinals)
		direction = pick(global.cardinal)
	else
		direction = pick(global.alldirs)
	for(i=0, i<pick(1,2,3), i++)
		sleep(5)
		step(sparks,direction)

/////////////////////////////////////////////
//// SMOKE SYSTEMS
// direct can be optinally added when set_up, to make the smoke always travel in one direction
// in case you wanted a vent to always smoke north for example
/////////////////////////////////////////////


/obj/effect/effect/smoke
	name = "smoke"
	icon_state = "smoke"
	opacity = TRUE
	anchored = FALSE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	var/time_to_live = 100

	//Remove this bit to use the old smoke
	icon = 'icons/effects/96x96.dmi'
	pixel_x = -32
	pixel_y = -32

/obj/effect/effect/smoke/Initialize(mapload, smoke_duration)
	. = ..()
	if(smoke_duration)
		time_to_live = smoke_duration
	addtimer(CALLBACK(src, PROC_REF(end_of_life)), time_to_live)

/obj/effect/effect/smoke/proc/end_of_life()
	if(!QDELETED(src))
		qdel(src)

/obj/effect/effect/smoke/Crossed(atom/movable/AM)
	..()
	if(isliving(AM))
		affect_mob(AM)

/obj/effect/effect/smoke/proc/affect_mob(var/mob/living/M)
	if(!istype(M))
		return 0
	if(M.get_internals() != null && M.check_for_airtight_internals(FALSE))
		return FALSE
	return TRUE

/////////////////////////////////////////////
// Illumination
/////////////////////////////////////////////

/obj/effect/effect/smoke/illumination
	name = "illumination"
	opacity = FALSE
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"

/obj/effect/effect/smoke/illumination/Initialize(mapload, var/lifetime=10, var/range=null, var/power=null, var/color=null)
	set_light(range, power, color)
	time_to_live=lifetime
	. = ..()

/////////////////////////////////////////////
// Bad smoke
/////////////////////////////////////////////

/obj/effect/effect/smoke/bad
	time_to_live = 200

/obj/effect/effect/smoke/bad/Move()
	..()
	for(var/mob/living/M in get_turf(src))
		affect_mob(M)

/obj/effect/effect/smoke/bad/affect_mob(var/mob/living/M)
	if (!..())
		return 0
	M.drop_held_items()
	M.take_damage(1, OXY)
	M.cough()

/obj/effect/effect/smoke/bad/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover, /obj/item/projectile/beam))
		var/obj/item/projectile/beam/B = mover
		B.damage = (B.damage/2)
	return 1
/////////////////////////////////////////////
// Sleep smoke
/////////////////////////////////////////////

/obj/effect/effect/smoke/sleepy

/obj/effect/effect/smoke/sleepy/Move()
	..()
	for(var/mob/living/M in get_turf(src))
		affect_mob(M)

/obj/effect/effect/smoke/sleepy/affect_mob(var/mob/living/M)
	if (!..())
		return 0

	M.drop_held_items()
	ADJ_STATUS(M, STAT_ASLEEP, 1)
	M.cough()

/////////////////////////////////////////////
// Mustard Gas
/////////////////////////////////////////////


/obj/effect/effect/smoke/mustard
	name = "mustard gas"
	icon_state = "mustard"

/obj/effect/effect/smoke/mustard/Move()
	..()
	for(var/mob/living/M in get_turf(src))
		affect_mob(M)

/obj/effect/effect/smoke/mustard/affect_mob(var/mob/living/M)
	if (!..() || !isliving(M))
		return 0
	if (M.get_equipped_item(slot_wear_suit_str))
		return 0

	M.take_overall_damage(0, 0.75)
	if (world.time > M.last_cough + 2 SECONDS)
		M.last_cough = world.time
		M.emote(/decl/emote/audible/gasp)

/////////////////////////////////////////////
// Smoke spread
/////////////////////////////////////////////

/datum/effect/effect/system/smoke_spread
	var/total_smoke = 0 // To stop it being spammed and lagging!
	var/direction
	var/smoke_type = /obj/effect/effect/smoke

/datum/effect/effect/system/smoke_spread/set_up(n = 5, c = 0, loca, direct)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)
	if(direct)
		direction = direct

/datum/effect/effect/system/smoke_spread/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		if(src.total_smoke > 20)
			return
		addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/effect/effect/system, spread), i), 0)

/datum/effect/effect/system/smoke_spread/spread(var/i)
	if(holder)
		if(QDELING(holder))
			holder = null
		else
			src.location = get_turf(holder)
	var/obj/effect/effect/smoke/smoke = new smoke_type(location, rand(8.5 SECONDS, 10.5 SECONDS))
	src.total_smoke++
	var/direction = src.direction
	if(!direction)
		direction = pick(src.cardinals ? global.cardinal : global.alldirs)
	for(i=0, i<pick(0,1,1,1,2,2,2,3), i++)
		sleep(1 SECOND)
		if(QDELETED(smoke))
			total_smoke--
			return
		step(smoke,direction)
	total_smoke--

/datum/effect/effect/system/smoke_spread/bad
	smoke_type = /obj/effect/effect/smoke/bad

/datum/effect/effect/system/smoke_spread/sleepy
	smoke_type = /obj/effect/effect/smoke/sleepy


/datum/effect/effect/system/smoke_spread/mustard
	smoke_type = /obj/effect/effect/smoke/mustard


/////////////////////////////////////////////
//////// Attach an Ion trail to any object, that spawns when it moves (like for the jetpack)
/// just pass in the object to attach it to in set_up
/// Then do start() to start it and stop() to stop it, obviously
/// and don't call start() in a loop that will be repeated otherwise it'll get spammed!
/////////////////////////////////////////////
/datum/effect/effect/system/trail
	var/turf/oldposition
	var/processing = 1
	var/on = 1
	var/max_number = 0
	number = 0
	var/list/specific_turfs = list()
	var/trail_type
	var/duration_of_effect = 10

/datum/effect/effect/system/trail/set_up(var/atom/atom)
	attach(atom)
	oldposition = get_turf(atom)


/datum/effect/effect/system/trail/start()
	if(!src.on)
		src.on = 1
		src.processing = 1
	if(src.processing)
		src.processing = 0
		spawn(0)
			var/turf/T = get_turf(src.holder)
			if(T != src.oldposition)
				if(is_type_in_list(T, specific_turfs) && (!max_number || number < max_number))
					var/obj/effect/effect/trail = new trail_type(oldposition)
					src.oldposition = T
					effect(trail)
					number++
					spawn( duration_of_effect )
						number--
						qdel(trail)
				spawn(2)
					if(src.on)
						src.processing = 1
						src.start()
			else
				spawn(2)
					if(src.on)
						src.processing = 1
						src.start()

/datum/effect/effect/system/trail/proc/stop()
	src.processing = 0
	src.on = 0

/datum/effect/effect/system/trail/Destroy()
	stop()
	return ..()

/datum/effect/effect/system/trail/proc/effect(var/obj/effect/effect/T)
	T.set_dir(src.holder.dir)
	return

/obj/effect/effect/ion_trails
	name = "ion trails"
	icon_state = "ion_trails"
	anchored = TRUE

/datum/effect/effect/system/trail/ion
	trail_type = /obj/effect/effect/ion_trails
	specific_turfs = list(/turf/space)
	duration_of_effect = 20

/datum/effect/effect/system/trail/ion/effect(var/obj/effect/effect/T)
	..()
	flick("ion_fade", T)
	T.icon_state = "blank"

/obj/effect/effect/thermal_trail
	name = "therman trail"
	icon_state = "explosion_particle"
	anchored = TRUE

/datum/effect/effect/system/trail/thermal
	trail_type = /obj/effect/effect/thermal_trail
	specific_turfs = list(/turf/space)

/////////////////////////////////////////////
//////// Attach a steam trail to an object (eg. a reacting beaker) that will follow it
// even if it's carried of thrown.
/////////////////////////////////////////////

/datum/effect/effect/system/trail/steam
	max_number = 3
	trail_type = /obj/effect/effect/steam

/datum/effect/effect/system/reagents_explosion
	var/amount 						// TNT equivalent
	var/flashing = 0			// does explosion creates flash effect?
	var/flashing_factor = 0		// factor of how powerful the flash effect relatively to the explosion

/datum/effect/effect/system/reagents_explosion/set_up(amt, loc, flash = 0, flash_fact = 0)
	amount = amt
	if(istype(loc, /turf/))
		location = loc
	else
		location = get_turf(loc)

	flashing = flash
	flashing_factor = flash_fact

	return

/datum/effect/effect/system/reagents_explosion/start()
	if (amount <= 2)
		spark_at(location, amount = 2, cardinal_only = TRUE)
		location.visible_message(SPAN_DANGER("The solution violently explodes!"))
		for(var/mob/living/M in viewers(1, location))
			if(prob (50 * amount))
				to_chat(M, SPAN_DANGER("The explosion knocks you down!"))
				SET_STATUS_MAX(M, STAT_WEAK, rand(1,5))
		return
	else
		var/devst = -1
		var/heavy = -1
		var/light = -1
		var/flash = -1

		// Clamp all values to fractions of global.max_explosion_range, following the same pattern as for tank transfer bombs
		if (round(amount/12) > 0)
			devst = devst + amount/12

		if (round(amount/6) > 0)
			heavy = heavy + amount/6

		if (round(amount/3) > 0)
			light = light + amount/3

		if (flashing && flashing_factor)
			flash = (amount/4) * flashing_factor

		location.visible_message(SPAN_DANGER("The solution violently explodes!"))

		explosion(
			location,
			round(min(devst, BOMBCAP_DVSTN_RADIUS)),
			round(min(heavy, BOMBCAP_HEAVY_RADIUS)),
			round(min(light, BOMBCAP_LIGHT_RADIUS)),
			round(min(flash, BOMBCAP_FLASH_RADIUS))
			)
