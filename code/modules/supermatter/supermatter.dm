/*
	How to tweak the SM

	POWER_FACTOR		directly controls how much power the SM puts out at a given level of excitation (power var). Making this lower means you have to work the SM harder to get the same amount of power.
	CRITICAL_TEMPERATURE	The temperature at which the SM starts taking damage.

	CHARGING_FACTOR		Controls how much emitter shots excite the SM.
	DAMAGE_RATE_LIMIT	Controls the maximum rate at which the SM will take damage due to high temperatures.
*/

// Base variants are applied to everyone on the same Z level
// Range variants are applied on per-range basis: numbers here are on point blank, it scales with the map size (assumes square shaped Z levels)
#define DETONATION_RADS 40
#define DETONATION_MOB_CONCUSSION 4			// Value that will be used for SET_STATUS_MAX(src, STAT_WEAK) on mobs.

// Base amount of ticks for which a specific type of machine will be offline for. +- 20% added by RNG.
// This does pretty much the same thing as an electrical storm, it just affects the whole Z level instantly.
#define DETONATION_APC_OVERLOAD_PROB 10		// prob() of overloading an APC's lights.
#define DETONATION_SHUTDOWN_APC 120			// Regular APC.
#define DETONATION_SHUTDOWN_CRITAPC 10		// Critical APC. AI core and such. Considerably shorter as we don't want to kill the AI with a single blast. Still a nuisance.
#define DETONATION_SHUTDOWN_SMES 60			// SMES
#define DETONATION_SHUTDOWN_RNG_FACTOR 20	// RNG factor. Above shutdown times can be +- X%, where this setting is the percent. Do not set to 100 or more.
#define DETONATION_SOLAR_BREAK_CHANCE 60	// prob() of breaking solar arrays (this is per-panel, and only affects the Z level SM is on)

#define WARNING_DELAY 20			//seconds between warnings.

#define LIGHT_POWER_CALC (max(power / 50, 1))

var/global/list/supermatter_final_thoughts = list(
	"Oh, fuck.",
	"That was not a wise decision."
)

// Returns a truthy value that is also used for power generation by the supermatter core itself.
/proc/try_supermatter_consume(var/mob/user, var/atom/movable/victim, var/atom/source, var/collided)

	if(!istype(victim) || !istype(source) || istype(victim, /obj/effect) || !victim.simulated || isobserver(victim))
		return 0

	var/decl/pronouns/victim_pronouns = victim.get_pronouns()
	if(isliving(victim))
		if(user)
			var/hurls = (collided ? "hurls" : "pushes")
			source.visible_message(
				SPAN_DANGER("\The [user] [hurls] \the [victim] into \the [source], inducing a resonance! [victim_pronouns.He] starts to glow and catches aflame before flashing into ash."),\
				SPAN_DANGER("\The [user] [hurls] you into \the [source], and your ears are filled with unearthly ringing."), \
				SPAN_WARNING("You hear an unearthly ringing, then what sounds like a shrilling kettle as a wave of heat washes over you."))
		else
			source.visible_message(
				SPAN_DANGER("\The [victim] [collided ? "slams into" : "touches"] \the [source], inducing a resonance! [victim_pronouns.He] starts to glow and catches aflame before flashing into ash."), \
				SPAN_DANGER("You [collided ? "slam into" : "touch"] \the [source], and your ears are filled with unearthly ringing. Your last thought is \"[pick(global.supermatter_final_thoughts)]\""), \
				SPAN_WARNING("You hear an unearthly ringing, then what sounds like a shrilling kettle as a wave of heat washes over you."))
	else
		if(user)
			source.visible_message( \
				SPAN_DANGER("\The [user][collided ? "throws" : "touches"] \the [victim] [collided ? "into" : "to"] \the [source] and [victim_pronouns.he] instantly flashes away into ashes."), \
				SPAN_WARNING("You hear a loud crack as you are washed with a wave of heat."))
		else
			source.visible_message( \
				SPAN_DANGER("\The [victim] [collided ? "smacks into" : "touches"] \the [source] and instantly flashes away into ashes."), \
				SPAN_WARNING("You hear a loud crack as you are washed with a wave of heat."))
	playsound(source, 'sound/effects/supermatter.ogg', 50, 1)

	if(isliving(victim))
		var/mob/living/M = victim
		M.dust()
		. = 2
	else
		. = 1
		qdel(victim)

	//Some poor sod got eaten, go ahead and irradiate people nearby.
	var/list/viewers = viewers(source)
	for(var/mob/living/M in range(10, get_turf(source)))
		if(M in viewers)
			M.show_message( \
				SPAN_DANGER("As \the [source] slowly stops resonating, you find your skin covered in new radiation burns."), 1,\
				SPAN_DANGER("The unearthly ringing subsides and you notice you have new radiation burns."), 2)
		else
			M.show_message(SPAN_DANGER("You hear an uneartly ringing and notice your skin is covered in fresh radiation burns."), 2)
	var/rads = 500
	SSradiation.radiate(source, rads)

