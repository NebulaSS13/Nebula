/decl/material/solid/organic/wood/sif
	name = "sifwood"
	uid = "mat_wood_sif"
	color = "#0099cc"

/decl/material/solid/organic/wood/chipboard/sif
	name = "sifwood chipboard"
	adjective_name = "sifwood laminate"
	uid = "mat_chipboard_sif"
	color = "#0099cc"

/decl/material/solid/organic/plantmatter/grass/sif
	name  = "sifmoss"
	color = "#447171"
	uid = "mat_solid_sifmoss"
	dug_drop_type = /obj/item/stack/material/bundle

DEFINE_STACK_SUBTYPES(sif,           "sifwood",           solid/organic/wood/sif,       plank, null)
DEFINE_STACK_SUBTYPES(sif,           "sifwood",           solid/organic/wood/sif,       log,   null)
DEFINE_STACK_SUBTYPES(chipboard_sif, "sifwood chipboard", solid/organic/wood/chipboard, sheet, null)

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

/decl/material/liquid/sifsap/proc/sap_ingested(mob/living/subject, removed)
	return FALSE

/decl/material/liquid/sifsap/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)
	if(M.has_trait(/decl/trait/sivian_biochemistry))
		if(!sap_ingested(M, removed))
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
