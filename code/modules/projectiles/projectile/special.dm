/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	fire_sound = 'sound/weapons/Laser.ogg'
	damage = 0
	atom_damage_type = BURN
	damage_flags = 0
	nodamage = 1
	var/heavy_effect_range = 1
	var/light_effect_range = 2

/obj/item/projectile/ion/on_impact(var/atom/A)
	empulse(A, heavy_effect_range, light_effect_range)
	return 1

/obj/item/projectile/ion/small
	name = "ion pulse"
	heavy_effect_range = 0
	light_effect_range = 1

/obj/item/projectile/ion/tiny
	heavy_effect_range = 0
	light_effect_range = 0

/obj/item/projectile/bullet/gyro
	name ="explosive bolt"
	icon_state= "bolter"
	damage = 50
	damage_flags = DAM_BULLET | DAM_SHARP | DAM_EDGE
	var/gyro_devastation = -1
	var/gyro_heavy_impact = 0
	var/gyro_light_impact = 2

/obj/item/projectile/bullet/gyro/on_hit(var/atom/target, var/blocked = 0)
	target = get_turf(target)
	if(istype(target))
		explosion(target, gyro_devastation, gyro_heavy_impact, gyro_light_impact)
	return 1

/obj/item/projectile/bullet/gyro/microrocket
	name = "microrocket"
	distance_falloff = 1.3
	fire_sound = 'sound/effects/Explosion1.ogg'
	gyro_light_impact = 1

/obj/item/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"
	fire_sound = 'sound/weapons/pulse3.ogg'
	damage = 0
	atom_damage_type = BURN
	damage_flags = 0
	nodamage = 1
	var/firing_temperature = 300

/obj/item/projectile/temp/on_hit(var/atom/target, var/blocked = 0)//These two could likely check temp protection on the mob
	if(isliving(target))
		var/mob/M = target
		M.bodytemperature = firing_temperature
	return 1

/obj/item/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "smallf"
	damage = 0
	atom_damage_type = BRUTE
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
		if(!M.stat && !isAI(M))
			shake_camera(M, 3, 1)
	qdel(src)
	return TRUE

/obj/item/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"
	fire_sound = 'sound/effects/stealthoff.ogg'
	damage = 0
	atom_damage_type = TOX
	nodamage = 1

/obj/item/projectile/energy/floramut/on_hit(var/atom/target, var/blocked = 0)
	if(!isliving(target))
		return

	var/mob/living/M = target
	if(M.get_species()?.species_flags & SPECIES_FLAG_IS_PLANT)
		if(M.get_nutrition() < 500)
			if(prob(15))
				M.apply_damage((rand(30,80)),IRRADIATE, damage_flags = DAM_DISPERSED)
				SET_STATUS_MAX(M, STAT_WEAK, 5)
				var/decl/pronouns/G = M.get_pronouns()
				visible_message(
					SPAN_DANGER("\The [M] writhes in pain as [G.his] vacuoles boil."),
					blind_message = SPAN_WARNING("You hear a crunching sound.")
				)
			if(prob(35))
				if(prob(80))
					M.add_genetic_condition(pick(decls_repository.get_decls_of_type(/decl/genetic_condition/disability)))
				else
					M.add_genetic_condition(pick(decls_repository.get_decls_of_type(/decl/genetic_condition/superpower)))
		else
			M.heal_damage(BURN, rand(5,15))
			M.show_message(SPAN_DANGER("The radiation beam singes you!"))
	else
		M.show_message(SPAN_NOTICE("The radiation beam dissipates harmlessly through your body."))

/obj/item/projectile/energy/floramut/gene
	name = "gamma somatoray"
	icon_state = "energy2"
	fire_sound = 'sound/effects/stealthoff.ogg'
	damage = 0
	atom_damage_type = TOX
	nodamage = 1
	var/decl/plant_gene/gene = null

/obj/item/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"
	fire_sound = 'sound/effects/stealthoff.ogg'
	damage = 0
	atom_damage_type = TOX
	nodamage = 1

/obj/item/projectile/energy/florayield/on_hit(var/atom/target, var/blocked = 0)
	if(!isliving(target))
		return
	var/mob/living/M = target
	if(M.get_species()?.species_flags & SPECIES_FLAG_IS_PLANT)
		if(M.get_nutrition() < 500)
			M.adjust_nutrition(30)
	else
		M.show_message(SPAN_NOTICE("The radiation beam dissipates harmlessly through your body."))


/obj/item/projectile/beam/mindflayer
	name = "flayer ray"

/obj/item/projectile/beam/mindflayer/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/human/M = target
		ADJ_STATUS(M, STAT_CONFUSE, rand(5,8))

/obj/item/projectile/chameleon
	name = "bullet"
	icon_state = "bullet"
	damage = 1 // stop trying to murderbone with a fake gun dumbass!!!
	embed = 0 // nope
	nodamage = 1
	atom_damage_type = PAIN
	damage_flags = 0
	muzzle_type = /obj/effect/projectile/muzzle/bullet

/obj/item/projectile/venom
	name = "venom bolt"
	icon_state = "venom"
	damage = 5 //most damage is in the reagent
	atom_damage_type = TOX
	damage_flags = 0

/obj/item/projectile/venom/on_hit(atom/target, blocked, def_zone)
	. = ..()
	var/mob/living/L = target
	if(L.reagents)
		L.add_to_reagents(/decl/material/liquid/venom, 5)

/obj/item/missile
	icon = 'icons/obj/items/grenades/missile.dmi'
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/fiberglass
	matter = list(
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_TRACE,
		/decl/material/solid/silicon         = MATTER_AMOUNT_TRACE,
		/decl/material/liquid/anfo           = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/liquid/fuel           = MATTER_AMOUNT_REINFORCEMENT,
	)
	var/primed = null

/obj/item/missile/throw_impact(atom/hit_atom)
	..()
	if(primed)
		explosion(hit_atom, 0, 1, 2, 4)
		qdel(src)

/obj/item/projectile/hotgas
	name = "gas vent"
	icon_state = null
	atom_damage_type = BURN
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