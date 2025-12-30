/obj/machinery/shield
	name = "emergency energy shield"
	desc = "An energy shield used to contain hull breaches."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old"
	density = TRUE
	opacity = FALSE
	anchored = TRUE
	max_health = 200
	frame_type = null
	construct_state = /decl/machine_construction/noninteractive
	var/shield_generate_power = 7500	//how much power we use when regenerating
	var/shield_idle_power = 1500		//how much power we use when just being sustained.

/obj/machinery/shield/take_damage(amount, damtype, silent)
	if(amount <= 0)
		return
	if(damtype != BRUTE && damtype != BURN && damtype != ELECTROCUTE)
		return
	if(!silent)
		playsound(src.loc, 'sound/effects/EMPulse.ogg', 75, TRUE)
	current_health -= amount
	set_opacity(TRUE)
	check_failure()
	if(!QDELETED(src))
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, set_opacity), FALSE), 2 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)

// This should never be damaged via anything but the shield's health dropping.
/obj/machinery/shield/dismantle()
	check_failure()
	return QDELING(src) // return true if deleted, false otherwise

/obj/machinery/shield/malfai
	name = "emergency forcefield"
	desc = "A weak forcefield which seems to be projected by the emergency atmosphere containment field."
	max_health = 100 // Half health, it's not suposed to resist much.

/obj/machinery/shield/malfai/Process()
	current_health -= 0.5 // Slowly lose integrity over time
	check_failure()

/obj/machinery/shield/proc/check_failure()
	if (current_health <= 0)
		visible_message(SPAN_NOTICE("\The [src] dissipates!"))
		qdel(src)
		return

/obj/machinery/shield/Initialize()
	. = ..()
	src.set_dir(pick(1,2,3,4))
	update_nearby_tiles(need_rebuild=1)

/obj/machinery/shield/Destroy()
	set_opacity(FALSE)
	set_density(FALSE)
	update_nearby_tiles()
	. = ..()

/obj/machinery/shield/CanPass(atom/movable/mover, turf/target, height, air_group)
	// blocks air, normal behavior for everything else
	if(!height || air_group) return 0
	else return ..()

/obj/machinery/shield/explosion_act(severity)
	. = ..()
	if(. && ((severity == 1 && prob(75)) || (severity == 2 && prob(50)) || (severity == 3 && prob(25))))
		physically_destroyed()

/obj/machinery/shield/emp_act(severity)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if(prob(50))
				qdel(src)

/obj/machinery/shield/hitby(atom/movable/hitter, var/datum/thrownthing/thrownthing)
	. = ..()
	if(.)
		//Let everyone know we've been hit!
		visible_message(SPAN_DANGER("\The [src] was hit by \the [hitter]."))
		//Super realistic, resource-intensive, real-time damage calculations.
		var/tforce = 0
		if(ismob(hitter)) // All mobs have a multiplier and a size according to mob_defines.dm
			var/mob/mob_hitter = hitter
			tforce = mob_hitter.mob_size * (thrownthing.speed/THROWFORCE_SPEED_DIVISOR)
		else
			var/obj/obj_hitter = hitter
			tforce = obj_hitter.get_thrown_attack_force() * (thrownthing.speed/THROWFORCE_SPEED_DIVISOR)
		if(tforce > 0)
			take_damage(tforce, BRUTE)

/obj/machinery/shieldgen
	name = "Emergency shield projector"
	desc = "Used to seal minor hull breaches."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shieldoff"
	density = TRUE
	opacity = FALSE
	anchored = FALSE
	initial_access = list(access_engine)
	max_health = 100
	var/active = 0
	var/malfunction = 0 //Malfunction causes parts of the shield to slowly dissapate
	var/list/deployed_shields = list()
	// var/list/regenerating = list() //TODO: Remove or add regeneration of destroyed shields
	var/is_open = 0 //Whether or not the wires are exposed
	var/locked = 0
	var/check_delay = 60	//periodically recheck if we need to rebuild a shield
	use_power = POWER_USE_OFF
	idle_power_usage = 0

/obj/machinery/shieldgen/Destroy()
	collapse_shields()
	. = ..()

/obj/machinery/shieldgen/proc/shields_up()
	if(active) return 0 //If it's already turned on, how did this get called?

	src.active = 1

	create_shields()

	var/new_idle_power_usage = 0
	for(var/obj/machinery/shield/shield_tile in deployed_shields)
		new_idle_power_usage += shield_tile.shield_idle_power
	change_power_consumption(new_idle_power_usage, POWER_USE_IDLE)
	update_use_power(POWER_USE_IDLE)

/obj/machinery/shieldgen/proc/shields_down()
	if(!active) return 0 //If it's already off, how did this get called?

	src.active = 0

	collapse_shields()

	update_use_power(POWER_USE_OFF)

/obj/machinery/shieldgen/proc/create_shields()
	for(var/turf/target_tile in range(8, src))
		if(target_tile.is_open() && !(locate(/obj/machinery/shield) in target_tile))
			if (malfunction && prob(33) || !malfunction)
				var/obj/machinery/shield/S = new/obj/machinery/shield(target_tile)
				deployed_shields += S
				use_power_oneoff(S.shield_generate_power)

	for(var/turf/above in range(8, GetAbove(src)))//Probably a better way to do this.
		if(above.is_open() && !(locate(/obj/machinery/shield) in above))
			if (malfunction && prob(33) || !malfunction)
				var/obj/machinery/shield/A = new/obj/machinery/shield(above)
				deployed_shields += A
				use_power_oneoff(A.shield_generate_power)

