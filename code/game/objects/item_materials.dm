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

/obj/item/proc/check_health(var/lastdamage = null, var/lastdamtype = null, var/lastdamflags = 0, var/consumed = FALSE)
	if(health > 0 || !can_take_damage())
		return //If invincible, or if we're not dead yet, skip
	if(lastdamtype == BRUTE)
		if(material?.is_brittle())
			shatter(consumed)
			return
	else if(lastdamtype == BURN)
		melt()
		return
	physically_destroyed()

/obj/item/melt()
	for(var/mat in matter)
		var/decl/material/M = GET_DECL(mat)
		if(!M)
			log_warning("[src] ([type]) has a bad material path in its matter var.")
			continue
		var/turf/T = get_turf(src)
		//TODO: Would be great to just call a proc to do that, like "Material.place_burn_product(loc, amount_matter)" so no need to care if its a gas or something else
		var/datum/gas_mixture/environment = T?.return_air()
		if(M.burn_product)
			environment.adjust_gas(M.burn_product, M.fuel_value * (matter[mat] / SHEET_MATERIAL_AMOUNT))

	new /obj/effect/decal/cleanable/molten_item(src)
	qdel(src)

/obj/item/proc/shatter(var/consumed)
	var/turf/T = get_turf(src)
	T?.visible_message(SPAN_DANGER("\The [src] [material ? material.destruction_desc : "shatters"]!"))
	playsound(src, "shatter", 70, 1)
	if(!consumed && material && w_class > ITEM_SIZE_SMALL && T)
		material.place_shards(T)
	qdel(src)

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

/obj/item/update_material_health(override_max_health, keep_health)
	//#TODO: Move this to obj level
	if(istype(material))
		var/mat_health_modifier = get_material_health_modifier()
		//Only set the health if health is null. Some things define their own health value.
		if(isnull(max_health))
			max_health = round(mat_health_modifier * material.integrity, 0.01)
			if(max_health < 1)
				//Make sure to warn us if the values we set make the max_health be under 1
				log_warning("The 'max_health' of '[src]'([type]) made out of '[material]' was calculated as [mat_health_modifier] * [material.integrity] == [max_health], which is smaller than 1.")

		if(isnull(health)) //only set health if we didn't specify one already, so damaged objects on spawn and etc can be a thing
			health = max_health

/obj/item/update_material_armor(list/overriden_armor)
	//#TODO: Move this to obj level
	if(istype(material))
		if(material_armor_multiplier)
			armor = material.get_armor(material_armor_multiplier)
			armor_degradation_speed = material.armor_degradation_speed
			if(length(armor))
				set_extension(src, armor_type, armor, armor_degradation_speed)
			else
				remove_extension(src, armor_type)