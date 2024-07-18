/****************************************************
			   DAMAGE PROCS
****************************************************/

/obj/item/organ/external/proc/is_damageable(var/additional_damage = 0)
	//Continued damage to vital organs can kill you, and robot organs don't count towards total damage so no need to cap them.
	return (BP_IS_PROSTHETIC(src) || brute_dam + burn_dam + additional_damage < max_damage * 4)

/obj/item/organ/external/take_general_damage(var/amount, var/silent = FALSE)
	take_external_damage(amount)

/obj/item/organ/external/proc/take_external_damage(brute, burn, damage_flags, used_weapon, override_droplimb)

	if(!owner)
		return

	brute = round(brute * get_brute_mod(damage_flags), 0.1)
	burn = round(burn * get_burn_mod(damage_flags), 0.1)

	if((brute <= 0) && (burn <= 0))
		return 0

	var/sharp = (damage_flags & DAM_SHARP)
	var/edge  = (damage_flags & DAM_EDGE)
	var/laser = (damage_flags & DAM_LASER)
	var/blunt = !!(brute && !sharp && !edge)

	// Handle some status-based damage multipliers.
	if(BP_IS_CRYSTAL(src) && burn && laser)
		brute += burn // Stress fracturing from heat!
		owner.bodytemperature += burn
		burn = 0
		if(prob(25))
			owner.visible_message(SPAN_WARNING("\The [owner]'s crystalline [name] shines with absorbed energy!"))

	if(used_weapon)
		add_autopsy_data(used_weapon, brute + burn)

	var/spillover = 0
	var/pure_brute = brute
	if(!is_damageable(brute + burn))
		spillover =  brute_dam + burn_dam + brute - max_damage
		if(spillover > 0)
			brute = max(brute - spillover, 0)
		else
			spillover = brute_dam + burn_dam + brute + burn - max_damage
			if(spillover > 0)
				burn = max(burn - spillover, 0)

	//If limb took enough damage, try to cut or tear it off
	if(owner && loc == owner)
		owner.update_health() //droplimb will call update_health() again if it does end up being called
		if((limb_flags & ORGAN_FLAG_CAN_AMPUTATE) && get_config_value(/decl/config/toggle/on/health_limbs_can_break))
			var/total_damage = brute_dam + burn_dam + brute + burn + spillover
			var/threshold = max_damage * get_config_value(/decl/config/num/health_organ_health_multiplier)
			if(total_damage > threshold)
				if(attempt_dismemberment(pure_brute, burn, sharp, edge, used_weapon, spillover, total_damage > threshold*6, override_droplimb = override_droplimb))
					return

	//blunt damage is gud at fracturing
	if(brute_dam + brute > min_broken_damage && prob(brute_dam + brute * (1+blunt)) )
		fracture()

	// High brute damage or sharp objects may damage internal organs
	if(LAZYLEN(internal_organs) && damage_internal_organs(brute, burn, damage_flags))
		brute /= 2
		burn  /= 2

	if((status & ORGAN_BROKEN) && brute)
		jostle_bone(brute)
		if(can_feel_pain() && prob(40))
			owner.emote(/decl/emote/audible/scream)	//getting hit on broken hand hurts

	// If the limbs can break, make sure we don't exceed the maximum damage a limb can take before breaking
	var/datum/wound/created_wound
	var/block_cut = (species.species_flags & SPECIES_FLAG_NO_MINOR_CUT) && brute <= 15
	var/can_cut = !block_cut && !BP_IS_PROSTHETIC(src) && (sharp || prob(brute))

	if(brute)
		var/to_create = BRUISE
		if(can_cut)
			to_create = CUT
			//need to check sharp again here so that blunt damage that was strong enough to break skin doesn't give puncture wounds
			if(sharp && !edge)
				to_create = PIERCE
		created_wound = createwound(to_create, brute)

	if(burn)
		if(laser)
			created_wound = createwound(LASER, burn)
			if(prob(40))
				owner.IgniteMob()
		else
			created_wound = createwound(BURN, burn)

	//Initial pain spike
	add_pain(0.6*burn + 0.4*brute)

	//Disturb treated burns
	if(brute > 5)
		var/disturbed = 0
		for(var/datum/wound/burn/W in wounds)
			if((W.disinfected || W.salved) && prob(brute + W.damage))
				W.disinfected = 0
				W.salved = 0
				disturbed += W.damage
		if(disturbed)
			to_chat(owner,"<span class='warning'>Ow! Your burns were disturbed.</span>")
			add_pain(0.5*disturbed)

	//If there are still hurties to dispense
	if (spillover)
		owner.shock_stage += spillover * get_config_value(/decl/config/num/health_organ_damage_spillover_multiplier)

	// sync the organ's damage with its wounds
	update_damages()
	owner.update_health()
	if(status & ORGAN_BLEEDING)
		owner.update_bandages()

	if(owner && update_damstate())
		owner.update_damage_overlays()

	if(created_wound && isobj(used_weapon))
		var/obj/O = used_weapon
		O.after_wounding(src, created_wound)

	return created_wound