/obj/machinery/shieldgen/proc/collapse_shields()
	for(var/obj/machinery/shield/shield_tile in deployed_shields)
		qdel(shield_tile)

/obj/machinery/shieldgen/power_change()
	. = ..()
	if(!. || !active) return
	if (stat & NOPOWER)
		collapse_shields()
	else
		create_shields()

/obj/machinery/shieldgen/Process()
	if (!active || (stat & NOPOWER))
		return

	if(malfunction)
		if(deployed_shields.len && prob(5))
			qdel(pick(deployed_shields))
	else
		if (check_delay <= 0)
			create_shields()

			var/new_power_usage = 0
			for(var/obj/machinery/shield/shield_tile in deployed_shields)
				new_power_usage += shield_tile.shield_idle_power

			if (new_power_usage != idle_power_usage)
				change_power_consumption(new_power_usage, POWER_USE_IDLE)

			check_delay = 60
		else
			check_delay--

// todo: roll this into normal machinery damage stuff? maybe it only blows up if active when it's destroyed?
/obj/machinery/shieldgen/proc/checkhp()
	if(current_health <= 30)
		src.malfunction = 1
	if(current_health <= 0)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(explosion), get_turf(src), 0, 0, 1, 0, 0, 0), 0)
		qdel(src)
	update_icon()
	return

/obj/machinery/shieldgen/explosion_act(severity)
	. = ..()
	if(.)
		if(severity == 1)
			current_health -= 75
		else if(severity == 2)
			current_health -= 30
			if(prob(15))
				malfunction = 1
		else if(severity == 3)
			current_health -= 10
		checkhp()

/obj/machinery/shieldgen/emp_act(severity)
	switch(severity)
		if(1)
			current_health /= 2 //cut health in half
			malfunction = 1
			locked = pick(0,1)
		if(2)
			if(prob(50))
				current_health *= 0.3 //chop off a third of the health
				malfunction = 1
	checkhp()

/obj/machinery/shieldgen/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	if(locked)
		to_chat(user, "The machine is locked, you are unable to use it.")
		return TRUE
	if(is_open)
		to_chat(user, "The panel must be closed before operating this machine.")
		return TRUE

	if (src.active)
		user.visible_message("<span class='notice'>[html_icon(src)] [user] deactivated the shield generator.</span>", \
			"<span class='notice'>[html_icon(src)] You deactivate the shield generator.</span>", \
			"You hear heavy droning fade out.")
		src.shields_down()
	else
		if(anchored)
			user.visible_message("<span class='notice'>[html_icon(src)] [user] activated the shield generator.</span>", \
				"<span class='notice'>[html_icon(src)] You activate the shield generator.</span>", \
				"You hear heavy droning.")
			src.shields_up()
		else
			to_chat(user, "The device must first be secured to the floor.")
	return TRUE

/obj/machinery/shieldgen/emag_act(var/remaining_charges, var/mob/user)
	if(!malfunction)
		malfunction = 1
		update_icon()
		return 1

/obj/machinery/shieldgen/attackby(obj/item/used_item, mob/user)
	if(IS_SCREWDRIVER(used_item))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		if(is_open)
			to_chat(user, "<span class='notice'>You close the panel.</span>")
			is_open = 0
		else
			to_chat(user, "<span class='notice'>You open the panel and expose the wiring.</span>")
			is_open = 1
		return TRUE
	else if(IS_COIL(used_item) && malfunction && is_open)
		var/obj/item/stack/cable_coil/coil = used_item
		to_chat(user, "<span class='notice'>You begin to replace the wires.</span>")
		if(!do_after(user, 3 SECONDS, src))
			to_chat(user, SPAN_NOTICE("You stop repairing \the [src]."))
			return TRUE
		if (coil.use(1))
			current_health = get_max_health()
			malfunction = 0
			to_chat(user, "<span class='notice'>You repair \the [src]!</span>")
			update_icon()
		return TRUE
	else if(IS_WRENCH(used_item))
		if(locked)
			to_chat(user, "The bolts are covered, unlocking this would retract the covers.")
			return TRUE
		if(anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			to_chat(user, "<span class='notice'>'You unsecure \the [src] from the floor!</span>")
			if(active)
				to_chat(user, "<span class='notice'>\The [src] shuts off!</span>")
				src.shields_down()
			anchored = FALSE
		else if(!isspaceturf(get_turf(src))) //No wrenching these in space!
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			to_chat(user, "<span class='notice'>You secure \the [src] to the floor!</span>")
			anchored = TRUE
		return TRUE
	else if(istype(used_item, /obj/item/card/id) || istype(used_item, /obj/item/modular_computer/pda))
		if(src.allowed(user))
			src.locked = !src.locked
			to_chat(user, "The controls are now [src.locked ? "locked." : "unlocked."]")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
		return TRUE
	return ..()


/obj/machinery/shieldgen/on_update_icon()
	if(active && !(stat & NOPOWER))
		src.icon_state = malfunction ? "shieldonbr":"shieldon"
	else
		src.icon_state = malfunction ? "shieldoffbr":"shieldoff"
	return
