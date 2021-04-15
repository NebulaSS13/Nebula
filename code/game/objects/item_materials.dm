/obj/item/on_update_icon()
	overlays.Cut()
	var/decl/material/material = get_primary_material()
	if(applies_material_colour && material)
		color = material.color
		alpha = 100 + material.opacity * 255
	if(blood_overlay)
		overlays += blood_overlay

/obj/item/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	. = ..()
	var/decl/material/material = get_primary_material()
	if(material && (material.is_brittle() || target.get_blocked_ratio(hit_zone, BRUTE, damage_flags(), armor_penetration, force) * 100 >= material.hardness/5))
		check_shatter()

/obj/item/on_parry(damage_source)
	if(istype(damage_source, /obj/item))
		check_shatter()

/obj/item/proc/check_shatter()
	var/decl/material/material = get_primary_material()
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
	var/decl/material/material = get_primary_material()
	var/turf/T = get_turf(src)
	T.visible_message(SPAN_DANGER("\The [src] [material ? material.destruction_desc : "shatters"]!"))
	playsound(src, "shatter", 70, 1)
	if(!consumed && material && w_class > ITEM_SIZE_SMALL)
		material.place_shard(T)
	qdel(src)

/obj/item/get_primary_material()
	var/datum/materials/matter = get_material_composition()
	if(istype(matter))
		return matter.get_primary_material()

/obj/item/proc/update_force()
	var/new_force
	if(!max_force)
		max_force = 5 * min(w_class, ITEM_SIZE_GARGANTUAN)
	var/decl/material/material = get_primary_material()
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
