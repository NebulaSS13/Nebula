// TODO Add fire processing for non-energy guns
// TODO Add UI
// TODO Add area turret controller
// TODO Add frame types (Constructable from different materials to affect health)
// TODO Add component parts list
// TODO Add sensor component processing, including upgrades to accuracy
// TODO Add malf upgrade
// TODO Add sprites
// TODO Add warrant status checking
// TODO Incorporate network_lock and access_lock stock parts
// TODO Allow defining whitelist from area
// TODO Allow defining req_access from area
// TODO Fix wires being accessible with closed panel
// TODO Fix runtime errors when turret has construct_state of PANEL_OPEN
// TODO Switch individual turret sprites to colorable 'lighting' overlay
// TODO Add glow lighting effect
// TODO Add automatic mode switch based on alert status
// TODO Re-organize procs (Overrides > Getters/Setters > Logic Procs)
// TODO Replace current emag effect with unlocking access and adding haywire mode option


/obj/machinery/turret
	name = "turret"
	desc = "A standard automated turret system."
	icon = 'icons/obj/turret.dmi' // TODO Get sprites
	icon_state = "turret_off" // TODO Get sprites

	anchored = 1
	density = 1
	idle_power_usage = 50
	active_power_usage = 300
	power_channel = EQUIP
	req_access = list(list(access_security, access_bridge)) // List of access flags permitted to unlock/lock the panel TODO Replace with access_lock and network_lock
	stat_immune = 0
	waterproof = TRUE
	base_type = /obj/machinery/turret
	uncreated_component_parts = null
	maximum_component_parts = list(
		/obj/item/stock_parts = 10,
		/obj/item/stock_parts/weapon_control_system = 1
	)
	construct_state = /decl/machine_construction/default/panel_closed
	wires = /datum/wires/turret

	var/turret_mode = TURR_MODE_OFF // User-defined mode of the turret. On, Off, or 'Haywire' (EMP effect)
	var/turret_state = TURR_STATE_OFF // Current state of the turret. Off, Idle, Engaged, or Disabled
	var/turret_targets = TURR_TGT_PEOPLE | TURR_TGT_UNKNOWNS // Bitflag. What the turret will and will not target
	var/haywire = FALSE // Turret is malfunctioning/going haywire (EMP/Hack/EMAG effect). Fires on everything regardless of settings.
	var/haywire_timer
	var/power_cut = FALSE // Power wire is cut
	var/power_cut_timer
	var/panel_locked = TRUE // If the turret control panel is locked TODO Remove this; Replace with automatic ID checks
	var/lock_cut = FALSE // Lock wire is cut. Cut means the lock state cannot be
	var/ai_locked = FALSE // If the turret control panel is locked from AI access
	var/list/turret_whitelist =  list(list(access_security, access_bridge)) // List of access flags that will NOT be fired on
	var/cooldown = FALSE // True = Turret has recently fired and is on cooldown. False = Turret is ready to fire.
	var/turret_controller = FALSE // TRUE = Connected to area turret controller, if present. FALSE = Not connected/Independent
	var/last_target // Tracker for the last person the turret fired on, to keep firing at the same target.
	var/engaged = FALSE // State of if the turret is actively engaging someone or not
	var/fire_delay = 15 // Base fire delay modifier for the turret
	var/fire_accuracy = 0.25 // Base accuracy modifier for the turret


/obj/machinery/turret/Initialize()
	. = ..()
	update_state()


/obj/machinery/turret/examine(mob/user)
	. = ..()
	switch (turret_state)
		if (TURR_STATE_OFF)
			to_chat(user, "It appears to be turned off.")
		if (TURR_STATE_IDLE)
			to_chat(user, "It appears to be turned on and idle.")
		if (TURR_STATE_ENGAGED)
			to_chat(user, SPAN_WARNING("It appears to be turned on and preparing to fire!"))
		if (TURR_STATE_DISABLED)
			to_chat(user, "It appears to be disabled.")
		if (TURR_STATE_BROKEN)
			to_chat(user, "It appears to be broken.")
		if (TURR_STATE_UNARMED)
			to_chat(user, "It appears to be turned on and idle.")
		else
			to_chat(user, "It appears to be in some unrecognized state. Maybe you should bug report this.")

	var/obj/item/gun/G = get_gun()
	if (istype(G))
		to_chat(user, "It has \a [get_gun()] installed.")
	else
		to_chat(user, "It doesn't have a gun installed.")


