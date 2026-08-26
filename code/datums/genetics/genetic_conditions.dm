/decl/genetic_condition
	decl_flags = DECL_FLAG_MANDATORY_UID
	/// Descriptive name, used in VV panel.
	var/name
	/// Verb to be added or removed on activate/deactivate
	var/grant_verb
	/// Message shown when the gene is activated.
	var/activation_message
	/// Message shown when the gene is deactivated.
	var/deactivation_message
	/// State to use for underlays.
	var/underlay_state
	/// Icon to pull mob underlays from.
	var/underlay_icon   = 'icons/effects/genetics.dmi'
	/// Type that this gene can apply to.
	var/expected_type   = /mob/living/human
	/// Required return result from isSynthetic() for the gene to activate, if not null.
	var/check_synthetic = FALSE
	/// Set to FALSE if mob snapshots should not include this condition.
	var/is_heritable    = TRUE

/decl/genetic_condition/proc/activate_condition(mob/living/M)
	if(istype(M, expected_type) && M.can_have_genetic_conditions())
		if(!isnull(check_synthetic) && M.isSynthetic() != check_synthetic)
			return FALSE
		if(grant_verb)
			M.verbs |= grant_verb
		if(activation_message)
			to_chat(M, SPAN_NOTICE(activation_message))
		return TRUE
	return FALSE

/decl/genetic_condition/proc/deactivate_condition(mob/living/M)
	if(istype(M, expected_type) && M.can_have_genetic_conditions())
		if(!isnull(check_synthetic) && M.isSynthetic() != check_synthetic)
			return FALSE
		if(grant_verb)
			M.verbs -= grant_verb
		if(deactivation_message)
			to_chat(M, SPAN_NOTICE(deactivation_message))
		return TRUE
	return FALSE

/decl/genetic_condition/proc/get_mob_overlay()
	if(underlay_icon && underlay_state)
		return overlay_image(underlay_icon, underlay_state)

/decl/genetic_condition/superpower
	abstract_type = /decl/genetic_condition/superpower

/decl/genetic_condition/superpower/no_breath
	name               = "No Breathing"
	activation_message = "You feel no need to breathe."
	uid                = "genetic_condition_superpower_nobreath"

/decl/genetic_condition/superpower/remoteview
	name               = "Remote Viewing"
	grant_verb         = /mob/living/human/proc/remoteobserve
	activation_message = "Your mind expands."
	uid                = "genetic_condition_superpower_remoteview"

/decl/genetic_condition/superpower/running
	name               = "Super Speed"
	activation_message = "Your leg muscles pulsate."
	uid                = "genetic_condition_superpower_running"

/decl/genetic_condition/superpower/remotetalk
	name               = "Telepathy"
	grant_verb         = /mob/living/human/proc/remotesay
	activation_message = "You expand your mind outwards."
	uid                = "genetic_condition_superpower_remotetalk"

/decl/genetic_condition/superpower/cold_resist
	name               = "Cold Resistance"
	underlay_state     = "fire_s"
	activation_message = "Your body is filled with warmth."
	uid                = "genetic_condition_superpower_cold_resist"

/decl/genetic_condition/superpower/noprints
	name               = "No Prints"
	activation_message = "Your fingers feel numb."
	uid                = "genetic_condition_superpower_noprints"

/decl/genetic_condition/superpower/xray
	name               = "X-Ray Vision"
	activation_message = "The walls suddenly disappear."
	uid                = "genetic_condition_superpower_xray"

/decl/genetic_condition/superpower/space_resist
	name               = "Space Resistance"
	activation_message = "Your skin feels strange."
	uid                = "genetic_condition_superpower_spaceresist"

/decl/genetic_condition/disability
	abstract_type      = /decl/genetic_condition/disability

/decl/genetic_condition/disability/clumsy
	name               = "Clumsy"
	uid                = "genetic_condition_disability_clumsy"

/decl/genetic_condition/disability/nearsighted
	name               = "Nearsighted"
	uid                = "genetic_condition_disability_nearsighted"

/decl/genetic_condition/disability/epilepsy
	name               = "Epilepsy"
	uid                = "genetic_condition_disability_epilepsy"

/decl/genetic_condition/disability/coughing
	name               = "Coughing"
	uid                = "genetic_condition_disability_coughing"

/decl/genetic_condition/disability/tourettes
	name               = "Tourettes"
	uid                = "genetic_condition_disability_tourettes"

/decl/genetic_condition/disability/nervous
	name               = "Nervous"
	uid                = "genetic_condition_disability_nervous"

/decl/genetic_condition/disability/blinded
	name               = "Blinded"
	check_synthetic    = null
	uid                = "genetic_condition_disability_blinded"

/decl/genetic_condition/disability/muted
	name               = "Mute"
	check_synthetic    = null
	uid                = "genetic_condition_disability_mute"

/decl/genetic_condition/disability/deafened
	name               = "Deafened"
	check_synthetic    = null
	uid                = "genetic_condition_disability_deafened"

/decl/genetic_condition/husk
	name               = "Husk"
	uid                = "genetic_condition_husk"

/decl/genetic_condition/husk/activate_condition(mob/living/M)
	. = ..()
	if(.)
		SET_FACIAL_HAIR_STYLE(M, /decl/sprite_accessory/facial_hair/shaved, TRUE)
		SET_HAIR_STYLE(M, /decl/sprite_accessory/hair/bald, TRUE)
		for(var/obj/item/organ/external/E in M.get_external_organs())
			E.status |= ORGAN_DISFIGURED
		M.update_body(TRUE)