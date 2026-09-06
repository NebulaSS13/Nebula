/proc/drake_spend_sap(mob/living/user, amount)
	var/obj/item/organ/internal/drake_gizzard/gizzard = user.get_organ(BP_DRAKE_GIZZARD)
	if(!REAGENT_TOTAL_VOLUME(gizzard?.sap_crop))
		return FALSE
	if(!gizzard.sap_crop.has_reagent(/decl/material/liquid/sifsap, amount))
		return FALSE
	gizzard.sap_crop.remove_reagent(/decl/material/liquid/sifsap, amount)
	return TRUE

/proc/drake_has_sap(mob/living/user, amount)
	var/obj/item/organ/internal/drake_gizzard/gizzard = user.get_organ(BP_DRAKE_GIZZARD)
	return REAGENT_TOTAL_VOLUME(gizzard?.sap_crop) >= amount

/proc/drake_add_sap(mob/living/user, amount)
	var/obj/item/organ/internal/drake_gizzard/gizzard = user.get_organ(BP_DRAKE_GIZZARD)
	var/max_volume = REAGENT_MAXIMUM_VOLUME(gizzard?.sap_crop)
	if(!max_volume)
		return FALSE
	if(REAGENT_VOLUME(gizzard.sap_crop, /decl/material/liquid/sifsap) >= max_volume)
		return FALSE
	gizzard.sap_crop.add_reagent(/decl/material/liquid/sifsap, amount)
	return TRUE

/decl/material/liquid/sifsap
	name = "sifsap"
	uid = "chem_liquid_sifsap"
	lore_text = "A natural slurry comprised of fluorescent bacteria native to Sif, in the Vir system."
	taste_description = "sour"
	overdose = 20
	ingest_met = REM
	toxicity = 2
	color = "#c6e2ff"
	affect_blood_on_ingest = 0.7

/decl/material/liquid/sifsap/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)
	if(M.has_trait(/decl/trait/sivian_biochemistry))
		if(!drake_add_sap(M, removed))
			M.adjust_nutrition(toxicity * removed)
		return
	. = ..()

/decl/material/liquid/sifsap/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	if(M.has_trait(/decl/trait/sivian_biochemistry))
		return
	M.add_chemical_effect(CE_PULSE, -1)
	return ..()

/decl/material/liquid/sifsap/affect_overdose(mob/living/victim, total_dose)
	if(victim.has_trait(/decl/trait/sivian_biochemistry))
		return
	victim.apply_damage(1, IRRADIATE)
	SET_STATUS_MAX(victim, 5, STAT_DROWSY)
	return ..()