/obj/item/organ/external/proc/damage_internal_organs(brute, burn, damage_flags)
	if(!LAZYLEN(internal_organs))
		return FALSE

	var/laser = (damage_flags & DAM_LASER)

	var/damage_amt = brute
	var/cur_damage = brute_dam
	if(laser || BP_IS_PROSTHETIC(src))
		damage_amt += burn
		cur_damage += burn_dam

	if(!damage_amt)
		return FALSE

	var/organ_damage_threshold = 10
	if(damage_flags & DAM_SHARP)
		organ_damage_threshold *= 0.5
	if(laser)
		organ_damage_threshold *= 2

	if(!(cur_damage + damage_amt >= max_damage) && !(damage_amt >= organ_damage_threshold))
		return FALSE

	var/list/victims = list()
	var/organ_hit_chance = 0
	for(var/obj/item/organ/internal/I in internal_organs)
		if(I.damage < I.max_damage)
			victims[I] = I.relative_size
			organ_hit_chance += I.relative_size

	//No damageable organs
	if(!length(victims))
		return FALSE

	organ_hit_chance += 5 * damage_amt/organ_damage_threshold

	if(encased && !(status & ORGAN_BROKEN)) //ribs protect
		organ_hit_chance *= 0.6

	organ_hit_chance = min(organ_hit_chance, 100)
	if(prob(organ_hit_chance))
		var/obj/item/organ/internal/victim = pickweight(victims)
		damage_amt -= max(damage_amt*victim.damage_reduction, 0)
		victim.take_internal_damage(damage_amt)
		return TRUE

/obj/item/organ/external/heal_damage(brute, burn, internal = 0, robo_repair = 0)
	if(BP_IS_PROSTHETIC(src) && !robo_repair)
		return

	//Heal damage on the individual wounds
	for(var/datum/wound/W in wounds)
		if(brute == 0 && burn == 0)
			break

		// heal brute damage
		if(W.damage_type == BURN)
			burn = W.heal_damage(burn)
		else
			brute = W.heal_damage(brute)

	if(internal)
		status &= ~ORGAN_BROKEN

	//Sync the organ's damage with its wounds
	update_damages()
	owner.update_health()

	return update_damstate()

// Geneloss/cloneloss.
/obj/item/organ/external/proc/get_genetic_damage()
	if(!bodytype || (bodytype.body_flags & BODY_FLAG_NO_DNA))
		return 0
	if(BP_IS_PROSTHETIC(src))
		return 0
	return genetic_degradation

/obj/item/organ/external/proc/remove_genetic_damage(var/amount)
	if(bodytype.body_flags & BODY_FLAG_NO_DNA)
		genetic_degradation = 0
		status &= ~ORGAN_MUTATED
		return
	var/last_gene_dam = genetic_degradation
	genetic_degradation = min(100,max(0,genetic_degradation - amount))
	if(genetic_degradation <= 30)
		if(status & ORGAN_MUTATED)
			unmutate()
			to_chat(src, "<span class = 'notice'>Your [name] is shaped normally again.</span>")
	return -(genetic_degradation - last_gene_dam)

