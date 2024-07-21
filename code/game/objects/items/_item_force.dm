/obj/item
	/// Tracking var for base attack value with material modifiers, to save recalculating 200 times.
	VAR_PRIVATE/_cached_attack_force
	/// Base force value; generally, the damage output if used one-handed by a medium mob (human) and made of steel.
	VAR_PROTECTED/_base_attack_force         = 5
	/// Multiplier to base force based on the material of the weapon, with additional tweaking from sharpness.
	VAR_PROTECTED/_material_force_multiplier = 1.25
	/// Multiplier to the base thrown force based on the material per above.
	VAR_PROTECTED/_thrown_force_multiplier   = 0.1
	/// Multiplier to total base damage from weapon and material if the weapon is wieldable and held in two hands.
	VAR_PROTECTED/_wielded_force_multiplier  = 1.25
	/// How much of our overall damage is influenced by material weight?
	VAR_PROTECTED/_weight_force_factor       = 0.25
	/// How much of our overall damage is influenced by material hardness?
	VAR_PROTECTED/_hardness_force_factor     = 0.25

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

	// Get our base force.
	_cached_attack_force = get_base_attack_force()
	if(_cached_attack_force <= 0 || !istype(material))
		_cached_attack_force = 0
		return _cached_attack_force

	// Check if this material is hard enough to hold an edge.
	if(!material.can_hold_edge())
		edge = FALSE
	else if(!edge)
		edge = initial(edge)

	// Check if this material can hold a point.
	if(!material.can_hold_sharpness())
		sharp = FALSE
	else if(!sharp)
		sharp = initial(sharp)

	// Assumptions for the purposes of this calc:
	// - sharp objects are used for thrusting so rely on hardness
	// - blunt objects are used for striking so use weight.

	// Work out where we're going to cap our calculated force.
	// Any additional force resulting from hardness or weight turn into armour penetration.
	var/accumulated_force  = _cached_attack_force
	var/expected_max_force = _material_force_multiplier * _cached_attack_force

	// Heavier weapons are generally going to be more effective, regardless of edge or sharpness.
	// We don't factor in w_class or matter at this point, because we are assuming the base attack
	// force was set already taking into account how effective this weapon should be.
	var/weight_force_component = (_cached_attack_force * _weight_force_factor)
	var/relative_weight = (material.weight / MAT_VALUE_VERY_HEAVY)
	if(obj_flags & OBJ_FLAG_HOLLOW)
		relative_weight *= HOLLOW_OBJECT_MATTER_MULTIPLIER
	accumulated_force += (weight_force_component * relative_weight) - (weight_force_component/2)

	// Apply hardness in the same way.
	var/hardness_force_component = (_cached_attack_force * _hardness_force_factor)/2
	accumulated_force += (hardness_force_component * (material.hardness / MAT_VALUE_VERY_HARD)) - (hardness_force_component/2)

	// Round off our calculated attack force and turn any overflow into armour penetration.
	_cached_attack_force = round(min(accumulated_force, expected_max_force))

	// Update our armor penetration.
	armor_penetration = initial(armor_penetration)
	if(accumulated_force > expected_max_force)
		armor_penetration = armor_penetration+(accumulated_force-expected_max_force)
	armor_penetration += 2 * max(0, material.brute_armor - 2)
	armor_penetration = min(100, round(armor_penetration))

	return _cached_attack_force

// TODO: consider strength, athletics, mob size
/mob/living/proc/modify_attack_force(obj/item/weapon, supplied_force, wield_mult)
	if(!istype(weapon) || !weapon.is_held_twohanded())
		return supplied_force
	return round(supplied_force * wield_mult)
