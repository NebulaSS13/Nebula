/decl/species/grafadreka
	traits = list(
		/decl/trait/sivian_biochemistry = TRAIT_LEVEL_EXISTS
	)

/decl/species/grafadreka/should_poison_creature(mob/living/other)
	return !other?.has_trait(/decl/trait/sivian_biochemistry)

/decl/species/grafadreka/treat_organ(obj/item/organ/external/limb)
	if(!(. = ..()))
		return
	var/datum/reagents/bloodstream = limb.owner?.get_injected_reagents()
	bloodstream?.add_reagent(/decl/material/liquid/sifsap, rand(1,2))

/decl/mob_modifier/drake_salve/check_failure_conditions(mob/living/owner, decl/mob_modifier/modifier)
	if((. = ..())) // We are dead or synthetic.
		return
	var/decl/species/grafadreka/drakes = IMPLIED_DECL
	if(drakes.should_poison_creature(owner))
		owner.take_damage(TOX, 1)

/obj/item/organ/internal/drake_gizzard
	var/datum/reagents/sap_crop

/obj/item/organ/internal/drake_gizzard/Initialize()
	sap_crop = new(60, src)
	. = ..()

/obj/item/organ/internal/drake_gizzard/Destroy()
	QDEL_NULL(sap_crop)
	. = ..()

/obj/item/organ/internal/drake_gizzard/add_charge(amount)
	sap_crop.add_reagent(/decl/material/liquid/sifsap, amount)
	stored_sap = REAGENT_TOTAL_VOLUME(sap_crop)

/obj/item/organ/internal/drake_gizzard/spend_charge(amount)
	if(!sap_crop.has_reagent(/decl/material/liquid/sifsap, amount))
		return FALSE
	sap_crop.remove_reagent(/decl/material/liquid/sifsap, amount)
	stored_sap = REAGENT_TOTAL_VOLUME(sap_crop)
	return TRUE

/obj/item/organ/internal/drake_gizzard/Process()
	. = ..()
	stored_sap = REAGENT_TOTAL_VOLUME(sap_crop)

/obj/item/organ/internal/drake_gizzard/do_uninstall(in_place, detach, ignore_children, update_icon)
	. = ..()
	if(stored_sap)
		if(reagents)
			sap_crop.trans_to_holder(reagents, stored_sap)
		else if(isatom(loc))
			sap_crop.splash(loc, stored_sap)
		sap_crop.clear_reagents()

/decl/material/liquid/sifsap/sap_ingested(mob/living/subject, removed)
	return drake_add_sap(subject, removed)

/obj/item/projectile/drake_spit
	material = /decl/material/liquid/sifsap