/obj/item/organ/external/proc/add_genetic_damage(var/amount)
	if(bodytype.body_flags & BODY_FLAG_NO_DNA)
		genetic_degradation = 0
		status &= ~ORGAN_MUTATED
		return
	var/last_gene_dam = genetic_degradation
	genetic_degradation = min(100,max(0,genetic_degradation + amount))
	if(genetic_degradation > 30)
		if(!(status & ORGAN_MUTATED) && prob(genetic_degradation))
			mutate()
			to_chat(owner, "<span class = 'notice'>Something is not right with your [name]...</span>")
	return (genetic_degradation - last_gene_dam)

/obj/item/organ/external/proc/mutate()
	if(BP_IS_PROSTHETIC(src))
		return
	src.status |= ORGAN_MUTATED
	if(owner) owner.update_body()

/obj/item/organ/external/proc/unmutate()
	if(!BP_IS_DEFORMED(src) && !BP_IS_PROSTHETIC(src))
		src.status &= ~ORGAN_MUTATED
		if(owner) owner.update_body()

// Pain/halloss
/obj/item/organ/external/proc/get_pain()
	if(!can_feel_pain())
		return 0
	var/lasting_pain = 0
	if(is_broken())
		lasting_pain += 10
	else if(is_dislocated())
		lasting_pain += 5
	var/tox_dam = 0
	for(var/obj/item/organ/internal/I in internal_organs)
		tox_dam += I.getToxLoss()
	return pain + lasting_pain + 0.7 * brute_dam + 0.8 * burn_dam + 0.3 * tox_dam + 0.5 * get_genetic_damage()

/obj/item/organ/external/proc/remove_pain(var/amount)
	if(!can_feel_pain())
		pain = 0
		return
	var/last_pain = pain
	pain = max(0,min(max_damage,pain-amount))
	return -(pain-last_pain)

/obj/item/organ/external/proc/add_pain(var/amount)
	if(!can_feel_pain())
		pain = 0
		return
	var/last_pain = pain
	if(owner)
		amount -= (GET_CHEMICAL_EFFECT(owner, CE_PAINKILLER)/3)
		if(amount <= 0)
			return
	pain = max(0,min(max_damage,pain+amount))
	if(owner && ((amount > 15 && prob(20)) || (amount > 30 && prob(60))))
		owner.emote(/decl/emote/audible/scream)
	return pain-last_pain

/obj/item/organ/external/proc/stun_act(var/stun_amount, var/agony_amount)
	if(agony_amount && owner && can_feel_pain())
		agony_amount -= (GET_CHEMICAL_EFFECT(owner, CE_PAINKILLER)/2)//painkillers does wonders!
		agony_amount += get_pain()
		if(agony_amount < 5)
			return

		if(check_pain_disarm())
			return TRUE

		if(limb_flags & ORGAN_FLAG_CAN_STAND)
			if(prob((agony_amount/max_damage)*100))
				owner.stance_damage_prone(src)
				return TRUE

		else if(agony_amount > 0.5 * max_damage)
			owner.visible_message(SPAN_WARNING("\The [owner] reels in pain!"))
			if(has_genitals() || agony_amount > max_damage)
				SET_STATUS_MAX(owner, STAT_WEAK, 4)
			else
				SET_STATUS_MAX(owner, STAT_STUN, 4)
			return 1

/obj/item/organ/external/proc/get_agony_multiplier()
	return has_genitals() ? 2 : 1

/obj/item/organ/external/proc/sever_artery()
	var/obj/item/organ/internal/heart/heart_path = bodytype?.has_organ[BP_HEART]
	if(heart_path)
		if(!BP_IS_PROSTHETIC(src) && !(limb_flags & ORGAN_FLAG_SKELETAL) && !(status & ORGAN_ARTERY_CUT) && !initial(heart_path.open))
			status |= ORGAN_ARTERY_CUT
			return TRUE
	return FALSE

