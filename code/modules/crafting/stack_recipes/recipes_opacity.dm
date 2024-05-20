/decl/stack_recipe/opacity
	abstract_type               = /decl/stack_recipe/opacity
	required_max_opacity        = 0.5
	on_floor                    = TRUE
	difficulty                  = MAT_VALUE_HARD_DIY
	required_reinforce_material = MATERIAL_ALLOWED
	craft_stack_types           = list(
		/obj/item/stack/material/pane,
		/obj/item/stack/material/sheet,
		/obj/item/stack/material/panel
	)

/decl/stack_recipe/opacity/fullwindow
	name                 = "full-tile window"
	result_type          = /obj/structure/window
	max_res_amount       = 1

/decl/stack_recipe/opacity/fullwindow/can_make(mob/user)
	. = ..()
	if(.)
		for(var/obj/structure/window/check_window in user.loc)
			if(check_window.is_fulltile())
				to_chat(user, SPAN_WARNING("There is already a full-tile window here!"))
				return FALSE

/decl/stack_recipe/opacity/fullwindow/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat)
	return new result_type(user?.loc, MATERIAL_RECIPE_PARAMS, SOUTHWEST, TRUE)

/decl/stack_recipe/opacity/borderwindow
	name                 = "border window"
	result_type          = /obj/structure/window
	one_per_turf         = 0
	max_res_amount       = 1

/decl/stack_recipe/opacity/borderwindow/can_make(mob/user)
	. = ..()
	if(.)
		for(var/obj/structure/window/check_window in user.loc)
			if(check_window.dir == user.dir)
				to_chat(user, "<span class='warning'>There is already a window facing that direction here!</span>")
				return FALSE

/decl/stack_recipe/opacity/borderwindow/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat)
	return new result_type(user?.loc, MATERIAL_RECIPE_PARAMS, user?.dir, TRUE)

/decl/stack_recipe/opacity/windoor
	result_type          = /obj/structure/windoor_assembly
	max_res_amount       = 1

/decl/stack_recipe/opacity/windoor/can_make(mob/user)
	. = ..()
	if(.)
		if(locate(/obj/machinery/door/window) in user.loc)
			to_chat(user, "<span class='warning'>There is already a windoor here!</span>")
			return FALSE

/decl/stack_recipe/opacity/windoor/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat)
	return new result_type(user?.loc, MATERIAL_RECIPE_PARAMS)