/obj/machinery/power/supermatter
	name = "Supermatter"
	desc = "A strangely translucent and iridescent crystal. <span class='danger'>You get headaches just from looking at it.</span>"
	icon = 'icons/obj/engine.dmi'
	icon_state = "darkmatter"
	density = 1
	anchored = 0
	light_range = 4
	layer = ABOVE_OBJ_LAYER
	matter = list(
		/decl/material/solid/exotic_matter = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/steel =   MATTER_AMOUNT_REINFORCEMENT
	)

	var/nitrogen_retardation_factor = 0.15 // Higher == N2 slows reaction more
	var/thermal_release_modifier = 10000   // Higher == more heat released during reaction
	var/product_release_modifier = 1500     // Higher == less product gas released by reaction
	var/oxygen_release_modifier = 15000    // Higher == less oxygen released at high temperature/power
	var/radiation_release_modifier = 2     // Higher == more radiation released with more power.
	var/reaction_power_modifier =  1.1     // Higher == more overall power

	//Controls how much power is produced by each collector in range - this is the main parameter for tweaking SM balance, as it basically controls how the power variable relates to the rest of the game.
	var/power_factor = 1.0
	var/decay_factor = 700			//Affects how fast the supermatter power decays
	var/critical_temperature = 5000	//K
	var/charging_factor = 0.05
	var/damage_rate_limit = 4.5		//damage rate cap at power = 300, scales linearly with power

	var/gasefficency = 0.25

	var/base_icon_state = "darkmatter"

	var/last_power
	var/damage = 0
	var/damage_archived = 0
	var/safe_alert = "Crystaline hyperstructure returning to safe operating levels."
	var/safe_warned = 0
	var/public_alert = 0 //Stick to Engineering frequency except for big warnings when integrity bad
	var/warning_point = 100
	var/warning_alert = "Danger! Crystal hyperstructure instability!"
	var/emergency_point = 700
	var/emergency_alert = "CRYSTAL DELAMINATION IMMINENT."
	var/explosion_point = 1000

	light_color = "#8a8a00"
	var/warning_color = "#b8b800"
	var/emergency_color = "#d9d900"

	var/grav_pulling = 0
	// Time in ticks between delamination ('exploding') and exploding (as in the actual boom)
	var/pull_time = 300
	var/explosion_power = 9

	var/emergency_issued = 0

	// Time in 1/10th of seconds since the last sent warning
	var/lastwarning = 0

	// This stops spawning redundand explosions. Also incidentally makes supermatter unexplodable if set to 1.
	var/exploded = 0

	var/power = 0
	var/oxygen = 0

	//Temporary values so that we can optimize this
	//How much the bullets damage should be multiplied by when it is added to the internal variables
	var/config_bullet_energy = 2
	//How much of the power is left after processing is finished?
