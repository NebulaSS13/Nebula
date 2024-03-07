/datum/controller/subsystem/materials/get_armor_key(damage_type, damage_flags)
	. = (damage_type == PSIONIC) ? PSIONIC : ..()

/datum/extension/armor/psionic
	expected_type = /datum/ability_handler/psionics
	full_block_message = "You block the blow with your mind!"
	partial_block_message = "You soften the blow with your mind!"

/datum/extension/armor/psionic/get_value(key)
	var/datum/ability_handler/psionics/psi = holder
	return psi.get_armour(key)

/datum/extension/armor/psionic/on_blocking(damage, damage_type, damage_flags, armor_pen, blocked)
	var/datum/ability_handler/psionics/psi = holder
	var/blocked_damage = damage * blocked
	if(blocked_damage)
		psi.spend_power_armor(blocked_damage)