/obj/item/organ/external/proc/sever_tendon()
	if((limb_flags & ORGAN_FLAG_HAS_TENDON) && !BP_IS_PROSTHETIC(src) && !(limb_flags & ORGAN_FLAG_SKELETAL) && !(status & ORGAN_TENDON_CUT))
		status |= ORGAN_TENDON_CUT
		return TRUE
	return FALSE

/obj/item/organ/external/proc/get_brute_mod(var/damage_flags)
	var/obj/item/organ/internal/augment/armor/A = owner?.get_organ(BP_AUGMENT_CHEST_ARMOUR, /obj/item/organ/internal/augment/armor)
	var/B = 1
	if(A)
		B = A.brute_mult
	if(!BP_IS_PROSTHETIC(src))
		B *= species.get_brute_mod(owner)
	var/blunt = !(damage_flags & DAM_EDGE|DAM_SHARP)
	if(blunt && BP_IS_BRITTLE(src))
		B *= 1.5
	if(BP_IS_CRYSTAL(src))
		B *= 0.8
	return B + (0.2 * burn_dam/max_damage) //burns make you take more brute damage

/obj/item/organ/external/proc/get_burn_mod(var/damage_flags)
	var/obj/item/organ/internal/augment/armor/A = owner?.get_organ(BP_AUGMENT_CHEST_ARMOUR, /obj/item/organ/internal/augment/armor)
	var/B = 1
	if(A)
		B = A.burn_mult
	if(!BP_IS_PROSTHETIC(src))
		B *= species.get_burn_mod(owner)
	if(BP_IS_CRYSTAL(src))
		B *= 0.1
	return B

//organs can come off in three cases
//1. If the damage source is edge_eligible and the brute damage dealt exceeds the edge threshold, then the organ is cut off.
//2. If the damage amount dealt exceeds the disintegrate threshold, the organ is completely obliterated.
//3. If the organ has already reached or would be put over it's max damage amount (currently redundant),
//   and the brute damage dealt exceeds the tearoff threshold, the organ is torn off.
/obj/item/organ/external/proc/attempt_dismemberment(brute, burn, sharp, edge, used_weapon, spillover, force_droplimb, override_droplimb)
	//Check edge eligibility
	var/edge_eligible = FALSE
	if(edge)
		// used_weapon can be a string sometimes, for some reason
		// todo: refactor to avoid?
		if(istype(used_weapon,/obj/item))
			var/obj/item/used_item = used_weapon
			if(used_item.w_class >= w_class)
				edge_eligible = TRUE
		else
			edge_eligible = TRUE
	else if(sharp)
		brute = 0.5 * brute
	if(force_droplimb)
		if(burn)
			dismember(FALSE, (override_droplimb || DISMEMBER_METHOD_BURN))
		else if(brute)
			dismember(FALSE, (override_droplimb || (edge_eligible ? DISMEMBER_METHOD_EDGE : DISMEMBER_METHOD_BLUNT)))
		return TRUE

	if(edge_eligible && brute >= max_damage / DROPLIMB_THRESHOLD_EDGE)
		if(prob(brute))
			dismember(FALSE, (override_droplimb || DISMEMBER_METHOD_EDGE))
			return TRUE
	else if(burn >= max_damage / DROPLIMB_THRESHOLD_DESTROY)
		if(prob(burn/3))
			dismember(FALSE, (override_droplimb || DISMEMBER_METHOD_BURN))
			return TRUE
	else if(brute >= max_damage / DROPLIMB_THRESHOLD_DESTROY)
		if(prob(brute))
			dismember(FALSE, (override_droplimb || DISMEMBER_METHOD_BLUNT))
			return TRUE
	else if(brute >= max_damage / DROPLIMB_THRESHOLD_TEAROFF)
		if(prob(brute/3))
			dismember(FALSE, (override_droplimb || DISMEMBER_METHOD_EDGE))
			return TRUE
