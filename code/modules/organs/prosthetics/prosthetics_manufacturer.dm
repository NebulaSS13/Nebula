/decl/bodytype/prosthetic
	name = "Unbranded"                                            // Shown when selecting the limb.
	icon_base = 'icons/mob/human_races/cyberlimbs/robotic.dmi'    // Icon base to draw from.

	var/unavailable_at_chargen                                    // If set, not available at chargen.
	var/can_eat                                                   // Determines if heads with this model can ingest food/drink.
	var/can_feel_pain                                             // Modifies the return from human can_feel_pain().

	var/list/bodytypes_cannot_use                                 // Blacklists bodytypes from using this limb.
	var/list/species_restricted                                   // Determines which species can use this limb.
	var/list/applies_to_part                                      // Determines which bodyparts can use this limb.
	var/list/allowed_bodytypes = list(BODYTYPE_HUMANOID)          // Determines which bodytypes can apply the limb.
	var/modifier_string = "robotic"                               // Used to alter the name of the limb.
	var/hardiness = 1                                             // Modifies min and max broken damage for the limb.
	var/movement_slowdown = 0                                     // Applies a slowdown value to this limb.
	var/is_robotic = TRUE                                         // Determines if EMP damage is applied to this prosthetic.
	var/modular_prosthetic_tier = MODULAR_BODYPART_INVALID        // Determines how the limb behaves as a prosthetic with regards to manual attachment/detachment.
	var/limb_tech = "{'engineering':1,'materials':1,'magnets':1}" // What tech levels should limbs of this type use/need?

/decl/bodytype/prosthetic/proc/check_can_install(var/target_slot, var/target_bodytype, var/target_species)
	. = istext(target_slot)
	if(.)
		if(islist(applies_to_part) && !(target_slot in applies_to_part))
			return FALSE
		if(target_bodytype)
			if(islist(allowed_bodytypes) && !(target_bodytype in allowed_bodytypes))
				return FALSE
			if(islist(bodytypes_cannot_use) && (target_bodytype in bodytypes_cannot_use))
				return FALSE
		if(target_species && islist(species_restricted) && !(target_species in species_restricted))
			return FALSE
