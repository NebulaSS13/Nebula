//"Tracing" projectile

//Helper proc to check if you can hit them or not.
/proc/check_trajectory(atom/target as mob|obj, atom/firer as mob|obj, var/pass_flags=PASS_FLAG_TABLE|PASS_FLAG_GLASS|PASS_FLAG_GRILLE)
	if(!istype(target) || !istype(firer))
		return 0

	var/obj/item/projectile/test/trace = new /obj/item/projectile/test(get_turf(firer)) //Making the test....

	//Set the flags and pass flags to that of the real projectile...
	trace.pass_flags = pass_flags

	return trace.launch(target) //Test it!

/obj/item/projectile/test //Used to see if you can hit them.
	invisibility = INVISIBILITY_ABSTRACT
	hitscan = TRUE
	nodamage = TRUE
	damage = 0
	var/list/hit = list()

/obj/item/projectile/test/process_hitscan()
	. = ..()
	if(!QDELING(src))
		qdel(src)
	return hit

/obj/item/projectile/test/Bump(atom/A, forced = FALSE)
	if(A != src)
		hit |= A
	return ..()

/obj/item/projectile/test/attack_mob()
	return

//Do we even have actors anymore

/obj/item/projectile/chameleon
	name = "bullet"
	icon_state = "bullet"
	damage = 1 // stop trying to murderbone with a fake gun dumbass!!!
	embed = 0 // nope
	nodamage = 1
	damage_type = PAIN
	damage_flags = 0
	muzzle_type = /obj/effect/projectile/muzzle/bullet

//Wizard

/obj/item/projectile/animate
	name = "bolt of animation"
	icon_state = "ice_1"
	damage = 0
	damage_type = BURN
	nodamage = 1
	damage_flags = 0

/obj/item/projectile/animate/Bump(var/atom/change, forced=0)
	if((istype(change, /obj/item) || istype(change, /obj/structure)) && !is_type_in_list(change, protected_objects))
		var/obj/O = change
		new /mob/living/simple_animal/hostile/mimic/(O.loc, O, firer)
	..()

/obj/item/projectile/change
	name = "bolt of change"
	icon_state = "ice_1"
	damage = 0
	damage_type = BURN
	damage_flags = 0
	nodamage = 1

/obj/item/projectile/change/on_hit(var/atom/change)
	wabbajack(change)

/obj/item/projectile/change/proc/get_random_transformation_options(var/mob/M)
	. = list()
	if(!isrobot(M))
		. += "robot"
	for(var/t in get_all_species())
		. += t
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		. -= H.species.name

/obj/item/projectile/change/proc/apply_transformation(var/mob/M, var/choice)

	if(choice == "robot")
		var/mob/living/silicon/robot/R = new(get_turf(M))
		R.set_gender(M.get_gender())
		R.job = ASSIGNMENT_ROBOT
		R.mmi = new /obj/item/mmi(R)
		R.mmi.transfer_identity(M)
		return R

	if(get_species_by_key(choice))
		var/mob/living/carbon/human/H = M
		if(!istype(H))
			H = new(get_turf(M))
			H.set_gender(M.get_gender())
		H.name = "unknown" // This will cause set_species() to randomize the mob name.
		H.real_name = H.name
		H.change_species(choice)
		H.universal_speak = TRUE
		var/datum/preferences/A = new()
		A.randomize_appearance_and_body_for(H)
		return H

/obj/item/projectile/change/proc/wabbajack(var/mob/M)
	if(istype(M, /mob/living) && M.stat != DEAD)
		if(HAS_TRANSFORMATION_MOVEMENT_HANDLER(M))
			return
		M.handle_pre_transformation()
		var/choice = pick(get_random_transformation_options(M))
		var/mob/living/new_mob = apply_transformation(M, choice)
		if(new_mob)
			for (var/spell/S in M.mind.learned_spells)
				new_mob.add_spell(new S.type)
			new_mob.a_intent = "hurt"
			if(M.mind)
				M.mind.transfer_to(new_mob)
			else
				new_mob.key = M.key
			to_chat(new_mob, "<span class='warning'>Your form morphs into that of \a [choice].</span>")

			qdel(M)
		else
			to_chat(M, "<span class='warning'>Your form morphs into that of \a [choice].</span>")

/obj/item/projectile/forcebolt
	name = "force bolt"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "ice_1"
	damage = 20
	damage_type = BURN
	damage_flags = 0

/obj/item/projectile/forcebolt/strong
	name = "force bolt"

/obj/item/projectile/forcebolt/on_hit(var/atom/movable/target, var/blocked = 0)
	if(istype(target))
		var/throwdir = get_dir(firer,target)
		target.throw_at(get_edge_target_turf(target, throwdir),10,10)
		return 1

