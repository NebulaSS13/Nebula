/obj/item
	/// Tracking var for base attack value with material modifiers, to save recalculating 200 times.
	VAR_PRIVATE/_cached_attack_force
	/// Base force value; generally, the damage output if used one-handed by a medium mob (human) and made of steel.
	VAR_PROTECTED/_base_attack_force         = 5
	/// Multiplier to base force based on the material of the weapon, with additional tweaking from sharpness.
	VAR_PROTECTED/_material_force_multiplier = 1
	/// Multiplier to the base thrown force based on the material per above.
	VAR_PROTECTED/_thrown_force_multiplier   = 0.1
	/// Multiplier to total base damage from weapon and material if the weapon is wieldable and held in two hands.
	VAR_PROTECTED/_wielded_force_multiplier  = 1.25

/obj/item/proc/get_max_weapon_force()
	. = get_attack_force()
	if(can_be_twohanded)
		. = round(. * _wielded_force_multiplier)

/obj/item/proc/get_attack_force(mob/living/user)
	if(_base_attack_force <= 0 || (item_flags & ITEM_FLAG_NO_BLUDGEON))
		return 0
	if(isnull(_cached_attack_force))
		update_attack_force()
	if(_cached_attack_force <= 0)
		return 0
	return istype(user) ? user.modify_attack_force(src, _cached_attack_force, _wielded_force_multiplier) : _cached_attack_force

// Existing hitby() code expects mobs, structures and machines to be thrown, it seems.
/atom/movable/proc/get_thrown_attack_force()
	return get_object_size()

/obj/item/get_thrown_attack_force()
	return round(get_attack_force() * _thrown_force_multiplier)

/obj/item/proc/get_base_attack_force()
	return _base_attack_force

/obj/item/proc/get_initial_base_attack_force()
	return initial(_base_attack_force)

/obj/item/proc/set_base_attack_force(new_force)
	_cached_attack_force = null
	_base_attack_force = new_force

/obj/item/proc/update_attack_force()

	_cached_attack_force = get_base_attack_force()
	if(_cached_attack_force <= 0)
		_cached_attack_force = 0
		return _cached_attack_force

/*
	var/new_force
	if(!_max_force)
		_max_force = 5 * min(w_class, ITEM_SIZE_GARGANTUAN)
	if(material)
		if(edge || sharp)
			new_force = material.get_edge_damage()
		else
			new_force = material.get_blunt_damage()
			if(obj_flags & OBJ_FLAG_HOLLOW)
				new_force *= HOLLOW_OBJECT_MATTER_MULTIPLIER

		new_force = round(new_force*_material_force_multiplier)
		force = min(new_force, _max_force)

	if(new_force > _max_force)
		armor_penetration = initial(armor_penetration) + new_force - _max_force

	if(material)
		armor_penetration += 2*max(0, material.brute_armor - 2)
		_throwforce = material.get_blunt_damage() * thrown_force_multiplier
		if(obj_flags & OBJ_FLAG_HOLLOW)
			_throwforce *= HOLLOW_OBJECT_MATTER_MULTIPLIER
		_throwforce = round(_throwforce)
*/

// TODO: consider strength, athletics, mob size
/mob/living/proc/modify_attack_force(obj/item/weapon, supplied_force, wield_mult)
	if(!istype(weapon) || !weapon.is_held_twohanded())
		return supplied_force
	return round(supplied_force * wield_mult)
