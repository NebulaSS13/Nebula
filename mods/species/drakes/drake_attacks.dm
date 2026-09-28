/proc/drake_infect_wounds(obj/item/organ/external/bitten)

	var/decl/species/grafadreka/drakes = IMPLIED_DECL
	if(!drakes.should_poison_creature(bitten?.owner))
		return
	var/list/open_wounds = list()
	for(var/datum/wound/wound in bitten?.wounds)
		if(wound.damage_type != CUT)
			continue
		if(wound.is_treated())
			continue
		open_wounds += wound
	if(!length(open_wounds))
		return
	var/germs_per_wound = max(1, round(rand(50,80) / length(open_wounds)))
	for(var/datum/wound/wound in open_wounds)
		wound.germ_level += germs_per_wound
		wound.disinfected = FALSE

/decl/species/grafadreka/proc/check_can_infect_wounds(obj/item/organ/external/bitten)
	return TRUE

// 50% damage bonus on prone, stunned or confused enemies.
/decl/natural_attack/bite/sharp/drake
	damage = 12 // chomp
	can_damage_structures = TRUE

/decl/natural_attack/bite/sharp/drake/get_unarmed_damage(mob/living/user, mob/living/victim)
	. = ..()
	if(victim.current_posture?.prone || HAS_STATUS(victim, STAT_CONFUSE) || HAS_STATUS(victim, STAT_STUN))
		. = max(1, round(. * 1.5))

/decl/natural_attack/claws/strong/drake
	damage = 8 // chonky for digging
	can_damage_structures = TRUE

/decl/natural_attack/claws/strong/drake/get_unarmed_damage(mob/living/user, mob/living/victim)
	. = ..()
	if(victim.current_posture?.prone || HAS_STATUS(victim, STAT_CONFUSE) || HAS_STATUS(victim, STAT_STUN))
		. = max(1, round(. * 1.5))

// Raises germ level of wounds on attack.
/decl/natural_attack/bite/sharp/drake/apply_attack_effects(mob/living/user, mob/living/target, attack_damage, zone)
	. = ..()
	if(. && drake_spend_spit(user, 5))
		var/obj/item/organ/external/bit = target.get_organ(zone)
		if(bit)
			drake_infect_wounds(bit)

/decl/natural_attack/claws/strong/drake/apply_attack_effects(mob/living/user, mob/living/target, attack_damage, zone)
	. = ..()
	if(. && drake_spend_spit(user, 5))
		var/obj/item/organ/external/bit = target.get_organ(zone)
		if(bit)
			drake_infect_wounds(bit)