//        var/config_power_reduction_per_tick = 0.5
	//How much hallucination should it produce per unit of power?
	var/config_hallucination_power = 0.1

	var/debug = 0

	var/disable_adminwarn = FALSE

	var/aw_normal = FALSE
	var/aw_notify = FALSE
	var/aw_warning = FALSE
	var/aw_danger = FALSE
	var/aw_emerg = FALSE
	var/aw_delam = FALSE
	var/aw_EPR = FALSE

	var/list/threshholds = list( // List of lists defining the amber/red labeling threshholds in readouts. Numbers are minminum red and amber and maximum amber and red, in that order
		list("name" = SUPERMATTER_DATA_EER,         "min_h" = -1, "min_l" = -1,  "max_l" = 150,  "max_h" = 300),
		list("name" = SUPERMATTER_DATA_TEMPERATURE, "min_h" = -1, "min_l" = -1,  "max_l" = 4000, "max_h" = 5000),
		list("name" = SUPERMATTER_DATA_PRESSURE,    "min_h" = -1, "min_l" = -1,  "max_l" = 5000, "max_h" = 10000),
		list("name" = SUPERMATTER_DATA_EPR,         "min_h" = -1, "min_l" = 1.0, "max_l" = 2.5,  "max_h" = 4.0)
	)

/obj/machinery/power/supermatter/Initialize()
	. = ..()
	uid = gl_uid++

/obj/machinery/power/supermatter/get_matter_amount_modifier()
	. = ..() * (1/HOLLOW_OBJECT_MATTER_MULTIPLIER) * 10 // Big solid chunk of matter.

/obj/machinery/power/supermatter/proc/handle_admin_warnings()
	if(disable_adminwarn)
		return

	// Generic checks, similar to checks done by supermatter monitor program.
	aw_normal = status_adminwarn_check(SUPERMATTER_NORMAL, aw_normal, "INFO: Supermatter crystal has been energised.", FALSE)
	aw_notify = status_adminwarn_check(SUPERMATTER_NOTIFY, aw_notify, "INFO: Supermatter crystal is approaching unsafe operating temperature.", FALSE)
	aw_warning = status_adminwarn_check(SUPERMATTER_WARNING, aw_warning, "WARN: Supermatter crystal is taking integrity damage!", FALSE)
	aw_danger = status_adminwarn_check(SUPERMATTER_DANGER, aw_danger, "WARN: Supermatter integrity is below 50%!", TRUE)
	aw_emerg = status_adminwarn_check(SUPERMATTER_EMERGENCY, aw_emerg, "CRIT: Supermatter integrity is below 25%!", FALSE)
	aw_delam = status_adminwarn_check(SUPERMATTER_DELAMINATING, aw_delam, "CRIT: Supermatter is delaminating!", TRUE)

	// EPR check. Only runs when supermatter is energised. Triggers when there is very low amount of coolant in the core (less than one standard canister).
	// This usually means a core breach or deliberate venting.
	if(get_status() && (get_epr() < 0.5))
		if(!aw_EPR)
			log_and_message_admins("WARN: Supermatter EPR value low. Possible core breach detected.")
		aw_EPR = TRUE
	else
		aw_EPR = FALSE

/obj/machinery/power/supermatter/proc/status_adminwarn_check(var/min_status, var/current_state, var/message, var/send_to_irc = FALSE)
	var/status = get_status()
	if(status >= min_status)
		if(!current_state)
			log_and_message_admins(message)
			if(send_to_irc)
				send2adminirc(message)
		return TRUE
	else
		return FALSE

/obj/machinery/power/supermatter/proc/get_epr()
	var/turf/T = get_turf(src)
	if(!istype(T))
		return
	var/datum/gas_mixture/air = T.return_air()
	if(!air)
		return 0
	return round((air.total_moles / air.group_multiplier) / 23.1, 0.01)

