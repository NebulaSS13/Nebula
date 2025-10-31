
////////////////////////////////////////////////////////////////////////////////
/// (Mixing)Glass.
////////////////////////////////////////////////////////////////////////////////
/obj/item/chems/glass
	name = ""
	desc = ""
	icon_state = "null"
	item_state = "null"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[5,10,15,25,30,60]"
	chem_volume = 60
	w_class = ITEM_SIZE_SMALL
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	obj_flags = OBJ_FLAG_HOLLOW
	material = /decl/material/solid/glass
	abstract_type = /obj/item/chems/glass
	drop_sound = 'sound/foley/bottledrop1.ogg'
	pickup_sound = 'sound/foley/bottlepickup1.ogg'
	watertight = FALSE // /glass uses the open container flag for this

/obj/item/chems/glass/proc/get_atoms_can_be_placed_into()
	var/static/list/_can_be_placed_into = list(
		/obj/machinery/chem_master/,
		/obj/machinery/chemical_dispenser,
		/obj/machinery/reagentgrinder,
		/obj/structure/table,
		/obj/structure/closet,
		/obj/structure/hygiene/sink,
		/obj/item/grenade/chem_grenade,
		/mob/living/bot/medbot,
		/obj/item/secure_storage/safe,
		/obj/structure/iv_drip,
		/obj/machinery/disposal,
		/mob/living/simple_animal/cow,
		/mob/living/simple_animal/hostile/goat,
		/obj/machinery/sleeper,
		/obj/machinery/smartfridge/,
		/obj/machinery/biogenerator,
		/obj/machinery/constructable_frame,
		/obj/machinery/radiocarbon_spectrometer,
		/obj/machinery/material_processing/extractor
	)
	return _can_be_placed_into

/obj/item/chems/glass/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance > 2)
		return
	if(reagents?.total_volume)
		. += SPAN_NOTICE("It contains [reagents.total_volume] units of reagents.")
	else
		. += SPAN_NOTICE("It is empty.")
	if(!ATOM_IS_OPEN_CONTAINER(src))
		. += SPAN_NOTICE("The airtight lid seals it completely.")

/obj/item/chems/glass/proc/can_lid()
	return TRUE

/obj/item/chems/glass/proc/should_drink_from(mob/drinker)
	. = reagents?.total_volume > 0
	if(.)
		var/decl/material/drinking = reagents.get_primary_reagent_decl()
		return drinking ? !drinking.is_unsafe_to_drink(drinker) : FALSE

#ifdef UNIT_TEST
// Will get generated during atom creation/deletion tests so no need for a distinct unit test.
var/global/list/lid_check_glass_types = list()
/obj/item/chems/glass/Initialize()
	. = ..()
	if(can_lid() && !global.lid_check_glass_types[type])
		if(!check_state_in_icon("[icon_state]_lid", icon))
			log_error("Liddable vessel [type] missing lid state from [icon]!")
		global.lid_check_glass_types[type] = TRUE
#endif

/obj/item/chems/glass/on_update_icon()
	. = ..()
	update_overlays()
	compile_overlays()

/obj/item/chems/glass/proc/get_lid_color()
	return COLOR_WHITE

/obj/item/chems/glass/proc/get_lid_flags()
	return RESET_COLOR | RESET_ALPHA

/obj/item/chems/glass/proc/update_overlays()
	if (can_lid() && !ATOM_IS_OPEN_CONTAINER(src))
		add_overlay(overlay_image(icon, "[icon_state]_lid", get_lid_color(), get_lid_flags()))

/obj/item/chems/glass/attack_self(mob/user)

	if(can_lid() && user.check_intent(I_FLAG_HELP))
		if(ATOM_IS_OPEN_CONTAINER(src))
			to_chat(user, SPAN_NOTICE("You put the lid on \the [src]."))
			atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
		else
			to_chat(user, SPAN_NOTICE("You take the lid off \the [src]."))
			atom_flags |= ATOM_FLAG_OPEN_CONTAINER
		update_icon()
		return TRUE

	if(should_drink_from(user) && is_edible(user) && handle_eaten_by_mob(user, user) != EATEN_INVALID)
		return TRUE

	return ..()

