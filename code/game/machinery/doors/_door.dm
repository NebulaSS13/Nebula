//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
#define DOOR_REPAIR_AMOUNT 50	//amount of health regained per stack amount used

/obj/machinery/door
	name = "Door"
	desc = "It opens and closes."
	icon = 'icons/obj/doors/Doorint.dmi'
	icon_state = "door1"
	anchored = TRUE
	opacity = TRUE
	density = TRUE
	layer = CLOSED_DOOR_LAYER
	interact_offline = TRUE
	construct_state = /decl/machine_construction/default/panel_closed/door
	uncreated_component_parts = null
	required_interaction_dexterity = DEXTERITY_SIMPLE_MACHINES
	max_health = 300

	var/can_open_manually = TRUE

	var/open_layer = OPEN_DOOR_LAYER
	var/closed_layer = CLOSED_DOOR_LAYER

	var/visible = 1
	var/operating = 0
	var/autoclose = 0
	var/glass = 0
	var/normalspeed = 1
	var/heat_proof = 0 // For glass airlocks/opacity firedoors
	var/destroy_hits = 10 //How many strong hits it takes to destroy the door
	var/min_force = 10 //minimum amount of force needed to damage the door with a melee weapon
	var/hitsound = 'sound/weapons/smash.ogg' //sound door makes when hit with a weapon
	var/pry_mod = 1 //difficulty scaling for simple animal door prying
	var/obj/item/stack/material/repairing
	var/block_air_zones = 1 //If set, air zones cannot merge across the door even when it is opened.
	var/close_door_at = 0 //When to automatically close the door, if possible
	var/connections = 0

	var/autoset_access = TRUE // Determines whether the door will automatically set its access from the areas surrounding it. Can be used for mapping.

	//Multi-tile doors
	dir = SOUTH
	var/width = 1

	//Used for intercepting clicks on our turf. Set 0 to disable click interception
	var/turf_hand_priority = 3

	atmos_canpass = CANPASS_PROC

	var/set_dir_on_update = TRUE
	var/begins_closed     = TRUE
	var/icon_state_open   = "door0"
	var/icon_state_closed = "door1"

/obj/machinery/door/get_blend_objects()
	var/static/list/blend_objects = list(
		/obj/structure/wall_frame,
		/obj/structure/window,
		/obj/structure/grille,
		/obj/machinery/door
	) // Objects which to blend with
	return blend_objects

/obj/machinery/door/proc/can_operate(var/mob/user)
	. = istype(user) && !user.restrained() && (!issmall(user) || ishuman(user) || issilicon(user) || isbot(user))

/obj/machinery/door/attack_generic(var/mob/user, var/damage, var/attack_verb, var/environment_smash)
	if(environment_smash >= 1)
		damage = max(damage, 10)

	if(damage >= 10)
		visible_message("<span class='danger'>\The [user] [attack_verb] into \the [src]!</span>")
		take_damage(damage)
	else
		visible_message("<span class='notice'>\The [user] bonks \the [src] harmlessly.</span>")
	attack_animation(user)

/obj/machinery/door/Initialize(var/mapload, var/d, var/populate_parts = TRUE, var/obj/structure/door_assembly/assembly = null)
	if(!populate_parts)
		inherit_from_assembly(assembly)
	set_extension(src, /datum/extension/penetration, /datum/extension/penetration/proc_call, PROC_REF(CheckPenetration))

	if(!begins_closed)
		icon_state = icon_state_open
		set_density(FALSE)
		set_opacity(FALSE)
		layer = open_layer

	..()
	. = INITIALIZE_HINT_LATELOAD

	if(density)
		layer = closed_layer
		update_heat_protection(get_turf(src))
	else
		layer = open_layer

	set_bounds()

	if (turf_hand_priority)
		set_extension(src, /datum/extension/turf_hand, turf_hand_priority)

#ifdef UNIT_TEST
	if(autoset_access && length(req_access))
		PRINT_STACK_TRACE("A door with mapped access restrictions was set to autoinitialize access.")
#endif

/obj/machinery/door/proc/inherit_from_assembly(var/obj/structure/door_assembly/assembly)
	if (assembly && istype(assembly))
		frame_type = assembly.type
		if(assembly.electronics)
			var/obj/item/stock_parts/circuitboard/electronics = assembly.electronics
			install_component(electronics, FALSE, FALSE) // will be refreshed in parent call; unsafe to refresh prior to calling ..() in Initialize
			electronics.construct(src)
		return TRUE

