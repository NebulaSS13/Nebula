/turf/wall/natural
	var/excavation_level = 0
	var/datum/artifact_find/artifact_find
	var/list/finds
	var/last_excavation
	var/next_rock = 0
	var/archaeo_overlay
	var/excav_overlay

/turf/wall/natural/proc/place_artifact_debris(var/severity = 0)
	for(var/j in 1 to rand(1, 3 + max(min(severity, 1), 0) * 2))
		switch(rand(1,7))
			if(1)
				SSmaterials.create_object(/decl/material/solid/metal/steel, src, rand(5, 25), /obj/item/stack/material/rods)
			if(2, 3)
				SSmaterials.create_object(/decl/material/solid/metal/plasteel, src, rand(5, 25))
			if(4)
				SSmaterials.create_object(/decl/material/solid/metal/steel, src, rand(5, 25))
			if(5)
				for(var/i = 1 to rand(1,3))
					new /obj/item/shard(src)
			if(6)
				for(var/i = 1 to rand(1,3))
					new /obj/item/shard/borosilicate(src)
			if(7)
				SSmaterials.create_object(/decl/material/solid/metal/uranium, src, rand(5, 25))

/turf/wall/natural/proc/excavate_find(var/prob_clean = 0, var/datum/find/F)
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
		pass_geodata_to(new /obj/item/strangerock(src, F.find_type))
	finds.Remove(F)

/turf/wall/natural/proc/handle_xenoarch_tool_interaction(var/obj/item/tool/xeno/P, var/mob/user)
	. = TRUE
	if(P.material?.hardness < material.hardness)
		to_chat(user, SPAN_WARNING("\The [P] is not hard enough to excavate [material.solid_name]."))
		return
	if(last_excavation + 2 SECONDS > world.time)//prevents message spam
		return
	last_excavation = world.time
	var/newDepth = excavation_level + P.get_tool_property(TOOL_PICK, TOOL_PROP_EXCAVATION_DEPTH) // Used commonly below
	//handle any archaeological finds we might uncover
	if(!P.do_tool_interaction(TOOL_PICK, user, src, 2 SECONDS, suffix_message = destroy_artifacts(P, newDepth)))
		return

	if(length(finds))
		var/datum/find/F = finds[1]
		if(newDepth == F.excavation_required) // When the pick hits that edge just right, you extract your find perfectly, it's never confined in a rock
			excavate_find(1, F)
		else if(newDepth > F.excavation_required - F.clearance_range) // Not quite right but you still extract your find, the closer to the bottom the better, but not above 80%
			excavate_find(prob(80 * (F.excavation_required - newDepth) / F.clearance_range), F)

	if(newDepth >= 200) // This means the rock is mined out fully
		if(artifact_find)
			if( excavation_level > 0 || prob(15) )
				var/obj/structure/boulder/excavated/B = new(src, material?.type, paint_color)
				B.artifact_find = artifact_find
			else
				place_artifact_debris(1)
			artifact_find = null
			SSxenoarch.artifact_spawning_turfs -= src
		else if(prob(5))
			new /obj/structure/boulder/excavated(src, material?.type)
		dismantle_turf()
		return

	var/excav_level = P.get_tool_property(TOOL_PICK, TOOL_PROP_EXCAVATION_DEPTH)
	excavation_level += excav_level
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
		if(excavation_level - excav_level < 150)
			update_excav_overlay = 1
	else if(excavation_level >= 100)
		if(excavation_level - excav_level < 100)
			update_excav_overlay = 1
	else if(excavation_level >= 50)
		if(excavation_level - excav_level < 50)
			update_excav_overlay = 1

	//update overlays displaying excavation level
	if( !(excav_overlay && excavation_level > 0) || update_excav_overlay )
		var/excav_quadrant = round(excavation_level / 50) + 1
		excav_overlay = image('icons/turf/excavation_overlays.dmi',"overlay_excv[excav_quadrant]_[rand(1,3)]")
		queue_icon_update()

	//drop some rocks
	next_rock += excav_level
	var/amount_rocks = round(next_rock / 50)
	next_rock = next_rock % 50
	if(amount_rocks > 0)
		pass_geodata_to(new /obj/item/stack/material/ore(src, amount_rocks, material?.type))

/turf/wall/natural/proc/destroy_artifacts(var/obj/item/W, var/newDepth)
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
