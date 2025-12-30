//Dummy object for holding items in vehicles.
//Prevents items from being interacted with.
/datum/vehicle_dummy_load
	var/actual_load

/obj/vehicle
	name = "vehicle"
	icon = 'icons/obj/vehicles.dmi'
	layer = ABOVE_HUMAN_LAYER
	density = TRUE
	anchored = TRUE
	animate_movement=1
	light_range = 3
	abstract_type = /obj/vehicle

	can_buckle = 1
	buckle_movable = 1
	buckle_lying = 0

	var/attack_log = null
	var/on = 0
	var/fire_dam_coeff = 1.0
	var/brute_dam_coeff = 1.0
	var/open = 0	//Maint panel
	var/locked = 1
	var/stat = 0
	var/emagged = 0
	var/powered = 0		//set if vehicle is powered and should use fuel when moving
	var/move_delay = 1	//set this to limit the speed of the vehicle

	var/obj/item/cell/cell
	var/charge_use = 200 // W

	var/atom/movable/load		//all vehicles can take a load, since they should all be a least drivable
	var/load_item_visible = 1	//set if the loaded item should be overlayed on the vehicle sprite
	var/load_offset_x = 0		//pixel_x offset for item overlay
	var/load_offset_y = 0		//pixel_y offset for item overlay

//-------------------------------------------
// Standard procs
//-------------------------------------------

/obj/vehicle/Move()
	if(world.time > l_move_time + move_delay)
		var/old_loc = get_turf(src)
		if(on && powered && cell.charge < (charge_use * CELLRATE))
			turn_off()

		var/init_anc = anchored
		anchored = FALSE
		if(!..())
			anchored = init_anc
			return 0

		set_dir(get_dir(old_loc, loc))
		anchored = init_anc

		if(on && powered)
			cell.use(charge_use * CELLRATE)

		//Dummy loads do not have to be moved as they are just an overlay
		//See load_object() proc in cargo_trains.dm for an example
		if(load && !istype(load, /datum/vehicle_dummy_load))
			load.forceMove(loc)
			load.set_dir(dir)

		return 1
	else
		return 0

/obj/vehicle/attackby(obj/item/used_item, mob/user)
	if(istype(used_item, /obj/item/hand_labeler))
		return FALSE // allow afterattack to run
	if(IS_SCREWDRIVER(used_item))
		if(!locked)
			open = !open
			update_icon()
			to_chat(user, "<span class='notice'>Maintenance panel is now [open ? "opened" : "closed"].</span>")
			return TRUE
		to_chat(user, SPAN_WARNING("You can't [open ? "close" : "open"] the maintenance panel while \the [src] is locked!"))
		return TRUE
	else if(IS_CROWBAR(used_item) && cell && open)
		remove_cell(user)
		return TRUE
	else if(istype(used_item, /obj/item/cell) && !cell && open)
		insert_cell(used_item, user)
		return TRUE
	else if(IS_WELDER(used_item))
		var/current_max_health = get_max_health()
		if(current_health >= current_max_health)
			to_chat(user, "<span class='notice'>[src] does not need repairs.</span>")
			return TRUE
		if(!open)
			to_chat(user, "<span class='notice'>Unable to repair with the maintenance panel closed.</span>")
			return TRUE
		var/obj/item/weldingtool/welder = used_item
		if(!welder.welding)
			to_chat(user, "<span class='notice'>Unable to repair while [used_item] is off.</span>")
			return TRUE
		if(welder.weld(5, user))
			current_health = min(current_max_health, current_health+10)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			user.visible_message("<span class='warning'>\The [user] repairs \the [src] with \the [welder]!</span>","<span class='notice'>You repair \the [src] with \the [welder]!</span>")
			return TRUE
		return TRUE // welder.weld already includes on-fail feedback
	return ..() // handles bash()

/obj/vehicle/bash(obj/item/weapon, mob/user)
	if(isliving(user) && user.check_intent(I_FLAG_HELP))
		return FALSE
	if(!weapon.user_can_attack_with(user))
		return FALSE
	if(weapon.item_flags & ITEM_FLAG_NO_BLUDGEON)
		return FALSE
	// physical damage types that can impart force; swinging a bat or energy sword
	switch(weapon.atom_damage_type)
		if(BURN)
			current_health -= weapon.expend_attack_force(user) * fire_dam_coeff
			. = TRUE
		if(BRUTE)
			current_health -= weapon.expend_attack_force(user) * brute_dam_coeff
			. = TRUE
		else
			. = FALSE
	if(.)
		healthcheck()

/obj/vehicle/bullet_act(var/obj/item/projectile/Proj)
	current_health -= Proj.get_structure_damage()
	..()
	healthcheck()

/obj/vehicle/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	if(severity == 1)
		explode()
	else
		if(severity == 2)
			current_health -= rand(5,10)*fire_dam_coeff
			current_health -= rand(10,20)*brute_dam_coeff
		else if(prob(50))
			current_health -= rand(1,5)*fire_dam_coeff
			current_health -= rand(1,5)*brute_dam_coeff
		healthcheck()

/obj/vehicle/emp_act(severity)
	addtimer(CALLBACK(src, PROC_REF(end_emp), on), severity * 30 SECONDS)
	stat |= EMPED
	var/obj/effect/temp_visual/emp_burst/burst = new /obj/effect/temp_visual/emp_burst(loc)
	burst.set_dir(pick(global.cardinal))
	if(on)
		turn_off()

/obj/vehicle/proc/end_emp(was_on)
	stat &= ~EMPED
	if(was_on)
		turn_on()

/obj/vehicle/attack_ai(mob/living/silicon/ai/user)
	return

/obj/vehicle/unbuckle_mob(mob/user)
	. = ..(user)
	if(load == .)
		unload(.)