/obj/machinery/door/LateInitialize(mapload, dir=0, populate_parts=TRUE)
	..()
	update_connections(1)
	update_icon()
	update_nearby_tiles(need_rebuild=1)
	if(populate_parts && (autoset_access || length(req_access))) // Delayed because apparently the dir is not set by mapping and we need to wait for nearby walls to init and turn us.
		var/obj/item/stock_parts/access_lock/lock = install_component(/obj/item/stock_parts/access_lock/buildable, refresh_parts = FALSE)
		if(autoset_access)
			lock.autoset = TRUE
			lock.req_access = get_auto_access()
		else
			lock.req_access = req_access.Copy()

/obj/machinery/door/Destroy()
	set_density(0)
	update_nearby_tiles()
	. = ..()

/obj/machinery/door/Process()
	if(close_door_at && world.time >= close_door_at)
		if(autoclose)
			close_door_at = next_close_time()
			INVOKE_ASYNC(src, PROC_REF(close))
		else
			close_door_at = 0

/obj/machinery/door/proc/can_open()
	if(!density || operating)
		return 0
	return 1

/obj/machinery/door/proc/can_close()
	if(density || operating)
		return 0
	return 1

/obj/machinery/door/proc/set_bounds()
	if (dir == NORTH || dir == SOUTH)
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size

/obj/machinery/door/set_density(new_density)
	. = ..()
	if(.)
		explosion_resistance = density ? initial(explosion_resistance) : 0

/obj/machinery/door/set_dir(new_dir)
	if(set_dir_on_update)
		if(new_dir & (EAST|WEST))
			new_dir = WEST
		else
			new_dir = SOUTH

	. = ..(new_dir)

	if(.)
		set_bounds()

/obj/machinery/door/Bumped(atom/AM)
	if(panel_open || operating)
		return

	if(ismob(AM))
		var/mob/M = AM
		if(world.time - M.last_bumped <= 10)
			return	//Can bump-open one airlock per second. This is to prevent shock spam.
		M.last_bumped = world.time
		bumpopen(M)

/obj/machinery/door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group)
		return !block_air_zones
	if(istype(mover) && mover.checkpass(PASS_FLAG_GLASS))
		return !opacity
	return !density

/obj/machinery/door/proc/bumpopen(mob/user)
	if(operating || !can_operate(user))
		return
	if(user.last_airflow > world.time - vsc.airflow_delay) //Fakkit
		return
	src.add_fingerprint(user)
	if(density && can_operate(user))
		if(allowed(user))
			open()
		else
			do_animate("deny")

/obj/machinery/door/physically_destroyed(skip_qdel)
	SSmaterials.create_object(/decl/material/solid/metal/steel, loc, 2)
	SSmaterials.create_object(/decl/material/solid/metal/steel, loc, 3, /obj/item/stack/material/rods)
	. = ..()

/obj/machinery/door/bullet_act(var/obj/item/projectile/Proj)
	..()

	var/damage = Proj.get_structure_damage()

	// Emitter Blasts - these will eventually completely destroy the door, given enough time.
	if (damage > 90)
		destroy_hits--
		if (destroy_hits <= 0)
			visible_message("<span class='danger'>\The [src.name] disintegrates!</span>")
			switch (Proj.atom_damage_type)
				if(BRUTE)
					physically_destroyed()
				if(BURN)
					new /obj/effect/decal/cleanable/ash(src.loc) // Turn it to ashes!
			qdel(src)

	if(damage)
		//cap projectile damage so that there's still a minimum number of hits required to break the door
		take_damage(min(damage, 100), Proj.atom_damage_type)

/obj/machinery/door/hitby(var/atom/movable/AM, var/datum/thrownthing/TT)
	. = ..()
	if(.)
		visible_message(SPAN_DANGER("\The [src] was hit by \the [AM]."))
		playsound(src.loc, hitsound, 100, 1)
		take_damage(AM.get_thrown_attack_force() * (TT.speed/THROWFORCE_SPEED_DIVISOR))

// This is legacy code that should be revisited, probably by moving the bulk of the logic into here.
/obj/machinery/door/physical_attack_hand(user)
	if(operating || !can_open_manually)
		return FALSE

	if(allowed(user) && can_operate(user))
		toggle()
	else if(density)
		do_animate("deny")

	return TRUE

