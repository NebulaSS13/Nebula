var/global/list/_tool_crafting_lookup
/proc/get_tool_crafting_lookup()
	if(!global._tool_crafting_lookup)
		global._tool_crafting_lookup = list()
		for(var/tool in global._tool_crafting_components)
			for(var/component in global._tool_crafting_components[tool])
				LAZYINITLIST(global._tool_crafting_lookup[component])
				for(var/other_component in global._tool_crafting_components[tool])
					if(other_component == component)
						continue
					LAZYSET(global._tool_crafting_lookup[component], other_component, tool)
	return global._tool_crafting_lookup

var/global/list/_tool_crafting_components = list(
	/obj/item/tool/hammer = list(
		/obj/item/tool_component/head/hammer,
		/obj/item/tool_component/handle/short
	),
	/obj/item/tool/shovel = list(
		/obj/item/tool_component/head/shovel,
		/obj/item/tool_component/handle/short
	),
	/obj/item/tool/hoe = list(
		/obj/item/tool_component/head/hoe,
		/obj/item/tool_component/handle/short
	),
	/obj/item/tool/pickaxe = list(
		/obj/item/tool_component/head/pickaxe,
		/obj/item/tool_component/handle/long
	),
	/obj/item/tool/hammer/sledge = list(
		/obj/item/tool_component/head/sledgehammer,
		/obj/item/tool_component/handle/long
	),
	/obj/item/tool/axe = list(
		/obj/item/tool_component/head/handaxe,
		/obj/item/tool_component/handle/short
	)
)

/decl/crafting_stage/tool/tool_start
	descriptor = "tool"
	begins_with_object_type = /obj/item/tool_component/head
	completion_trigger_type = /obj/item/tool_component/handle
	next_stages = list(/decl/crafting_stage/tool_binding)
	progress_message = "You loosely attach the head to the handle."
	item_icon_state = null

/decl/crafting_stage/tool/tool_start/handle
	begins_with_object_type = /obj/item/tool_component/handle
	completion_trigger_type = /obj/item/tool_component/head

/decl/crafting_stage/tool/tool_start/is_appropriate_tool(obj/item/thing, obj/item/target)

	if(!..())
		return FALSE

	if(thing.material?.hardness < MAT_VALUE_SOFT)
		to_chat(usr, SPAN_WARNING("\The [thing] is too soft to be used as part of an effective tool."))
		return FALSE

	if(target.material?.hardness < MAT_VALUE_SOFT)
		to_chat(usr, SPAN_WARNING("\The [target] is too soft to be used as part of an effective tool."))
		return FALSE

	var/is_valid_tool_combo = FALSE
	var/list/tool_lookup = get_tool_crafting_lookup()
	for(var/base_comp_type in tool_lookup)
		if(!istype(target, base_comp_type))
			continue
		for(var/other_comp_type in tool_lookup[base_comp_type])
			if(istype(thing, other_comp_type))
				is_valid_tool_combo = TRUE
				break

	if(!is_valid_tool_combo)
		to_chat(usr, SPAN_WARNING("\The [target] and \the [thing] cannot be combined into a functional tool."))
		return FALSE

	return TRUE

/decl/crafting_stage/tool_binding
	descriptor = "tool binding"
	completion_trigger_type = /obj/item/stack/material
	stack_consume_amount = 5
	consume_completion_trigger = FALSE
	product = /obj/item/tool // see get_product()

	var/static/list/binding_types = list(
		/obj/item/stack/material/thread,
		/obj/item/stack/material/bundle,
		/obj/item/stack/material/bolt
	)
	var/static/list/binding_materials = list(
		/decl/material/solid/organic/plantmatter/grass/dry,
		/decl/material/solid/organic/leather,
		/decl/material/solid/organic/cloth
	)

/decl/crafting_stage/tool_binding/is_appropriate_tool(obj/item/thing, obj/item/target)
	. = is_type_in_list(thing, binding_types) && thing.material && is_type_in_list(thing.material, binding_materials) && ..()

/decl/crafting_stage/tool_binding/get_product(var/obj/item/work)

	var/obj/item/tool_component/handle/handle = locate() in work
	var/obj/item/tool_component/head/head     = locate() in work
	var/obj/item/stack/binding                = locate() in work

	if(!istype(handle) || !istype(head))
		return null
	var/tool_type
	var/list/tool_lookup = get_tool_crafting_lookup()
	for(var/handle_comp_type in tool_lookup)
		if(!istype(handle, handle_comp_type))
			continue
		for(var/head_comp_type in tool_lookup[handle_comp_type])
			if(!istype(head, head_comp_type))
				continue
			tool_type = tool_lookup[handle_comp_type][head_comp_type]
			break
	if(!tool_type)
		return null
	return new tool_type(get_turf(work), head.material?.type, handle.material?.type, binding?.material?.type, head.tool_qualities, head.tool_properties)