/obj/machinery/turret/on_update_icon()
	switch (turret_state)
		if (TURR_STATE_OFF)
			icon_state = "turret_off"
		if (TURR_STATE_IDLE)
			icon_state = "turret_idle"
		if (TURR_STATE_ENGAGED)
			icon_state = "turret_active"
		if (TURR_STATE_DISABLED)
			icon_state = "turret_disabled"
		if (TURR_STATE_BROKEN)
			icon_state = "turret_broken"
		if (TURR_STATE_UNARMED)
			icon_state = "turret_unarmed"
		else
			icon_state = "turret_disabled"


/obj/machinery/turret/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	. = ..()
	// TODO


/obj/machinery/turret/CanUseTopic(mob/user)
	if (!anchored)
		to_chat(user, SPAN_NOTICE("\The [src] must be secured first!"))
		return STATUS_CLOSE

	if (turret_state == TURR_STATE_BROKEN)
		to_chat(user, SPAN_NOTICE("\The [src] is broken."))
		return STATUS_CLOSE

	if (turret_state == TURR_STATE_DISABLED)
		to_chat(user, SPAN_NOTICE("\The [src] is not functioning."))
		return STATUS_CLOSE

	if (issilicon(user) && (ai_locked || emagged))
		to_chat(user, SPAN_NOTICE("\The [src] rejects your input."))
		return STATUS_CLOSE

	if (!issilicon(user))
		if (emagged)
			to_chat(user, SPAN_WARNING("\The [src]'s panel displays an error. You can't see any way to access it."))
			return STATUS_CLOSE

		if (panel_locked)
			to_chat(user, SPAN_NOTICE("\The [src]'s panel is currently locked."))
			return STATUS_CLOSE

	return ..()


/obj/machinery/turret/OnTopic(mob/user, href_list, datum/topic_state/state)
	if (href_list["turret_mode"] == "1")
		set_mode(TURR_MODE_ON)
		. = TOPIC_REFRESH

	if (href_list["turret_mode"] == "0")
		set_mode(TURR_MODE_OFF)
		. = TOPIC_REFRESH

	if (href_list["target_toggle_people"])
		set_target(TURR_TGT_PEOPLE)
		. = TOPIC_REFRESH

	if (href_list["target_toggle_unknown"])
		set_target(TURR_TGT_UNKNOWNS)
		. = TOPIC_REFRESH

	if (href_list["target_toggle_creature"])
		set_target(TURR_TGT_CREATURES)
		. = TOPIC_REFRESH

	if (href_list["target_toggle_synth"])
		set_target(TURR_TGT_SYNTHS)
		. = TOPIC_REFRESH

	if (href_list["target_toggle_downed"])
		set_target(TURR_TGT_DOWNED)
		. = TOPIC_REFRESH

	if (href_list["target_toggle_ign_access"])
		set_target(TURR_TGT_IGNORE_ACCESS)
		. = TOPIC_REFRESH


/obj/machinery/turret/interface_interact(user)
	ui_interact(user)
	return TRUE


/obj/machinery/turret/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/obj/item/stock_parts/weapon_control_system/WCS = get_wcs()
	var/obj/item/gun/G = get_gun()

	var/list/data = list()
	data["haywire"] = haywire
	data["turret_mode"] = turret_mode
	data["wcs"] = istype(WCS) ? WCS.name : null
	data["has_gun"] = istype(G)

	data["target_people"] = turret_targets & TURR_TGT_PEOPLE
	data["target_unknown"] = turret_targets & TURR_TGT_UNKNOWNS
	data["target_creature"] = turret_targets & TURR_TGT_CREATURES
	data["target_synth"] = turret_targets & TURR_TGT_SYNTHS
	data["target_downed"] = turret_targets & TURR_TGT_DOWNED
	data["target_ign_access"] = turret_targets & TURR_TGT_IGNORE_ACCESS

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "turret.tmpl", "Turret Controls", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)