/obj/item/chems/glass/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(expend_attack_force(user) && !(item_flags & ITEM_FLAG_NO_BLUDGEON) && user.check_intent(I_FLAG_HARM))
		return ..()
	return FALSE

/obj/item/chems/glass/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!ATOM_IS_OPEN_CONTAINER(src) || !proximity) //Is the container open & are they next to whatever they're clicking?
		return FALSE //If not, do nothing.
	if(target?.storage)
		return TRUE
	for(var/type in get_atoms_can_be_placed_into()) //Is it something it can be placed into?
		if(istype(target, type))
			return TRUE
	if(standard_dispenser_refill(user, target)) //Are they clicking a water tank/some dispenser?
		return TRUE
	if(standard_pour_into(user, target)) //Pouring into another beaker?
		return TRUE
	if(handle_eaten_by_mob(user, target) != EATEN_INVALID)
		return TRUE
	if(user.check_intent(I_FLAG_HARM))
		if(standard_splash_mob(user,target))
			return TRUE
		if(reagents && reagents.total_volume)
			to_chat(user, SPAN_DANGER("You splash the contents of \the [src] onto \the [target]."))
			reagents.splash(target, reagents.total_volume)
			return TRUE
	else if(reagents && reagents.total_volume)
		to_chat(user, SPAN_NOTICE("You splash a small amount of the contents of \the [src] onto \the [target]."))
		reagents.splash(target, min(reagents.total_volume, 5))
		return TRUE
	. = ..()

// Drinking out of bowls.
/obj/item/chems/glass/get_edible_material_amount(mob/eater)
	return reagents?.total_volume

/obj/item/chems/glass/get_utensil_food_type()
	return /obj/item/food/lump

// Interaction code borrowed from /food.
// Should we consider moving this down to /chems for any open container? Medicine from a bottle using a spoon, etc.
/obj/item/chems/glass/attackby(obj/item/used_item, mob/living/user)

	if(!ATOM_IS_OPEN_CONTAINER(src))
		return ..()

	var/obj/item/utensil/utensil = used_item
	if(istype(utensil) && (utensil.utensil_flags & UTENSIL_FLAG_SCOOP))
		if(utensil.loaded_food)
			to_chat(user, SPAN_WARNING("You already have something on \the [utensil]."))
			return TRUE
		if(!reagents?.total_volume)
			to_chat(user, SPAN_WARNING("\The [src] is empty."))
			return TRUE
		separate_food_chunk(utensil, user)
		if(utensil.loaded_food?.reagents?.total_volume)
			to_chat(user, SPAN_NOTICE("You scoop up some of \the [utensil.loaded_food.reagents.get_primary_reagent_name()] with \the [utensil]."))
		return TRUE

	return ..()

/obj/item/chems/glass/get_alt_interactions(mob/user)
	. = ..()
	if(reagents?.total_volume >= FLUID_PUDDLE)
		LAZYADD(., /decl/interaction_handler/dip_item)
		LAZYADD(., /decl/interaction_handler/fill_from)
	if(user?.get_active_held_item())
		LAZYADD(., /decl/interaction_handler/empty_into)
	if(can_lid())
		LAZYADD(., /decl/interaction_handler/toggle_lid)

/decl/interaction_handler/toggle_lid
	name = "Toggle Lid"
	expected_target_type = /obj/item/chems/glass

/decl/interaction_handler/toggle_lid/is_possible(atom/target, mob/user, obj/item/prop)
	. = ..()
	if(. && !istype(prop))
		var/obj/item/chems/glass/glass = target
		return glass.can_lid()

/decl/interaction_handler/toggle_lid/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/item/chems/glass/glass = target
	if(istype(glass) && glass.can_lid())
		if(ATOM_IS_OPEN_CONTAINER(glass))
			to_chat(user, SPAN_NOTICE("You put the lid on \the [glass]."))
			glass.atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
		else
			to_chat(user, SPAN_NOTICE("You take the lid off \the [glass]."))
			glass.atom_flags |= ATOM_FLAG_OPEN_CONTAINER
		glass.update_icon()
	return TRUE

