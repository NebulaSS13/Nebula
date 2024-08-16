
//malfunctioning combat drones
/mob/living/simple_animal/hostile/malf_drone
	name = "combat drone"
	desc = "An automated combat drone armed with state of the art weaponry and shielding."
	icon = 'icons/mob/simple_animal/drone_combat.dmi'
	burst_projectile = 0
	a_intent = I_HURT
	max_health = 300
	move_intents = list(
		/decl/move_intent/walk/animal_slow,
		/decl/move_intent/run/animal_slow
	)
	projectiletype = /obj/item/projectile/beam/drone
	projectilesound = 'sound/weapons/laser3.ogg'
	gene_damage = -1
	butchery_data = /decl/butchery_data/synthetic
	bleed_colour = SYNTH_BLOOD_COLOR
	base_movement_delay = 2
	ai = /datum/mob_controller/aggressive/malf_drone

	//Drones aren't affected by atmos.
	min_gas = null
	max_gas = null
	minbodytemp = 0
	faction = "malf_drone"

	var/has_loot = 1
	var/datum/effect/effect/system/trail/ion_trail
	var/explode_chance = 1
	var/disabled = 0
	var/exploding = 0

	var/static/list/debris = list(
		/decl/material/solid/glass =          /obj/item/shard,
		/decl/material/solid/metal/steel =    /obj/item/stack/material/rods,
		/decl/material/solid/metal/plasteel = null
	)

/datum/mob_controller/aggressive/malf_drone
	speak_chance = 1.25
	turns_per_wander = 6
	emote_speech = list("ALERT.","Hostile-ile-ile entities dee-twhoooo-wected.","Threat parameterszzzz- szzet.","Bring sub-sub-sub-systems uuuup to combat alert alpha-a-a.")
	emote_see    = list("beeps menacingly","whirrs threateningly","scans its immediate vicinity")
	stop_wander_when_pulled = FALSE
	only_attack_enemies = TRUE
	try_destroy_surroundings = FALSE
	//the drone randomly switches between these states if it's malfunctioning
	var/malfunctioning = 1
	var/hostile_drone = 0
	//0 - retaliate, only attack enemies that attack it
	//1 - hostile, attack everything that comes near
	var/hostile_range = 10

/mob/living/simple_animal/hostile/malf_drone/has_ranged_attack()
	return TRUE

/datum/mob_controller/aggressive/malf_drone/list_targets(var/dist = 7)
	. = ..(hostile_drone ? hostile_range : dist)
	for(var/mob/M in .)
		if(istype(M, body.type))
			. -= M

/mob/living/simple_animal/hostile/malf_drone/check_has_mouth()
	return FALSE

/mob/living/simple_animal/hostile/malf_drone/can_act()
	return disabled <= 0 && ..()

/mob/living/simple_animal/hostile/malf_drone/Initialize()
	. = ..()
	if(prob(5))
		projectiletype = /obj/item/projectile/beam/pulse/drone
		projectilesound = 'sound/weapons/pulse2.ogg'
	ion_trail = new /datum/effect/effect/system/trail/ion()
	ion_trail.set_up(src)
	ion_trail.start()

/mob/living/simple_animal/hostile/malf_drone/Process_Spacemove()
	return 1

/mob/living/simple_animal/hostile/malf_drone/proc/Haywire()
	var/datum/mob_controller/aggressive/malf_drone/drone_ai = ai
	if(prob(disabled ? 0 : 1) && istype(drone_ai) && drone_ai.malfunctioning)
		if(drone_ai.hostile_drone)
			src.visible_message("<span class='notice'>[html_icon(src)] [src] retracts several targetting vanes, and dulls it's running lights.</span>")
			drone_ai.hostile_drone = 0
		else
			src.visible_message("<span class='warning'>[html_icon(src)] [src] suddenly lights up, and additional targetting vanes slide into place.</span>")
			drone_ai.hostile_drone = 1

//self repair systems have a chance to bring the drone back to life
/mob/living/simple_animal/hostile/malf_drone/handle_living_non_stasis_processes()
	. = ..()
	if(!.)
		return FALSE

	//emps and lots of damage can temporarily shut us down
	if(disabled > 0)
		set_stat(UNCONSCIOUS)
		disabled--
		if(istype(ai))
			ai.stop_wandering()
			ai.speak_chance = 0
		if(disabled <= 0)
			set_stat(CONSCIOUS)
			if(istype(ai))
				ai.resume_wandering()
				ai.speak_chance = initial(ai.speak_chance)

	//repair a bit of damage
	if(prob(1))
		src.visible_message("<span class='warning'>[html_icon(src)] [src] shudders and shakes as some of it's damaged systems come back online.</span>")
		spark_at(src, cardinal_only = TRUE)
		heal_damage(BRUTE, (rand(10,50)), do_update_health = FALSE)
		heal_damage(BURN, (rand(10,50)))

	//spark for no reason
	if(prob(5))
		spark_at(src, cardinal_only = TRUE)

	//sometimes our targetting sensors malfunction, and we attack anyone nearby
	Haywire()

	var/current_health_ratio = get_health_ratio()
	if(current_health_ratio > 0.9)
		explode_chance = 0
	else if(current_health_ratio > 0.7)
		explode_chance = 0
	else if(current_health_ratio > 0.5)
		explode_chance = 0.5
	else if(current_health_ratio > 0.3)
		explode_chance = 5
	else if(current_health > 0)
		//if health gets too low, shut down
		exploding = 0
		if(!disabled)
			if(prob(50))
				src.visible_message("<span class='notice'>[html_icon(src)] [src] suddenly shuts down!</span>")
			else
				src.visible_message("<span class='notice'>[html_icon(src)] [src] suddenly lies still and quiet.</span>")
			disabled = rand(150, 600)
			stop_automove()

	if(exploding && prob(20))
		if(prob(50))
			src.visible_message("<span class='warning'>[html_icon(src)] [src] begins to spark and shake violenty!</span>")
		else
			src.visible_message("<span class='warning'>[html_icon(src)] [src] sparks and shakes like it's about to explode!</span>")
		spark_at(src, cardinal_only = TRUE)

	if(!exploding && !disabled && prob(explode_chance))
		exploding = 1
		set_stat(UNCONSCIOUS)
		ai?.resume_wandering()
		stop_automove()
		spawn(rand(50,150))
			if(!disabled && exploding)
				explosion(get_turf(src), 0, 1, 4, 7)
				death()

	update_icon()

