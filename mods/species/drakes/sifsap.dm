/proc/drake_spend_sap(mob/living/user, amount)
	var/obj/item/organ/internal/drake_gizzard/gizzard = user.get_organ(BP_DRAKE_GIZZARD)
	if(!gizzard?.sap_crop?.total_volume)
		return FALSE
	if(LAZYACCESS(gizzard.sap_crop.reagent_volumes, /decl/material/liquid/sifsap) < amount)
		return FALSE
	gizzard.sap_crop.remove_reagent(/decl/material/liquid/sifsap, amount)
	return TRUE

/proc/drake_has_sap(mob/living/user, amount)
	var/obj/item/organ/internal/drake_gizzard/gizzard = user.get_organ(BP_DRAKE_GIZZARD)
	return gizzard?.sap_crop?.total_volume >= amount

/proc/drake_add_sap(mob/living/user, amount)
	var/obj/item/organ/internal/drake_gizzard/gizzard = user.get_organ(BP_DRAKE_GIZZARD)
	if(!gizzard?.sap_crop?.maximum_volume)
		return FALSE
	if(LAZYACCESS(gizzard.sap_crop.reagent_volumes, /decl/material/liquid/sifsap) >= gizzard.sap_crop.maximum_volume)
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

/decl/material/liquid/sifsap/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)
	if(M.has_trait(/decl/trait/sivian_biochemistry))
		if(!drake_add_sap(M, removed))
			M.adjust_nutrition(toxicity * removed)
		return
	return affect_blood(M, removed * 0.7)

/decl/material/liquid/sifsap/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	if(M.has_trait(/decl/trait/sivian_biochemistry))
		return
	M.add_chemical_effect(CE_PULSE, -1)
	return ..()

/decl/material/liquid/sifsap/affect_overdose(mob/living/M, total_dose)
	if(M.has_trait(/decl/trait/sivian_biochemistry))
		return
	M.apply_damage(1, IRRADIATE)
	SET_STATUS_MAX(M, 5, STAT_DROWSY)
	return ..()