/obj/machinery/door/proc/handle_repair(obj/item/used_item, mob/user)
	if(istype(used_item, /obj/item/stack/material) && used_item.get_material_type() == src.get_material_type())
		if(reason_broken & MACHINE_BROKEN_GENERIC)
			to_chat(user, "<span class='notice'>It looks like \the [src] is pretty busted. It's going to need more than just patching up now.</span>")
			return TRUE
		var/current_max_health = get_max_health()
		if(current_health >= current_max_health)
			to_chat(user, "<span class='notice'>Nothing to fix!</span>")
			return TRUE
		if(!density)
			to_chat(user, "<span class='warning'>\The [src] must be closed before you can repair it.</span>")
			return TRUE

		//figure out how much metal we need
		var/amount_needed = (current_max_health - current_health) / DOOR_REPAIR_AMOUNT
		amount_needed = ceil(amount_needed)

		var/obj/item/stack/stack = used_item
		var/transfer
		if (repairing)
			transfer = stack.transfer_to(repairing, amount_needed - repairing.amount)
			if (!transfer)
				to_chat(user, "<span class='warning'>You must weld or remove \the [repairing] from \the [src] before you can add anything else.</span>")
		else
			repairing = stack.split(amount_needed, force=TRUE)
			if (repairing)
				repairing.dropInto(loc)
				transfer = repairing.amount
				repairing.uses_charge = FALSE //for clean robot door repair - stacks hint immortal if true

		if (transfer)
			to_chat(user, "<span class='notice'>You fit [transfer] [stack.singular_name]\s to damaged and broken parts on \the [src].</span>")

		return TRUE

	if(repairing && IS_WELDER(used_item))
		if(!density)
			to_chat(user, "<span class='warning'>\The [src] must be closed before you can repair it.</span>")
			return TRUE

		var/obj/item/weldingtool/welder = used_item
		if(welder.weld(0,user))
			to_chat(user, "<span class='notice'>You start to fix dents and weld \the [repairing] into place.</span>")
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			if(do_after(user, 5 * repairing.amount, src) && welder && welder.isOn())
				to_chat(user, "<span class='notice'>You finish repairing the damage to \the [src].</span>")
				current_health = clamp(current_health + repairing.amount*DOOR_REPAIR_AMOUNT,current_health, get_max_health())
				update_icon()
				qdel(repairing)
				repairing = null
		return TRUE

	if(repairing && IS_CROWBAR(used_item))
		to_chat(user, "<span class='notice'>You remove \the [repairing].</span>")
		playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
		repairing.dropInto(user.loc)
		repairing = null
		return TRUE

/obj/machinery/door/attackby(obj/item/used_item, mob/user)
	. = handle_repair(used_item, user)
	if(.)
		return
	return ..()

/obj/machinery/door/emag_act(var/remaining_charges)
	if(density && operable())
		do_animate("emag")
		sleep(6)
		open()
		emagged = TRUE
		return 1

/obj/machinery/door/bash(obj/item/weapon, mob/user)
	if(isliving(user) && !user.check_intent(I_FLAG_HARM))
		return FALSE
	if(!weapon.user_can_attack_with(user))
		return FALSE
	if(weapon.item_flags & ITEM_FLAG_NO_BLUDGEON)
		return FALSE
	if(!density)
		return FALSE
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	var/force = weapon.expend_attack_force(user)
	if(force < min_force)
		user.visible_message("<span class='danger'>\The [user] hits \the [src] with \the [weapon] with no visible effect.</span>")
	else
		user.visible_message("<span class='danger'>\The [user] forcefully strikes \the [src] with \the [weapon]!</span>")
		playsound(src.loc, hitsound, 100, 1)
		take_damage(force, weapon.atom_damage_type)
	return TRUE