/obj/machinery/turret/emp_act(severity)
	if (prob(60 / severity)) // 60% / 30% / 20% chance of temporary EMP effect
		set_stat(EMPED, TRUE)
		addtimer(CALLBACK(src, .proc/set_stat, EMPED, FALSE), rand((10 SECONDS) / severity, (20 SECONDS) / severity), TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT)

	if (prob(45 / severity)) // 45% / 23% / 15% chance of going haywire
		var/haywire_time
		if (severity == 1)
			haywire_time = prob(50) ? 0 : rand(30 SECONDS, 120 SECONDS) // Max severity should be a 50% chance of a permanent effect requiring an engineer to fix, or of an effect lasting 30-120 seconds
		else
			haywire_time = rand((30 SECONDS) / severity, (120 SECONDS) / severity) // 15-60 / 10-30 seconds
		set_haywire(haywire_time)
	else if (!controller_enabled())
		set_mode(rand(0, 1)) // 50% chance of on/off status

	..()


/obj/machinery/turret/set_stat()
	if (..())
		update_state()


/obj/machinery/turret/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()
	if (emagged)
		to_chat(user, SPAN_NOTICE("\The [src]'s control panel has already been shorted and is unresponsive to further hacking attempts."))
		return NO_EMAG_ACT

	set_stat(EMPED, TRUE)
	set_haywire()
	turret_controller = FALSE
	to_chat(user, SPAN_NOTICE("You swipe \the [emag_source] through \the [src]'s panel lock, shorting out the systems. You might want to get out of range before it reboots."))
	visible_message(SPAN_NOTICE("\The [src] sparks ominously as it powers down."), SPAN_NOTICE("You hear an ominous sparking."))

	addtimer(CALLBACK(src, .proc/set_stat, EMPED, FALSE), rand(60 SECONDS, 120 SECONDS), TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT)


/obj/machinery/turret/Process()
	if (can_fire() && istype(get_turf(src), /turf))
		var/list/targets = list()
		for (var/mob/M in mobs_in_view(world.view, src))
			if (target_validation(M))
				targets += M

		if (haywire && prob(50))
			var/target = pick(view(src))
			if (target)
				engage_target(target)
			return
		else if (targets.len)
			if (last_target && (last_target in targets) && istype(get_turf(last_target), /turf))
				engage_target(last_target)
				return
			else
				while (targets.len > 0)
					var/mob/target = pick(targets)
					if (!istype(get_turf(target), /turf))
						targets -= target
					else
						engage_target(target)
						return

		// If we reach this point, the turret never engaged anyone and should go back to idle
		engaged = FALSE

	update_state()


/obj/machinery/turret/is_unpowered(additional_flags)
	if (power_cut)
		return TRUE

	. = ..()


/**
 * Sets the haywire flag with a pre-determined time in ticks, or indefinitely if time is undefined or 0
 */
/obj/machinery/turret/proc/set_haywire(time = 0)
	haywire = TRUE
	if (time)
		haywire_timer = addtimer(CALLBACK(src, .proc/clear_haywire), time, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT | TIMER_STOPPABLE)


/**
 * Clears the haywire flag. If the turret is emagged, this does nothing unless ignore_emagged is TRUE
 */
/obj/machinery/turret/proc/clear_haywire(ignore_emagged = FALSE)
	if (!emagged || ignore_emagged)
		haywire = FALSE
	if (haywire_timer)
		deltimer(haywire_timer)
		haywire_timer = null


/**
 * Restores power. Primarily used by wires.
 */
/obj/machinery/turret/proc/regain_power()
	power_cut = wires.IsIndexCut(TURRET_WIRE_POWER) ? FALSE : TRUE
	update_state()
	if (power_cut_timer)
		deltimer(power_cut_timer)


/**
 * Disables power for a set time in ticks, or indefinitely if time is undefined or 0. Primarily used by wires.
 */
