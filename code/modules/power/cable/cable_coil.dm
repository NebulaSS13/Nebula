///////////////////////////////////////////////
// The cable coil object, used for laying cable
///////////////////////////////////////////////

////////////////////////////////
// Definitions
////////////////////////////////

#define MAXCOIL 30

/obj/item/stack/cable_coil
	name = "multipurpose cable coil"
	icon = 'icons/obj/items/cable_coil.dmi'
	icon_state = ICON_STATE_WORLD
	randpixel = 2
	amount = MAXCOIL
	max_amount = MAXCOIL
	color = COLOR_MAROON
	paint_color = COLOR_MAROON
	desc = "A coil of wiring, suitable for both delicate electronics and heavy-duty power supply."
	singular_name = "length of cable"
	plural_name = "lengths of cable"
	w_class = ITEM_SIZE_NORMAL
	throw_speed = 2
	throw_range = 5
	material = /decl/material/solid/metal/copper
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE
	)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY
	item_state = "coil"
	attack_verb = list("whipped", "lashed", "disciplined", "flogged")
	stack_merge_type = /obj/item/stack/cable_coil
	matter_multiplier = 0.15
	/// Whether or not this cable coil can even have a color in the first place.
	var/can_have_color = TRUE
	/// The type of cable structure produced when laying down this cable.
	/// src.cable_type::cable_type should equal stack_merge_type, ideally
	var/cable_type = /obj/structure/cable

/obj/item/stack/cable_coil/single
	amount = 1

/obj/item/stack/cable_coil/cyborg
	name = "cable coil synthesizer"
	desc = "A device that makes cable."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(1)
	max_health = ITEM_HEALTH_NO_DAMAGE
	is_spawnable_type = FALSE

/obj/item/stack/cable_coil/Initialize(mapload, c_length, var/param_color = null)
	. = ..(mapload, c_length)
	set_extension(src, /datum/extension/tool/variable/simple, list(
		TOOL_CABLECOIL = TOOL_QUALITY_DEFAULT,
		TOOL_SUTURES =   TOOL_QUALITY_MEDIOCRE
	))
	if (can_have_color && param_color) // It should be red by default, so only recolor it if parameter was specified.
		set_color(param_color)
	update_icon()
	update_wclass()

///////////////////////////////////
// General procedures
///////////////////////////////////

//you can use wires to heal robotics
/obj/item/stack/cable_coil/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	var/obj/item/organ/external/affecting = istype(target) && GET_EXTERNAL_ORGAN(target, user?.get_target_zone())
	if(affecting && user.check_intent(I_FLAG_HELP))
		if(!affecting.is_robotic())
			to_chat(user, SPAN_WARNING("\The [target]'s [affecting.name] is not robotic. \The [src] cannot repair it."))
		else if(BP_IS_BRITTLE(affecting))
			to_chat(user, SPAN_WARNING("\The [target]'s [affecting.name] is hard and brittle. \The [src] cannot repair it."))
		else
			var/use_amt = min(src.amount, ceil(affecting.burn_dam/3), 5)
			if(can_use(use_amt) && affecting.robo_repair(3*use_amt, BURN, "some damaged wiring", src, user))
				use(use_amt)
		return TRUE
	return ..()

/obj/item/stack/cable_coil/on_update_icon()
	. = ..()
	if (!paint_color && can_have_color)
		var/list/possible_cable_colours = get_global_cable_colors()
		set_color(possible_cable_colours[pick(possible_cable_colours)])
	if(amount == 1)
		icon_state = "coil1"
		SetName("cable piece")
	else if(amount == 2)
		icon_state = "coil2"
		SetName("cable piece")
	else if(amount > 2 && amount != max_amount)
		icon_state = "coil"
		SetName(initial(name))
	else
		icon_state = "coil-max"
		SetName(initial(name))

/obj/item/stack/cable_coil/proc/set_cable_color(var/selected_color, var/user)
	if(!selected_color || !can_have_color)
		return

	var/list/possible_cable_colours = get_global_cable_colors()
	var/final_color = possible_cable_colours[selected_color]
	if(!final_color)
		selected_color = "Red"
		final_color = possible_cable_colours[selected_color]
	set_color(final_color)
	to_chat(user, SPAN_NOTICE("You change \the [src]'s color to [lowertext(selected_color)]."))

/obj/item/stack/cable_coil/proc/update_wclass()
	if(amount == 1)
		w_class = ITEM_SIZE_TINY
	else
		w_class = ITEM_SIZE_SMALL

/obj/item/stack/cable_coil/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance > 1)
		return
	if(get_amount() == 1)
		. += "\A [singular_name]."
	else if(get_amount() == 2)
		. += "Two [plural_name]."
	else
		. += "A coil of power cable. There are [get_amount()] [plural_name] in the coil."

