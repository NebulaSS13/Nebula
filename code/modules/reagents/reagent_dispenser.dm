
/obj/structure/reagent_dispensers
	name = "dispenser"
	desc = "..."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	density = 1
	anchored = 0

	var/initial_capacity = 1000
	var/initial_reagent_types  // A list of reagents and their ratio relative the initial capacity. list(/datum/reagent/water = 0.5) would fill the dispenser halfway to capacity.
	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = @"[10,25,50,100,500]"

/obj/structure/reagent_dispensers/Initialize()
	. = ..()
	create_reagents(initial_capacity)

	if (!possible_transfer_amounts)
		verbs -= /obj/structure/reagent_dispensers/verb/set_amount_per_transfer_from_this

	for(var/reagent_type in initial_reagent_types)
		var/reagent_ratio = initial_reagent_types[reagent_type]
		reagents.add_reagent(reagent_type, reagent_ratio * initial_capacity)

/obj/structure/reagent_dispensers/examine(mob/user, distance)
	. = ..()
	if(distance <= 2)
		to_chat(user, SPAN_NOTICE("It contains:"))
		if(reagents && reagents.reagent_list.len)
			for(var/datum/reagent/R in reagents.reagent_list)
				to_chat(user, SPAN_NOTICE("[R.volume] units of [R.name]"))
		else
			to_chat(user, SPAN_NOTICE("Nothing."))

/obj/structure/reagent_dispensers/verb/set_amount_per_transfer_from_this()
	set name = "Set transfer amount"
	set category = "Object"
	set src in view(1)
	if(!CanPhysicallyInteract(usr))
		to_chat(usr, SPAN_NOTICE("You're in no condition to do that!'"))
		return
	var/N = input("Amount per transfer from this:","[src]") as null|anything in cached_json_decode(possible_transfer_amounts)
	if(!CanPhysicallyInteract(usr))  // because input takes time and the situation can change
		to_chat(usr, SPAN_NOTICE("You're in no condition to do that!'"))
		return
	if (N)
		amount_per_transfer_from_this = N

/obj/structure/reagent_dispensers/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				new /obj/effect/effect/water(loc)
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				new /obj/effect/effect/water(loc)
				qdel(src)
				return
		else
	return

/obj/structure/reagent_dispensers/AltClick(var/mob/user)
	if(possible_transfer_amounts)
		set_amount_per_transfer_from_this()
	else
		return ..()


//Dispensers
/obj/structure/reagent_dispensers/watertank
	name = "water tank"
	desc = "A tank containing water."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	amount_per_transfer_from_this = 10
	var/modded = 0
	var/fill_level = FLUID_SHALLOW // Can be adminbussed for silly room-filling tanks.
	possible_transfer_amounts = @"[10,25,50,100]"
	initial_capacity = 50000
	initial_reagent_types = list(/datum/reagent/water = 1)
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE

/obj/structure/reagent_dispensers/watertank/proc/drain_water()
	if(reagents.total_volume <= 0)
		return

	// To prevent it from draining while in a container.
	if(!isturf(loc))
		return

	// Check for depth first, and pass if the water's too high. A four foot high water tank
	// cannot jettison water above the level of a grown adult's head!
	var/turf/T = get_turf(src)

	if(!T || T.get_fluid_depth() > fill_level)
		return

	// For now, this cheats and only checks/leaks water, pending additions to the fluid system.
	var/W = reagents.remove_reagent(/datum/reagent/water, amount_per_transfer_from_this * 5)
	if(W > 0)
		// Artificially increased flow - a 1:1 rate doesn't result in very much water at all.
		T.add_fluid(W * 100, /datum/reagent/water)

/obj/structure/reagent_dispensers/watertank/examine(mob/user)
	. = ..()
	if(modded)
		to_chat(user, SPAN_WARNING("Someone has wrenched open its tap - it's spilling everywhere!"))

/obj/structure/reagent_dispensers/watertank/attackby(obj/item/W, mob/user)
	if((istype(W, /obj/item/robot_parts/l_arm) || istype(W, /obj/item/robot_parts/r_arm)) && user.unEquip(W))
		to_chat(user, "You add \the [W] arm to \the [src].")
		qdel(W)
		new /obj/item/farmbot_arm_assembly(loc, src)
		return TRUE
	if(isWrench(W))
		modded = !modded
		visible_message(SPAN_NOTICE("\The [user] wrenches \the [src]'s tap [modded ? "open" : "shut"]."))
		if (modded)
			log_and_message_admins("opened a water tank at [get_area(loc)], leaking water.")
			// Allows the water tank to continuously expel water, differing it from the fuel tank.
			START_PROCESSING(SSprocessing, src)
		else
			STOP_PROCESSING(SSprocessing, src)
		return TRUE
	return FALSE

/obj/structure/reagent_dispensers/watertank/Process()
	if(modded)
		drain_water()

/obj/structure/reagent_dispensers/watertank/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/structure/reagent_dispensers/fueltank
	name = "fuel tank"
	desc = "A tank containing welding fuel."
	icon = 'icons/obj/objects.dmi'
	icon_state = "weldtank"
	amount_per_transfer_from_this = 10
	var/modded = 0
	var/obj/item/assembly_holder/rig = null
	initial_reagent_types = list(/datum/reagent/fuel = 1)
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/structure/reagent_dispensers/fueltank/examine(mob/user)
	. = ..()
	if (modded)
		to_chat(user, SPAN_WARNING("The faucet is wrenched open, leaking fuel!"))
	if(rig)
		to_chat(user, SPAN_WARNING("There is some kind of device rigged to the tank."))