/obj/machinery/turret/proc/disable_power(time = 0)
	power_cut = TRUE
	update_state()
	if (time)
		power_cut_timer = addtimer(CALLBACK(src, .proc/regain_power), time, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT | TIMER_STOPPABLE)


/**
 * Engages at a given target - Will call fire. Will also begin processing of bursts if applicable.
 */
/obj/machinery/turret/proc/engage_target(atom/target)
	var/obj/item/gun/G = get_gun()

	// Allow a brief period for the turret to 'acquire target' before firing the first shot. Gives people a chance to run.
	last_target = target
	set_dir(get_dir(src, last_target))
	if (!engaged)
		engaged = TRUE
		cooldown(fire_delay(TRUE))
		update_state()
		return

	// Fire
	visible_message(SPAN_WARNING("\The [src] fires \the [G]!"))
	fire(target)

	// Handle burst fire
	if (G.burst > 1)
		addtimer(CALLBACK(src, .proc/resolve_burst_fire, target, 1, G.burst), G.burst_delay, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT)
	else if (G.can_autofire) // No full auto turrets - Operate as a 'short burst' instead
		addtimer(CALLBACK(src, .proc/resolve_burst_fire, target, 1, 5), G.burst_delay, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT)


/**
 * Determines the amount of time to wait for turret firing cooldown based on the turret, installed WCS, and gun
 */
/obj/machinery/turret/proc/fire_delay(ignore_gun = FALSE)
	var/final_delay = fire_delay

	// Process upgraded Weapon Control Systems
	var/obj/item/stock_parts/weapon_control_system/WCS = get_wcs()
	final_delay = final_delay / WCS.rating // 100% / 50% / 33% base fire delay

	// Process gun's delay
	if (!ignore_gun)
		var/obj/item/gun/G = get_gun()
		if (G)
			final_delay += G.fire_delay

	return final_delay


/**
 * Handles the act of firing the turret's gun
 */
/obj/machinery/turret/proc/fire(atom/target, burst_sequence = 1)
	var/obj/item/stock_parts/weapon_control_system/WCS = get_wcs()
	var/obj/item/gun/G = get_gun()
	var/obj/item/projectile/P
	// Handle the two different gun types - Energy and XYZ
	if (istype(G, /obj/item/gun/energy))
		var/obj/item/gun/energy/EG = G
		P = new EG.projectile_type
	if (!P)
		crash_with("Couldn't create a projectile. This is probably a bug.")

	// Process accuracy
	P.hitchance_mod = G.accuracy_power * G.accuracy * fire_accuracy
	P.dispersion = G.dispersion[min(burst_sequence, G.dispersion.len)]

	var/def_zone = get_exposed_defense_zone(target) // Ensure the turret targets extremities if firing at someone that's got a grab
	var/launched = !P.launch_from_gun(target, src, G, def_zone)
	if (launched)
		G.play_fire_sound(src, P)
		if (G.combustion)
			var/turf/curloc = get_turf(src)
			if(curloc)
				curloc.hotspot_expose(700, 5)

	use_power_oneoff(WCS.power_use)
	cooldown(fire_delay())


/**
 * Handles firing additional rounds. Primarily used for weapons in burst mode. Calls itself recursively, and is called in fire() using timers.
 */
/obj/machinery/turret/proc/resolve_burst_fire(atom/target, shot_number, total_shots)
	// Ensure the turret can stil fire - I.e., not broken or disabled
	if (!can_fire(TRUE))
		return
	var/obj/item/gun/G = get_gun()
	if (!G || !istype(G))
		return // If there's no gun, i.e. it was removed mid-burst, stop firing
	if (shot_number > total_shots)
		return // Failsafe in case this somehow decides to run indefinitely
	shot_number++
	fire(target, shot_number)
	if (shot_number < total_shots)
		addtimer(CALLBACK(src, .proc/resolve_burst_fire, target, shot_number, total_shots), G.burst_delay, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT)


/**
 * Handles cooldown processing
 */
