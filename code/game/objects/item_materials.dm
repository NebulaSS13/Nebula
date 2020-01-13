/obj/item/on_update_icon()
	overlays.Cut()
	if(applies_material_colour && material)
		color = material.icon_colour
		alpha = 100 + material.opacity * 255

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

/obj/item/disrupts_psionics()
	. = (material && material.is_psi_null()) ? src : FALSE

/obj/item/withstand_psi_stress(var/stress, var/atom/source)
	. = ..(stress, source)
	if(health >= 0 && . > 0 && disrupts_psionics())
		health -= .
		. = max(0, -(health))
		check_health(consumed = TRUE)

/obj/item/get_material()
	. = material

/obj/item/proc/update_force()
	var/new_force
	if(material)
		if(edge || sharp)
			new_force = material.get_edge_damage()
		else
			new_force = material.get_blunt_damage()
		new_force = round(new_force*material_force_multiplier)
		force = min(new_force, max_force)

	if(new_force > max_force)
		armor_penetration = initial(armor_penetration) + new_force - max_force

	attack_cooldown = initial(attack_cooldown)
	if(material)
		armor_penetration += 2*max(0, material.brute_armor - 2)
		throwforce = round(material.get_blunt_damage() * thrown_material_force_multiplier)
		attack_cooldown += material.get_attack_cooldown()

/obj/item/proc/set_material(var/new_material)
	if(new_material)
		material = SSmaterials.get_material_by_name(new_material)
	if(istype(material))
		health = round(material.integrity/5)
		if(material.products_need_process())
			START_PROCESSING(SSobj, src)
		if(material.conductive)
			obj_flags |= OBJ_FLAG_CONDUCTIBLE
		else
			obj_flags &= (~OBJ_FLAG_CONDUCTIBLE)
		update_force()
		if(applies_material_name)
			SetName("[material.display_name] [initial(name)]")
	queue_icon_update()