/obj/machinery/power/supermatter/proc/get_status()
	var/turf/T = get_turf(src)
	if(!T)
		return SUPERMATTER_ERROR
	var/datum/gas_mixture/air = T.return_air()
	if(!air)
		return SUPERMATTER_ERROR

	if(grav_pulling || exploded)
		return SUPERMATTER_DELAMINATING

	if(get_integrity() < 25)
		return SUPERMATTER_EMERGENCY

	if(get_integrity() < 50)
		return SUPERMATTER_DANGER

	if((get_integrity() < 100) || (air.temperature > critical_temperature))
		return SUPERMATTER_WARNING

	if(air.temperature > (critical_temperature * 0.8))
		return SUPERMATTER_NOTIFY

	if(power > 5)
		return SUPERMATTER_NORMAL
	return SUPERMATTER_INACTIVE


/obj/machinery/power/supermatter/proc/explode()
	set waitfor = 0

	if(exploded)
		return

	log_and_message_admins("Supermatter delaminating at [x] [y] [z]")
	anchored = 1
	grav_pulling = 1
	exploded = 1
	sleep(pull_time)
	var/turf/TS = get_turf(src)		// The turf supermatter is on. SM being in a locker, exosuit, or other container shouldn't block it's effects that way.
	if(!istype(TS))
		return

	var/list/affected_z = GetConnectedZlevels(TS.z)

	// Effect 1: Radiation, weakening to all mobs on Z level
	for(var/z in affected_z)
		SSradiation.z_radiate(locate(1, 1, z), DETONATION_RADS, 1)

	for(var/mob/living/mob in global.living_mob_list_)
		var/turf/TM = get_turf(mob)
		if(!TM)
			continue
		if(!(TM.z in affected_z))
			continue

		SET_STATUS_MAX(mob, STAT_WEAK, DETONATION_MOB_CONCUSSION)
		to_chat(mob, "<span class='danger'>An invisible force slams you against the ground!</span>")

	// Effect 2: Z-level wide electrical pulse
	for(var/obj/machinery/power/apc/A in SSmachines.machinery)
		if(!(A.z in affected_z))
			continue

		// Overloads lights
		if(prob(DETONATION_APC_OVERLOAD_PROB))
			A.overload_lighting()
		// Causes the APCs to go into system failure mode.
		var/random_change = rand(100 - DETONATION_SHUTDOWN_RNG_FACTOR, 100 + DETONATION_SHUTDOWN_RNG_FACTOR) / 100
		if(A.is_critical)
			A.energy_fail(round(DETONATION_SHUTDOWN_CRITAPC * random_change))
		else
			A.energy_fail(round(DETONATION_SHUTDOWN_APC * random_change))

	for(var/obj/machinery/power/smes/buildable/S in SSmachines.machinery)
		if(!(S.z in affected_z))
			continue
		// Causes SMESes to shut down for a bit
		var/random_change = rand(100 - DETONATION_SHUTDOWN_RNG_FACTOR, 100 + DETONATION_SHUTDOWN_RNG_FACTOR) / 100
		S.energy_fail(round(DETONATION_SHUTDOWN_SMES * random_change))

	// Effect 3: Break solar arrays

	for(var/obj/machinery/power/solar/S in SSmachines.machinery)
		if(!(S.z in affected_z))
			continue
		if(prob(DETONATION_SOLAR_BREAK_CHANCE))
			S.set_broken(TRUE)



	// Effect 4: Medium scale explosion
	spawn(0)
		explosion(TS, explosion_power/2, explosion_power, explosion_power * 2, explosion_power * 4, 1)
		qdel(src)

/obj/machinery/power/supermatter/examine(mob/user)
	. = ..()
	if(user.skill_check(SKILL_ENGINES, SKILL_EXPERT))
		var/integrity_message
		switch(get_integrity())
			if(0 to 30)
				integrity_message = "<span class='danger'>It looks highly unstable!</span>"
			if(31 to 70)
				integrity_message = "It appears to be losing cohesion!"
			else
				integrity_message = "At a glance, it seems to be in sound shape."
		to_chat(user, integrity_message)
		if(user.skill_check(SKILL_ENGINES, SKILL_PROF))
			var/display_power = power
			display_power *= (0.85 + 0.3 * rand())
			display_power = round(display_power, 20)
			to_chat(user, "Eyeballing it, you place the relative EER at around [display_power] MeV/cm3.")

