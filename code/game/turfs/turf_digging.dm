/// Return an assoc list of resource item type to a metadata list containing base amount, random component, and material override
/// ex. return list(/obj/item/stack/material/ore/handful/sand = list("amount" = 3, "variance" = 2, "material" = /decl/material/foo))
/turf/proc/get_diggable_resources()
	return null

/turf/proc/clear_diggable_resources()
	SHOULD_CALL_PARENT(TRUE)
	update_icon()

/turf/proc/can_be_dug(tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	return FALSE

/turf/proc/drop_diggable_resources(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	var/list/diggable_resources = get_diggable_resources()
	if(!length(diggable_resources))
		return
	for(var/resource_type in diggable_resources)

		var/list/resource_data = diggable_resources[resource_type]
		var/list/loot          = list()
		var/amount             = max(1, resource_data["amount"] + resource_data["variance"])
		var/spawn_material     = resource_data["material"]

		if(ispath(resource_type, /obj/item/stack))
			loot += new resource_type(src, amount, spawn_material)
		else
			for(var/i = 1 to amount)
				loot += new resource_type(src, spawn_material)

		if(length(loot))
			if(user)
				for(var/obj/item/thing in loot)
					if(thing.material && thing.material != get_material())
						to_chat(user, SPAN_NOTICE("You unearth \a [thing]!"))
			LAZYADD(., loot)

	for(var/obj/item/stack/stack in .)
		stack.add_to_stacks()

	clear_diggable_resources()

// Procs for digging pits.
/turf/proc/can_dig_pit(tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	return can_be_dug(tool_hardness, using_tool) && !(locate(/obj/structure/pit) in src)

/turf/proc/try_dig_pit(var/mob/user, var/obj/item/tool, using_tool = TOOL_SHOVEL)
	if((!user && !tool) || tool.do_tool_interaction(using_tool, user, src, 5 SECONDS, check_skill = SKILL_HAULING, set_cooldown = TRUE))
		return dig_pit(user, tool?.material?.hardness, using_tool)
	return null

/turf/proc/dig_pit(mob/user, tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	return can_dig_pit(tool_hardness, using_tool) && new /obj/structure/pit(src)

// Procs for digging farms.
/turf/proc/can_dig_farm(tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	return get_plant_growth_rate() > 0 && can_be_dug(tool_hardness, using_tool) && !(locate(/obj/machinery/portable_atmospherics/hydroponics/soil) in src)

/turf/proc/try_dig_farm(mob/user, obj/item/tool, using_tool = TOOL_HOE)
	var/decl/material/turf_material = get_material()
	if(!turf_material?.tillable)
		return
	if((!user && !tool) || tool.do_tool_interaction(using_tool, user, src, 5 SECONDS, set_cooldown = TRUE, check_skill = SKILL_BOTANY))
		return dig_farm(user, tool?.material?.hardness, using_tool)
	return null

/turf/proc/dig_farm(mob/user, tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	return can_dig_farm(tool_hardness, using_tool) && new /obj/machinery/portable_atmospherics/hydroponics/soil(src)

// Proc for digging trenches.
/turf/proc/can_dig_trench(tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	return can_be_dug(tool_hardness, using_tool) && (HasBelow(z) || get_physical_height() > -(FLUID_DEEP))

/turf/proc/try_dig_trench(mob/user, obj/item/tool, using_tool = TOOL_SHOVEL)
	if((!user && !tool) || tool.do_tool_interaction(using_tool, user, src, 2.5 SECONDS, check_skill = SKILL_HAULING, set_cooldown = TRUE))
		return dig_trench(user, tool?.material?.hardness, using_tool)
	return null

/turf/proc/dig_trench(mob/user, tool_hardness = MAT_VALUE_MALLEABLE, using_tool = TOOL_SHOVEL)
	return FALSE
