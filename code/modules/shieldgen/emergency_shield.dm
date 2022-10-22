/obj/machinery/shield
	name = "Emergency energy shield"
	desc = "An energy shield used to contain hull breaches."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old"
	density = TRUE
	opacity = FALSE
	anchored = TRUE
	material = null
	max_health = 200 //The shield can only take so much beating (prevents perma-prisons)
	hitsound = 'sound/effects/EMPulse.ogg'
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED | OBJ_FLAG_NOFALL
	anchor_fall = TRUE
	var/shield_generate_power = 7500	//how much power we use when regenerating
	var/shield_idle_power = 1500		//how much power we use when just being sustained.

/obj/machinery/shield/can_be_corroded_by(decl/material/M, amount)
	return FALSE

/obj/machinery/shield/malfai
	name = "emergency forcefield"
	desc = "A weak forcefield which seems to be projected by the emergency atmosphere containment field."
	max_health = 100 // Half health, it's not suposed to resist much.

/obj/machinery/shield/malfai/Process()
	take_damage(0.5, armor_pen = ARMOR_MELEE_SHIELDED, quiet = TRUE) // Slowly lose integrity over time

/obj/machinery/shield/physically_destroyed(skip_qdel)
	visible_message(SPAN_NOTICE("\The [src] dissipates!"))
	. = ..()

/obj/machinery/shield/Initialize(ml)
	. = ..()
	set_dir(pick(1,2,3,4))
	update_nearby_tiles(need_rebuild=1)

/obj/machinery/shield/Destroy()
	set_opacity(0)
	set_density(0)
	update_nearby_tiles()
	. = ..()

/obj/machinery/shield/CanPass(atom/movable/mover, turf/target, height, air_group)
	if(!height || air_group) return 0
	else return ..()

/obj/machinery/shield/check_health(lastdamage, lastdamtype, lastdamflags)
	if((lastdamage > 0) && (lastdamtype == BRUTE || lastdamtype == BURN))
		do_flicker()
	. = ..()

///Makes the shield flicker
/obj/machinery/shield/proc/do_flicker()
	set waitfor = FALSE
	set_opacity(TRUE)
	sleep(2 SECONDS)
	if(QDELETED(src))
		return
	set_opacity(FALSE)

/obj/machinery/shield/hitby(AM, var/datum/thrownthing/TT)
	//Let everyone know we've been hit!
	visible_message(SPAN_DANGER("\The [src] was hit by \the [AM]."))
	. = ..()

/obj/machinery/shieldgen
	name = "Emergency shield projector"
	desc = "Used to seal minor hull breaches."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shieldoff"
	density = 1
	opacity = 0
	anchored = 0
	initial_access = list(access_engine)
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_HOLLOW
	max_health = 100
	use_power = POWER_USE_OFF
	idle_power_usage = 0	
	var/active = 0
	var/malfunction = 0 //Malfunction causes parts of the shield to slowly dissapate
	var/list/deployed_shields = list()
	// var/list/regenerating = list() //TODO: Remove or add regeneration of destroyed shields
	var/is_open = 0 //Whether or not the wires are exposed
	var/locked = 0
	var/check_delay = 60	//periodically recheck if we need to rebuild a shield

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
	if(!. || !active)
		return
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

/obj/machinery/shieldgen/check_health(lastdamage, lastdamtype, lastdamflags)
	if(!malfunction && (health <= 30))
		trigger_malfunction() //#FIXME: Probably should use the broken flag and broken reason?
	. = ..()

/obj/machinery/shieldgen/melt()
	var/deloc = get_turf(src.loc)
	. = ..() //Deleted in melt
	explosion(deloc, 0, 0, 1, 0, 0, 0)

/obj/machinery/shieldgen/physically_destroyed(skip_qdel)
	. = ..(TRUE)
	explosion(loc, 0, 0, 1, 0, 0, 0)
	qdel(src)

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
	. = ..()
	if(!malfunction)
		trigger_malfunction()
		return 1

/obj/machinery/shieldgen/proc/trigger_malfunction()
	if(malfunction)
		return
	malfunction = TRUE
	update_icon()

/obj/machinery/shieldgen/can_repair(mob/user)
	return ..() || malfunction
	
/obj/machinery/shieldgen/can_repair_with(obj/item/tool, mob/user)
	return ..() || IS_COIL(tool)

//Moved here the repair code to clear the malfunction flag
/obj/machinery/shieldgen/handle_repair(mob/user, obj/item/tool)
	if(IS_COIL(tool))
		//#TODO: Check if cables coils are hard intercepted by terminal connectors components
		if(!panel_open)
			to_chat(user, SPAN_WARNING("You must open the maintenance panel first to replace the wiring!"))
			return
		var/obj/item/stack/cable_coil/coil = tool
		to_chat(user, SPAN_NOTICE("You begin replacing the wiring."))
		if(user.do_skilled(3 SECONDS, SKILL_ELECTRICAL, src) && coil.use(1) && malfunction)
			//Really bad people get shocked
			if(!(stat & NOPOWER) && user.skill_fail_prob(SKILL_ELECTRICAL, 60, SKILL_BASIC))
				var/power_src = get_first_working_power_source()
				if(power_src && electrocute_mob(user, power_src, src))
					to_chat(user, SPAN_DANGER("You wired the thing in reverse and electrocuted yourself!"))
				return
			to_chat(user, SPAN_NOTICE("You successfully replaced the wiring!"))
			malfunction = FALSE
			update_icon()
		return TRUE
	
	. = ..()

/obj/machinery/shieldgen/wrench_floor_bolts(mob/user, delay)
	if(locked)
		to_chat(user, SPAN_WARNING("The bolts are covered, unlocking this would retract the covers."))
		return
	. = ..()
	if(!anchored && active)
		to_chat(user, SPAN_NOTICE("The [src] shuts off!"))
		shields_down()

/obj/machinery/shieldgen/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id) || istype(W, /obj/item/modular_computer/pda))
		if(allowed(user))
			locked = !locked
			to_chat(user, SPAN_NOTICE("The controls are now [locked ? "locked." : "unlocked."]"))
		else
			to_chat(user, SPAN_WARNING("Access denied."))
		return TRUE
	return ..()


/obj/machinery/shieldgen/on_update_icon()
	if(active && !(stat & NOPOWER))
		src.icon_state = malfunction ? "shieldonbr":"shieldon"
	else
		src.icon_state = malfunction ? "shieldoffbr":"shieldoff"
	return
