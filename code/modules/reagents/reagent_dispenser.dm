
/obj/structure/reagent_dispensers
	name                              = "dispenser"
	desc                              = "A large tank for storing chemicals."
	icon                              = 'icons/obj/objects.dmi'
	icon_state                        = "watertank"
	density                           = TRUE
	anchored                          = FALSE
	material                          = /decl/material/solid/plastic
	matter                            = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_SECONDARY)
	maxhealth                         = 100
	tool_interaction_flags            = TOOL_INTERACTION_DECONSTRUCT
	var/unwrenched                    = FALSE
	var/tmp/volume                    = 1000
	var/amount_dispensed              = 10
	var/tmp/possible_transfer_amounts = @"[10,25,50,100,500]"

/obj/structure/reagent_dispensers/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	initialize_reagents()
	if (!possible_transfer_amounts)
		verbs -= /obj/structure/reagent_dispensers/verb/set_amount_dispensed

/obj/structure/reagent_dispensers/initialize_reagents(populate = TRUE)
	if(!reagents)
		create_reagents(volume)
	else
		reagents.maximum_volume = max(reagents.maximum_volume, volume)
	. = ..()

/obj/structure/reagent_dispensers/proc/leak()
	var/turf/T = get_turf(src)
	if(reagents && T)
		reagents.trans_to_turf(T, min(reagents.total_volume, FLUID_PUDDLE))

/obj/structure/reagent_dispensers/Move()
	. = ..()
	if(. && unwrenched)
		leak()

/obj/structure/reagent_dispensers/Process()
	if(!unwrenched)
		return PROCESS_KILL
	leak()

/obj/structure/reagent_dispensers/examine(mob/user, distance)
	. = ..()
	if(unwrenched)
		to_chat(user, SPAN_WARNING("Someone has wrenched open its tap - it's spilling everywhere!"))
	if(distance > 2)
		return

	if(ATOM_IS_OPEN_CONTAINER(src))
		to_chat(user, "Its refilling cap is open.")
	else
		to_chat(user, "Its refilling cap is closed.")

	if(reagents?.total_volume)
		to_chat(user, "It contains [reagents.total_volume] units of fluid.")
	else
		to_chat(user, "It's empty.")

	if(reagents?.maximum_volume)
		to_chat(user, "It may contain up to [reagents.maximum_volume] units of fluid.")

/obj/structure/reagent_dispensers/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/structure/reagent_dispensers/attackby(obj/item/W, mob/user)
	if(IS_WRENCH(W))
		unwrenched = !unwrenched
		visible_message(SPAN_NOTICE("\The [user] wrenches \the [src]'s tap [unwrenched ? "open" : "shut"]."))
		if(unwrenched)
			log_and_message_admins("opened a tank at [get_area_name(loc)].")
			START_PROCESSING(SSprocessing, src)
		else
			STOP_PROCESSING(SSprocessing, src)
		return TRUE
	. = ..()

/obj/structure/reagent_dispensers/examine(mob/user, distance)
	. = ..()
	if(distance <= 2)
		to_chat(user, SPAN_NOTICE("It contains:"))
		if(LAZYLEN(reagents?.reagent_volumes))
			for(var/rtype in reagents.reagent_volumes)
				var/decl/material/R = GET_DECL(rtype)
				to_chat(user, SPAN_NOTICE("[REAGENT_VOLUME(reagents, rtype)] units of [R.name]"))
		else
			to_chat(user, SPAN_NOTICE("Nothing."))

/obj/structure/reagent_dispensers/verb/set_amount_dispensed()
	set name = "Set amount dispensed"
	set category = "Object"
	set src in view(1)
	if(!CanPhysicallyInteract(usr))
		to_chat(usr, SPAN_NOTICE("You're in no condition to do that!'"))
		return
	var/N = input("Amount dispensed:","[src]") as null|anything in cached_json_decode(possible_transfer_amounts)
	if(!CanPhysicallyInteract(usr))  // because input takes time and the situation can change
		to_chat(usr, SPAN_NOTICE("You're in no condition to do that!'"))
		return
	if (N)
		amount_dispensed = N

/obj/structure/reagent_dispensers/physically_destroyed(var/skip_qdel)
	if(reagents?.total_volume)
		reagents.trans_to_turf(get_turf(src), reagents.total_volume)
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
	volume                    = 7500
	atom_flags                = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	movable_flags             = MOVABLE_FLAG_WHEELED

/obj/structure/reagent_dispensers/watertank/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/water, reagents.maximum_volume)

/obj/structure/reagent_dispensers/watertank/firefighter
	name   = "firefighting water reserve"
	volume = 50000

/obj/structure/reagent_dispensers/watertank/attackby(obj/item/W, mob/user)
	//FIXME: Maybe this should be handled differently? Since it can essentially make the tank unusable.
	if((istype(W, /obj/item/robot_parts/l_arm) || istype(W, /obj/item/robot_parts/r_arm)) && user.try_unequip(W))
		to_chat(user, "You add \the [W] arm to \the [src].")
		qdel(W)
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
	reagents.add_reagent(/decl/material/liquid/fuel, reagents.maximum_volume)

/obj/structure/reagent_dispensers/fueltank/examine(mob/user, distance)
	. = ..()
	if(rig && distance < 2)
		to_chat(user, SPAN_WARNING("There is some kind of device rigged to the tank."))

