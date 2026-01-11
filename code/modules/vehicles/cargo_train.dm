/obj/vehicle/train/engine
	name = "cargo train tug"
	desc = "A ridable electric car designed for pulling cargo trolleys."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "cargo_engine"
	on = 0
	powered = 1
	locked = 0

	load_item_visible = 1
	load_offset_x = 0
	buckle_pixel_shift = list("x" = 0, "y" = 0, "z" = 7)
	charge_use = 1 KILOWATTS
	active_engines = 1

	var/car_limit = 3		//how many cars an engine can pull before performance degrades
	var/obj/item/key/key
	var/key_type = /obj/item/key/cargo_train

/obj/item/key/cargo_train
	desc = "A small key on a yellow fob reading \"Choo Choo!\"."
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT
	)
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "train_keys"
	w_class = ITEM_SIZE_TINY

//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/train/engine/Initialize()
	. = ..()
	cell = new /obj/item/cell/high(src)
	key = new key_type(src)
	update_icon()
	turn_off()	//so engine verbs are correctly set

/obj/vehicle/train/engine/on_update_icon()
	. = ..()
	var/image/I = image(icon, "cargo_engine_overlay")
	I.plane = plane
	I.layer = layer
	set_overlays(I)

/obj/vehicle/train/engine/Move(var/turf/destination)
	if(on && cell.charge < (charge_use * CELLRATE))
		turn_off()
		update_stats()
		if(load && is_train_head())
			to_chat(load, "The drive motor briefly whines, then drones to a stop.")

	if(is_train_head() && !on)
		return 0

	//space check ~no flying space trains sorry
	if(on && isspaceturf(destination))
		return 0

	return ..()

/obj/vehicle/train/engine/attackby(obj/item/used_item, mob/user)
	if(istype(used_item, key_type))
		if(!key && user.try_unequip(used_item, src))
			key = used_item
			verbs |= /obj/vehicle/train/engine/verb/remove_key
		return TRUE
	return ..()

/obj/vehicle/train/engine/insert_cell(var/obj/item/cell/cell, var/mob/living/human/H)
	..()
	update_stats()

/obj/vehicle/train/engine/remove_cell(var/mob/living/human/H)
	..()
	update_stats()

/obj/vehicle/train/engine/Bump(atom/Obstacle)
	var/obj/machinery/door/D = Obstacle
	var/mob/living/human/H = load
	if(istype(D) && istype(H))
		D.Bumped(H)		//a little hacky, but hey, it works, and respects access rights

	..()

//-------------------------------------------
// Train procs
//-------------------------------------------
/obj/vehicle/train/engine/turn_on()
	if(!key)
		return
	if(!cell)
		return
	..()
	update_stats()
	if(on)
		verbs |= /obj/vehicle/train/engine/verb/stop_engine
		verbs -= /obj/vehicle/train/engine/verb/start_engine
	else
		verbs |= /obj/vehicle/train/engine/verb/start_engine
		verbs -= /obj/vehicle/train/engine/verb/stop_engine

/obj/vehicle/train/engine/turn_off()
	..()
	if(!on)
		verbs |= /obj/vehicle/train/engine/verb/start_engine
		verbs -= /obj/vehicle/train/engine/verb/stop_engine
	else
		verbs |= /obj/vehicle/train/engine/verb/stop_engine
		verbs -= /obj/vehicle/train/engine/verb/start_engine


/obj/vehicle/train/engine/on_update_icon()
	if(open)
		icon_state = initial(icon_state) + "_open"
	else
		icon_state = initial(icon_state)

/obj/vehicle/train/engine/crossed_mob(var/mob/living/victim)
	victim.apply_effects(5, 5)
	for(var/i = 1 to rand(1,5))
		var/obj/item/organ/external/E = pick(victim.get_external_organs())
		if(E)
			victim.apply_damage(rand(5,10), BRUTE, E.organ_tag)

/obj/vehicle/train/engine/crossed_mob(var/mob/living/victim)
	..()
	if(is_train_head() && ishuman(load))
		var/mob/living/human/D = load
		to_chat(D, "<span class='danger'>You ran over \the [victim]!</span>")
		visible_message("<span class='danger'>\The [src] ran over \the [victim]!</span>")
		attack_log += text("\[[time_stamp()]\] <font color='red'>ran over [victim.name] ([victim.ckey]), driven by [D.name] ([D.ckey])</font>")
		msg_admin_attack("[D.name] ([D.ckey]) ran over [victim.name] ([victim.ckey]). (<A HREF='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")
	else
		attack_log += text("\[[time_stamp()]\] <font color='red'>ran over [victim.name] ([victim.ckey])</font>")