/obj/machinery/door/take_damage(damage, damage_type = BRUTE, damage_flags, inflicter, armor_pen = 0, silent, do_update_health)
	if(!current_health)
		..(damage, damage_type)
		update_icon()
		return

	var/component_damage = get_damage_leakthrough(damage, BRUTE)
	damage -= component_damage

	//Part of damage is soaked by our own health
	var/current_max_health = get_max_health()
	var/initialhealth = current_health
	current_health = max(0, current_health - damage)
	if(current_health <= 0 && initialhealth > 0)
		visible_message(SPAN_WARNING("\The [src] breaks down!"))
		set_broken(TRUE)
	else if(current_health < current_max_health / 4 && initialhealth >= current_max_health / 4)
		visible_message(SPAN_WARNING("\The [src] looks like it's about to break!"))
	else if(current_health < current_max_health / 2 && initialhealth >= current_max_health / 2)
		visible_message(SPAN_WARNING("\The [src] looks seriously damaged!"))
	else if(current_health < current_max_health * 3/4 && initialhealth >= current_max_health * 3/4)
		visible_message(SPAN_WARNING("\The [src] shows signs of damage!"))

	..(component_damage, damage_type)
	update_icon()

//How much damage should be passed to components inside even when door health is non zero
/obj/machinery/door/proc/get_damage_leakthrough(var/damage, damtype=BRUTE)
	var/current_max_health = get_max_health()
	if(current_health > 0.75 * current_max_health && damage < 10)
		return 0
	. = round((1 - current_health/current_max_health) * damage)

/obj/machinery/door/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(current_health <= 0)
		. += SPAN_DANGER("\The [src] is broken!")
	else
		var/current_max_health = get_max_health()
		if(current_health < current_max_health / 4)
			. += SPAN_DANGER("\The [src] looks like it's about to break!")
		else if(current_health < current_max_health / 2)
			. += SPAN_DANGER("\The [src] looks seriously damaged!")
		else if(current_health < current_max_health * 3/4)
			. += SPAN_WARNING("\The [src] shows signs of damage!")
		else if(current_health < current_max_health && get_dist(src, user) <= 1)
			. += SPAN_WARNING("\The [src] has some minor scuffing.")

	var/mob/living/human/H = user
	if (emagged && istype(H) && (H.skill_check(SKILL_COMPUTER, SKILL_ADEPT) || H.skill_check(SKILL_ELECTRICAL, SKILL_ADEPT)))
		. += SPAN_WARNING("\The [src]'s control panel looks fried.")

/obj/machinery/door/set_broken(new_state, cause)
	. = ..()
	if(. && new_state && (cause & MACHINE_BROKEN_GENERIC))
		visible_message("<span class = 'warning'>\The [src.name] breaks!</span>")

/obj/machinery/door/on_update_icon()
	if(density)
		icon_state = icon_state_closed
	else
		icon_state = icon_state_open

	SSradiation.resistance_cache.Remove(get_turf(src))

/obj/machinery/door/proc/do_animate(animation)
	switch(animation)
		if("opening")
			if(panel_open)
				flick("o_doorc0", src)
			else
				flick("doorc0", src)
		if("closing")
			if(panel_open)
				flick("o_doorc1", src)
			else
				flick("doorc1", src)
		if("spark")
			if(density)
				flick("door_spark", src)
		if("deny")
			if(density && !(stat & (NOPOWER|BROKEN)))
				flick("door_deny", src)
				playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 0)

/obj/machinery/door/proc/open(forced = FALSE)
	if(!can_open(forced))
		return FALSE

	operating = 1

	do_animate("opening")
	icon_state = icon_state_open
	set_opacity(FALSE)

	sleep(0.5 SECONDS)
	src.set_density(FALSE)
	update_nearby_tiles()

	sleep(0.5 SECONDS)
	src.layer = open_layer
	update_icon()
	set_opacity(FALSE)
	operating = 0

	if(autoclose)
		close_door_at = next_close_time()

	return TRUE

/obj/machinery/door/proc/next_close_time()
	return world.time + (normalspeed ? 150 : 5)

/obj/machinery/door/proc/close(forced = FALSE)
	if(!can_close(forced))
		return FALSE

	operating = 1

	close_door_at = 0
	do_animate("closing")

	sleep(0.5 SECONDS)
	src.set_density(TRUE)
	update_nearby_tiles()
	src.layer = closed_layer

	sleep(0.5 SECONDS)
	update_icon()
	if(visible && !glass)
		set_opacity(TRUE)
	operating = 0

	//I shall not add a check every x ticks if a door has closed over some fire.
	var/obj/fire/fire = locate() in loc
	qdel(fire)
	return TRUE

/obj/machinery/door/proc/toggle(to_open = density)
	if(to_open)
		open()
	else
		close()

/obj/machinery/door/proc/requiresID()
	return 1