/obj/machinery/turret/proc/cooldown(delay)
	cooldown = TRUE
	addtimer(CALLBACK(src, .proc/cooldown_resolve), delay, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT)


/**
 * Handles ending the cooldown state. Used by cooldown() via timer - Probably shouldn't be called directly.
 */
/obj/machinery/turret/proc/cooldown_resolve()
	cooldown = FALSE


/**
 * Handles checks for if the turret can currently fire
 */
/obj/machinery/turret/proc/can_fire(ignore_cooldown = FALSE)
	if (turret_state == TURR_STATE_BROKEN || turret_state == TURR_STATE_DISABLED || turret_state == TURR_STATE_OFF || turret_state == TURR_STATE_UNARMED)
		return FALSE
	if (!ignore_cooldown && cooldown)
		return FALSE
	return TRUE


/**
 * Handles validation of a mob as a potential target based on various conditions
 */
/obj/machinery/turret/proc/target_validation(mob/M)
	// Initial checks - Things that should always cause the target to not be valid
	if (!M || !istype(M))
		return FALSE
	if (M.invisibility >= INVISIBILITY_LEVEL_ONE)
		return FALSE
	if (get_dist(src, M) > 7)
		return FALSE
	if (!check_trajectory(M, src))
		return FALSE
	if (isAI(M))
		return FALSE // Failsafe to prevent AI killing/suicide shennanigans

	// If the turret is going haywire, any checks past this point should be ignored and the turret should always target the mod
	if (haywire)
		return TRUE

	// Remaining checks are based on turret targeting configuration
	if (!(turret_targets & TURR_TGT_CREATURES) && (isanimal(M) || issmall(M)))
		return FALSE

	if (!(turret_targets & TURR_TGT_DOWNED) && M.stat)
		return FALSE

	if (!(turret_targets & TURR_TGT_DOWNED) && iscuffed(M))
		return FALSE

	if (!(turret_targets & TURR_TGT_SYNTHS) && issilicon(M))
		return FALSE

	// Additional checks for mob/living
	var/mob/living/L = M
	if (istype(L))
		if (!(turret_targets & TURR_TGT_DOWNED) && L.lying)
			return FALSE

	// If no other checks failed, then final checks for ID/access
	var/mob/living/carbon/human/H = M
	if (istype(H))
		var/access_check = FALSE
		var/id_check = FALSE

		if (turret_targets & TURR_TGT_PEOPLE)
			if (turret_targets & TURR_TGT_IGNORE_ACCESS)
				access_check = TRUE
			else
				var/area/A = get_area(src)
				var/list/access = H.GetAccess()
				if (!access || !has_access(A.req_access, access))
					access_check = TRUE

		if (turret_targets & TURR_TGT_UNKNOWNS)
			var/obj/item/card/id/id = H.GetIdCard()
			if (!id || !istype(id))
				id_check = TRUE

		if (!access_check && !id_check)
			return FALSE

	// All else fails, the target's valid
	return TRUE


/**
 * Updates turret's state var based on mode and other conditions
 */
