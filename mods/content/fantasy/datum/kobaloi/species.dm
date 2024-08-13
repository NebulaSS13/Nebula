/decl/species/kobaloi
	name                = SPECIES_KOBALOI
	spawn_flags         = SPECIES_CAN_JOIN
	preview_outfit      = null
	description         = "Kobaloi are small, scaled and furred creatures that usually dwell in the quiet places of the world, \
	often living and working unseen or overlooked alongside human and hnoll. Many assume that kobaloi all live in tribes within \
	caves, eating mushrooms and moss, but in the modern era an increasing number of kobaloi families have left their traditional \
	warrens to take up residence in cities and settlements on the surface. The collapse of the Imperial Aegis went largely unnoticed \
	by the kobaloi, and they usually try to keep out of any hnoll-human political or ideological conflicts if they can."
	hidden_from_codex   = FALSE
	available_bodytypes = list(
		/decl/bodytype/kobaloi
	)
	preview_outfit      = /decl/outfit/job/generic/fantasy
	base_external_prosthetics_model = null

	available_cultural_info = list(
		TAG_HOMEWORLD = list(
			/decl/cultural_info/location/fantasy,
			/decl/cultural_info/location/fantasy/mountains,
			/decl/cultural_info/location/fantasy/steppe,
			/decl/cultural_info/location/fantasy/woods,
			/decl/cultural_info/location/fantasy/kobaloi,
			/decl/cultural_info/location/other
		),
		TAG_FACTION =   list(
			/decl/cultural_info/faction/fantasy,
			/decl/cultural_info/faction/fantasy/kobaloi,
			/decl/cultural_info/faction/fantasy/barbarian,
			/decl/cultural_info/faction/fantasy/centrist,
			/decl/cultural_info/faction/fantasy/aegis,
			/decl/cultural_info/faction/fantasy/primitivist,
			/decl/cultural_info/faction/other
		),
		TAG_CULTURE =   list(
			/decl/cultural_info/culture/fantasy/kobaloi,
			/decl/cultural_info/culture/other
		),
		TAG_RELIGION =  list(
			/decl/cultural_info/religion/ancestors,
			/decl/cultural_info/religion/folk_deity,
			/decl/cultural_info/religion/anima_materialism,
			/decl/cultural_info/religion/virtuist,
			/decl/cultural_info/religion/other
		)
	)