/obj/machinery/door/allowed(mob/M)
	if(!requiresID())
		return ..(null) //don't care who they are or what they have, act as if they're NOTHING
	return ..(M)

/obj/machinery/door/update_nearby_tiles(need_rebuild)
	. = ..()
	for(var/turf/turf in locs)
		if(turf.simulated)
			update_heat_protection(turf)
	return 1

/obj/machinery/door/proc/update_heat_protection(var/turf/source)
	if(istype(source))
		if(src.density && (src.opacity || src.heat_proof))
			source.thermal_conductivity = DOOR_HEAT_TRANSFER_COEFFICIENT
		else
			source.thermal_conductivity = initial(source.thermal_conductivity)

/obj/machinery/door/Move(new_loc, new_dir)
	. = ..()
	update_nearby_tiles()
	if(.)
		dismantle(TRUE)

/obj/machinery/door/proc/CheckPenetration(var/base_chance, var/damage)
	. = damage/get_max_health()*180
	if(glass)
		. *= 2
	. = round(.)

/obj/machinery/door/morgue
	icon = 'icons/obj/doors/doormorgue.dmi'
	frame_type = /obj/structure/door_assembly/blast/morgue
	base_type = /obj/machinery/door/morgue

/obj/machinery/door/proc/update_connections(var/propagate = 0)
	var/dirs = 0

	for(var/direction in global.cardinal)
		var/turf/T = get_step(src, direction)
		var/success = 0

		if( istype(T, /turf/wall))
			success = 1
			if(propagate)
				for(var/turf/wall/wall in RANGE_TURFS(T, 1))
					wall.wall_connections = null
					wall.other_connections = null
					wall.queue_icon_update()

		else if(istype(T, /turf/unsimulated/wall))
			success = 1
		else
			for(var/obj/blend_obj in T)
				for(var/blend_type in get_blend_objects())
					if( istype(blend_obj, blend_type))
						success = 1

					if(success)
						break
				if(success)
					break

		if(success)
			dirs |= direction
	connections = dirs

/obj/machinery/door/CanFluidPass(var/coming_from)
	return !density

/obj/machinery/door/proc/access_area_by_dir(direction)
	var/turf/T = get_turf(get_step(src, direction))
	if (T && !T.density)
		return get_area(T)

/obj/machinery/door/get_auto_access()
	var/area/fore = access_area_by_dir(dir)
	var/area/aft = access_area_by_dir(global.reverse_dir[dir])
	fore = fore || aft
	aft = aft || fore

	if (!fore && !aft)
		return list()
	else if (fore.secure || aft.secure)
		return req_access_union(fore, aft)
	else
		return req_access_diff(fore, aft)

/obj/machinery/door/get_req_access()
	. = list()
	for(var/obj/item/stock_parts/access_lock/lock in get_all_components_of_type(/obj/item/stock_parts/access_lock))
		if(lock.locked && length(lock.req_access))
			. |= lock.req_access

	for(var/obj/item/stock_parts/network_receiver/network_lock/lock in get_all_components_of_type(/obj/item/stock_parts/network_receiver/network_lock))
		. |= lock.get_req_access()

/obj/machinery/door/do_simple_ranged_interaction(var/mob/user)
	if((!requiresID() || allowed(null)) && can_operate(user) && can_open_manually)
		toggle()
	return TRUE

/obj/machinery/door/components_are_accessible(var/path)
	if(ispath(path, /obj/item/stock_parts/circuitboard))
		return TRUE
	return ..()

// Public access

/decl/public_access/public_method/open_door
	name = "open door"
	desc = "Opens the door if possible."
	call_proc = TYPE_PROC_REF(/obj/machinery/door, open)

/decl/public_access/public_method/toggle_door
	name = "toggle door"
	desc = "Toggles whether the door is open or not, if possible."
	call_proc = TYPE_PROC_REF(/obj/machinery/door, toggle)

/decl/public_access/public_method/toggle_door_to
	name = "toggle door to"
	desc = "Toggles the door, depending on the supplied argument, to open (if 1) or closed (if 0)."
	call_proc = TYPE_PROC_REF(/obj/machinery/door, toggle)
	forward_args = TRUE

/decl/public_access/public_method/close_door
	name = "close door"
	desc = "Closes the door if possible."
	call_proc = TYPE_PROC_REF(/obj/machinery/door, close)
