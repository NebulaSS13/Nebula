/obj/item/grenade/flashbang
	name = "flashbang"
	desc = "A grenade designed to blind, stun and disorient by means of an extremely bright flash and loud explosion."
	icon = 'icons/obj/items/grenades/flashbang.dmi'
	origin_tech = "{'materials':2,'combat':1}"
	var/banglet = 0

/obj/item/grenade/flashbang/detonate()
	..()
	var/list/victims = list()
	var/list/objs = list()
	var/turf/T = get_turf(src)
	get_mobs_and_objs_in_view_fast(T, 7, victims, objs)
	for(var/mob/living/carbon/M in victims)
		bang(T, M)

	for(var/obj/effect/blob/B in objs) //Blob damage here
		var/damage = round(30/(get_dist(B,T)+1))
		B.take_damage(damage)

	new /obj/effect/sparks(loc)
	new /obj/effect/effect/smoke/illumination(loc, 5, 30, 1, "#ffffff")
	qdel(src)

// Added a new proc called 'bang' that takes a location and a person to be banged.
// Called during the loop that bangs people in lockers/containers and when banging
// people in normal view.  Could theroetically be called during other explosions.
// -- Polymorph
/obj/item/grenade/flashbang/proc/bang(var/turf/T , var/mob/living/carbon/M)
	to_chat(M, SPAN_DANGER("BANG"))
	playsound(src, 'sound/weapons/flashbang.ogg', 100)

	//Checking for protections
	var/eye_safety = 0
	var/ear_safety = 0
	if(iscarbon(M))
		eye_safety = M.eyecheck()
		if(ishuman(M))
			if(M.get_sound_volume_multiplier() < 0.2)
				ear_safety += 2
			if(MUTATION_HULK in M.mutations)
				ear_safety += 1
			var/mob/living/carbon/human/H = M
			if(istype(H.head, /obj/item/clothing/head/helmet))
				ear_safety += 1

	//Flashing everyone
	M.flash_eyes(FLASH_PROTECTION_MODERATE)
	if(eye_safety < FLASH_PROTECTION_MODERATE)
		M.Stun(2)
		M.confused += 5

	//Now applying sound
	if(ear_safety)
		if(ear_safety < 2 && get_dist(M, T) <= 2)
			M.Stun(1)
			M.confused += 3

	else if(get_dist(M, T) <= 2)
		M.Stun(3)
		M.confused += 8
		M.ear_damage += rand(0, 5)
		M.ear_deaf = max(M.ear_deaf,15)

	else if(get_dist(M, T) <= 5)
		M.Stun(2)
		M.confused += 5
		M.ear_damage += rand(0, 3)
		M.ear_deaf = max(M.ear_deaf,10)

	else
		M.Stun(1)
		M.confused += 3
		M.ear_damage += rand(0, 1)
		M.ear_deaf = max(M.ear_deaf,5)

	//This really should be in mob not every check
	switch(M.ear_damage)
		if(1 to 14)
			to_chat(M, "<span class='danger'>Your ears start to ring!</span>")
		if(15 to INFINITY)
			to_chat(M, "<span class='danger'>Your ears start to ring badly!</span>")

	if(!ear_safety)
		sound_to(M, 'sound/weapons/flash_ring.ogg')

/obj/item/grenade/flashbang/Destroy()
	walk(src, 0) // Because we might have called walk_away, we must stop the walk loop or BYOND keeps an internal reference to us forever.
	return ..()

/obj/item/grenade/flashbang/instant
	invisibility = INVISIBILITY_MAXIMUM

/obj/item/grenade/flashbang/instant/Initialize()
	. = ..()
	name = "arcane energy"
	detonate()

/obj/item/grenade/flashbang/clusterbang//Created by Polymorph, fixed by Sieve
	desc = "Use of this weapon may constiute a war crime in your area, consult your local captain."
	name = "clusterbang"
	icon = 'icons/obj/items/grenades/clusterbang.dmi'

/obj/item/grenade/flashbang/clusterbang/detonate()
	var/numspawned = rand(4,8)
	var/again = 0
	for(var/more = numspawned,more > 0,more--)
		if(prob(35))
			again++
			numspawned --
	for(,numspawned > 0, numspawned--)
		new /obj/item/grenade/flashbang/cluster(src.loc)//Launches flashbangs
		playsound(src.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)

	for(,again > 0, again--)
		new /obj/item/grenade/flashbang/clusterbang/segment(src.loc)//Creates a 'segment' that launches a few more flashbangs
		playsound(src.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
	qdel(src)

/obj/item/grenade/flashbang/clusterbang/segment
	desc = "A smaller segment of a clusterbang. Better run."
	name = "clusterbang segment"
	icon = 'icons/obj/items/grenades/clusterbang_segment.dmi'

/obj/item/grenade/flashbang/clusterbang/segment/Initialize()
	. = ..() //Segments should never exist except part of the clusterbang, since these immediately 'do their thing' and asplode
	banglet = 1
	activate()
	var/stepdist = rand(1,4)//How far to step
	var/temploc = src.loc//Saves the current location to know where to step away from
	walk_away(src,temploc,stepdist)//I must go, my people need me
	addtimer(CALLBACK(src, .proc/detonate), rand(15,60))

/obj/item/grenade/flashbang/clusterbang/segment/detonate()
	var/numspawned = rand(4,8)
	for(var/more = numspawned,more > 0,more--)
		if(prob(35))
			numspawned --
	for(,numspawned > 0, numspawned--)
		new /obj/item/grenade/flashbang/cluster(src.loc)
		playsound(src.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
	qdel(src)

/obj/item/grenade/flashbang/cluster/Initialize()
	. = ..() //Same concept as the segments, so that all of the parts don't become reliant on the clusterbang
	banglet = 1
	activate()
	var/stepdist = rand(1,3)
	var/temploc = src.loc
	walk_away(src,temploc,stepdist)
	addtimer(CALLBACK(src, .proc/detonate), rand(15,60))
