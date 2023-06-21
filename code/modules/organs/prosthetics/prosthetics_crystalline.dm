/**
 * This is NOT to be used in place of ORGAN_PROP_CRYSTAL.
 * It doesn't handle crystalline logic, only setting up organs as crystalline
 * on their initial creation.
 **/
/decl/bodytype/prosthetic/crystalline
	abstract_type = /decl/bodytype/prosthetic/crystalline
	limb_tech = "{'materials':4}"
	is_robotic = FALSE
	modifier_string = null // i think this is handled elsewhere?
	material = /decl/material/solid/gemstone/crystal
	body_flags = BODY_FLAG_CRYSTAL_REFORM | BODY_FLAG_NO_DNA
	var/is_brittle

/decl/bodytype/prosthetic/crystalline/apply_bodytype_organ_modifications(obj/item/organ/org)
	. = ..()
	if(is_brittle)
		org.status |= ORGAN_BRITTLE
	org.organ_properties |= ORGAN_PROP_CRYSTAL