//-------------------------------------------
// Interaction procs
//-------------------------------------------
/obj/vehicle/train/engine/relaymove(mob/user, direction)
	if(user != load || user.incapacitated())
		return FALSE
	if(is_train_head())
		if(direction == global.reverse_dir[dir] && tow)
			return FALSE
		if(Move(get_step(src, direction)))
			return TRUE
		return FALSE
	return ..()

/obj/vehicle/train/engine/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1)
		. += "The power light is [on ? "on" : "off"].\nThere are[key ? "" : " no"] keys in the ignition."
		. += "The charge meter reads [cell? round(cell.percent(), 0.01) : 0]%"

/obj/vehicle/train/engine/verb/start_engine()
	set name = "Start engine"
	set category = "Vehicle"
	set src in view(0)

	if(!ishuman(usr))
		return

	if(on)
		to_chat(usr, SPAN_WARNING("The engine is already running."))
		return

	turn_on()
	if (on)
		to_chat(usr, SPAN_NOTICE("You start \the [src]'s engine."))
	else
		if(!cell)
			to_chat(usr, SPAN_NOTICE("\The [src] doesn't appear to have a power cell!"))
		else if(cell.charge < charge_use)
			to_chat(usr, SPAN_NOTICE("\The [src] is out of power."))
		else
			to_chat(usr, SPAN_NOTICE("\The [src]'s engine won't start."))

/obj/vehicle/train/engine/verb/stop_engine()
	set name = "Stop engine"
	set category = "Vehicle"
	set src in view(0)

	if(!ishuman(usr))
		return

	if(!on)
		to_chat(usr, SPAN_WARNING("The engine is already stopped."))
		return

	turn_off()
	if (!on)
		to_chat(usr, SPAN_NOTICE("You stop [src]'s engine."))

/obj/vehicle/train/engine/verb/remove_key()
	set name = "Remove key"
	set category = "Vehicle"
	set src in view(0)

	if(!isliving(usr) || !key || (load && load != usr))
		return

	if(on)
		turn_off()

	var/mob/living/user = usr
	key.dropInto(get_turf(user))
	usr.put_in_hands(key)
	key = null
	verbs -= /obj/vehicle/train/engine/verb/remove_key

/obj/vehicle/train/engine/load_onto_vehicle(var/atom/movable/loading, var/mob/user)
	return istype(loading, /mob/living/human) && ..()

//-------------------------------------------
// Latching/unlatching procs
//-------------------------------------------

/obj/vehicle/train/engine/latch(obj/vehicle/train/T, mob/user)
	if(!istype(T) || !Adjacent(T))
		return 0

	//if we are attaching a trolley to an engine we don't care what direction
	// it is in and it should probably be attached with the engine in the lead
	if(istype(T, /obj/vehicle/train/trolley))
		T.attach_to(src, user)
	else
		var/T_dir = get_dir(src, T)	//figure out where T is wrt src

		if(dir == T_dir) 	//if car is ahead
			src.attach_to(T, user)
		else if(global.reverse_dir[dir] == T_dir)	//else if car is behind
			T.attach_to(src, user)

//-------------------------------------------------------
// Stat update procs
//
// Update the trains stats for speed calculations.
// The longer the train, the slower it will go. car_limit
// sets the max number of cars one engine can pull at
// full speed. Adding more cars beyond this will slow the
// train proportionate to the length of the train. Adding
// more engines increases this limit by car_limit per
// engine.
//-------------------------------------------------------
/obj/vehicle/train/engine/update_vehicle_move_delay(atom/prev_loc)
	..()
	if(is_train_head() && on)
		move_delay = max(move_delay, (-car_limit * active_engines) + train_length - active_engines)	//limits base overweight so you can't overspeed trains
		move_delay *= (1 / max(1, active_engines)) * 2 										//overweight penalty (scaled by the number of engines)

/obj/vehicle/train/engine/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/train/toggle_ignition)
	if(key)
		LAZYADD(., /decl/interaction_handler/train/remove_key)

/decl/interaction_handler/train
	abstract_type = /decl/interaction_handler/train
	expected_target_type = /obj/vehicle/train/engine

/decl/interaction_handler/train/toggle_ignition
	name = "Toggle Ignition"

/decl/interaction_handler/train/toggle_ignition/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/vehicle/train/engine/train = target
	if(train.on)
		train.stop_engine()
	else
		train.start_engine()

/decl/interaction_handler/train/remove_key
	name = "Remove Key"

/decl/interaction_handler/train/remove_key/is_possible(atom/target, mob/user, obj/item/prop)
	if((. = ..()))
		var/obj/vehicle/train/engine/train = target
		return train.key

/decl/interaction_handler/train/remove_key/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/vehicle/train/engine/train = target
	train.remove_key()