/obj/item/stack/cable_coil/verb/make_restraint()
	set name = "Make Cable Restraints"
	set category = "Object"
	var/mob/M = usr

	if(ishuman(M) && !M.incapacitated())
		if(!isturf(usr.loc)) return
		if(!src.use(15))
			to_chat(usr, SPAN_WARNING("You need at least 15 [plural_name] of cable to make restraints!"))
			return
		var/obj/item/handcuffs/cable/B = new /obj/item/handcuffs/cable(usr.loc)
		B.set_color(color)
		to_chat(usr, SPAN_NOTICE("You wind some [plural_name] of cable together to make some restraints."))
	else
		to_chat(usr, SPAN_NOTICE("You cannot do that."))

/obj/item/stack/cable_coil/cyborg/verb/set_colour()
	set name = "Change Colour"
	set category = "Object"

	var/selected_type = input("Pick new colour.", "Cable Colour", null, null) as null|anything in get_global_cable_colors()
	set_cable_color(selected_type, usr)

// Items usable on a cable coil :
//   - Wirecutters : cut them duh !
//   - Cable coil : merge cables
/obj/item/stack/cable_coil/can_merge_stacks(var/obj/item/stack/other)
	return !other || (istype(other) && other.color == color)

/obj/item/stack/cable_coil/cyborg/can_merge_stacks(var/obj/item/stack/other)
	return TRUE

/obj/item/stack/cable_coil/transfer_to(obj/item/stack/cable_coil/coil)
	if(!istype(coil))
		return 0
	if(!(can_merge_stacks(coil) || coil.can_merge_stacks(src)))
		return 0

	return ..()

///////////////////////////////////////////////
// Cable laying procedures
//////////////////////////////////////////////

// called when cable_coil is clicked on a turf
/obj/item/stack/cable_coil/proc/turf_place(turf/F, mob/user)
	if(!isturf(user.loc))
		return

	if(get_amount() < 1) // Out of cable
		to_chat(user, SPAN_WARNING("There is no [plural_name] left."))
		return

	if(get_dist(F,user) > 1) // Too far
		to_chat(user, SPAN_WARNING("You can't lay cable at a place that far away."))
		return

	if(!F.is_plating())		// Ff floor is intact, complain
		to_chat(user, SPAN_WARNING("You can't lay cable there unless the floor tiles are removed."))
		return

	var/dirn
	if(user.loc == F)
		dirn = user.dir			// if laying on the tile we're on, lay in the direction we're facing
	else
		dirn = get_dir(F, user)

	var/end_dir = 0
	if(istype(F) && F.is_open())
		if(!can_use(2))
			to_chat(user, SPAN_WARNING("You don't have enough [plural_name] of cable to do this!"))
			return
		end_dir = DOWN

	for(var/obj/structure/cable/LC in F)
		if((LC.d1 == dirn && LC.d2 == end_dir ) || ( LC.d2 == dirn && LC.d1 == end_dir))
			to_chat(user, SPAN_WARNING("There's already a cable at that position."))
			return

	put_cable(F, user, end_dir, dirn)
	if(end_dir == DOWN)
		put_cable(GetBelow(F), user, UP, 0)
	return TRUE

