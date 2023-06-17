/decl/bodytype/prosthetic
	abstract_type = /decl/bodytype/prosthetic
	icon_base = 'icons/mob/human_races/cyberlimbs/robotic.dmi'
	/// Seen when examining a limb.
	var/desc = "A generic unbranded robotic prosthesis."
	/// Determines if eyes should render on heads using this model.
	var/has_eyes = TRUE
	/// Modifies the return from human can_feel_pain().
	var/can_feel_pain
	/// Determines if human skintone should be applied to this limb.
	var/skintone
	/// Determines which bodyparts can use this limb.
	var/list/applies_to_part
	/// Used to alter the name of the limb.
	var/modifier_string = "robotic"
	/// Modifies min and max broken damage for the limb.
	var/hardiness = 1
	/// For hands, determines the dexterity value passed to get_manual_dexterity().
	var/manual_dexterity = DEXTERITY_FULL
	/// Applies a slowdown value to this limb.
	var/movement_slowdown = 0
	/// Determines if this prosthetic can be repaired by nanopaste, sparks when damaged, can malfunction, and can take EMP damage.
	var/is_robotic = TRUE
	/// Determines how the limb behaves as a prosthetic with regards to manual attachment/detachment.
	var/modular_prosthetic_tier = MODULAR_BODYPART_INVALID
	/// What tech levels should limbs of this type use/need?
	var/limb_tech = "{'engineering':1,'materials':1,'magnets':1}"
	/// Determines if heads with this model can ingest food/drink.
	var/can_eat

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
