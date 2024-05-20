/decl/configuration_category/health
	name = "Health"
	desc = "Configuration options relating to the health simulation."
	associated_configuration = list(
		/decl/config/num/health_stress_shock_recovery_constant,
		/decl/config/num/health_stress_healing_recovery_constant,
		/decl/config/num/health_stress_blood_recovery_constant,
		/decl/config/num/health_health_threshold_dead,
		/decl/config/num/health_organ_health_multiplier,
		/decl/config/num/health_organ_regeneration_multiplier,
		/decl/config/num/health_organ_damage_spillover_multiplier,
		/decl/config/num/health_revival_brain_life,
		/decl/config/toggle/on/health_bones_can_break,
		/decl/config/toggle/on/health_limbs_can_break
	)

/decl/config/toggle/health_adjust_healing_from_stress
	uid = "adjust_healing_from_stress"
	config_flags = CONFIG_FLAG_BOOL
	desc = "Determines if allow stressors should impact shock, healing and blood recovery."

/decl/config/toggle/health_show_human_death_message
	uid = "show_human_death_message"
	config_flags = CONFIG_FLAG_BOOL
	desc = "Determines if humans should show a visible message upon death ('X seizes up then falls limp, eyes dead and lifeless')."

/decl/config/toggle/health_organs_decay
	uid = "organs_decay"
	config_flags = CONFIG_FLAG_BOOL
	desc = "Determines if organs should decay outside of a body or storage item."

/decl/config/toggle/on/health_bones_can_break
	uid = "bones_can_break"
	desc = list(
		"Determines whether bones can be broken through excessive damage to the organ.",
		"0 means bones can't break, 1 means they can."
	)

/decl/config/toggle/on/health_limbs_can_break
	uid = "limbs_can_break"
	desc = list(
		"Determines whether limbs can be amputated through excessive damage to the organ.",
		"0 means limbs can't be amputated, 1 means they can."
	)


/decl/config/num/health_stress_shock_recovery_constant
	uid = "stress_shock_recovery_constant"
	default_value = 0.5
	rounding = 0.01
	desc = "A multiplier for the impact stress has on shock recovery - 0.3 means maximum stress imposes a 30% penalty on shock recovery."

/decl/config/num/health_stress_healing_recovery_constant
	uid = "stress_healing_recovery_constant"
	default_value = 0.3
	rounding = 0.01
	desc = "A multiplier for the impact stress has on wound passive healing, as above."

/decl/config/num/health_stress_blood_recovery_constant
	uid = "stress_blood_recovery_constant"
	default_value = 0.3
	rounding = 0.01
	desc = "A multiplier for the impact stress has on blood regeneration, as above."

/decl/config/num/health_health_threshold_dead
	uid = "health_threshold_dead"
	default_value = -100
	desc = "Level of health at which a mob becomes dead."

/decl/config/num/health_organ_health_multiplier
	uid = "organ_health_multiplier"
	default_value = 0.9
	rounding = 0.01
	desc = "Percentage multiplier which enables organs to take more damage before bones breaking or limbs being destroyed."

/decl/config/num/health_organ_regeneration_multiplier
	uid = "organ_regeneration_multiplier"
	default_value = 0.25
	desc = "Percentage multiplier which influences how fast organs regenerate naturally."

/decl/config/num/health_organ_damage_spillover_multiplier
	uid = "organ_damage_spillover_multiplier"
	desc = "Percentage multiplier that influences how damage spreads around organs. 100 means normal, 50 means half."
	default_value = 0.5
	rounding = 0.01

/decl/config/num/health_revival_brain_life
	uid = "revival_brain_life"
	default_value = -1
	desc = "Amount of time (in hundredths of seconds) for which a brain retains the 'spark of life' after the person's death (set to -1 for infinite)."
