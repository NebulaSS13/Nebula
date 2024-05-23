/decl/species/kobaloi
	name                = SPECIES_KOBALOI
	spawn_flags         = SPECIES_CAN_JOIN
	preview_outfit      = null
	description         = "A small reptomammalian creature."
	hidden_from_codex   = FALSE
	available_bodytypes = list(
		/decl/bodytype/kobaloi
	)
	preview_outfit      = /decl/hierarchy/outfit/job/generic/fantasy
	base_external_prosthetics_model = null

	available_cultural_info = list(
		TAG_HOMEWORLD = list(
			/decl/cultural_info/location/kobaloi,
			/decl/cultural_info/location/other
		),
		TAG_FACTION =   list(
			/decl/cultural_info/faction/kobaloi,
			/decl/cultural_info/faction/other
		),
		TAG_CULTURE =   list(
			/decl/cultural_info/culture/kobaloi,
			/decl/cultural_info/culture/other
		),
		TAG_RELIGION =  list(
			/decl/cultural_info/religion/other
		)
	)