// called when cable_coil is click on an installed obj/cable
// or click on a turf that already contains a "node" cable
/obj/item/stack/cable_coil/proc/cable_join(obj/structure/cable/C, mob/user)
	var/turf/U = user.loc
	if(!isturf(U))
		return

	var/turf/T = C.loc

	if(!isturf(T) || !T.is_plating())		// sanity checks, also stop use interacting with T-scanner revealed cable
		return

	if(get_dist(C, user) > 1)		// make sure it's close enough
		to_chat(user, SPAN_WARNING("You can't lay cable at a place that far away."))
		return

	if(U == T) //if clicked on the turf we're standing on, try to put a cable in the direction we're facing
		return turf_place(T,user)

	var/dirn = get_dir(C, user)

	// one end of the clicked cable is pointing towards us
	if(C.d1 == dirn || C.d2 == dirn)
		if(!U.is_plating())						// can't place a cable if the floor is complete
			to_chat(user, SPAN_WARNING("You can't lay cable there unless the floor tiles are removed."))
			return
		else
			// cable is pointing at us, we're standing on an open tile
			// so create a stub pointing at the clicked cable on our tile

			var/fdirn = turn(dirn, 180)		// the opposite direction

			for(var/obj/structure/cable/LC in U)		// check to make sure there's not a cable there already
				if(LC.d1 == fdirn || LC.d2 == fdirn)
					to_chat(user, SPAN_WARNING("There's already a cable at that position."))
					return
			put_cable(U,user,0,fdirn)
			return TRUE

	// exisiting cable doesn't point at our position, so see if it's a stub
	else if(C.d1 == 0)
							// if so, make it a full cable pointing from it's old direction to our dirn
		var/nd1 = C.d2	// these will be the new directions
		var/nd2 = dirn


		if(nd1 > nd2)		// swap directions to match icons/states
			nd1 = dirn
			nd2 = C.d2


		for(var/obj/structure/cable/LC in T)		// check to make sure there's no matching cable
			if(LC == C)			// skip the cable we're interacting with
				continue
			if((LC.d1 == nd1 && LC.d2 == nd2) || (LC.d1 == nd2 && LC.d2 == nd1) )	// make sure no cable matches either direction
				to_chat(user, SPAN_WARNING("There's already a cable at that position."))
				return


		C.cableColor(color)

		C.d1 = nd1
		C.d2 = nd2

		C.add_fingerprint()
		C.update_icon()


		C.mergeConnectedNetworks(C.d1) //merge the powernets...
		C.mergeConnectedNetworks(C.d2) //...in the two new cable directions
		C.mergeConnectedNetworksOnTurf()

		if(C.d1 & (C.d1 - 1))// if the cable is layed diagonally, check the others 2 possible directions
			C.mergeDiagonalsNetworks(C.d1)

		if(C.d2 & (C.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
			C.mergeDiagonalsNetworks(C.d2)

		use(1)

		if (C.shock(user, 50))
			if (prob(50)) //fail
				new/obj/item/stack/cable_coil(C.loc, 2, C.color)
				qdel(C)
				return

		C.denode()// this call may have disconnected some cables that terminated on the centre of the turf, if so split the powernets.
		return TRUE

	else if(C.d1 == UP) //Special cases for zcables, since they behave weirdly
		. = turf_place(T, user)
		if(.)
			to_chat(user, SPAN_NOTICE("You connect the cable hanging from the ceiling."))
		return .

/obj/item/stack/cable_coil/proc/put_cable(turf/F, mob/user, d1, d2)
	if(!istype(F))
		return FALSE

	var/obj/structure/cable/C = new cable_type(F)
	C.cableColor(color)
	C.d1 = d1
	C.d2 = d2
	C.add_fingerprint(user)
	C.update_icon()

	//create a new powernet with the cable, if needed it will be merged later
	var/datum/powernet/PN = new()
	PN.add_cable(C)

	C.mergeConnectedNetworks(C.d1) //merge the powernets...
	C.mergeConnectedNetworks(C.d2) //...in the two new cable directions
	C.mergeConnectedNetworksOnTurf()

	if(C.d1 & (C.d1 - 1))// if the cable is layed diagonally, check the others 2 possible directions
		C.mergeDiagonalsNetworks(C.d1)

	if(C.d2 & (C.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
		C.mergeDiagonalsNetworks(C.d2)

	. = use(1)
	if (C.shock(user, 50))
		if (prob(50)) //fail
			new/obj/item/stack/cable_coil(C.loc, 1, C.color)
			qdel(C)
			return FALSE

//////////////////////////////
// Misc.
/////////////////////////////
/obj/item/stack/cable_coil/five
	amount = 5

/obj/item/stack/cable_coil/cut
	item_state = "coil2"

/obj/item/stack/cable_coil/cut/Initialize()
	. = ..()
	src.amount = rand(1,2)
	update_icon()
	update_wclass()

/obj/item/stack/cable_coil/yellow
	color = COLOR_AMBER
	paint_color = COLOR_AMBER

/obj/item/stack/cable_coil/blue
	color = COLOR_CYAN_BLUE
	paint_color = COLOR_CYAN_BLUE

/obj/item/stack/cable_coil/green
	color = COLOR_GREEN
	paint_color = COLOR_GREEN

/obj/item/stack/cable_coil/pink
	color = COLOR_PURPLE
	paint_color = COLOR_PURPLE

/obj/item/stack/cable_coil/orange
	color = COLOR_ORANGE
	paint_color = COLOR_ORANGE

/obj/item/stack/cable_coil/cyan
	color = COLOR_SKY_BLUE
	paint_color = COLOR_SKY_BLUE

/obj/item/stack/cable_coil/white
	color = COLOR_SILVER
	paint_color = COLOR_SILVER

/obj/item/stack/cable_coil/lime
	color = COLOR_LIME
	paint_color = COLOR_LIME

/obj/item/stack/cable_coil/random/Initialize(mapload, c_length, param_color)
	var/list/possible_cable_colours = get_global_cable_colors()
	set_color(possible_cable_colours[pick(possible_cable_colours)])
	. = ..()

// Produces cable coil from a rig power cell.
/obj/item/stack/cable_coil/fabricator
	name = "cable fabricator"
	var/cost_per_cable = 10

/obj/item/stack/cable_coil/fabricator/split(var/tamount, var/force=FALSE)
	return

/obj/item/stack/cable_coil/fabricator/get_cell()
	if(istype(loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = loc
		return module.get_cell()
	if(isrobot(loc))
		var/mob/living/silicon/robot/robot = loc
		return robot.get_cell()

/obj/item/stack/cable_coil/fabricator/use(var/used)
	var/obj/item/cell/cell = get_cell()
	return cell?.use(used * cost_per_cable)

/obj/item/stack/cable_coil/fabricator/get_amount()
	var/obj/item/cell/cell = get_cell()
	. = (cell ? floor(cell.charge / cost_per_cable) : 0)

/obj/item/stack/cable_coil/fabricator/get_max_amount()
	var/obj/item/cell/cell = get_cell()
	. = (cell ? floor(cell.maxcharge / cost_per_cable) : 0)
