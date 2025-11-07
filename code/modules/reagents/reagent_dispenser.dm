
/obj/structure/reagent_dispensers
	name                              = "dispenser"
	desc                              = "A large tank for storing chemicals."
	icon                              = 'icons/obj/objects.dmi'
	icon_state                        = "watertank"
	density                           = TRUE
	anchored                          = FALSE
	material                          = /decl/material/solid/organic/plastic
	matter                            = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_SECONDARY)
	max_health                        = 100
	tool_interaction_flags            = TOOL_INTERACTION_DECONSTRUCT
	chem_volume                       = 1000

	var/wrenchable                    = TRUE
	var/unwrenched                    = FALSE
	var/amount_dispensed              = 10
	var/can_toggle_open               = TRUE
	var/tmp/possible_transfer_amounts = @"[10,25,50,100,500]"

/obj/structure/reagent_dispensers/get_reagent_amount_dispensed()
	return amount_dispensed

/obj/structure/reagent_dispensers/set_reagent_amount_dispensed(new_amount)
	amount_dispensed = new_amount

/obj/structure/reagent_dispensers/get_possible_reagent_transfer_amounts()
	return cached_json_decode(possible_transfer_amounts)

/obj/structure/reagent_dispensers/on_reagent_change()
	if(!(. = ..()))
		return
	if(reagents?.total_volume > 0)
		tool_interaction_flags &= ~TOOL_INTERACTION_DECONSTRUCT
	else
		tool_interaction_flags |= TOOL_INTERACTION_DECONSTRUCT

/obj/structure/reagent_dispensers/proc/leak()
	var/turf/T = get_turf(src)
	if(reagents && T)
		reagents.trans_to_turf(T, min(reagents.total_volume, FLUID_PUDDLE))

/obj/structure/reagent_dispensers/Move()
	. = ..()
	if(. && unwrenched)
		leak()

/obj/structure/reagent_dispensers/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(unwrenched)
		. += SPAN_WARNING("Someone has wrenched open its tap - it's spilling everywhere!")
	if(distance <= 2)
		if(wrenchable)
			if(ATOM_IS_OPEN_CONTAINER(src))
				. += "Its refilling cap is open."
			else
				. += "Its refilling cap is closed."

/obj/structure/reagent_dispensers/attackby(obj/item/used_item, mob/user)

	if(wrenchable && IS_WRENCH(used_item))
		unwrenched = !unwrenched
		visible_message(SPAN_NOTICE("\The [user] wrenches \the [src]'s tap [unwrenched ? "open" : "shut"]."))
		if(unwrenched)
			log_and_message_admins("opened a tank at [get_area_name(loc)].")
			leak()
		return TRUE

	. = ..()

/obj/structure/reagent_dispensers/explosion_act(severity)
	. = ..()
	if(. && (severity == 1) || (severity == 2 && prob(50)) || (severity == 3 && prob(5)))
		physically_destroyed()

//Dispensers
/obj/structure/reagent_dispensers/watertank
	name                      = "water tank"
	desc                      = "A tank containing water."
	icon_state                = "watertank"
	amount_dispensed          = 10
	possible_transfer_amounts = @"[10,25,50,100]"
	chem_volume               = 7500
	atom_flags                = ATOM_FLAG_CLIMBABLE
	movable_flags             = MOVABLE_FLAG_WHEELED

/obj/structure/reagent_dispensers/watertank/populate_reagents()
	add_to_reagents(/decl/material/liquid/water, reagents.maximum_volume)

/obj/structure/reagent_dispensers/watertank/high
	name = "high-capacity water tank"
	desc = "A highly-pressurized water tank made to hold vast amounts of water."
	icon = 'icons/obj/structures/water_tank_high.dmi'
	icon_state = ICON_STATE_WORLD

/obj/structure/reagent_dispensers/watertank/firefighter
	name        = "firefighting water reserve"
	chem_volume = 50000

