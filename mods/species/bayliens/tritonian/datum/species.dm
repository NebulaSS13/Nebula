/decl/species/human/tritonian
	name = SPECIES_TRITONIAN
	name_plural = "Tritonians"
	description = "A human-derived genotype designed for colonizing aquatic worlds."

	available_bodytypes = list(
		/decl/bodytype/human/tritonian,
		/decl/bodytype/human/tritonian/masculine
	)

	oxy_mod    = 0.5
	toxins_mod = 1.5

	body_temperature =    302
	water_soothe_amount = 5

	unarmed_attacks = list(
		/decl/natural_attack/stomp,
		/decl/natural_attack/kick,
		/decl/natural_attack/punch,
		/decl/natural_attack/bite/sharp
	)
