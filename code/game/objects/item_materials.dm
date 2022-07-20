/obj/item/on_update_icon()
	. = ..()
	SHOULD_CALL_PARENT(TRUE)
	cut_overlays()
	if(applies_material_colour && material)
		color = material.color
		alpha = 100 + material.opacity * 255
	if(blood_overlay)
		add_overlay(blood_overlay)
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
	if(material && health != -1 && prob(material.hardness))
		if(material.is_brittle())
			health = 0
		else
			health--
		check_health()

/obj/item/proc/check_health(var/lastamount = null, var/lastdamtype = null, var/lastdamflags = 0, var/consumed = FALSE)
	if(health > 0)
		return
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

	new /obj/effect/decal/cleanable/ash(src)
	qdel(src)

/obj/item/proc/shatter(var/consumed)
	var/turf/T = get_turf(src)
	T.visible_message(SPAN_DANGER("\The [src] [material ? material.destruction_desc : "shatters"]!"))
	playsound(src, "shatter", 70, 1)
	if(!consumed && material && w_class > ITEM_SIZE_SMALL)
		material.place_shards(T)
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
		max_health = round(material_health_multiplier * material.integrity)
		if(health != -1)
			health = max_health
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

/obj/item/create_matter()
	..()
	LAZYINITLIST(matter)
	if(istype(material))
		matter[material.type] = max(matter[material.type], round(MATTER_AMOUNT_PRIMARY * get_matter_amount_modifier()))
	UNSETEMPTY(matter)