/obj/structure/reagent_dispensers/watertank/attackby(obj/item/used_item, mob/user)
	//FIXME: Maybe this should be handled differently? Since it can essentially make the tank unusable.
	if((istype(used_item, /obj/item/robot_parts/l_arm) || istype(used_item, /obj/item/robot_parts/r_arm)) && user.try_unequip(used_item))
		to_chat(user, "You add \the [used_item] arm to \the [src].")
		qdel(used_item)
		new /obj/item/farmbot_arm_assembly(loc, src)
		return TRUE
	. = ..()

/obj/structure/reagent_dispensers/fueltank
	name             = "fuel tank"
	desc             = "A tank containing welding fuel."
	icon_state       = "weldtank"
	amount_dispensed = 10
	atom_flags       = ATOM_FLAG_CLIMBABLE
	movable_flags    = MOVABLE_FLAG_WHEELED
	var/obj/item/assembly_holder/rig

/obj/structure/reagent_dispensers/fueltank/populate_reagents()
	add_to_reagents(/decl/material/liquid/fuel, reagents.maximum_volume)

/obj/structure/reagent_dispensers/fueltank/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(rig && distance < 2)
		. += SPAN_WARNING("There is some kind of device rigged to the tank.")

/obj/structure/reagent_dispensers/fueltank/attack_hand(var/mob/user)
	if (!rig || !user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()
	visible_message(SPAN_NOTICE("\The [user] begins to detach \the [rig] from \the [src]."))
	if(!user.do_skilled(2 SECONDS, SKILL_ELECTRICAL, src))
		return TRUE
	visible_message(SPAN_NOTICE("\The [user] detaches \the [rig] from \the [src]."))
	rig.dropInto(loc)
	rig = null
	update_icon()
	return TRUE

/obj/structure/reagent_dispensers/fueltank/attackby(obj/item/used_item, mob/user)

	if(istype(used_item, /obj/item/assembly_holder))
		if (rig)
			to_chat(user, SPAN_WARNING("There is another device already in the way."))
			return ..()
		visible_message(SPAN_NOTICE("\The [user] begins rigging \the [used_item] to \the [src]."))
		if(do_after(user, 20, src) && user.try_unequip(used_item, src))
			visible_message(SPAN_NOTICE("\The [user] rigs \the [used_item] to \the [src]."))
			var/obj/item/assembly_holder/H = used_item
			if (istype(H.a_left,/obj/item/assembly/igniter) || istype(H.a_right,/obj/item/assembly/igniter))
				log_and_message_admins("rigged a fuel tank for explosion at [loc.loc.name].")
			rig = used_item
			update_icon()
		return TRUE

	if(used_item.isflamesource())
		log_and_message_admins("triggered a fuel tank explosion with \the [used_item].")
		visible_message(SPAN_DANGER("\The [user] puts \the [used_item] to \the [src]!"))
		try_detonate_reagents()
		return TRUE

	. = ..()

/obj/structure/reagent_dispensers/fueltank/on_update_icon()
	. = ..()
	if(rig)
		var/mutable_appearance/I = new(rig.appearance)
		I.pixel_x += 6
		I.pixel_y += 1
		add_overlay(I)

/obj/structure/reagent_dispensers/fueltank/bullet_act(var/obj/item/projectile/Proj)
	//FIXME: Probably should check if it can actual inflict that structure damage first.
	if(Proj.get_structure_damage())
		if(isliving(Proj.firer))
			var/turf/turf = get_turf(src)
			if(turf)
				var/area/area = turf.loc || "*unknown area*"
				log_and_message_admins("[key_name_admin(Proj.firer)] shot a fuel tank in \the [area.proper_name].")
			else
				log_and_message_admins("shot a fuel tank outside the world.")

		if((Proj.damage_flags & DAM_EXPLODE) || (Proj.atom_damage_type == BURN) || (Proj.atom_damage_type == ELECTROCUTE) || (Proj.atom_damage_type == BRUTE))
			try_detonate_reagents()

	return ..()

/obj/structure/reagent_dispensers/fueltank/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C+500)
		try_detonate_reagents()
	return ..()

/obj/structure/reagent_dispensers/peppertank
	name             = "pepper spray refiller"
	desc             = "Refills pepper spray canisters."
	icon             = 'icons/obj/objects.dmi'
	icon_state       = "peppertank"
	anchored         = TRUE
	density          = FALSE
	amount_dispensed = 45

