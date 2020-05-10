/obj/structure
	icon = 'icons/obj/structures/barricade.dmi'
	w_class = ITEM_SIZE_STRUCTURE
	layer = STRUCTURE_LAYER

	var/last_damage_message
	var/health = 0
	var/maxhealth = -1
	var/hitsound = 'sound/weapons/smash.ogg'
	var/breakable
	var/parts_type
	var/footstep_type
	var/mob_offset

/obj/structure/create_matter()
	..()
	if(material || reinf_material)
		LAZYINITLIST(matter)
		var/matter_mult = get_matter_amount_modifier()
		if(material)
			matter[material.type] = max(matter[material.type], round(MATTER_AMOUNT_PRIMARY * matter_mult))
		if(reinf_material)
			matter[reinf_material.type] = max(matter[reinf_material.type], round(MATTER_AMOUNT_REINFORCEMENT * matter_mult))
		UNSETEMPTY(matter)

/obj/structure/Initialize(var/ml, var/_mat, var/_reinf_mat)
	if(ispath(_mat, /material))
		material = _mat
	if(ispath(material, /material))
		material = SSmaterials.get_material_datum(material)
	if(ispath(_reinf_mat, /material))
		reinf_material = _reinf_mat
	if(ispath(reinf_material, /material))
		reinf_material = SSmaterials.get_material_datum(reinf_material)
	. = ..()
	update_materials()
	if(!CanFluidPass())
		fluid_update()

/obj/structure/proc/show_examined_damage(mob/user, var/perc)
	if(maxhealth == -1)
		return
	if(perc >= 1)
		to_chat(user, SPAN_NOTICE("It looks fully intact."))
	else if(perc > 0.75)
		to_chat(user, SPAN_NOTICE("It has a few cracks."))
	else if(perc > 0.5)
		to_chat(user, SPAN_WARNING("It looks slightly damaged."))
	else if(perc > 0.25)
		to_chat(user, SPAN_WARNING("It looks moderately damaged."))
	else
		to_chat(user, SPAN_DANGER("It looks heavily damaged."))

/obj/structure/examine(mob/user, var/distance)
	. = ..()
	if(distance <= 3)

		show_examined_damage(user, (health/maxhealth))

		if(tool_interaction_flags & TOOL_INTERACTION_ANCHOR)
			if(anchored)
				to_chat(user, SPAN_SUBTLE("Can be unanchored with a wrench, and moved around."))
			else
				to_chat(user, SPAN_SUBTLE("Can be anchored in place with a wrench."))

		if(tool_interaction_flags & TOOL_INTERACTION_DECONSTRUCT)
			var/removed_with = "a crowbar"
			if(material && material.removed_by_welder)
				removed_with = "a welding torch"
			if(tool_interaction_flags & TOOL_INTERACTION_ANCHOR)
				if(anchored)
					to_chat(user, SPAN_SUBTLE("Can be deconstructed with [removed_with]."))
				else
					to_chat(user, SPAN_SUBTLE("Can be deconstructed with [removed_with], if anchored down with a wrench first."))
			else
				to_chat(user, SPAN_SUBTLE("Can be deconstructed with [removed_with]."))

		if(tool_interaction_flags & TOOL_INTERACTION_WIRING)
			if(tool_interaction_flags & TOOL_INTERACTION_ANCHOR)
				if(wired)
					if(anchored)
						to_chat(user, SPAN_SUBTLE("Can have its wiring removed with wirecutters"))
					else
						to_chat(user, SPAN_SUBTLE("Can have its wiring removed with wirecutters, if anchored down with a wrench first."))
				else
					if(anchored)
						to_chat(user, SPAN_SUBTLE("Can have wiring installed with a cable coil."))
					else
						to_chat(user, SPAN_SUBTLE("Can have wiring installed with a cable coil, if anchored down with a wrench first."))
			else
				if(wired)
					to_chat(user, SPAN_SUBTLE("Can have its wiring removed with wirecutters"))
				else
					to_chat(user, SPAN_SUBTLE("Can have wiring installed with a cable coil."))

/obj/structure/proc/mob_breakout(var/mob/living/escapee)
	set waitfor = FALSE
	return FALSE

/obj/structure/proc/take_damage(var/damage)
	if(health == -1) // This object does not take damage.
		return

	if(material && material.is_brittle())
		if(reinf_material)
			if(reinf_material.is_brittle())
				damage *= STRUCTURE_BRITTLE_MATERIAL_DAMAGE_MULTIPLIER
		else
			damage *= STRUCTURE_BRITTLE_MATERIAL_DAMAGE_MULTIPLIER

	playsound(loc, hitsound, 75, 1)
	health = Clamp(health - damage, 0, maxhealth)
	
	show_damage_message(health/maxhealth)

	if(health == 0)
		destroyed()

