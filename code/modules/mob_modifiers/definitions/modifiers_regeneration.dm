/decl/mob_modifier/regeneration
	name                 = "Regeneration"
	desc                 = "You are rapidly recovering from physical trauma and poisons."
	hud_icon_state       = "regeneration"
	can_be_admin_granted = TRUE

	var/brute_mult = 1
	var/fire_mult  = 1
	var/tox_mult   = 1

/decl/mob_modifier/regeneration/on_modifier_datum_mob_life(mob/living/_owner, list/modifiers)
	. = ..()
	_owner.heal_damage(BRUTE, brute_mult, do_update_health = FALSE)
	_owner.heal_damage(BURN, fire_mult, do_update_health = FALSE)
	_owner.heal_damage(TOX, tox_mult)

/decl/mob_modifier/regeneration/organ
	name                        = "Organ Regeneration"
	desc                        = "Your body is rapidly recovering from physical trauma and poisons, so long as you can feed it."
	var/nutrition_damage_mult   = 1 //How much nutrition it takes to heal regular damage
	var/external_nutrition_mult = 50 // How much nutrition it takes to regrow a limb
	var/organ_mult              = 2
	var/regen_message           = SPAN_WARNING("Your body throbs as you feel your ORGAN regenerate.")
	var/grow_chance             = 15
	var/grow_threshold          = 200
	var/ignore_tag              = BP_BRAIN //organ tag to ignore
	var/last_nutrition_warning  = 0
	var/innate_heal             = TRUE // Whether the aura is on, basically.

/decl/mob_modifier/regeneration/organ/proc/external_regeneration_effect(mob/living/_owner, obj/item/organ/external/limb)
	return

/decl/mob_modifier/regeneration/organ/on_modifier_datum_mob_life(mob/living/_owner, list/modifiers)
	. = ..()
	if(!length(_owner.get_external_organs()))
		return
	if(!innate_heal || _owner.has_mob_modifier(/decl/mob_modifier/stasis) || _owner.stat == DEAD)
		return
	if(_owner.get_nutrition() < nutrition_damage_mult)
		low_nut_warning(_owner)
		return

	var/update_health = FALSE
	var/organ_regen = get_config_value(/decl/config/num/health_organ_regeneration_multiplier)
	if(brute_mult && _owner.get_damage(BRUTE))
		update_health = TRUE
		_owner.heal_damage(BRUTE, brute_mult * organ_regen, do_update_health = FALSE)
		_owner.adjust_nutrition(-nutrition_damage_mult)
	if(fire_mult && _owner.get_damage(BURN))
		update_health = TRUE
		_owner.heal_damage(BURN, fire_mult * organ_regen, do_update_health = FALSE)
		_owner.adjust_nutrition(-nutrition_damage_mult)
	if(tox_mult && _owner.get_damage(TOX))
		update_health = TRUE
		_owner.heal_damage(TOX, tox_mult * organ_regen, do_update_health = FALSE)
		_owner.adjust_nutrition(-nutrition_damage_mult)
	if(update_health)
		_owner.update_health()
	if(!can_regenerate_organs())
		return
	if(organ_mult)
		if(prob(10) && _owner.nutrition >= 150 && !_owner.get_damage(BRUTE) && !_owner.get_damage(BURN))
			var/obj/item/organ/external/D = GET_EXTERNAL_ORGAN(_owner, BP_HEAD)
			if (D.status & ORGAN_DISFIGURED)
				if (_owner.nutrition >= 20)
					D.status &= ~ORGAN_DISFIGURED
					_owner.adjust_nutrition(-20)
				else
					low_nut_warning(_owner, BP_HEAD)

		var/list/organs = _owner.get_internal_organs()
		for(var/obj/item/organ/internal/regen_organ in shuffle(organs.Copy()))
			if(BP_IS_PROSTHETIC(regen_organ) || regen_organ.organ_tag == ignore_tag)
				continue
			if(istype(regen_organ))
				if(regen_organ.get_organ_damage() > 0 && !(regen_organ.status & ORGAN_DEAD))
					if (_owner.nutrition >= organ_mult)
						regen_organ.adjust_organ_damage(-(organ_mult))
						_owner.adjust_nutrition(-(organ_mult))
						if(prob(5))
							to_chat(_owner, replacetext(regen_message,"ORGAN", regen_organ.name))
					else
						low_nut_warning(_owner, regen_organ.name)

	if(prob(grow_chance))
		var/decl/bodytype/root_bodytype = _owner.get_bodytype()
		for(var/limb_type in root_bodytype.has_limbs)
			var/obj/item/organ/external/limb = GET_EXTERNAL_ORGAN(_owner, limb_type)
			if(limb && limb.organ_tag != BP_HEAD && !limb.is_vital_to_owner() && !limb.is_usable())	//Skips heads and vital bits...
				if (_owner.nutrition > grow_threshold)
					_owner.remove_organ(limb) 		//...because no one wants their head to explode to make way for a new one.
					qdel(limb)
					limb = null
				else
					low_nut_warning(_owner, limb.name)
			if(!limb)
				var/list/organ_data = root_bodytype.has_limbs[limb_type]
				var/limb_path = organ_data["path"]
				limb = new limb_path(_owner)
				_owner.add_organ(limb, GET_EXTERNAL_ORGAN(_owner, limb.parent_organ), FALSE, FALSE)
				_owner.adjust_nutrition(-external_nutrition_mult)
				external_regeneration_effect(_owner, limb)
				return
			else if (_owner.nutrition > grow_threshold) //We don't subtract any nut here, but let's still only heal wounds when we have nut.
				for(var/datum/wound/wound in limb.wounds)
					if(wound.wound_damage() == 0 && prob(50))
						qdel(wound)

/decl/mob_modifier/regeneration/organ/proc/low_nut_warning(mob/living/_owner, var/wound_type)
	if (last_nutrition_warning + 1 MINUTE < world.time)
		to_chat(_owner, SPAN_WARNING("You need more energy to regenerate your [wound_type || "wounds"]."))
		last_nutrition_warning = world.time
		return TRUE
	return FALSE

/decl/mob_modifier/regeneration/organ/proc/can_regenerate_organs()
	return TRUE

// Distinct type to avoid removing the wrong type on unwield.
/decl/mob_modifier/regeneration/item
	name                 = "Regenerative Aura"
	desc                 = "An item is helping your body heal physical damage and toxins."
	can_be_admin_granted = FALSE