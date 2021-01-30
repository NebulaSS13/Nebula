/turf/exterior/wall
	var/excavation_level = 0
	var/datum/artifact_find/artifact_find
	var/list/finds
	var/last_excavation
	var/next_rock = 0
	var/archaeo_overlay
	var/excav_overlay

/turf/exterior/wall/proc/place_artifact_debris(var/severity = 0)
	for(var/j in 1 to rand(1, 3 + max(min(severity, 1), 0) * 2))
		switch(rand(1,7))
			if(1)
				new /obj/item/stack/material/rods(src, rand(5, 25))
			if(2)
				new /obj/item/stack/material/plasteel(src, rand(5,25))
			if(3)
				new /obj/item/stack/material/steel(src, rand(5,25))
			if(4)
				new /obj/item/stack/material/plasteel(src, rand(5,25))
			if(5)
				for(var/i = 1 to rand(1,3))
					new /obj/item/shard(src)
			if(6)
				for(var/i = 1 to rand(1,3))
					new /obj/item/shard/borosilicate(src)
			if(7)
				new /obj/item/stack/material/uranium(src, rand(5,25))

/turf/exterior/wall/proc/excavate_find(var/prob_clean = 0, var/datum/find/F)
	//many finds are ancient and thus very delicate - luckily there is a specialised energy suspension field which protects them when they're being extracted
	if(prob(F.prob_delicate))
		var/obj/effect/suspension_field/S = locate() in src
		if(!S)
			visible_message(SPAN_DANGER("[pick("An object in the rock crumbles away into dust.","Something falls out of the rock and shatters onto the ground.")]"))
			finds.Remove(F)
			return
	//with skill and luck, players can cleanly extract finds
	//otherwise, they come out inside a chunk of rock
	if(prob_clean)
		F.spawn_find_item(src)
	else
		pass_geodata_to(new /obj/item/ore/strangerock(src, F.find_type))
	finds.Remove(F)

/turf/exterior/wall/proc/handle_xenoarch_tool_interaction(var/obj/item/pickaxe/xeno/P, var/mob/user)
	. = TRUE
	if(last_excavation + P.digspeed > world.time)//prevents message spam
		return
	last_excavation = world.time
	playsound(user, P.drill_sound, 20, 1)
	var/newDepth = excavation_level + P.excavation_amount // Used commonly below
	//handle any archaeological finds we might uncover
	to_chat(user, SPAN_NOTICE("You start [P.drill_verb][destroy_artifacts(P, newDepth)]."))
	if(!do_after(user,P.digspeed, src))
		return
	
	if(length(finds))
		var/datum/find/F = finds[1]
		if(newDepth == F.excavation_required) // When the pick hits that edge just right, you extract your find perfectly, it's never confined in a rock
			excavate_find(1, F)
		else if(newDepth > F.excavation_required - F.clearance_range) // Not quite right but you still extract your find, the closer to the bottom the better, but not above 80%
			excavate_find(prob(80 * (F.excavation_required - newDepth) / F.clearance_range), F)

	to_chat(user, SPAN_NOTICE("You finish [P.drill_verb] \the [src]."))

	if(newDepth >= 200) // This means the rock is mined out fully
		if(artifact_find)
			if( excavation_level > 0 || prob(15) )
				var/obj/structure/boulder/B = new(src, material?.type, paint_color)
				B.artifact_find = artifact_find
			else
				place_artifact_debris(1)
			artifact_find = null
			SSxenoarch.artifact_spawning_turfs -= src
		else if(prob(5))
			new /obj/structure/boulder(src, material?.type)
		dismantle_wall()
		return

	excavation_level += P.excavation_amount
	//archaeo overlays
	if(!archaeo_overlay && finds && finds.len)
		var/datum/find/F = finds[1]
		if(F.excavation_required <= excavation_level + F.view_range)
			archaeo_overlay = image('icons/turf/excavation_overlays.dmi',"overlay_archaeo[rand(1,3)]")
			queue_icon_update()
	else if(archaeo_overlay && (!finds || !finds.len))
		archaeo_overlay = null
		queue_icon_update()

	//there's got to be a better way to do this
	var/update_excav_overlay = 0
	if(excavation_level >= 150)
		if(excavation_level - P.excavation_amount < 150)
			update_excav_overlay = 1
	else if(excavation_level >= 100)
		if(excavation_level - P.excavation_amount < 100)
			update_excav_overlay = 1
	else if(excavation_level >= 50)
		if(excavation_level - P.excavation_amount < 50)
			update_excav_overlay = 1

	//update overlays displaying excavation level
	if( !(excav_overlay && excavation_level > 0) || update_excav_overlay )
		var/excav_quadrant = round(excavation_level / 50) + 1
		excav_overlay = image('icons/turf/excavation_overlays.dmi',"overlay_excv[excav_quadrant]_[rand(1,3)]")
		queue_icon_update()

	//drop some rocks
	next_rock += P.excavation_amount
	while(next_rock > 50)
		next_rock -= 50
		pass_geodata_to(new /obj/item/ore(src, material?.type))

/turf/exterior/wall/proc/destroy_artifacts(var/obj/item/W, var/newDepth)
	if(!length(finds))
		return
	var/datum/find/F = finds[1]
	if(newDepth > F.excavation_required) // Digging too deep can break the item. At least you won't summon a Balrog (probably)
		if(W)
			. = ". <b>[pick("There is a crunching noise","[W] collides with some different rock","Part of the rock face crumbles away","Something breaks under [W]")]</b>"
		if(prob(10))
			return
		if(prob(25))
			excavate_find(prob(5), finds[1])
		else if(prob(50))
			finds.Remove(finds[1])
			if(prob(50))
				place_artifact_debris()
