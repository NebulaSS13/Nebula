/decl/mob_modifier/mechshield
	name           = "Mech Energy Shield"
	hud_icon_state = "shield"
	modifier_type  = /datum/mob_modifier/object/mechshield

/decl/mob_modifier/mechshield/on_modifier_datum_added(mob/living/_owner, datum/mob_modifier/modifier)
	. = ..()
	if(istype(modifier, /datum/mob_modifier/object))
		var/datum/mob_modifier/object/obj_modifier = modifier
		if(istype(obj_modifier.object))
			flick("shield_raise", obj_modifier.object)

/decl/mob_modifier/mechshield/on_modifier_datum_removed(mob/living/_owner, datum/mob_modifier/modifier)
	if(istype(modifier, /datum/mob_modifier/object))
		var/datum/mob_modifier/object/obj_modifier = modifier
		if(istype(obj_modifier.object))
			var/obj/effect/temporary/drop_shield = new(get_turf(_owner))
			drop_shield.appearance = obj_modifier.object
			flick("shield_drop", drop_shield)
			QDEL_IN(drop_shield, 1 SECOND)
	return ..()

/datum/mob_modifier/object/mechshield
	object         = /obj/abstract/follower/mechshield

/obj/abstract/follower/mechshield
	name           = "mechshield"
	layer          = ABOVE_HUMAN_LAYER
	plane          = DEFAULT_PLANE
	icon           = 'icons/mecha/shield.dmi'
	icon_state     = "shield"
	pixel_x        = 8
	pixel_y        = 4
	mouse_opacity  = MOUSE_OPACITY_UNCLICKABLE
	invisibility   = INVISIBILITY_NONE
	alpha          = 255
	hide_on_init   = FALSE

/obj/abstract/follower/mechshield/follow_owner(atom/movable/owner)
	. = ..()
	layer = (dir == NORTH) ? MECH_UNDER_LAYER : initial(layer)

/decl/mob_modifier/mechshield/check_modifiers_block_attack(mob/living/_owner, list/modifiers, attack_type, atom/movable/attacker, additional_data)

	if(attack_type == MM_ATTACK_TYPE_WEAPON)
		return ..()

	. = MM_ATTACK_RESULT_NONE
	var/shield_hit = FALSE
	if(attack_type == MM_ATTACK_TYPE_PROJECTILE)

		var/obj/item/projectile/projectile = attacker
		if(!istype(projectile))
			return

		for(var/datum/mob_modifier/modifier in modifiers)
			var/obj/item/mech_equipment/shields/shield = modifier.source?.resolve()
			if(!istype(shield) || !shield.charge)
				continue
			if(!shield_hit)
				_owner.visible_message(SPAN_WARNING("\The [shield.owner]'s shields flash and crackle."))
				shield_hit = TRUE
				new /obj/effect/effect/smoke/illumination(_owner.loc, 5, 4, 1, "#ffffff")
				spark_at(_owner, amount=5)
			projectile.damage = shield.stop_damage(projectile.damage)
		if(projectile.damage <= 0)
			. = (MM_ATTACK_RESULT_BLOCKED|MM_ATTACK_RESULT_DEFLECTED)

	else if(attack_type == MM_ATTACK_TYPE_THROWN)

		var/datum/thrownthing/thrown = additional_data
		if(!istype(thrown) || thrown.speed > 5)
			return

		for(var/datum/mob_modifier/modifier in modifiers)
			var/obj/item/mech_equipment/shields/shield = modifier.source?.resolve()
			if(istype(shield) && shield.charge)
				_owner.visible_message(SPAN_WARNING("\The [shield.owner]'s shields flash briefly as they deflect \the [thrown.thrownthing]."))
				shield_hit = TRUE
				. = (MM_ATTACK_RESULT_BLOCKED|MM_ATTACK_RESULT_DEFLECTED)
				break

	//light up the night.
	if(shield_hit)
		playsound(_owner,'sound/effects/basscannon.ogg', 20, 1)
		for(var/datum/mob_modifier/object/mechshield/obj_modifier in modifiers)
			if(obj_modifier.object)
				flick("shield_impact", obj_modifier.object)

/decl/mob_modifier/mech_ballistic
	name           = "Mech Ballistic Shield"
	hud_icon_state = "nanomachines"
	modifier_type  = /datum/mob_modifier/object/mechshield_ballistic