/obj/structure/reagent_dispensers/fueltank/attack_hand(var/mob/user)
	if (!rig || !user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return ..()
	visible_message(SPAN_NOTICE("\The [user] begins to detach \the [rig] from \the [src]."))
	if(!user.do_skilled(2 SECONDS, SKILL_ELECTRICAL, src))
		return TRUE
	visible_message(SPAN_NOTICE("\The [user] detaches \the [rig] from \the [src]."))
	rig.dropInto(loc)
	rig = null
	update_icon()
	return TRUE

/obj/structure/reagent_dispensers/fueltank/attackby(obj/item/W, mob/user)
	add_fingerprint(user)
	if(istype(W,/obj/item/assembly_holder))
		if (rig)
			to_chat(user, SPAN_WARNING("There is another device already in the way."))
			return ..()
		visible_message(SPAN_NOTICE("\The [user] begins rigging \the [W] to \the [src]."))
		if(do_after(user, 20, src) && user.try_unequip(W, src))
			visible_message(SPAN_NOTICE("\The [user] rigs \the [W] to \the [src]."))
			var/obj/item/assembly_holder/H = W
			if (istype(H.a_left,/obj/item/assembly/igniter) || istype(H.a_right,/obj/item/assembly/igniter))
				log_and_message_admins("rigged a fuel tank for explosion at [loc.loc.name].")
			rig = W
			update_icon()
		return TRUE
	if(W.isflamesource())
		log_and_message_admins("triggered a fuel tank explosion with \the [W].")
		visible_message(SPAN_DANGER("\The [user] puts \the [W] to \the [src]!"))
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

		if((Proj.damage_flags & DAM_EXPLODE) || (Proj.damage_type == BURN) || (Proj.damage_type == ELECTROCUTE) || (Proj.damage_type == BRUTE))
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
	reagents.add_reagent(/decl/material/liquid/capsaicin/condensed, reagents.maximum_volume)

/obj/structure/reagent_dispensers/water_cooler
	name                      = "water cooler"
	desc                      = "A machine that dispenses cool water to drink."
	icon                      = 'icons/obj/vending.dmi'
	icon_state                = "water_cooler"
	possible_transfer_amounts = null
	amount_dispensed          = 5
	anchored                  = TRUE
	volume                    = 500
	tool_interaction_flags    = (TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT)
	var/cups                  = 12
	var/tmp/max_cups          = 12
	var/tmp/cup_type          = /obj/item/chems/drinks/sillycup

/obj/structure/reagent_dispensers/water_cooler/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/water, reagents.maximum_volume)

/obj/structure/reagent_dispensers/water_cooler/attack_hand(var/mob/user)
	if(user.check_dexterity(DEXTERITY_GRIP, TRUE))
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
		to_chat(user, "The [src]'s cup dispenser is empty.")

/obj/structure/reagent_dispensers/water_cooler/attackby(obj/item/W, mob/user)
	//Allow refilling with a box
	if((cups < max_cups) && istype(W, /obj/item/storage))
		var/obj/item/storage/S = W
		for(var/obj/item/chems/drinks/C in S)
			if(cups >= max_cups)
				break
			if(istype(C, cup_type))
				S.remove_from_storage(C, src)
				qdel(C)
				cups++
		return TRUE

	. = ..()
	if(!. && ATOM_IS_OPEN_CONTAINER(W))
		flick("[icon_state]-vend", src)

/obj/structure/reagent_dispensers/beerkeg
	name             = "beer keg"
	desc             = "A beer keg."
	icon_state       = "beertankTEMP"
	amount_dispensed = 10
	atom_flags       = ATOM_FLAG_CLIMBABLE
	material         = /decl/material/solid/metal/aluminium
	matter           = list(/decl/material/solid/metal/stainlesssteel = MATTER_AMOUNT_TRACE)

/obj/structure/reagent_dispensers/beerkeg/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/beer, reagents.maximum_volume)

/obj/structure/reagent_dispensers/acid
	name             = "sulphuric acid dispenser"
	desc             = "A dispenser of acid for industrial processes."
	icon_state       = "acidtank"
	amount_dispensed = 10
	anchored         = TRUE

/obj/structure/reagent_dispensers/acid/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/acid, reagents.maximum_volume)

//Interactions
/obj/structure/reagent_dispensers/get_alt_interactions(var/mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/set_transfer/reagent_dispenser)
	LAZYADD(., /decl/interaction_handler/toggle_open/reagent_dispenser)

//Set amount dispensed
/decl/interaction_handler/set_transfer/reagent_dispenser
	expected_target_type = /obj/structure/reagent_dispensers

/decl/interaction_handler/set_transfer/reagent_dispenser/is_possible(var/atom/target, var/mob/user)
	. = ..()
	if(.)
		var/obj/structure/reagent_dispensers/R = target
		return !!R.possible_transfer_amounts

/decl/interaction_handler/set_transfer/reagent_dispenser/invoked(var/atom/target, var/mob/user)
	var/obj/structure/reagent_dispensers/R = target
	R.set_amount_dispensed()

//Allows normal refilling, or toggle back to normal reagent dispenser operation
/decl/interaction_handler/toggle_open/reagent_dispenser
	name                 = "Toggle refilling cap"
	expected_target_type = /obj/structure/reagent_dispensers

/decl/interaction_handler/toggle_open/reagent_dispenser/invoked(var/obj/structure/reagent_dispensers/target, var/mob/user)
	if(target.atom_flags & ATOM_FLAG_OPEN_CONTAINER)
		target.atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER
	else
		target.atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	return TRUE