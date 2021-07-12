
//malfunctioning combat drones
/mob/living/simple_animal/hostile/retaliate/malf_drone
	name = "combat drone"
	desc = "An automated combat drone armed with state of the art weaponry and shielding."
	icon_state = "drone"
	icon_living = "drone"
	icon_dead = "drone_dead"
	ranged = 1
	rapid = 0
	speak_chance = 5
	turns_per_move = 3
	speak = list("ALERT.","Hostile-ile-ile entities dee-twhoooo-wected.","Threat parameterszzzz- szzet.","Bring sub-sub-sub-systems uuuup to combat alert alpha-a-a.")
	emote_see = list("beeps menacingly","whirrs threateningly","scans its immediate vicinity")
	a_intent = I_HURT
	stop_automated_movement_when_pulled = 0
	health = 300
	maxHealth = 300
	speed = 8
	move_to_delay = 6
	projectiletype = /obj/item/projectile/beam/drone
	projectilesound = 'sound/weapons/laser3.ogg'
	destroy_surroundings = 0
	gene_damage = -1

	meat_type =     null
	meat_amount =   0
	bone_material = null
	bone_amount =   0
	skin_material = null
	skin_amount =   0

	var/datum/effect/effect/system/trail/ion_trail

	//the drone randomly switches between these states if it's malfunctioning
	var/malfunctioning = 1
	var/hostile_drone = 0
	//0 - retaliate, only attack enemies that attack it
	//1 - hostile, attack everything that comes near
	var/hostile_range = 10

	var/turf/patrol_target
	var/explode_chance = 1
	var/disabled = 0
	var/exploding = 0

	//Drones aren't affected by atmos.
	min_gas = null
	max_gas = null
	minbodytemp = 0

	var/has_loot = 1
	faction = "malf_drone"

	var/static/list/debris = list(
		/decl/material/solid/glass =          /obj/item/shard,
		/decl/material/solid/metal/steel =    /obj/item/stack/material/rods,
		/decl/material/solid/metal/plasteel = null
	)


/mob/living/simple_animal/hostile/retaliate/malf_drone/Initialize()
	. = ..()
	if(prob(5))
		projectiletype = /obj/item/projectile/beam/pulse/drone
		projectilesound = 'sound/weapons/pulse2.ogg'
	ion_trail = new /datum/effect/effect/system/trail/ion()
	ion_trail.set_up(src)
	ion_trail.start()

/mob/living/simple_animal/hostile/retaliate/malf_drone/Process_Spacemove()
	return 1

/mob/living/simple_animal/hostile/retaliate/malf_drone/proc/Haywire()
	if(prob(disabled ? 0 : 1) && malfunctioning)
		if(hostile_drone)
			src.visible_message("<span class='notice'>[html_icon(src)] [src] retracts several targetting vanes, and dulls it's running lights.</span>")
			hostile_drone = 0
		else
			src.visible_message("<span class='warning'>[html_icon(src)] [src] suddenly lights up, and additional targetting vanes slide into place.</span>")
			hostile_drone = 1

/mob/living/simple_animal/hostile/retaliate/malf_drone/ListTargets()
	if(hostile_drone)
		var/list/targets = list()
		for(var/mob/M in view(src, hostile_range))
			if(M == src || istype(M, type))
				continue
			targets |= M

		return targets
	else
		return ..()