/obj/structure/reagent_dispensers/fueltank/attack_hand(var/mob/user)
	if (rig)
		visible_message(SPAN_NOTICE("\The [user] begins to detach \the [rig] from \the [src]."))
		if(do_after(user, 20, src))
			visible_message(SPAN_NOTICE("\The [user] detaches \the [rig] from \the [src]."))
			rig.dropInto(loc)
			rig = null
			overlays.Cut()

/obj/structure/reagent_dispensers/fueltank/attackby(obj/item/W, mob/user)
	add_fingerprint(user)
	if(isWrench(W))
		visible_message(SPAN_NOTICE("\The [user] wrenches \the [src]'s faucet [modded ? "closed" : "open"]."))
		modded = !modded
		if(modded)
			log_and_message_admins("opened a fuel tank at [loc.loc.name], leaking fuel.")
			leak_fuel(amount_per_transfer_from_this)
		return TRUE
	if(istype(W,/obj/item/assembly_holder))
		if (rig)
			to_chat(user, SPAN_WARNING("There is another device already in the way."))
			return ..()
		visible_message(SPAN_NOTICE("\The [user] begins rigging \the [W] to \the [src]."))
		if(do_after(user, 20, src) && user.unEquip(W, src))
			visible_message(SPAN_NOTICE("\The [user] rigs \the [W] to \the [src]."))
			var/obj/item/assembly_holder/H = W
			if (istype(H.a_left,/obj/item/assembly/igniter) || istype(H.a_right,/obj/item/assembly/igniter))
				log_and_message_admins("rigged a fuel tank for explosion at [loc.loc.name].")
			rig = W
			var/icon/test = getFlatIcon(W)
			test.Shift(NORTH,1)
			test.Shift(EAST,6)
			overlays += test
		return TRUE
	if(isflamesource(W))
		log_and_message_admins("triggered a fuel tank explosion with \the [W].")
		visible_message(SPAN_DANGER("\The [user] puts \the [W] to \the [src]!"))
		explode()
		return TRUE
	return FALSE

/obj/structure/reagent_dispensers/fueltank/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		if(istype(Proj.firer))
			var/turf/turf = get_turf(src)
			if(turf)
				var/area/area = turf.loc || "*unknown area*"
				log_and_message_admins("[key_name_admin(Proj.firer)] shot a fuel tank in \the [area].")
			else
				log_and_message_admins("shot a fuel tank outside the world.")

		if(!istype(Proj ,/obj/item/projectile/beam/lastertag) && !istype(Proj ,/obj/item/projectile/beam/practice) )
			explode()

/obj/structure/reagent_dispensers/fueltank/proc/explode()
	for(var/datum/reagent/R in reagents.reagent_list)
		R.ex_act(src, 1)
	qdel(src)

/obj/structure/reagent_dispensers/fueltank/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if (modded)
		explode()
	else if (exposed_temperature > T0C+500)
		explode()
	return ..()

/obj/structure/reagent_dispensers/fueltank/Move()
	if (..() && modded)
		leak_fuel(amount_per_transfer_from_this/10.0)

/obj/structure/reagent_dispensers/fueltank/proc/leak_fuel(amount)
	if (reagents.total_volume > 0)
		amount = min(amount, reagents.total_volume)
		reagents.remove_reagent(/datum/reagent/fuel,amount)
		new /obj/effect/decal/cleanable/liquid_fuel(loc, amount,1)

/obj/structure/reagent_dispensers/peppertank
	name = "pepper spray refiller"
	desc = "Refills pepper spray canisters."
	icon = 'icons/obj/objects.dmi'
	icon_state = "peppertank"
	anchored = 1
	density = 0
	amount_per_transfer_from_this = 45
	initial_reagent_types = list(/datum/reagent/capsaicin/condensed = 1)

/obj/structure/reagent_dispensers/water_cooler
	name = "water cooler"
	desc = "A machine that dispenses cool water to drink."
	amount_per_transfer_from_this = 5
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler"
	possible_transfer_amounts = null
	anchored = 1
	initial_capacity = 500
	initial_reagent_types = list(/datum/reagent/water = 1)
	tool_interaction_flags = (TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT)
	var/cups = 12
	var/cup_type = /obj/item/chems/food/drinks/sillycup

/obj/structure/reagent_dispensers/water_cooler/attack_hand(var/mob/user)
	if(cups > 0)
		var/visible_messages = DispenserMessages(user)
		visible_message(visible_messages[1], visible_messages[2])
		var/cup = new cup_type(loc)
		user.put_in_active_hand(cup)
		cups--
	else
		to_chat(user, RejectionMessage(user))

/obj/structure/reagent_dispensers/water_cooler/proc/DispenserMessages(var/mob/user)
	return list("\The [user] grabs a paper cup from \the [src].", "You grab a paper cup from \the [src]'s cup compartment.")

/obj/structure/reagent_dispensers/water_cooler/proc/RejectionMessage(var/mob/user)
	return "The [src]'s cup dispenser is empty."

/obj/structure/reagent_dispensers/water_cooler/attackby(obj/item/W, mob/user)
	. = ..()
	if(!.)
		flick("[icon_state]-vend", src)

/obj/structure/reagent_dispensers/beerkeg
	name = "beer keg"
	desc = "A beer keg."
	icon = 'icons/obj/objects.dmi'
	icon_state = "beertankTEMP"
	amount_per_transfer_from_this = 10
	initial_reagent_types = list(/datum/reagent/ethanol/beer = 1)
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/structure/reagent_dispensers/acid
	name = "sulphuric acid dispenser"
	desc = "A dispenser of acid for industrial processes."
	icon = 'icons/obj/objects.dmi'
	icon_state = "acidtank"
	amount_per_transfer_from_this = 10
	anchored = 1
	initial_reagent_types = list(/datum/reagent/acid = 1)