//Changes color and luminosity of the light to these values if they were not already set
/obj/machinery/power/supermatter/proc/shift_light(var/lum, var/clr)
	if(lum != light_range || abs(power - last_power) > 10 || clr != light_color)
		set_light(lum, LIGHT_POWER_CALC, clr)
		last_power = power

/obj/machinery/power/supermatter/proc/get_integrity()
	var/integrity = damage / explosion_point
	integrity = round(100 - integrity * 100)
	integrity = integrity < 0 ? 0 : integrity
	return integrity


/obj/machinery/power/supermatter/proc/announce_warning()
	var/integrity = get_integrity()
	var/alert_msg = " Integrity at [integrity]%"

	if(damage > emergency_point)
		alert_msg = emergency_alert + alert_msg
		lastwarning = world.timeofday - WARNING_DELAY * 4
	else if(damage >= damage_archived) // The damage is still going up
		safe_warned = 0
		alert_msg = warning_alert + alert_msg
		lastwarning = world.timeofday
	else if(!safe_warned)
		safe_warned = 1 // We are safe, warn only once
		alert_msg = safe_alert
		lastwarning = world.timeofday
	else
		alert_msg = null
	if(alert_msg)
		var/obj/item/radio/announcer = get_global_announcer()
		announcer.autosay(alert_msg, "Supermatter Monitor", "Engineering")
		//Public alerts
		if((damage > emergency_point) && !public_alert)
			announcer.autosay("WARNING: SUPERMATTER CRYSTAL DELAMINATION IMMINENT! SAFEROOMS UNBOLTED.", "Supermatter Monitor")
			public_alert = 1
			global.using_map.unbolt_saferooms()
			for(var/mob/M in global.player_list)
				var/turf/T = get_turf(M)
				if(T && (T.z in global.using_map.station_levels) && !istype(M,/mob/new_player) && !isdeaf(M))
					sound_to(M, 'sound/ambience/matteralarm.ogg')
		else if(safe_warned && public_alert)
			announcer.autosay(alert_msg, "Supermatter Monitor")
			public_alert = 0


