/decl/prosthetics_manufacturer
	var/name = "Unbranded"                                 // Shown when selecting the limb.
	var/desc = "A generic unbranded robotic prosthesis."      // Seen when examining a limb.
	var/icon = 'icons/mob/human_races/cyberlimbs/robotic.dmi' // Icon base to draw from.
	var/unavailable_at_chargen                                // If set, not available at chargen.
	var/can_eat
	var/has_eyes = TRUE
	var/can_feel_pain
	var/skintone
	var/limb_blend
	var/list/bodytypes_cannot_use = list()
	var/list/species_restricted
	var/list/applies_to_part
	var/list/allowed_bodytypes = list(BODYTYPE_HUMANOID)
	var/modifier_string = "robotic"
	var/hardiness = 1
	var/manual_dexterity = DEXTERITY_FULL
	var/movement_slowdown = 0
	var/is_robotic = TRUE

/decl/prosthetics_manufacturer/proc/check_can_install(var/target_slot, var/target_bodytype, var/target_species)
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

/decl/prosthetics_manufacturer/wooden
	name = "wooden prosthesis"
	desc = "A crude wooden prosthetic."
	icon = 'icons/mob/human_races/cyberlimbs/morgan/morgan_main.dmi'
	modifier_string = "wooden"
	hardiness = 0.75
	manual_dexterity = DEXTERITY_SIMPLE_MACHINES
	movement_slowdown = 1
	is_robotic = FALSE
