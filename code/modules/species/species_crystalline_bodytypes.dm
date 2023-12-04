/**
 * This is NOT to be used in place of ORGAN_PROP_CRYSTAL.
 * It doesn't handle crystalline logic, only setting up organs as crystalline
 * on their initial creation.
 **/
/decl/bodytype/crystalline
	abstract_type = /decl/bodytype/crystalline
	limb_tech = @'{"materials":4}'
	is_robotic = FALSE
	material = /decl/material/solid/gemstone/crystal
	body_flags = BODY_FLAG_CRYSTAL_REFORM | BODY_FLAG_NO_DNA | BODY_FLAG_NO_DEFIB | BODY_FLAG_NO_STASIS
	var/is_brittle

/decl/bodytype/crystalline/apply_bodytype_organ_modifications(obj/item/organ/org)
	. = ..()
	if(is_brittle)
		org.status |= ORGAN_BRITTLE
	BP_SET_CRYSTAL(org)