/obj/machinery/power/supermatter/Process()
	var/turf/L = loc

	if(isnull(L))		// We have a null turf...something is wrong, stop processing this entity.
		return PROCESS_KILL

	if(!istype(L)) 	//We are in a crate or somewhere that isn't turf, if we return to turf resume processing but for now.
		return  //Yeah just stop.

	if(damage > explosion_point)
		if(!exploded)
			if(!isspaceturf(L) && (L.z in global.using_map.station_levels))
				announce_warning()
			explode()
	else if(damage > warning_point) // while the core is still damaged and it's still worth noting its status
		shift_light(5, warning_color)
		if(damage > emergency_point)
			shift_light(7, emergency_color)
		if(!isspaceturf(L) && ((world.timeofday - lastwarning) >= WARNING_DELAY * 10) && (L.z in global.using_map.station_levels))
			announce_warning()
	else
		shift_light(4,initial(light_color))
	if(grav_pulling)
		supermatter_pull(src)

	//Ok, get the air from the turf
	var/datum/gas_mixture/removed = null
	var/datum/gas_mixture/env = null

	//ensure that damage doesn't increase too quickly due to super high temperatures resulting from no coolant, for example. We dont want the SM exploding before anyone can react.
	//We want the cap to scale linearly with power (and explosion_point). Let's aim for a cap of 5 at power = 300 (based on testing, equals roughly 5% per SM alert announcement).
	var/damage_inc_limit = (power/300)*(explosion_point/1000)*damage_rate_limit

	if(!isspaceturf(L))
		env = L.return_air()
		removed = env.remove(gasefficency * env.total_moles)	//Remove gas from surrounding area

	if(!env || !removed || !removed.total_moles)
		damage += max((power - 15*power_factor)/10, 0)
	else if (grav_pulling) //If supermatter is detonating, remove all air from the zone
		env.remove(env.total_moles)
	else
		damage_archived = damage

		damage = max(0, damage + between(-damage_rate_limit, (removed.temperature - critical_temperature) / 150, damage_inc_limit))

		//Ok, 100% oxygen atmosphere = best reaction
		//Maxes out at 100% oxygen pressure
		oxygen = Clamp((removed.get_by_flag(XGM_GAS_OXIDIZER) - (removed.gas[/decl/material/gas/nitrogen] * nitrogen_retardation_factor)) / removed.total_moles, 0, 1)

		//calculate power gain for oxygen reaction
		var/temp_factor
		var/equilibrium_power
		if (oxygen > 0.8)
			//If chain reacting at oxygen == 1, we want the power at 800 K to stabilize at a power level of 400
			equilibrium_power = 400
			icon_state = "[base_icon_state]_glow"
		else
			//If chain reacting at oxygen == 1, we want the power at 800 K to stabilize at a power level of 250
			equilibrium_power = 250
			icon_state = base_icon_state

		temp_factor = ( (equilibrium_power/decay_factor)**3 )/800
		power = max( (removed.temperature * temp_factor) * oxygen + power, 0)

		var/device_energy = power * reaction_power_modifier

		//Release reaction gasses
		var/heat_capacity = removed.heat_capacity()
		removed.adjust_multi(/decl/material/solid/exotic_matter, max(device_energy / product_release_modifier, 0), \
		                     /decl/material/gas/oxygen, max((device_energy + removed.temperature - T0C) / oxygen_release_modifier, 0))

		var/thermal_power = thermal_release_modifier * device_energy
		if (debug)
			var/heat_capacity_new = removed.heat_capacity()
			visible_message("[src]: Releasing [round(thermal_power)] W.")
			visible_message("[src]: Releasing additional [round((heat_capacity_new - heat_capacity)*removed.temperature)] W with exhaust gasses.")

		removed.add_thermal_energy(thermal_power)
		removed.temperature = between(0, removed.temperature, 10000)

		env.merge(removed)

	for(var/mob/living/carbon/human/subject in view(src, min(7, round(sqrt(power/6)))))
		var/obj/item/organ/internal/eyes/eyes = subject.get_internal_organ(BP_EYES)
		if (!eyes)
			continue
		if (BP_IS_PROSTHETIC(eyes))
			continue
		if(subject.has_meson_effect())
			continue
		var/effect = max(0, min(200, power * config_hallucination_power * sqrt( 1 / max(1,get_dist(subject, src)))) )
		subject.adjust_hallucination(effect, 0.25 * effect)


	SSradiation.radiate(src, power * radiation_release_modifier) //Better close those shutters!
	power -= (power/decay_factor)**3		//energy losses due to radiation
	handle_admin_warnings()

	return 1


/obj/machinery/power/supermatter/bullet_act(var/obj/item/projectile/Proj)
	var/turf/L = loc
	if(!istype(L))		// We don't run process() when we are in space
		return 0	// This stops people from being able to really power up the supermatter
				// Then bring it inside to explode instantly upon landing on a valid turf.


	var/proj_damage = Proj.get_structure_damage()
	if(istype(Proj, /obj/item/projectile/beam))
		power += proj_damage * config_bullet_energy	* charging_factor / power_factor
	else
		damage += proj_damage * config_bullet_energy
	return 0

/obj/machinery/power/supermatter/attack_robot(mob/user)
	if(Adjacent(user))
		return attack_hand(user)
	else
		ui_interact(user)
	return

/obj/machinery/power/supermatter/attack_ai(mob/living/silicon/ai/user)
	ui_interact(user)