/obj/structure/reagent_dispensers/peppertank/populate_reagents()
	add_to_reagents(/decl/material/liquid/capsaicin/condensed, reagents.maximum_volume)

/obj/structure/reagent_dispensers/water_cooler
	name                      = "water cooler"
	desc                      = "A machine that dispenses cool water to drink."
	icon                      = 'icons/obj/structures/water_cooler.dmi'
	icon_state                = "water_cooler"
	possible_transfer_amounts = null
	amount_dispensed          = 5
	anchored                  = TRUE
	chem_volume               = 500
	tool_interaction_flags    = (TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT)
	var/cups                  = 12
	var/tmp/max_cups          = 12
	var/tmp/cup_type          = /obj/item/chems/drinks/sillycup

/obj/structure/reagent_dispensers/water_cooler/populate_reagents()
	add_to_reagents(/decl/material/liquid/water, reagents.maximum_volume)

/obj/structure/reagent_dispensers/water_cooler/attack_hand(var/mob/user)
	if(user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return dispense_cup(user)
	return ..()

/obj/structure/reagent_dispensers/water_cooler/proc/dispense_cup(var/mob/user, var/skip_text = FALSE)
	if(cups > 0)
		var/cup = new cup_type(loc)
		user.put_in_active_hand(cup)
		cups--
		if(!skip_text)
			visible_message("\The [user] grabs a paper cup from \the [src].", "You grab a paper cup from \the [src]'s cup compartment.")
		return TRUE

	if(!skip_text)
		to_chat(user, "\The [src]'s cup dispenser is empty.")
	return TRUE

/obj/structure/reagent_dispensers/water_cooler/attackby(obj/item/used_item, mob/user)
	//Allow refilling with a box
	if(cups < max_cups && used_item?.storage)
		for(var/obj/item/chems/drinks/C in used_item.storage.get_contents())
			if(cups >= max_cups)
				break
			if(istype(C, cup_type))
				used_item.storage.remove_from_storage(user, C, src)
				qdel(C)
				cups++
		return TRUE
	return ..()

/obj/structure/reagent_dispensers/water_cooler/on_reagent_change()
	. = ..()
	// Bubbles in top of cooler.
	if(reagents?.total_volume)
		var/vend_state = "[icon_state]-vend"
		if(check_state_in_icon(vend_state, icon))
			flick(vend_state, src)

/obj/structure/reagent_dispensers/beerkeg
	name             = "beer keg"
	desc             = "A beer keg."
	icon_state       = "beertankTEMP"
	amount_dispensed = 10
	atom_flags       = ATOM_FLAG_CLIMBABLE
	material         = /decl/material/solid/metal/aluminium
	matter           = list(/decl/material/solid/metal/stainlesssteel = MATTER_AMOUNT_TRACE)

/obj/structure/reagent_dispensers/beerkeg/populate_reagents()
	add_to_reagents(/decl/material/liquid/alcohol/beer, reagents.maximum_volume)

/obj/structure/reagent_dispensers/acid
	name             = "sulfuric acid dispenser"
	desc             = "A dispenser of acid for industrial processes."
	icon_state       = "acidtank"
	amount_dispensed = 10
	anchored         = TRUE
	density          = FALSE

/obj/structure/reagent_dispensers/acid/populate_reagents()
	add_to_reagents(/decl/material/liquid/acid, reagents.maximum_volume)

//Interactions
/obj/structure/reagent_dispensers/get_alt_interactions(var/mob/user)
	. = ..()
	if(can_toggle_open)
		LAZYADD(., /decl/interaction_handler/toggle_open/reagent_dispenser)

//Allows normal refilling, or toggle back to normal reagent dispenser operation
/decl/interaction_handler/toggle_open/reagent_dispenser
	name                 = "Toggle refilling cap"
	expected_target_type = /obj/structure/reagent_dispensers
	examine_desc         = "open or close the refilling cap"

/decl/interaction_handler/toggle_open/reagent_dispenser/invoked(atom/target, mob/user, obj/item/prop)
	if(target.atom_flags & ATOM_FLAG_OPEN_CONTAINER)
		target.atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER
	else
		target.atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	target.update_icon()
	return TRUE
