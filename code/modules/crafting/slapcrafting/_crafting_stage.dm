/decl/crafting_stage
	abstract_type = /decl/crafting_stage
	var/descriptor = "undefined crafted item"
	var/item_desc = "It's an unfinished item of some sort."
	var/item_icon = 'icons/obj/crafting_icons.dmi'
	var/item_icon_state = "default"
	var/completion_trigger_type = /obj/item
	var/consume_completion_trigger = TRUE
	var/stack_consume_amount
	var/progress_message
	var/begins_with_object_type
	var/list/next_stages
	var/product
	/// What is the minimum map tech level to have access to this recipe?
	var/available_to_map_tech_level = MAP_TECH_LEVEL_ANY

/decl/crafting_stage/Initialize()
	. = ..()
	var/stages = list()
	for(var/nid in next_stages)
		stages += GET_DECL(nid)
	next_stages = stages

/decl/crafting_stage/proc/generate_completion_string()
	var/list/names = assemble_name_strings()
	if(ispath(completion_trigger_type, /obj/item/stack) || stack_consume_amount)
		names.Insert(1, max(stack_consume_amount, 1))
	return jointext(names, " ")

/decl/crafting_stage/proc/assemble_name_strings()
	SHOULD_CALL_PARENT(TRUE)
	var/list/names = list()
	var/obj/item/prop = completion_trigger_type
	if(ispath(prop, /obj/item/stack))
		var/obj/item/stack/stack = prop
		if(stack_consume_amount == 1)
			names += stack::singular_name
		else
			names += stack::plural_name
	else if(stack_consume_amount > 1)
		names += "[prop::name]\s"
	else
		names += prop::name
	return names

/decl/crafting_stage/proc/is_available()
	return global.using_map.map_tech_level >= available_to_map_tech_level

/decl/crafting_stage/proc/can_begin_with(var/obj/item/thing)
	. = istype(thing, begins_with_object_type)

/decl/crafting_stage/proc/get_next_stage(var/obj/item/trigger)
	for(var/decl/crafting_stage/next_stage in next_stages)
		if(next_stage.is_available() && next_stage.is_appropriate_tool(trigger) && next_stage.is_sufficient_amount(null, trigger))
			return next_stage

/decl/crafting_stage/proc/progress_to(var/obj/item/thing, var/mob/user, var/obj/item/target)
	if(consume_crafting_resource(user, thing, target))
		on_progress(user)
		return TRUE
	return FALSE

/decl/crafting_stage/proc/is_sufficient_amount(mob/user, obj/item/thing)
	if(stack_consume_amount <= 0)
		return TRUE
	if(!istype(thing, /obj/item/stack))
		return FALSE
	var/obj/item/stack/stack = thing
	. = stack.get_amount() >= stack_consume_amount
	if(!. && user)
		on_insufficient_material(user, stack)

/decl/crafting_stage/proc/is_appropriate_tool(obj/item/thing, obj/item/target)
	. = istype(thing, completion_trigger_type)

/decl/crafting_stage/proc/consume_crafting_resource(var/mob/user, var/obj/item/thing, var/obj/item/target)
	. = !consume_completion_trigger || user.try_unequip(thing, target)
	if(. && stack_consume_amount > 0)
		var/obj/item/stack/stack = thing
		if(!istype(stack) || stack.get_amount() < stack_consume_amount)
			on_insufficient_material(user, stack)
			return FALSE
		var/obj/item/stack/used_stack
		if(stack.amount > stack_consume_amount)
			used_stack = stack.split(stack_consume_amount)
		else
			if(!user.try_unequip(thing, target))
				return FALSE
			used_stack = stack
		if(!QDELETED(used_stack))
			used_stack.forceMove(target)
	target?.update_icon()

/decl/crafting_stage/proc/on_insufficient_material(var/mob/user, var/obj/item/stack/thing)
	if(istype(thing))
		to_chat(user, SPAN_WARNING("You need at least [stack_consume_amount] [stack_consume_amount == 1 ? thing.singular_name : thing.plural_name] to complete this task."))

/decl/crafting_stage/proc/on_progress(var/mob/user)
	if(progress_message)
		to_chat(user, SPAN_NOTICE(progress_message))

/decl/crafting_stage/proc/get_product(var/obj/item/work)
	. = ispath(product) && new product(get_turf(work))

/decl/crafting_stage/wiring
	completion_trigger_type = /obj/item/stack/cable_coil
	stack_consume_amount = 5
	consume_completion_trigger = FALSE

/decl/crafting_stage/material
	completion_trigger_type = /obj/item/stack/material/sheet
	stack_consume_amount = 5
	consume_completion_trigger = FALSE
	var/stack_material = /decl/material/solid/metal/steel

/decl/crafting_stage/material/assemble_name_strings()
	var/list/names = ..()
	if(stack_material)
		var/decl/material/mat = GET_DECL(stack_material)
		if(mat)
			names.Insert(1, mat.solid_name)
	return names

/decl/crafting_stage/material/consume_crafting_resource(var/mob/user, var/obj/item/thing, var/obj/item/target)
	var/obj/item/stack/material/M = thing
	. = istype(M) && (!stack_material || M.material.type == stack_material) && ..()

/decl/crafting_stage/welding/consume_crafting_resource(var/mob/user, var/obj/item/used_item, var/obj/item/target)
	var/decl/tool_archetype/welder_archetype = GET_DECL(TOOL_WELDER)
	return welder_archetype.can_use_tool(used_item) == TOOL_USE_SUCCESS && welder_archetype.handle_pre_interaction(user, used_item, 0) == TOOL_USE_SUCCESS

/decl/crafting_stage/welding
	consume_completion_trigger = FALSE

/decl/crafting_stage/welding/on_progress(var/mob/user)
	..()
	playsound(user.loc, 'sound/items/Welder2.ogg', 100, 1)

/decl/crafting_stage/screwdriver
	consume_completion_trigger = FALSE

/decl/crafting_stage/screwdriver/on_progress(var/mob/user)
	..()
	playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)

/decl/crafting_stage/screwdriver/progress_to(obj/item/thing, mob/user)
	. = IS_SCREWDRIVER(thing) && ..()

/decl/crafting_stage/tape
	stack_consume_amount = 4
	consume_completion_trigger = FALSE
	completion_trigger_type = /obj/item/stack/tape_roll/duct_tape

/decl/crafting_stage/tape/on_progress(var/mob/user)
	..()
	playsound(user.loc, 'sound/effects/tape.ogg', 100, 1)

/decl/crafting_stage/pipe
	completion_trigger_type = /obj/item/pipe

/decl/crafting_stage/scanner
	completion_trigger_type = /obj/item/scanner/health

/decl/crafting_stage/proximity
	completion_trigger_type = /obj/item/assembly/prox_sensor

/decl/crafting_stage/robot_arms
	progress_message = "You add the robotic arm to the assembly."
	completion_trigger_type = /obj/item/robot_parts

/decl/crafting_stage/robot_arms/is_appropriate_tool(obj/item/thing, obj/item/target)
	. = istype(thing, /obj/item/robot_parts/l_arm) || istype(thing, /obj/item/robot_parts/r_arm)

/decl/crafting_stage/empty_storage/can_begin_with(obj/item/thing)
	. = ..()
	if(.)
		if(!thing.storage)
			return FALSE
		return (length(thing.contents) == 0)
