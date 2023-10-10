#define EMITTER_DAMAGE_POWER_TRANSFER 450 //used to transfer power to containment field generators

/obj/machinery/emitter
	name = "emitter"
	desc = "A massive heavy industrial laser. This design is a fixed installation, capable of shooting in only one direction."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "emitter"
	anchored = 0
	density = 1
	initial_access = list(access_engine_equip)
	active_power_usage = 100 KILOWATTS

	var/efficiency = 0.3	// Energy efficiency. 30% at this time, so 100kW load means 30kW laser pulses.
	var/minimum_power = 10 KILOWATTS // The minimum power the emitter will still fire at it it doesn't have enough power available.
	var/active = 0
	var/fire_delay = 100
	var/max_burst_delay = 100
	var/min_burst_delay = 20
	var/burst_shots = 3
	var/last_shot = 0
	var/shot_number = 0
	var/state = 0
	var/locked = 0
	var/powered = 0
	core_skill = SKILL_ENGINES

	uncreated_component_parts = list(
		/obj/item/stock_parts/radio/receiver,
		/obj/item/stock_parts/power/terminal
	)
	public_variables = list(
		/decl/public_access/public_variable/emitter_active,
		/decl/public_access/public_variable/emitter_locked
	)
	public_methods = list(
		/decl/public_access/public_method/toggle_emitter
	)
	stock_part_presets = list(/decl/stock_part_preset/radio/receiver/emitter = 1, /decl/stock_part_preset/terminal_connect = 1)

/obj/machinery/emitter/anchored
	anchored = 1
	state = 2

/obj/machinery/emitter/Destroy()
	log_and_message_admins("deleted \the [src]")
	investigate_log("<font color='red'>deleted</font> at ([x],[y],[z])","singulo")
	return ..()

/obj/machinery/emitter/on_update_icon()
	if (active && powered)
		icon_state = "emitter_+a"
	else
		icon_state = "emitter"

/obj/machinery/emitter/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	activate(user)
	return TRUE

/obj/machinery/emitter/proc/activate(mob/user)
	if(!istype(user))
		user = null // safety, as the proc is publicly available.

	if(state == 2)
		if(!locked)
			if(active==1)
				active = 0
				to_chat(user, "You turn off \the [src].")
				log_and_message_admins("turned off \the [src]")
				investigate_log("turned <font color='red'>off</font> by [key_name_admin(user || usr)]","singulo")
			else
				active = 1
				if(user)
					operator_skill = user.get_skill_value(core_skill)
				update_efficiency()
				to_chat(user, "You turn on \the [src].")
				shot_number = 0
				fire_delay = get_initial_fire_delay()
				log_and_message_admins("turned on \the [src]")
				investigate_log("turned <font color='green'>on</font> by [key_name_admin(user || usr)]","singulo")
			update_icon()
		else
			to_chat(user, "<span class='warning'>The controls are locked!</span>")
	else
		to_chat(user, "<span class='warning'>\The [src] needs to be firmly secured to the floor first.</span>")
		return 1

/obj/machinery/emitter/proc/update_efficiency()
	efficiency = initial(efficiency)
	if(!operator_skill)
		return
	var/skill_modifier = 0.8 * (SKILL_MAX - operator_skill)/(SKILL_MAX - SKILL_MIN) //How much randomness is added
	efficiency *= 1 + (rand() - 1) * skill_modifier //subtract off between 0.8 and 0, depending on skill and luck.

/obj/machinery/emitter/emp_act(var/severity)
	return 1

/obj/machinery/emitter/Process()
	if(stat & (BROKEN))
		return
	if(state != 2)
		active = FALSE
		update_icon()
		return
	if(((last_shot + fire_delay) <= world.time) && (active == 1))
		if(active_power_usage - can_use_power_oneoff(active_power_usage) < minimum_power)
			powered = FALSE
			update_icon()
			return
		var/drawn_power = min(active_power_usage, active_power_usage - use_power_oneoff(active_power_usage))
		last_shot = world.time
		if(shot_number < burst_shots)
			fire_delay = get_burst_delay()
			shot_number ++
		else
			fire_delay = get_rand_burst_delay()
			shot_number = 0

		//need to calculate the power per shot as the emitter doesn't fire continuously.
		var/burst_time = (min_burst_delay + max_burst_delay)/2 + 2*(burst_shots-1)
		var/power_per_shot = (drawn_power * efficiency) * (burst_time/10) / burst_shots

		if(prob(35))
			spark_at(src, amount=5, cardinal_only = TRUE)

		var/obj/item/projectile/beam/emitter/A = get_emitter_beam()
		playsound(loc, A.fire_sound, 25, 1)
		A.damage = round(power_per_shot/EMITTER_DAMAGE_POWER_TRANSFER)
		A.launch( get_step(loc, dir) )

		if(!powered)
			powered = TRUE
			update_icon()