/datum/mob_modifier/object/mechshield_ballistic
	object             = /obj/abstract/follower/mechshield_ballistic

/datum/mob_modifier/object/mechshield_ballistic/on_modifier_added(skip_update = FALSE)
	. = ..()
	var/obj/item/mech_equipment/source_atom = source?.resolve()
	if(!istype(source_atom) || !istype(object) || !istype(owner, /mob/living/exosuit))
		return
	var/mob/living/exosuit/mech = owner
	for(var/hardpoint in mech.hardpoints)
		var/obj/item/mech_equipment/hardpoint_object = mech.hardpoints[hardpoint]
		if(source_atom != hardpoint_object)
			continue
		object.icon_state = "mech_shield_[hardpoint]"
		var/image/mech_overlay = image(object.icon, "[object.icon_state]_over")
		mech_overlay.layer = ABOVE_HUMAN_LAYER
		object.add_overlay(mech_overlay, priority = TRUE)

/obj/abstract/follower/mechshield_ballistic
	icon           = 'icons/mecha/ballistic_shield.dmi'
	layer          = MECH_UNDER_LAYER
	plane          = DEFAULT_PLANE
	mouse_opacity  = MOUSE_OPACITY_UNCLICKABLE
	invisibility   = INVISIBILITY_NONE
	alpha          = 255
	hide_on_init   = FALSE

/decl/mob_modifier/mech_ballistic/check_modifiers_block_attack(mob/living/_owner, list/modifiers, attack_type, atom/movable/attacker, additional_data)

	if(attack_type == MM_ATTACK_TYPE_PROJECTILE)

		var/obj/item/projectile/projectile = attacker
		if(istype(projectile))

			var/target_zone = BP_CHEST
			if(isliving(attacker))
				var/mob/living/attacker_mob = attacker
				target_zone = attacker_mob.get_target_zone()

			for(var/datum/mob_modifier/modifier in modifiers)
				var/obj/item/mech_equipment/ballistic_shield/shield = modifier.source?.resolve()
				if(istype(shield) && prob(shield.block_chance(projectile.damage, projectile.armor_penetration, source = projectile)))
					_owner.visible_message(SPAN_WARNING("\The [projectile] is blocked by \the [_owner]'s [shield.name]."))
					_owner.bullet_impact_visuals(projectile, target_zone, 0)
					shield.on_block_attack()
					return (MM_ATTACK_RESULT_BLOCKED|MM_ATTACK_RESULT_DEFLECTED)

	else if(attack_type == MM_ATTACK_TYPE_THROWN)

		var/datum/thrownthing/thrown = additional_data
		if(istype(thrown))
			var/throw_damage = thrown.thrownthing.get_thrown_attack_force() * (thrown.speed/THROWFORCE_SPEED_DIVISOR)
			for(var/datum/mob_modifier/modifier in modifiers)
				var/obj/item/mech_equipment/ballistic_shield/shield = modifier.source?.resolve()
				if(istype(shield) && prob(shield.block_chance(throw_damage, 0, source = thrown.thrownthing, attacker = thrown.thrower)))
					_owner.visible_message(SPAN_WARNING("\The [thrown.thrownthing] bounces off \the [_owner]'s [shield]."))
					playsound(_owner.loc, 'sound/weapons/Genhit.ogg', 50, 1)
					shield.on_block_attack()
					return (MM_ATTACK_RESULT_BLOCKED|MM_ATTACK_RESULT_DEFLECTED)

	else if(attack_type == MM_ATTACK_TYPE_WEAPON)

		var/obj/item/weapon = additional_data
		if(istype(weapon))
			for(var/datum/mob_modifier/modifier in modifiers)
				var/obj/item/mech_equipment/ballistic_shield/shield = modifier.source?.resolve()
				if(shield && prob(shield.block_chance(weapon.get_attack_force(), weapon.armor_penetration, source = weapon, attacker = _owner)))
					_owner.visible_message(SPAN_WARNING("\The [weapon] is blocked by \the [_owner]'s [shield.name]."))
					playsound(_owner.loc, 'sound/weapons/Genhit.ogg', 50, 1)
					return (MM_ATTACK_RESULT_BLOCKED|MM_ATTACK_RESULT_DEFLECTED)

	return ..()
