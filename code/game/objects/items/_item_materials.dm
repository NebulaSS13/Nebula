/obj/item/on_update_icon()
	. = ..()
	SHOULD_CALL_PARENT(TRUE)
	cut_overlays()
	if((material_alteration & MAT_FLAG_ALTERATION_COLOR) && material)
		alpha = 100 + material.opacity * 255
	color = get_color() // avoiding set_color() here as that will set it on paint_color
	if(blood_overlay)
		add_overlay(blood_overlay)
	if(global.contamination_overlay && contaminated)
		add_overlay(global.contamination_overlay)

/obj/item/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	. = ..()
	if(material && (material.is_brittle() || target.get_blocked_ratio(hit_zone, BRUTE, damage_flags(), armor_penetration, get_attack_force(user)) * 100 >= material.hardness/5))
		apply_wear()

/obj/item/on_parry(mob/user, damage_source, mob/attacker)
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
			current_health = 0
		else
			current_health--
		check_health()

/obj/item/proc/check_health(var/lastdamage = null, var/lastdamtype = null, var/lastdamflags = 0, var/consumed = FALSE)
	if(current_health > 0 || !can_take_damage())
		return //If invincible, or if we're not dead yet, skip
	if(lastdamtype == BRUTE)
		if(material?.is_brittle())
			shatter(consumed)
			return
	else if(lastdamtype == BURN)
		handle_destroyed_by_heat()
		return
	physically_destroyed()

/obj/item/proc/shatter(var/consumed)
	var/turf/T = get_turf(src)
	T?.visible_message(SPAN_DANGER("\The [src] [material ? material.destruction_desc : "shatters"]!"))
	playsound(src, "shatter", 70, 1)
	if(!consumed && material && w_class > ITEM_SIZE_SMALL && T)
		material.place_shards(T)
	qdel(src)

/obj/item/get_material()
	. = material

// TODO: Refactor more code to use this where necessary, and then make this use
// some sort of generalized system for hitting with different parts of an item
// e.g. pommel vs blade, rifle butt vs bayonet, knife hilt vs blade
/// What material are we using when we hit things?
/// Params:
///   mob/user (the mob striking something with src)
///   atom/target (the atom being struck with src)
/obj/item/proc/get_striking_material(mob/user, atom/target)
	return get_material()

/obj/item/proc/set_material(var/new_material)
	if(new_material)
		material = GET_DECL(new_material)
	attack_cooldown = initial(attack_cooldown)
	if(istype(material))
		attack_cooldown += material.get_attack_cooldown()
		//Only set the current_health if health is null. Some things define their own health value.
		if(isnull(max_health))
			max_health = round(material_health_multiplier * material.integrity, 0.01)
			if(max_health < 1)
				//Make sure to warn us if the values we set make the max_health be under 1
				log_warning("The 'max_health' of '[src]'([type]) made out of '[material]' was calculated as [material_health_multiplier] * [material.integrity] == [max_health], which is smaller than 1.")

		if(isnull(current_health)) //only set health if we didn't specify one already, so damaged objects on spawn and etc can be a thing
			current_health = get_max_health()

		if(material.products_need_process())
			START_PROCESSING(SSobj, src)
		if(material.conductive)
			obj_flags |= OBJ_FLAG_CONDUCTIBLE
		else
			obj_flags &= (~OBJ_FLAG_CONDUCTIBLE)
		update_attack_force()
		update_name()
		if(material_armor_multiplier)
			armor = material.get_armor(material_armor_multiplier)
			armor_degradation_speed = material.armor_degradation_speed
			if(length(armor))
				set_extension(src, armor_type, armor, armor_degradation_speed)
			else
				remove_extension(src, armor_type)

	queue_icon_update()

/obj/item/proc/update_name()
	if(material_alteration & MAT_FLAG_ALTERATION_NAME)
		SetName("[material.adjective_name] [base_name || initial(name)]")
	else
		SetName(base_name || initial(name))

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