/obj/machinery/turret/proc/update_state()
	var/old_state = turret_state
	if (is_broken())
		turret_state = TURR_STATE_BROKEN
	else if (is_unpowered(EMPED))
		turret_state = TURR_STATE_DISABLED
	else if (!get_gun() && turret_mode != TURR_MODE_OFF)
		turret_state = TURR_STATE_UNARMED
	else if (engaged && turret_mode != TURR_MODE_OFF)
		turret_state = TURR_STATE_ENGAGED
	else
		switch (turret_mode)
			if (TURR_MODE_ON)
				turret_state = TURR_STATE_IDLE
			if (TURR_MODE_OFF)
				turret_state = TURR_STATE_OFF
			else
				turret_state = TURR_STATE_OFF

	if (old_state != turret_state)
		if (turret_state == TURR_STATE_OFF || turret_state == TURR_STATE_DISABLED)
			if (old_state == TURR_STATE_IDLE || old_state == TURR_STATE_ENGAGED)
				visible_message("\The [src] slowly grows dark and quiet as it powers down.", "The soft whirring and beeping of a nearby machine slowly grows quiet.")
				engaged = FALSE
		else if (turret_state == TURR_STATE_IDLE)
			if (old_state == TURR_STATE_ENGAGED)
				visible_message(SPAN_NOTICE("\The [src] whirrs and beeps as it disengages and returns to an idle state."), SPAN_NOTICE("You hear an ominous beeping and whirring sound."))
			else
				visible_message(SPAN_NOTICE("\The [src] whirrs and beeps as it comes online and begins scanning the room."), SPAN_NOTICE("You hear an ominous beeping and whirring sound."))
		else if (turret_state == TURR_STATE_ENGAGED)
			visible_message(SPAN_WARNING("\The [src] emits a loud warning buzz as it locks onto a target and prepares to fire!"), SPAN_NOTICE("You hear a loud buzz and an ominous clicking."))
		else if (turret_state == TURR_STATE_BROKEN)
			if (!(reason_broken & MACHINE_BROKEN_NO_PARTS) && !(reason_broken & MACHINE_BROKEN_CONSTRUCT))
				visible_message(SPAN_WARNING("\The [src] sparks and breaks apart!"), SPAN_NOTICE("You hear the sound of sparking and breaking."))

		// Sound effects
		if (old_state == TURR_STATE_ENGAGED)
			playsound(src, 'sound/weapons/TargetOff.ogg', 30, 1)
		else if (turret_state == TURR_STATE_ENGAGED)
			playsound(src, 'sound/weapons/TargetOn.ogg', 30, 1)

		update_icon()


/**
 * Checks if a valid turret controller exists in the turret's area. Does not take into account turret configuration - Use `controller_enabled()` for that.
 * Returns TRUE or FALSE
 */
/obj/machinery/turret/proc/has_controller()
	var/area/A = get_area(src)
	return A && A.turret_controls.len > 0 // TODO Update with new turret controller


/**
 * Toggles the state of `turret_controller` if there is a controller active in the area.
 * Returns TRUE if successful, otherwise FALSE
 */
/obj/machinery/turret/proc/toggle_controller()
	if (has_controller() && !emagged)
		turret_controller = !turret_controller
		return TRUE
	return FALSE


/**
 * Checks various conditions to determine if the turret controller is enabled.
 * Returns TRUE or FALSE
 */
/obj/machinery/turret/proc/controller_enabled()
	if (!turret_controller)
		return FALSE

	if (!has_controller())
		turret_controller = FALSE // Failsafe to allow this proc to fix a broken state if there is no controller but the var is enabled
		return FALSE

	// TODO Add check for controller wire being disabled


/**
 * Sets the turrets mode and updates state
 */
/obj/machinery/turret/proc/set_mode(mode)
	if (emagged)
		turret_mode = TURR_MODE_ON
	else
		turret_mode = mode
	update_state()


/**
 * Indicates whether the turret is in a state considered online and operating.
 */
/obj/machinery/turret/proc/operating()
	return (turret_state == TURR_STATE_IDLE || turret_state == TURR_STATE_ENGAGED || turret_state == TURR_STATE_UNARMED)


/**
 * Returns the weapon control system component
 */
/obj/machinery/turret/proc/get_wcs()
	for (var/obj/item/stock_parts/weapon_control_system/WCS in get_all_components_of_type(/obj/item/stock_parts/weapon_control_system))
		. = WCS


/**
 * Returns the gun stored in the weapon control system component
 */
/obj/machinery/turret/proc/get_gun()
	var/obj/item/stock_parts/weapon_control_system/WCS = get_wcs()
	if (istype(WCS) && istype(WCS.installed_gun, /obj/item/gun))
		. = WCS.installed_gun


/**
 * Sets a target flag to on or off. Will flip the flag's state instead if new_mode is not provided.
 */
/obj/machinery/turret/proc/set_target(target_bit, new_mode = "flip")
	if (new_mode == "flip")
		turret_targets ^= target_bit
	else if (new_mode)
		turret_targets |= target_bit
	else
		turret_targets = turret_targets & ~target_bit