//self repair systems have a chance to bring the drone back to life
/mob/living/simple_animal/hostile/retaliate/malf_drone/Life()

	//emps and lots of damage can temporarily shut us down
	if(disabled > 0)
		set_stat(UNCONSCIOUS)
		icon_state = "[initial(icon_state)]_dead"
		disabled--
		wander = 0
		speak_chance = 0
		if(disabled <= 0)
			set_stat(CONSCIOUS)
			icon_state = "[initial(icon_state)]0"
			wander = 1
			speak_chance = 5

	//repair a bit of damage
	if(prob(1))
		src.visible_message("<span class='warning'>[html_icon(src)] [src] shudders and shakes as some of it's damaged systems come back online.</span>")
		spark_at(src, cardinal_only = TRUE)
		health += rand(25,100)

	//spark for no reason
	if(prob(5))
		spark_at(src, cardinal_only = TRUE)

	//sometimes our targetting sensors malfunction, and we attack anyone nearby
	Haywire()

	if(health / maxHealth > 0.9)
		icon_state = "[initial(icon_state)]"
		explode_chance = 0
	else if(health / maxHealth > 0.7)
		icon_state = "[initial(icon_state)]2"
		explode_chance = 0
	else if(health / maxHealth > 0.5)
		icon_state = "[initial(icon_state)]1"
		explode_chance = 0.5
	else if(health / maxHealth > 0.3)
		icon_state = "[initial(icon_state)]0"
		explode_chance = 5
	else if(health > 0)
		//if health gets too low, shut down
		icon_state = "[initial(icon_state)]_dead"
		exploding = 0
		if(!disabled)
			if(prob(50))
				src.visible_message("<span class='notice'>[html_icon(src)] [src] suddenly shuts down!</span>")
			else
				src.visible_message("<span class='notice'>[html_icon(src)] [src] suddenly lies still and quiet.</span>")
			disabled = rand(150, 600)
			walk(src,0)

	if(exploding && prob(20))
		if(prob(50))
			src.visible_message("<span class='warning'>[html_icon(src)] [src] begins to spark and shake violenty!</span>")
		else
			src.visible_message("<span class='warning'>[html_icon(src)] [src] sparks and shakes like it's about to explode!</span>")
		spark_at(src, cardinal_only = TRUE)

	if(!exploding && !disabled && prob(explode_chance))
		exploding = 1
		set_stat(UNCONSCIOUS)
		wander = 1
		walk(src,0)
		spawn(rand(50,150))
			if(!disabled && exploding)
				explosion(get_turf(src), 0, 1, 4, 7)
				death()
	..()

//ion rifle!
/mob/living/simple_animal/hostile/retaliate/malf_drone/emp_act(severity)
	health -= rand(3,15) * (severity + 1)
	disabled = rand(150, 600)
	hostile_drone = 0
	walk(src,0)

/mob/living/simple_animal/hostile/retaliate/malf_drone/death()
	..(null,"suddenly breaks apart.", "You have been destroyed.")
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/malf_drone/Destroy()
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
			C.origin_tech = "{'[TECH_DATA]':[rand(3, 6)]}"

		if(spawnees & 2)
			C = new(src.loc)
			C.SetName("Drone neural interface")
			C.origin_tech = "{'[TECH_BIO]':[rand(3, 6)]}"

		if(spawnees & 4)
			C = new(src.loc)
			C.SetName("Drone suspension processor")
			C.origin_tech = "{'[TECH_MAGNET]':[rand(3, 6)]}"

		if(spawnees & 8)
			C = new(src.loc)
			C.SetName("Drone shielding controller")
			C.origin_tech = "{'wormholes':[rand(3, 6)]}"

		if(spawnees & 16)
			C = new(src.loc)
			C.SetName("Drone power capacitor")
			C.origin_tech = "{'[TECH_POWER]':[rand(3, 6)]}"

		if(spawnees & 32)
			C = new(src.loc)
			C.SetName("Drone hull reinforcer")
			C.origin_tech = "{'[TECH_MATERIAL]':[rand(3, 6)]}"

		if(spawnees & 64)
			C = new(src.loc)
			C.SetName("Drone auto-repair system")
			C.origin_tech = "{'[TECH_ENGINEERING]':[rand(3, 6)]}"

		if(spawnees & 128)
			C = new(src.loc)
			C.SetName("Drone antigravity overcharge counter")
			C.origin_tech = "{'[TECH_EXOTIC_MATTER]':[rand(3, 6)]}"

		if(spawnees & 256)
			C = new(src.loc)
			C.SetName("Drone targetting circuitboard")
			C.origin_tech = "{'[TECH_COMBAT]':[rand(3, 6)]}"

		if(spawnees & 512)
			C = new(src.loc)
			C.SetName("Corrupted drone morality core")
			C.origin_tech = "{'[TECH_ESOTERIC]':[rand(3, 6)]}"

	..()

/obj/item/projectile/beam/drone
	damage = 15

/obj/item/projectile/beam/pulse/drone
	damage = 10
