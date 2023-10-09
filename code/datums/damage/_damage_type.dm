/decl/damage_handler
	abstract_type                          = /decl/damage_handler
	var/name
	var/color                              = COLOR_GUNMETAL
	var/applies_to_machinery               = FALSE
	var/machinery_hit_sound                = 'sound/weapons/smash.ogg'
	var/blocked_by_ablative                = FALSE
	var/can_ignite_reagents                = FALSE
	var/damage_verb                        = "shatters"
	var/allow_modification_in_vv           = TRUE
	var/usable_with_backstab               = FALSE
	var/causes_limb_damage                 = FALSE
	var/projectile_damage_divisor          = 1
	var/projectile_damages_assembly_casing = TRUE
	var/barrier_damage_multiplier          = 0
	var/item_damage_flags                  = 0
	var/category_type
	var/expected_type                      = /mob/living

/decl/damage_handler/validate()
	. = ..()
	if(!name)
		. += "no name set"
	if(!category_type)
		. += "no category type set"

/decl/damage_handler/proc/set_mob_damage(var/mob/living/target, var/damage, var/skip_update_health = FALSE)
	if(!(category_type in target._damage_values))
		return FALSE
	var/oldval = target._damage_values[category_type]
	var/newval = clamp(oldval + damage, 0, target.get_max_health())
	if(oldval == newval)
		return FALSE
	target._damage_values[category_type] = newval
	if(!skip_update_health)
		target.update_health()
	return TRUE

/decl/damage_handler/proc/heal_mob_damage(var/mob/living/target, var/damage, var/skip_update_health = FALSE)
	return set_mob_damage(target, target.get_damage(category_type)-damage, skip_update_health = skip_update_health)

/decl/damage_handler/proc/apply_damage_to_mob(var/mob/living/target, var/damage, var/def_zone, var/damage_flags = 0, var/used_weapon, var/silent = FALSE, var/skip_update_health = FALSE)
	return set_mob_damage(target, target.get_damage(category_type)+damage, skip_update_health = skip_update_health)

// There is a disconnect between legacy damage and armor code. This here helps bridge the gap.
/decl/damage_handler/proc/get_armor_key(var/damage_flags = 0)
	return null

/decl/damage_handler/proc/get_damage_for_mob(var/mob/living/target)
	return LAZYACCESS(target._damage_values, category_type) || 0

/decl/damage_handler/proc/damage_limb(var/obj/item/organ/external/organ, var/damage, var/damage_flags = 0, var/used_weapon, var/skip_update_health = FALSE)
	return organ?.take_damage(damage, category_type, damage_flags = damage_flags, used_weapon = used_weapon, skip_update_health = skip_update_health)