//-------------------------------------------
// Vehicle procs
//-------------------------------------------
/obj/vehicle/proc/turn_on()
	if(stat)
		return 0
	if(powered && cell.charge < (charge_use * CELLRATE))
		return 0
	on = 1
	set_light(5, 0.8)
	update_icon()
	return 1

/obj/vehicle/proc/turn_off()
	on = 0
	set_light(0)
	update_icon()

/obj/vehicle/emag_act(var/remaining_charges, mob/user)
	if(!emagged)
		emagged = 1
		if(locked)
			locked = 0
			to_chat(user, "<span class='warning'>You bypass [src]'s controls.</span>")
		return 1

/obj/vehicle/proc/explode()
	src.visible_message("<span class='danger'>\The [src] blows apart!</span>")
	var/turf/my_turf = get_turf(src)

	SSmaterials.create_object(/decl/material/solid/metal/steel, get_turf(src), 2, /obj/item/stack/material/rods)
	new /obj/item/stack/cable_coil/cut(my_turf)

	if(cell)
		cell.forceMove(my_turf)
		cell.update_icon()
		cell = null

	//stuns people who are thrown off a train that has been blown up
	if(isliving(load))
		var/mob/living/M = load
		M.apply_effects(5, 5)

	unload()

	new /obj/effect/gibspawner/robot(my_turf)
	new /obj/effect/decal/cleanable/blood/oil(src.loc)

	qdel(src)

/obj/vehicle/proc/healthcheck()
	if(current_health <= 0)
		explode()

/obj/vehicle/proc/powercheck()
	if(!cell && !powered)
		return

	if(!cell && powered)
		turn_off()
		return

	if(cell.charge < (charge_use * CELLRATE))
		turn_off()
		return

	if(cell && powered)
		turn_on()
		return

/obj/vehicle/proc/insert_cell(var/obj/item/cell/cell, var/mob/living/user)
	if(cell)
		return
	if(!istype(cell))
		return
	if(!user.try_unequip(cell, src))
		return
	cell = cell
	powercheck()
	to_chat(user, "<span class='notice'>You install [cell] in [src].</span>")

/obj/vehicle/proc/remove_cell(var/mob/living/user)
	if(!cell)
		return

	to_chat(user, "<span class='notice'>You remove [cell] from [src].</span>")
	user.put_in_hands(cell)
	cell = null
	powercheck()

//-------------------------------------------
// Loading/unloading procs
//
// Set specific item restriction checks in
// the vehicle load() definition before
// calling this parent proc.
//-------------------------------------------
/obj/vehicle/proc/load(var/atom/movable/loading)
	//This loads objects onto the vehicle so they can still be interacted with.
	//Define allowed items for loading in specific vehicle definitions.
	if(!isturf(loading.loc)) //To prevent loading things from someone's inventory, which wouldn't get handled properly.
		return 0
	if(load || loading.anchored)
		return 0

	// if a create/closet, close before loading
	var/obj/structure/closet/crate = loading
	if(istype(crate) && crate.opened && !crate.close())
		return 0

	loading.forceMove(loc)
	loading.set_dir(dir)
	loading.anchored = TRUE

	load = loading

	if(load_item_visible)
		loading.plane = plane
		loading.layer = VEHICLE_LOAD_LAYER		//so it sits above the vehicle

	if(ismob(loading))
		buckle_mob(loading)
	else if(load_item_visible)
		loading.pixel_x += load_offset_x
		loading.pixel_y += load_offset_y

	return 1


/obj/vehicle/proc/unload(var/mob/user, var/direction)
	if(!load)
		return

	var/turf/dest = null

	//find a turf to unload to
	if(direction)	//if direction specified, unload in that direction
		dest = get_step(src, direction)
	else if(user)	//if a user has unloaded the vehicle, unload at their feet
		dest = get_turf(user)

	if(!dest)
		dest = get_step_to(src, get_step(src, turn(dir, 90))) //try unloading to the side of the vehicle first if neither of the above are present

	//if these all result in the same turf as the vehicle or nullspace, pick a new turf with open space
	if(!dest || dest == get_turf(src))
		var/list/options = new()
		for(var/test_dir in global.alldirs)
			var/new_dir = get_step_to(src, get_step(src, test_dir))
			if(new_dir && load.Adjacent(new_dir))
				options += new_dir
		if(options.len)
			dest = pick(options)
		else
			dest = get_turf(src)	//otherwise just dump it on the same turf as the vehicle

	if(!isturf(dest))	//if there still is nowhere to unload, cancel out since the vehicle is probably in nullspace
		return 0

	load.forceMove(dest)
	load.set_dir(get_dir(loc, dest))
	load.anchored = FALSE		//we can only load non-anchored items, so it makes sense to set this to false
	if(ismob(load)) //atoms should probably have their own procs to define how their pixel shifts and layer can be manipulated, someday
		var/mob/M = load
		M.pixel_x = M.default_pixel_x
		M.pixel_y = M.default_pixel_y
	else
		load.pixel_x = initial(load.pixel_x)
		load.pixel_y = initial(load.pixel_y)
	load.reset_plane_and_layer()

	if(ismob(load))
		unbuckle_mob(load)

	load = null
	update_icon()

	return 1


//-------------------------------------------------------
// Stat update procs
//-------------------------------------------------------
/obj/vehicle/proc/update_stats()
	return

/obj/vehicle/handle_buckled_relaymove(var/datum/movement_handler/mh, var/mob/mob, var/direction, var/mover)
	//drunk driving
	if(HAS_STATUS(mob, STAT_CONFUSE) && prob(20)) //vehicles tend to keep moving in the same direction
		direction = turn(direction, pick(90, -90))
	relaymove(mob, direction)
	return MOVEMENT_HANDLED