/obj/machinery/emitter/attackby(obj/item/W, mob/user)

	if(IS_WRENCH(W))
		if(active)
			to_chat(user, "Turn off [src] first.")
			return
		switch(state)
			if(0)
				state = 1
				playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] secures [src] to the floor.", \
					"You secure the external reinforcing bolts to the floor.", \
					"You hear a ratchet.")
				anchored = 1
			if(1)
				state = 0
				playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] unsecures [src] reinforcing bolts from the floor.", \
					"You undo the external reinforcing bolts.", \
					"You hear a ratchet.")
				anchored = 0
			if(2)
				to_chat(user, "<span class='warning'>\The [src] needs to be unwelded from the floor.</span>")
		return

	if(IS_WELDER(W))
		var/obj/item/weldingtool/WT = W
		if(active)
			to_chat(user, "Turn off [src] first.")
			return
		switch(state)
			if(0)
				to_chat(user, "<span class='warning'>\The [src] needs to be wrenched to the floor.</span>")
			if(1)
				if (WT.weld(0,user))
					playsound(loc, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message("[user.name] starts to weld [src] to the floor.", \
						"You start to weld [src] to the floor.", \
						"You hear welding.")
					if (do_after(user,20,src))
						if(!src || !WT.isOn()) return
						state = 2
						to_chat(user, "You weld [src] to the floor.")
				else
					to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
			if(2)
				if (WT.weld(0,user))
					playsound(loc, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message("[user.name] starts to cut [src] free from the floor.", \
						"You start to cut [src] free from the floor.", \
						"You hear welding.")
					if (do_after(user,20,src))
						if(!src || !WT.isOn()) return
						state = 1
						to_chat(user, "You cut [src] free from the floor.")
				else
					to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
		return

	if(istype(W, /obj/item/card/id) || istype(W, /obj/item/modular_computer))
		if(emagged)
			to_chat(user, "<span class='warning'>The lock seems to be broken.</span>")
			return
		if(allowed(user))
			locked = !locked
			to_chat(user, "The controls are now [locked ? "locked." : "unlocked."]")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
		return
	..()
	return

/obj/machinery/emitter/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		locked = 0
		emagged = 1
		req_access.Cut()
		user.visible_message("[user.name] emags [src].","<span class='warning'>You short out the lock.</span>")
		return 1

/obj/machinery/emitter/components_are_accessible(var/path)
	if(ispath(path, /obj/item/stock_parts/power/terminal))
		return TRUE
	return ..()

/obj/machinery/emitter/proc/get_initial_fire_delay()
	return 100

/obj/machinery/emitter/proc/get_rand_burst_delay()
	return rand(min_burst_delay, max_burst_delay)

/obj/machinery/emitter/proc/get_burst_delay()
	return 2

/obj/machinery/emitter/proc/get_emitter_beam()
	return new /obj/item/projectile/beam/emitter(get_turf(src))

/decl/public_access/public_method/toggle_emitter
	name = "toggle emitter"
	desc = "Toggles whether or not the emitter is active. It must be unlocked to work."
	call_proc = /obj/machinery/emitter/proc/activate

/decl/public_access/public_variable/emitter_active
	expected_type = /obj/machinery/emitter
	name = "emitter active"
	desc = "Whether or not the emitter is firing."
	can_write = FALSE
	has_updates = FALSE

/decl/public_access/public_variable/emitter_active/access_var(obj/machinery/emitter/emitter)
	return emitter.active

/decl/public_access/public_variable/emitter_locked
	expected_type = /obj/machinery/emitter
	name = "emitter locked"
	desc = "Whether or not the emitter is locked. Being locked prevents one from changing the active state."
	can_write = FALSE
	has_updates = FALSE

/decl/public_access/public_variable/emitter_locked/access_var(obj/machinery/emitter/emitter)
	return emitter.locked

/decl/stock_part_preset/radio/receiver/emitter
	frequency = BUTTON_FREQ
	receive_and_call = list("button_active" = /decl/public_access/public_method/toggle_emitter)