/obj/machinery/power/supermatter/attack_ghost(mob/user)
	ui_interact(user)

/obj/machinery/power/supermatter/attack_hand(mob/user)
	if(Consume(null, user, TRUE))
		return TRUE
	return ..()

// This is purely informational UI that may be accessed by AIs or robots
/obj/machinery/power/supermatter/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	data["integrity_percentage"] = round(get_integrity())
	var/datum/gas_mixture/env = null
	var/turf/T = get_turf(src)

	if(istype(T))
		env = T.return_air()

	if(!env)
		data["ambient_temp"] = 0
		data["ambient_pressure"] = 0
	else
		data["ambient_temp"] = round(env.temperature)
		data["ambient_pressure"] = round(env.return_pressure())
	data["detonating"] = grav_pulling
	data["energy"] = power

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "supermatter_crystal.tmpl", "Supermatter Crystal", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/power/supermatter/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/tape_roll))
		to_chat(user, "You repair some of the damage to \the [src] with \the [W].")
		damage = max(damage -10, 0)

	user.visible_message("<span class=\"warning\">\The [user] touches \a [W] to \the [src] as a silence fills the room...</span>",\
		"<span class=\"danger\">You touch \the [W] to \the [src] when everything suddenly goes silent.\"</span>\n<span class=\"notice\">\The [W] flashes into dust as you flinch away from \the [src].</span>",\
		"<span class=\"warning\">Everything suddenly goes silent.</span>")
	user.drop_from_inventory(W)
	Consume(user, W, TRUE)
	user.apply_damage(150, IRRADIATE, damage_flags = DAM_DISPERSED)

/obj/machinery/power/supermatter/Bumped(atom/AM)
	if(!Consume(null, AM))
		return ..()

/obj/machinery/power/supermatter/proc/Consume(var/mob/living/user, var/obj/item/thing, var/touched)
	. = try_supermatter_consume(user, thing, src, touched)
	if(. <= 0)
		return
	power += . * 200
	. = !!.

/proc/supermatter_pull(var/atom/target, var/pull_range = 255, var/pull_power = STAGE_FIVE)
	for(var/atom/A in range(pull_range, target))
		A.singularity_pull(target, pull_power)

/obj/machinery/power/supermatter/GotoAirflowDest(n) //Supermatter not pushed around by airflow
	return

/obj/machinery/power/supermatter/RepelAirflowDest(n)
	return

/obj/machinery/power/supermatter/explosion_act(var/severity)
	. = ..()
	if(.)
		power *= max(1, 5 - severity)
		log_and_message_admins("WARN: Explosion near the Supermatter! New EER: [power].")

/obj/machinery/power/supermatter/get_artifact_scan_data()
	return "Superdense crystalline structure - appears to have been shaped or hewn, lattice is approximately 20 times denser than should be possible."

/obj/machinery/power/supermatter/shard //Small subtype, less efficient and more sensitive, but less boom.
	name = "Supermatter Shard"
	desc = "A strangely translucent and iridescent crystal that looks like it used to be part of a larger structure. <span class='danger'>You get headaches just from looking at it.</span>"
	icon_state = "darkmatter_shard"
	base_icon_state = "darkmatter_shard"

	warning_point = 50
	emergency_point = 400
	explosion_point = 600

	gasefficency = 0.125

	pull_time = 150
	explosion_power = 3

/obj/machinery/power/supermatter/shard/announce_warning() //Shards don't get announcements
	return

#undef LIGHT_POWER_CALC
#undef DETONATION_MOB_CONCUSSION
#undef DETONATION_APC_OVERLOAD_PROB
#undef DETONATION_SHUTDOWN_APC
#undef DETONATION_SHUTDOWN_CRITAPC
#undef DETONATION_SHUTDOWN_SMES
#undef DETONATION_SHUTDOWN_RNG_FACTOR
#undef DETONATION_SOLAR_BREAK_CHANCE
#undef WARNING_DELAY