/mob/living/simple_animal/hostile/malf_drone/on_update_icon()
	. = ..()
	if(stat != DEAD)
		var/current_max_health = get_max_health()
		if(current_health / current_max_health <= 0.3)
			icon_state = "[icon_state]-shield3"
		else if(current_health / current_max_health <= 0.5)
			icon_state = "[icon_state]-shield1"
		else if(current_health / current_max_health <= 0.7)
			icon_state = "[icon_state]-shield2"

//ion rifle!
/mob/living/simple_animal/hostile/malf_drone/emp_act(severity)
	take_damage(rand(3,15) * (severity + 1), BURN)
	disabled = rand(150, 600)
	var/datum/mob_controller/aggressive/malf_drone/drone_brain = ai
	if(istype(drone_brain))
		drone_brain.hostile_drone = 0
	stop_automove()

/mob/living/simple_animal/hostile/malf_drone/get_death_message(gibbed)
	return "suddenly breaks apart."

/mob/living/simple_animal/hostile/malf_drone/get_self_death_message(gibbed)
	return "You have been destroyed."

/mob/living/simple_animal/hostile/malf_drone/death(gibbed)
	. = ..()
	if(. && !gibbed)
		physically_destroyed()

/mob/living/simple_animal/hostile/malf_drone/Destroy()
	QDEL_NULL(ion_trail)
	return ..()

/mob/living/simple_animal/hostile/malf_drone/physically_destroyed(skip_qdel)
	//some random debris left behind
	if(has_loot)
		spark_at(src, cardinal_only = TRUE)
		var/atom/movable/M
		for(var/mat in debris)
			for(var/chance in list(100, 75, 50, 25))
				if(!prob(chance))
					break
				M = SSmaterials.create_object(mat, loc, 1, debris[mat])
				if(istype(M))
					step_to(M, get_turf(pick(view(7, src))))
		//also drop dummy circuit boards deconstructable for research (loot)
		var/obj/item/stock_parts/circuitboard/C
		//spawn 1-4 boards of a random type
		var/spawnees = 0
		var/num_boards = rand(1,4)
		var/list/options = list(1,2,4,8,16,32,64,128,256,512)
		for(var/i=0, i<num_boards, i++)
			var/chosen = pick(options)
			options.Remove(options.Find(chosen))
			spawnees |= chosen
		if(spawnees & 1)
			C = new(src.loc)
			C.SetName("Drone CPU motherboard")
			C.origin_tech = @'{"[TECH_DATA]":[rand(3, 6)]}'
		if(spawnees & 2)
			C = new(src.loc)
			C.SetName("Drone neural interface")
			C.origin_tech = @'{"[TECH_BIO]":[rand(3, 6)]}'
		if(spawnees & 4)
			C = new(src.loc)
			C.SetName("Drone suspension processor")
			C.origin_tech = @'{"[TECH_MAGNET]":[rand(3, 6)]}'
		if(spawnees & 8)
			C = new(src.loc)
			C.SetName("Drone shielding controller")
			C.origin_tech = @'{"wormholes":[rand(3, 6)]}'
		if(spawnees & 16)
			C = new(src.loc)
			C.SetName("Drone power capacitor")
			C.origin_tech = @'{"[TECH_POWER]":[rand(3, 6)]}'
		if(spawnees & 32)
			C = new(src.loc)
			C.SetName("Drone hull reinforcer")
			C.origin_tech = @'{"[TECH_MATERIAL]":[rand(3, 6)]}'
		if(spawnees & 64)
			C = new(src.loc)
			C.SetName("Drone auto-repair system")
			C.origin_tech = @'{"[TECH_ENGINEERING]":[rand(3, 6)]}'
		if(spawnees & 128)
			C = new(src.loc)
			C.SetName("Drone antigravity overcharge counter")
			C.origin_tech = @'{"[TECH_EXOTIC_MATTER]":[rand(3, 6)]}'
		if(spawnees & 256)
			C = new(src.loc)
			C.SetName("Drone targetting circuitboard")
			C.origin_tech = @'{"[TECH_COMBAT]":[rand(3, 6)]}'
		if(spawnees & 512)
			C = new(src.loc)
			C.SetName("Corrupted drone morality core")
			C.origin_tech = @'{"[TECH_ESOTERIC]":[rand(3, 6)]}'
	return ..()

/obj/item/projectile/beam/drone
	damage = 15

/obj/item/projectile/beam/pulse/drone
	damage = 10