/obj/item/projectile/firebolt
	name = "fireball"
	icon_state = "fireball"
	fire_sound = 'sound/magic/fireball.ogg'
	damage = 20
	damage_type = BURN
	damage_flags = 0

	var/ex_severe = -1
	var/ex_heavy =  -1
	var/ex_light =   1
	var/ex_flash =   2

/obj/item/projectile/firebolt/on_impact(var/atom/A)
	. = ..()
	explosion(A, ex_severe, ex_heavy, ex_light, ex_flash)

//Venom proj, used by spiders

/obj/item/projectile/venom
	name = "venom bolt"
	icon_state = "venom"
	damage = 5 //most damage is in the reagent
	damage_type = TOX
	damage_flags = 0

/obj/item/projectile/venom/on_hit(atom/target, blocked, def_zone)
	. = ..()
	var/mob/living/L = target
	if(L.reagents)
		L.reagents.add_reagent(/decl/material/liquid/venom, 5)

//Used by drake.dm

/obj/item/projectile/hotgas
	name = "gas vent"
	icon_state = null
	damage_type = BURN
	damage_flags = 0
	life_span = 3
	silenced = TRUE

/obj/item/projectile/hotgas/on_hit(atom/target, blocked, def_zone)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		to_chat(target, SPAN_WARNING("You feel a wave of heat wash over you!"))
		L.adjust_fire_stacks(rand(5,8))
		L.IgniteMob()

//Missile

/obj/item/missile
	icon = 'icons/obj/items/grenades/missile.dmi'
	icon_state = ICON_STATE_WORLD
	var/primed = null
	throwforce = 15

/obj/item/missile/throw_impact(atom/hit_atom)
	..()
	if(primed)
		explosion(hit_atom, 0, 1, 2, 4)
		qdel(src)

//Micrometeor

/obj/item/projectile/bullet/rock
	name = "micrometeor"
	icon_state = "rock"
	damage = 50
	armor_penetration = 50
	life_span = 255
	distance_falloff = 0

/obj/item/projectile/bullet/rock/Initialize()
	. = ..()
	icon_state = "rock[rand(1,3)]"
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)

//Meteor

/obj/item/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "smallf"
	damage = 0
	damage_type = BRUTE
	nodamage = 1

/obj/item/projectile/meteor/Bump(var/atom/A, forced=0)
	if(!istype(A))
		return
	if(A == firer)
		forceMove(A.loc)
		return
	A.explosion_act(2)
	playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)
	for(var/mob/M in range(10, src))
		if(!M.stat && !istype(M, /mob/living/silicon/ai))
			shake_camera(M, 3, 1)
	qdel(src)
	return TRUE

//Floragun

/obj/item/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"
	fire_sound = 'sound/effects/stealthoff.ogg'
	damage = 0
	damage_type = TOX
	nodamage = 1

/obj/item/projectile/energy/floramut/on_hit(var/atom/target, var/blocked = 0)
	var/mob/living/M = target
	if(ishuman(target))
		var/mob/living/carbon/human/H = M
		if((H.species.species_flags & SPECIES_FLAG_IS_PLANT) && (H.nutrition < 500))
			if(prob(15))
				H.apply_damage((rand(30,80)),IRRADIATE, damage_flags = DAM_DISPERSED)
				SET_STATUS_MAX(H, STAT_WEAK, 5)
				var/decl/pronouns/G = M.get_pronouns()
				visible_message(
					SPAN_DANGER("\The [M] writhes in pain as [G.his] vacuoles boil."), \
					blind_message = SPAN_WARNING("You hear a crunching sound."))
			if(prob(35))
				if(prob(80))
					randmutb(M)
					domutcheck(M,null)
				else
					randmutg(M)
					domutcheck(M,null)
			else
				M.adjustFireLoss(rand(5,15))
				M.show_message("<span class='danger'>The radiation beam singes you!</span>")
	else if(istype(target, /mob/living/carbon/))
		M.show_message("<span class='notice'>The radiation beam dissipates harmlessly through your body.</span>")
	else
		return 1

/obj/item/projectile/energy/floramut/gene
	name = "gamma somatoray"
	icon_state = "energy2"
	fire_sound = 'sound/effects/stealthoff.ogg'
	damage = 0
	damage_type = TOX
	nodamage = 1
	var/decl/plantgene/gene = null

/obj/item/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"
	fire_sound = 'sound/effects/stealthoff.ogg'
	damage = 0
	damage_type = TOX
	nodamage = 1

/obj/item/projectile/energy/florayield/on_hit(var/atom/target, var/blocked = 0)
	var/mob/M = target
	if(ishuman(target))
		var/mob/living/carbon/human/H = M
		if((H.species.species_flags & SPECIES_FLAG_IS_PLANT) && (H.nutrition < 500))
			H.adjust_nutrition(30)
	else if (istype(target, /mob/living/carbon/))
		M.show_message("<span class='notice'>The radiation beam dissipates harmlessly through your body.</span>")
	else
		return 1