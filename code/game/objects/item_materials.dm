/obj/item/on_update_icon()
	overlays.Cut()
	if(applies_material_colour && material)
		color = material.color
		alpha = 100 + material.opacity * 255
	if(blood_overlay)
		overlays += blood_overlay
	if(global.contamination_overlay && contaminated)
		overlays += global.contamination_overlay

/obj/item/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	. = ..()
	if(material && (material.is_brittle() || target.get_blocked_ratio(hit_zone, BRUTE, damage_flags(), armor_penetration, force) * 100 >= material.hardness/5))
		check_shatter()

/obj/item/on_parry(damage_source)
	if(istype(damage_source, /obj/item))
		check_shatter()

/obj/item/proc/check_shatter()
	if(material && !unbreakable && prob(material.hardness))
		if(material.is_brittle())
			health = 0
		else
			health--
		check_health()

/obj/item/proc/check_health(var/consumed)
	if(health<=0)
		shatter(consumed)

/obj/item/proc/shatter(var/consumed)
	var/turf/T = get_turf(src)
	T.visible_message(SPAN_DANGER("\The [src] [material ? material.destruction_desc : "shatters"]!"))
	playsound(src, "shatter", 70, 1)
	if(!consumed && material && w_class > ITEM_SIZE_SMALL)
		material.place_shard(T)
	qdel(src)

/obj/item/get_material()
	. = material

/obj/item/proc/update_force()
	var/new_force
	if(!max_force)
		max_force = 5 * min(w_class, ITEM_SIZE_GARGANTUAN)
	if(material)
		if(edge || sharp)
			new_force = material.get_edge_damage()
		else
			new_force = material.get_blunt_damage()
			if(item_flags & ITEM_FLAG_HOLLOW)
				new_force *= HOLLOW_OBJECT_MATTER_MULTIPLIER

		new_force = round(new_force*material_force_multiplier)
		force = min(new_force, max_force)

	if(new_force > max_force)
		armor_penetration = initial(armor_penetration) + new_force - max_force

	attack_cooldown = initial(attack_cooldown)
	if(material)
		armor_penetration += 2*max(0, material.brute_armor - 2)
		throwforce = material.get_blunt_damage() * thrown_material_force_multiplier
		if(item_flags & ITEM_FLAG_HOLLOW)
			throwforce *= HOLLOW_OBJECT_MATTER_MULTIPLIER
		throwforce = round(throwforce)
		attack_cooldown += material.get_attack_cooldown()

/obj/item/proc/set_material(var/new_material)
	if(new_material)
		material = GET_DECL(new_material)
	if(istype(material))
		health = round(material_health_multiplier * material.integrity)
		max_health = health
		if(material.products_need_process())
			START_PROCESSING(SSobj, src)
		if(material.conductive)
			obj_flags |= OBJ_FLAG_CONDUCTIBLE
		else
			obj_flags &= (~OBJ_FLAG_CONDUCTIBLE)
		update_force()
		if(applies_material_name)
			SetName("[material.solid_name] [initial(name)]")
		if(material_armor_multiplier)
			armor = material.get_armor(material_armor_multiplier)
			armor_degradation_speed = material.armor_degradation_speed
			if(length(armor))
				set_extension(src, armor_type, armor, armor_degradation_speed)
			else
				remove_extension(src, armor_type)
	queue_icon_update()

/obj/item/get_matter_amount_modifier()
	. = ..()
	if(item_flags & ITEM_FLAG_HOLLOW)
		. *= HOLLOW_OBJECT_MATTER_MULTIPLIER
