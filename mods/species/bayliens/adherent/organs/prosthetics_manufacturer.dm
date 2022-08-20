/decl/bodytype/prosthetic/adherent
	name = "piezoelectric"
	desc = "A gleaming crystalline mass."
	icon = 'mods/species/bayliens/adherent/icons/body_turquoise.dmi'
	unavailable_at_chargen = TRUE
	can_eat = FALSE
	can_feel_pain = FALSE
	allowed_bodytypes = list(BODYTYPE_ADHERENT)
	modifier_string = "crystalline"
	is_robotic = FALSE

/decl/bodytype/prosthetic/adherent/get_base_icon(var/mob/living/carbon/human/owner)
	if(!istype(owner) || !istype(owner.bodytype, /decl/bodytype/adherent))
		return ..()
	return owner.bodytype.icon_base
