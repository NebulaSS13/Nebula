/mob/living
	see_in_dark = 2
	see_invisible = SEE_INVISIBLE_LIVING
	transform_animate_time = ANIM_LYING_TIME
	abstract_type = /mob/living

	//Health and life related vars
	max_health = 100 //Maximum health that should be possible.
	current_health = INFINITY // A mob's current health. Set by update_health(). Defaults to INFINITY so mobs don't die on init.

	var/hud_updateflag = 0

	//Damage related vars, NOTE: THESE SHOULD ONLY BE MODIFIED BY PROCS // what a joke
	//var/bruteloss = 0 //Brutal damage caused by brute force (punching, being clubbed by a toolbox ect... this also accounts for pressure damage)
	//var/oxyloss = 0   //Oxygen depravation damage (no air in lungs)
	//var/toxloss = 0   //Toxic damage caused by being poisoned or radiated
	//var/fireloss = 0  //Burn damage caused by being way too hot, too cold or burnt.
	//var/halloss = 0   //Hallucination damage. 'Fake' damage obtained through hallucinating or the holodeck. Sleeping should cause it to wear off.

	/// Used by the resist verb and some mob abilities.
	var/next_special_ability = 0

	var/now_pushing = null
	var/mob_bump_flag = 0
	var/mob_swap_flags = 0
	var/mob_push_flags = 0
	var/mob_always_swap = 0

	var/mob/living/cameraFollow = null
	var/list/datum/action/actions = list()

	var/on_fire = 0 //The "Are we on fire?" var
	var/fire_stacks

	var/ticks_since_last_successful_breath = 0 //if we failed to breathe last tick
	var/failed_last_breath = 0 //This is used to determine if the mob failed a breath. If they did fail a brath, they will attempt to breathe each tick, otherwise just once per 4 ticks.
	var/possession_candidate // Can be possessed by ghosts if unplayed.

	var/job = null//Living
	var/list/obj/aura/auras = null //Basically a catch-all aura/force-field thing.

	var/last_resist = 0
	var/admin_paralyzed = FALSE

	/// For leaping and vaulting.
	var/jumping = FALSE

	var/list/chem_effects
	var/list/chem_doses
	var/last_pain_message
	var/next_pain_time = 0

	var/stress = 0
	var/currently_updating_stress = FALSE
	var/list/stressors

	var/life_tick
	var/list/stasis_sources
	var/stasis_value

	var/nutrition = 400
	var/hydration = 400

	var/original_fingerprint_seed
	var/fingerprint
	var/original_genetic_seed
	var/unique_enzymes
	var/blood_type = "A+"

	var/last_cough = 0

	// Used to track appearance descriptor datums.
	// Currently only on humans due to the spaghetti code involved, TODO: generalize.
	var/list/appearance_descriptors

	/// Total level of flash protection
	var/flash_protection = FLASH_PROTECTION_NONE

	/// Whether this mob's ability to stand has been affected
	var/stance_damage = 0

	var/list/smell_cooldown

	/// Whether or not this mob has a client who wishes to sleep indefinitely.
	var/player_triggered_sleeping = FALSE

	/// Organ instances that should report info to Stat().
	var/list/stat_organs

	/// Should this mob subscribe to the weather system for periodic weather effects?
	var/weather_sensitive = FALSE

	/// Var used to track current step for footsteps sounds.
	var/tmp/step_count