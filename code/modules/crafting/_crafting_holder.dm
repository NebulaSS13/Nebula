/obj/item/crafting_holder
	var/decl/crafting_stage/current_crafting_stage
	var/label_name

/obj/item/crafting_holder/examine(mob/user, distance)
	. = ..()
	if(current_crafting_stage)
		var/list/next_steps = list()
		var/list/next_products = list()
		for(var/decl/crafting_stage/next_stage in current_crafting_stage.next_stages)
			if(ispath(next_stage.completion_trigger_type))
				var/atom/next_tool = next_stage.completion_trigger_type
				var/tool_string = initial(next_tool.name)
				if(next_stage.stack_consume_amount > 1)
					tool_string = "[next_stage.stack_consume_amount] [tool_string]\s"
				else
					tool_string = "\a [tool_string]"
				if(ispath(next_stage.product))
					var/atom/next_product = next_stage.product
					next_products[tool_string] = "\a [initial(next_product.name)]"
				else
					next_steps += tool_string
		if(length(next_products))
			for(var/thing in next_products)
				to_chat(user, SPAN_NOTICE("With <b>[thing]</b>, you could finish building <b>[next_products[thing]]</b>."))
		if(length(next_steps))
			to_chat(user, SPAN_NOTICE("You could continue to work on this with <b>[english_list(next_steps, and_text = " or ")]</b>."))

/obj/item/crafting_holder/Initialize(var/ml, var/decl/crafting_stage/initial_stage, var/obj/item/target, var/obj/item/tool, var/mob/user)
	. = ..(ml)
	name = "[target.name] assembly"
	var/mob/M = target.loc
	if(istype(M))
		M.drop_from_inventory(target)
	target.forceMove(src)
	current_crafting_stage = initial_stage
	update_icon()
	update_strings()

/obj/item/crafting_holder/Destroy()
	for(var/thing in contents)
		qdel(thing)
	. = ..()

/obj/item/crafting_holder/attackby(var/obj/item/W, var/mob/user)

	if(istype(W, /obj/item/pen))
		var/new_label = sanitize_safe(input(user, "What do you wish to label this assembly?", "Assembly Labelling", label_name), MAX_NAME_LEN)
		if(new_label && !user.incapacitated() && W.loc == user && user.Adjacent(src) && !QDELETED(src))
			to_chat(user, SPAN_NOTICE("You label \the [src] with '[new_label]'."))
			label_name = new_label
		return

	if(current_crafting_stage)
		var/decl/crafting_stage/next_stage = current_crafting_stage.get_next_stage(W)
		if(next_stage && next_stage.progress_to(W, user, src))
			advance_to(next_stage, user, W)
			return

	. = ..()

/obj/item/crafting_holder/proc/advance_to(var/decl/crafting_stage/next_stage, var/mob/user, var/obj/item/tool)
	var/obj/item/product = next_stage && next_stage.get_product(src)
	if(product)
		if(ismob(product) && label_name)
			var/mob/M = product
			M.SetName(label_name)
		if(ismob(src.loc))
			var/mob/M = src.loc
			M.drop_from_inventory(src)
		qdel_self()
	else
		current_crafting_stage = next_stage
		update_icon()
		update_strings()

/obj/item/crafting_holder/on_update_icon()
	icon = current_crafting_stage.item_icon
	icon_state = current_crafting_stage.item_icon_state

/obj/item/crafting_holder/proc/update_strings()
	if(current_crafting_stage.item_desc)
		desc = current_crafting_stage.item_desc
