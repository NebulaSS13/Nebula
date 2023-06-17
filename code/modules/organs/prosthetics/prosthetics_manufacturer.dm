/decl/bodytype/prosthetic
	abstract_type = /decl/bodytype/prosthetic
	icon_base = 'icons/mob/human_races/cyberlimbs/robotic.dmi'
	desc = "A generic unbranded robotic prosthesis."
	limb_tech = "{'engineering':1,'materials':1,'magnets':1}"
	modifier_string = "robotic"
	can_eat = FALSE
	is_robotic = TRUE
	can_feel_pain = FALSE
	/// Determines which bodyparts can use this limb.
	var/list/applies_to_part

/**
 * Used to check if a prosthetic bodytype can be installed with a certain base bodytype/for a certain organ slot.
 * Parameters: var/target_slot
 * Parameters: var/target_bodytype - the bodytype_category we're checking
 */
/decl/bodytype/prosthetic/proc/check_can_install(target_slot, target_bodytype)
	. = istext(target_slot)
	if(.)
		if(islist(applies_to_part) && !(target_slot in applies_to_part))
			return FALSE
		if(target_bodytype && bodytype_category != target_bodytype)
			return FALSE
