/decl/species/grafadreka
	traits = list(
		/decl/trait/sivian_biochemistry = TRAIT_LEVEL_EXISTS
	)

/decl/species/grafadreka/should_poison_creature(mob/living/other)
	return !other?.has_trait(/decl/trait/sivian_biochemistry)

/decl/mob_modifier/drake_salve/check_failure_conditions(mob/living/owner, decl/mob_modifier/modifier)
	if((. = ..())) // We are dead or synthetic.
		return
	var/decl/species/grafadreka/drakes = IMPLIED_DECL
	if(drakes.should_poison_creature(owner))
		owner.take_damage(TOX, 1)

/decl/material/liquid/sifsap/sap_ingested(mob/living/subject, removed)
	return drake_add_spit(subject, removed)

/obj/item/backpack/drake_harness/explorer
	name = "\improper Exploration harness"
	paint_color = null
	desc = "A tough hard-wearing harness of synthetic material, emblazoned with Xenobiology colours. It's designed for some kind of quadrupedal animal."
	icon = 'mods/content/polaris/icons/clothing/drake_harness_explo.dmi'
	material = /decl/material/solid/organic/leather/synth
	material_alteration = MAT_FLAG_ALTERATION_NONE
