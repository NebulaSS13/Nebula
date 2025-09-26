//////////////////////////////////////////////////////////////////
// Welding tool tanks
//////////////////////////////////////////////////////////////////
/obj/item/chems/welder_tank
	name               = "welding tank"
	base_name          = "welding tank"
	desc               = "An interchangeable fuel tank meant for a welding tool."
	icon               = 'icons/obj/items/tool/welders/welder_tanks.dmi'
	icon_state         = "tank_normal"
	w_class            = ITEM_SIZE_SMALL
	atom_flags         = ATOM_FLAG_OPEN_CONTAINER
	obj_flags          = OBJ_FLAG_HOLLOW
	volume             = 20
	presentation_flags = PRESENTATION_FLAG_NAME
	current_health     = 40
	max_health         = 40
	material           = /decl/material/solid/metal/steel
	var/can_refuel     = TRUE
	var/size_in_use    = ITEM_SIZE_NORMAL
	var/unlit_force    = 7
	var/lit_force      = 11

/obj/item/chems/welder_tank/populate_reagents()
	add_to_reagents(/decl/material/liquid/fuel, reagents.maximum_volume)

/obj/item/chems/welder_tank/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance > 1)
		return
	if(reagents.total_volume <= 0)
		. += SPAN_WARNING("It is empty.")
	else
		. += "It contains [reagents.total_volume] units of liquid."
	. += "It can hold up to [reagents.maximum_volume] units."

/obj/item/chems/welder_tank/afterattack(obj/O, mob/user, proximity, click_parameters)
	if (!ATOM_IS_OPEN_CONTAINER(src) || !proximity)
		return
	if(standard_dispenser_refill(user, O))
		return TRUE
	if(standard_pour_into(user, O))
		return TRUE
	if(handle_eaten_by_mob(user, O) != EATEN_INVALID)
		return TRUE
	if(user.check_intent(I_FLAG_HARM))
		if(standard_splash_mob(user, O))
			return TRUE
		if(reagents && reagents.total_volume)
			to_chat(user, SPAN_DANGER("You splash the contents of \the [src] onto \the [O]."))
			reagents.splash(O, reagents.total_volume)
			return TRUE
	return ..()

/obj/item/chems/welder_tank/standard_dispenser_refill(mob/user, obj/structure/reagent_dispensers/target, skip_container_check = FALSE)
	if(!can_refuel)
		to_chat(user, SPAN_DANGER("\The [src] does not have a refuelling port."))
		return FALSE
	. = ..()
	if(.)
		playsound(src.loc, 'sound/effects/refill.ogg', 50, TRUE, -6)

/obj/item/chems/welder_tank/standard_pour_into(mob/user, atom/target)
	if(!can_refuel)
		to_chat(user, SPAN_DANGER("\The [src] is sealed shut."))
		return FALSE
	. = ..()

/obj/item/chems/welder_tank/standard_splash_mob(mob/user, mob/target)
	if(!can_refuel)
		to_chat(user, SPAN_DANGER("\The [src] is sealed shut."))
		return FALSE
	. = ..()

/obj/item/chems/welder_tank/handle_eaten_by_mob(mob/user, mob/target)
	if(!can_refuel)
		to_chat(user, SPAN_DANGER("\The [src] is sealed shut."))
		return EATEN_UNABLE
	return ..()

/obj/item/chems/welder_tank/get_alt_interactions(var/mob/user)
	. = ..()
	if(!can_refuel)
		LAZYREMOVE(., /decl/interaction_handler/set_transfer/chems)

/obj/item/chems/welder_tank/mini
	name               = "small welding tank"
	base_name          = "small welding tank"
	icon_state         = "tank_small"
	w_class            = ITEM_SIZE_TINY
	volume             = 5
	size_in_use        = ITEM_SIZE_SMALL
	unlit_force        = 5
	lit_force          = 7
	_base_attack_force = 4

/obj/item/chems/welder_tank/large
	name               = "large welding tank"
	base_name          = "large welding tank"
	icon_state         = "tank_large"
	w_class            = ITEM_SIZE_SMALL
	volume             = 40
	size_in_use        = ITEM_SIZE_NORMAL
	_base_attack_force = 6

/obj/item/chems/welder_tank/huge
	name               = "huge welding tank"
	base_name          = "huge welding tank"
	icon_state         = "tank_huge"
	w_class            = ITEM_SIZE_NORMAL
	volume             = 80
	size_in_use        = ITEM_SIZE_LARGE
	unlit_force        = 9
	lit_force          = 15
	_base_attack_force = 8

/obj/item/chems/welder_tank/experimental
	name               = "experimental welding tank"
	base_name          = "experimental welding tank"
	icon_state         = "tank_experimental"
	w_class            = ITEM_SIZE_NORMAL
	volume             = 40
	can_refuel         = FALSE
	size_in_use        = ITEM_SIZE_LARGE
	unlit_force        = 9
	lit_force          = 15
	presentation_flags = 0
	_base_attack_force = 8
	var/tmp/last_gen   = 0

/obj/item/chems/welder_tank/experimental/Initialize(ml, material_key)
	. = ..()
	atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER
	START_PROCESSING(SSobj, src)

/obj/item/chems/welder_tank/experimental/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/chems/welder_tank/experimental/Process()
	if(REAGENT_VOLUME(reagents, /decl/material/liquid/fuel) < reagents.maximum_volume)
		var/gen_amount = ((world.time-last_gen)/25)
		add_to_reagents(/decl/material/liquid/fuel, gen_amount)
		last_gen = world.time