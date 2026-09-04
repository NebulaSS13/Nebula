/datum/fabricator_recipe/pipe
	var/connect_types = CONNECT_TYPE_REGULAR								//what sort of connection this has
	var/pipe_color = PIPE_COLOR_GREY										//what color the pipe should be by default
	var/build_icon_state = "simple"											//Which icon state to use when creating a new pipe item.
	var/build_icon = 'icons/obj/pipe-item.dmi'								//Which file the icon is located at.
	var/dir = SOUTH															//Direction the pipe faces
	var/colorable = TRUE													//Can this pipe be colored?
	var/constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden	//What's the final form of this item?
	var/pipe_class = PIPE_CLASS_BINARY										//The node classification for this item.
	var/rotate_class = PIPE_ROTATE_STANDARD                                 //How it behaves when rotated
	var/desc                                                                //Sets custom desc on pipe item

	category = "Regular Pipes"
	path = /obj/item/pipe

	fabricator_types = list(
		FABRICATOR_CLASS_PIPE
	)
	max_amount = 10

/datum/fabricator_recipe/pipe/New()
	. = ..()
	if(isnull(desc) && ispath(constructed_path))
		var/obj/constructed_obj = constructed_path
		desc = initial(constructed_obj.desc)

/datum/fabricator_recipe/pipe/get_resources()
	resources = list()
	var/list/building_cost = atom_info_repository.get_matter_for(constructed_path)
	for(var/path in building_cost)
		resources[path] = building_cost[path] * FABRICATOR_EXTRA_COST_FACTOR

/datum/fabricator_recipe/pipe/build(var/turf/location, var/datum/fabricator_build_order/order)
	. = list()
	for(var/i = 1, i <= order.multiplier, i++)
		var/obj/item/pipe/new_item = new path(location)
		if(istype(new_item))
			if(connect_types != null)
				new_item.connect_types = connect_types
			new_item.pipe_class = pipe_class
			new_item.rotate_class = rotate_class
			new_item.constructed_path = constructed_path
		if(colorable)
			new_item.set_color(order.get_data("selected_color", PIPE_COLOR_WHITE))
		else if (pipe_color != null)
			new_item.set_color(pipe_color)
		new_item.SetName(name)
		if(desc)
			new_item.desc = desc
		new_item.set_dir(dir)
		new_item.icon = build_icon
		new_item.icon_state = build_icon_state
		. += new_item

/datum/fabricator_recipe/pipe/disposal_dispenser/build(var/turf/location, var/datum/fabricator_build_order/order)
	. = list()
	for(var/i = 1, i <= order.multiplier, i++)
		var/obj/structure/disposalconstruct/new_item = new path(location)
		new_item.SetName(name)
		if(desc)
			new_item.desc = desc
		new_item.set_dir(dir)
		new_item.icon = build_icon
		new_item.built_icon_state = build_icon_state
		new_item.set_density(1)
		new_item.turn = turn
		new_item.constructed_path = constructed_path
		new_item.update_icon()
		. += new_item