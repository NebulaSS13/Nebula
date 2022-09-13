/obj/item/modular_computer/telescreen
	name               = "telescreen"
	desc               = "A wall-mounted touchscreen computer."
	icon               = 'icons/obj/modular_computers/modular_telescreen.dmi'
	icon_state         = "telescreen"
	anchored           = FALSE
	density            = FALSE
	light_strength     = 4
	w_class            = ITEM_SIZE_HUGE
	computer_type      = /datum/extension/assembly/modular_computer/telescreen
	obj_flags          = 0
	directional_offset = "{'NORTH':{'y':-20}, 'SOUTH':{'y':24}, 'EAST':{'x':-24}, 'WEST':{'x':24}}"
	center_of_mass     = "{'x':0, 'y':-8}"
	matter             = list(
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/silicon         = MATTER_AMOUNT_REINFORCEMENT,
	)

/obj/item/modular_computer/telescreen/mapped
	anchored  = TRUE
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED

/obj/item/modular_computer/telescreen/enable_computer(mob/user)
	if(!anchored)
		return //Can't turn on when not anchored
	. = ..()

/obj/item/modular_computer/telescreen/afterattack(atom/target, mob/user, proximity)
	. = ..()
	var/turf/T = target
	if(isturf(T) && proximity && T.is_wall() && user.do_skilled(2 SECONDS, SKILL_ELECTRICAL, target) && !QDELETED(src))
		user.unEquip(src, get_turf(user)) //Always place on our tile
		set_dir(global.reverse_dir[user.dir])
		set_anchored(TRUE)
		visible_message(SPAN_NOTICE("\The [user] secures \the [src]."), SPAN_NOTICE("You secure \the [src]."), range = 3)
		playsound(src, 'sound/effects/metalhit.ogg', 25, TRUE)

/obj/item/modular_computer/telescreen/proc/set_anchored(var/state)
	var/datum/extension/assembly/modular_computer/telescreen/assembly = get_extension(src, /datum/extension/assembly)
	anchored = state
	if(anchored)
		obj_flags |= OBJ_FLAG_MOVES_UNSUPPORTED
		assembly.screen_on = TRUE
		update_directional_offset()
	else
		obj_flags &= ~OBJ_FLAG_MOVES_UNSUPPORTED
		default_pixel_x = 0
		default_pixel_y = -8 //The sprite is a bit offset to the top currently
		reset_offsets(0)
		shutdown_computer()
		assembly.screen_on = FALSE
		set_dir(SOUTH) //Revert to item direction

/obj/item/modular_computer/telescreen/attackby(var/obj/item/W, var/mob/user)
	if(IS_CROWBAR(W) && anchored)
		if(W.do_tool_interaction(TOOL_CROWBAR, user, src, 2 SECONDS))
			set_anchored(FALSE)
			visible_message(SPAN_NOTICE("\The [user] unsecures \the [src]."), SPAN_NOTICE("You unsecure \the [src]."), range = 3)
			return TRUE
	. = ..()
