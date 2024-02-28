/decl/stack_recipe/opacity
	abstract_type = /decl/stack_recipe/opacity
	required_max_opacity = 0.5
	one_per_turf = 1
	on_floor = 1
	difficulty = 2
	time = 5

/decl/stack_recipe/opacity/fullwindow
	name = "full-tile window"
	result_type = /obj/structure/window
	time = 15
	one_per_turf = 0

/decl/stack_recipe/opacity/fullwindow/can_make(mob/user)
	. = ..()
	if(.)
		for(var/obj/structure/window/check_window in user.loc)
			if(check_window.is_fulltile())
				to_chat(user, SPAN_WARNING("There is already a full-tile window here!"))
				return FALSE

/decl/stack_recipe/opacity/fullwindow/spawn_result(mob/user, location, amount)
	return new result_type(user?.loc, use_material, use_reinf_material, SOUTHWEST, TRUE)

/decl/stack_recipe/opacity/borderwindow
	name = "border window"
	result_type = /obj/structure/window
	time = 5
	one_per_turf = 0

/decl/stack_recipe/opacity/borderwindow/can_make(mob/user)
	. = ..()
	if(.)
		for(var/obj/structure/window/check_window in user.loc)
			if(check_window.dir == user.dir)
				to_chat(user, "<span class='warning'>There is already a window facing that direction here!</span>")
				return FALSE

/decl/stack_recipe/opacity/borderwindow/spawn_result(mob/user, location, amount)
	return new result_type(user?.loc, use_material, use_reinf_material, user?.dir, TRUE)

/decl/stack_recipe/opacity/windoor
	name = "windoor assembly"
	result_type = /obj/structure/windoor_assembly
	time = 20
	one_per_turf = 1

/decl/stack_recipe/opacity/windoor/can_make(mob/user)
	. = ..()
	if(.)
		if(locate(/obj/machinery/door/window) in user.loc)
			to_chat(user, "<span class='warning'>There is already a windoor here!</span>")
			return FALSE

/decl/stack_recipe/opacity/windoor/spawn_result(mob/user, location, amount)
	return new result_type(user?.loc, use_material, use_reinf_material)