/obj/structure/proc/show_damage_message(var/perc)
	if(perc > 0.75)
		return
	if(perc <= 0.25 && last_damage_message < 0.25)
		visible_message(SPAN_DANGER("\The [src] looks like it's about to break!"))
		last_damage_message = 0.25
	else if(perc <= 0.5 && last_damage_message < 0.5)
		visible_message(SPAN_WARNING("\The [src] looks seriously damaged!"))
		last_damage_message = 0.5
	else if(perc <= 0.75 && last_damage_message < 0.75)
		visible_message(SPAN_WARNING("\The [src] is showing some damage!"))
		last_damage_message = 0.75

/obj/structure/proc/destroyed()
	. = dismantle()

/obj/structure/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	. = ..()
	var/dmg = 100
	if(material)
		dmg = round(dmg * material.combustion_effect(get_turf(src),temperature, 0.3))
	if(dmg)
		take_damage(dmg)

/obj/structure/Destroy()
	reset_mobs_offset()
	var/turf/T = get_turf(src)
	if(T)
		T.fluid_update()
	. = ..()

/obj/structure/Crossed(mob/living/M)
	if(istype(M))
		M.on_structure_offset(mob_offset)
	..()

/obj/structure/proc/reset_mobs_offset()
	for(var/mob/living/M in loc)
		M.on_structure_offset(0)

/obj/structure/Move()
	. = ..()
	if(. && !CanFluidPass())
		fluid_update()

/obj/structure/attack_hand(mob/user)
	..()
	if(breakable)
		if(MUTATION_HULK in user.mutations)
			user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
			attack_generic(user,1,"smashes")
		else if(istype(user,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(user))
				attack_generic(user,1,"slices")
	return ..()

/obj/structure/grab_attack(var/obj/item/grab/G)
	if (!G.force_danger())
		to_chat(G.assailant, SPAN_WARNING("You need a better grip to do that!"))
		return TRUE
	var/mob/affecting_mob = G.get_affecting_mob()
	if (G.assailant.a_intent == I_HURT)

		if(!affecting_mob)
			to_chat(G.assailant, SPAN_WARNING("You need to be grabbing a living creature to do that!"))
			return TRUE

		// Slam their face against the table.
		var/blocked = affecting_mob.get_blocked_ratio(BP_HEAD, BRUTE, damage = 8)
		if (prob(30 * (1 - blocked)))
			affecting_mob.Weaken(5)
		affecting_mob.apply_damage(8, BRUTE, BP_HEAD)
		visible_message(SPAN_DANGER("[G.assailant] slams [affecting_mob]'s face against \the [src]!"))
		if (material)
			playsound(loc, material.tableslam_noise, 50, 1)
		else
			playsound(loc, 'sound/weapons/tablehit1.ogg', 50, 1)
		var/list/L = take_damage(rand(1,5))
		for(var/obj/item/material/shard/S in L)
			if(S.sharp && prob(50))
				affecting_mob.visible_message(SPAN_DANGER("\The [S] slices into [affecting_mob]'s face!"), SPAN_DANGER("\The [S] slices into your face!"))
				affecting_mob.standard_weapon_hit_effects(S, G.assailant, S.force*2, BP_HEAD)
		qdel(G)
	else if(atom_flags & ATOM_FLAG_CLIMBABLE)
		var/obj/occupied = turf_is_crowded()
		if (occupied)
			to_chat(G.assailant, SPAN_WARNING("There's \a [occupied] in the way."))
			return TRUE
		G.affecting.forceMove(src.loc)
		if(affecting_mob)
			affecting_mob.Weaken(rand(2,5))
		visible_message(SPAN_DANGER("[G.assailant] puts [G.affecting] on \the [src]."))
		qdel(G)
		return TRUE

/obj/structure/ex_act(severity)
	if(severity == 1)
		destroyed()
	else if(severity == 2)
		take_damage(rand(20, 30))
	else
		take_damage(rand(5, 15))

/obj/structure/proc/can_repair(var/mob/user)
	if(health >= maxhealth)
		to_chat(user, SPAN_NOTICE("\The [src] does not need repairs."))
		return FALSE
	return TRUE

/obj/structure/bullet_act(var/obj/item/projectile/Proj)
	take_damage(Proj.get_structure_damage())
