/obj/item
	/// Tracking var for base attack value with material modifiers, to save recalculating 200 times.
	VAR_PRIVATE/_cached_attack_force
	/// Base force value; generally, the damage output if used one-handed by a medium mob (human) and made of steel.
	VAR_PROTECTED/_base_attack_force        = 5
	/// Multiplier to the base thrown force based on the material per above.
	VAR_PROTECTED/_thrown_force_multiplier  = 0.3
	/// Multiplier to total base damage from weapon and material if the weapon is wieldable and held in two hands.
	VAR_PROTECTED/_wielded_force_multiplier = 1.25
	/// How much of our overall damage is influenced by material weight?
	VAR_PROTECTED/_weight_force_factor      = 0.25
	/// How much of our overall damage is influenced by material hardness?
	VAR_PROTECTED/_hardness_force_factor    = 0.25

/obj/item/proc/get_max_weapon_force()
	. = get_attack_force()
	if(can_be_twohanded)
		. = round(. * _wielded_force_multiplier)

/obj/item/proc/expend_attack_force(mob/living/user)
	. = get_attack_force(user)
	var/list/item_effects = get_item_effects(IE_CAT_DAMAGE)
	if(length(item_effects))
		for(var/decl/item_effect/damage_effect as anything in item_effects)
			damage_effect.expend_attack_use(src, user, item_effects[damage_effect])

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
	return round(expend_attack_force() * _thrown_force_multiplier)

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
		set_edge(FALSE)
	else if(!edge)
		set_edge(initial(edge))

	// Check if this material can hold a point.
	if(!material.can_hold_sharpness())
		set_sharp(FALSE)
	else if(!sharp)
		set_sharp(initial(sharp))

	// Work out where we're going to cap our calculated force.
	// Any additional force resulting from hardness or weight turn into armour penetration.
	var/accumulated_force        = _cached_attack_force
	var/weight_force_component   = (_cached_attack_force * _weight_force_factor)
	var/hardness_force_component = (_cached_attack_force * _hardness_force_factor)
	var/expected_material_mod    = (weight_force_component+hardness_force_component)/2
	var/expected_min_force       = _cached_attack_force - expected_material_mod
	var/expected_max_force       = _cached_attack_force + expected_material_mod

	// Heavier weapons are generally going to be more effective, regardless of edge or sharpness.
	// We don't factor in w_class or matter at this point, because we are assuming the base attack
	// force was set already taking into account how effective this weapon should be.
	var/relative_weight = (material.weight / MAT_VALUE_VERY_HEAVY)
	if(obj_flags & OBJ_FLAG_HOLLOW)
		relative_weight *= HOLLOW_OBJECT_MATTER_MULTIPLIER
	accumulated_force += (weight_force_component * relative_weight) - (weight_force_component/2)

	// Apply hardness in the same way.
	accumulated_force += (hardness_force_component * (material.hardness / MAT_VALUE_VERY_HARD)) - (hardness_force_component/2)

	// Round off our calculated attack force and turn any overflow into armour penetration.
	_cached_attack_force = round(clamp(accumulated_force, expected_min_force, expected_max_force))

	// Update our armor penetration.
	armor_penetration = initial(armor_penetration)
	if(accumulated_force > expected_max_force)
		armor_penetration = armor_penetration+(accumulated_force-expected_max_force)
	armor_penetration += 2 * max(0, material.brute_armor - 2)
	armor_penetration = min(100, round(armor_penetration))

	return _cached_attack_force

// TODO: consider strength, athletics, mob size
// `dry_run` param used in grindstone modpack to avoid depleting sharpness on non-attacks.
/mob/living/proc/modify_attack_force(obj/item/weapon, supplied_force, wield_mult)
	if(!istype(weapon) || !weapon.is_held_twohanded())
		. = supplied_force
	else
		. = supplied_force * wield_mult
	var/list/item_effects = weapon.get_item_effects(IE_CAT_DAMAGE)
	if(length(item_effects))
		for(var/decl/item_effect/damage_effect as anything in item_effects)
			. = damage_effect.modify_attack_damage(., weapon, src, item_effects[damage_effect])
	return round(.)

// Debug proc - leaving in for future work. Linter hates protected var access so leave commented.
/*
/client/verb/debug_dump_weapon_values()
	set name = "Dump Weapon Values"
	set category = "Debug"
	set src = usr

	var/list/rows = list()
	rows += jointext(list(
		"Name",
		"Type",
		"Base Force",
		"Calculated Force",
		"Thrown Force",
		"Min Force",
		"Max Force",
		"Wield force",
		"Armour Pen",
		"Sharp/Edge"
	), "|")

	for(var/thing in subtypesof(/obj/item))

		var/obj/item/item = thing
		if(!TYPE_IS_SPAWNABLE(item))
			continue

		item = new item

		var/attk_force = item.expend_attack_force()
		var/expected_material_mod = ((attk_force * item._weight_force_factor) + (attk_force * item._hardness_force_factor))/2

		rows += jointext(list(
			item.name,
			item.type,
			item.get_base_attack_force(),
			attk_force,
			item.get_thrown_attack_force(),
			(attk_force - expected_material_mod),
			(attk_force + expected_material_mod),
			(attk_force * item._wielded_force_multiplier),
			item.armor_penetration,
			(item.sharp|item.edge)
		), "|")

	text2file(jointext(rows, "\n"), "weapon_stats_dump.csv")
	if(fexists("weapon_stats_dump.csv"))
		ftp_to(usr, "weapon_stats_dump.csv", "weapon_stats_dump.csv")
	to_chat(usr, "Done.")
*/
