/obj/item/on_update_icon()
	. = ..()
	SHOULD_CALL_PARENT(TRUE)
	cut_overlays()
	if(blood_overlay)
		add_overlay(blood_overlay)
	if(global.contamination_overlay && contaminated)
		overlays += global.contamination_overlay

/obj/item/update_material_colour(override_colour, override_alpha)
	if(material && (material_alteration & MAT_FLAG_ALTERATION_COLOR))
		return ..(override_colour, override_alpha? override_alpha : (100 + (material.opacity * 255)))
	return ..()
	
/obj/item/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	. = ..()
	if(material && (material.is_brittle() || target.get_blocked_ratio(hit_zone, BRUTE, damage_flags(), armor_penetration, force) * 100 >= material.hardness/5))
		apply_wear()

/obj/item/on_parry(damage_source)
	if(istype(damage_source, /obj/item))
		apply_wear()

/**
 * Whether the object will take wear damage when used as a weapon.
 */
/obj/item/proc/can_take_wear_damage()
	return TRUE

/obj/item/proc/apply_wear()
	if(material && can_take_damage() && can_take_wear_damage() && prob(material.hardness))
		if(material.is_brittle())
			health = 0
		else
			health--
		check_health()

/obj/item/proc/update_force()
	var/new_force
	if(!max_force)
		max_force = 5 * min(w_class, ITEM_SIZE_GARGANTUAN)
	if(material)
		if(edge || sharp)
			new_force = material.get_edge_damage()
		else
			new_force = material.get_blunt_damage()
			if(obj_flags & OBJ_FLAG_HOLLOW)
				new_force *= HOLLOW_OBJECT_MATTER_MULTIPLIER

		new_force = round(new_force*material_force_multiplier)
		force = min(new_force, max_force)

	if(new_force > max_force)
		armor_penetration = initial(armor_penetration) + new_force - max_force

	attack_cooldown = initial(attack_cooldown)
	if(material)
		armor_penetration += 2*max(0, material.brute_armor - 2)
		throwforce = material.get_blunt_damage() * thrown_material_force_multiplier
		if(obj_flags & OBJ_FLAG_HOLLOW)
			throwforce *= HOLLOW_OBJECT_MATTER_MULTIPLIER
		throwforce = round(throwforce)
		attack_cooldown += material.get_attack_cooldown()

/obj/item/update_material(keep_health = FALSE, should_update_icon = TRUE)
	. = ..()
	update_force()

/obj/item/get_matter_amount_modifier()
	. = ..()
	if(obj_flags & OBJ_FLAG_HOLLOW)
		. *= HOLLOW_OBJECT_MATTER_MULTIPLIER

/obj/item/create_matter()
	..()
	LAZYINITLIST(matter)
	if(istype(material))
		matter[material.type] = max(matter[material.type], round(MATTER_AMOUNT_PRIMARY * get_matter_amount_modifier()))
	UNSETEMPTY(matter)
