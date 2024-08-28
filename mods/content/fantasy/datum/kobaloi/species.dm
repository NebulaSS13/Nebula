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

	available_background_info = list(
		/decl/background_category/homeworld = list(
			/decl/background_detail/location/fantasy,
			/decl/background_detail/location/fantasy/mountains,
			/decl/background_detail/location/fantasy/steppe,
			/decl/background_detail/location/fantasy/woods,
			/decl/background_detail/location/fantasy/kobaloi,
			/decl/background_detail/location/other
		),
		/decl/background_category/faction =   list(
			/decl/background_detail/faction/fantasy,
			/decl/background_detail/faction/fantasy/kobaloi,
			/decl/background_detail/faction/fantasy/barbarian,
			/decl/background_detail/faction/fantasy/centrist,
			/decl/background_detail/faction/fantasy/aegis,
			/decl/background_detail/faction/fantasy/primitivist,
			/decl/background_detail/faction/other
		),
		/decl/background_category/heritage =   list(
			/decl/background_detail/heritage/fantasy/kobaloi,
			/decl/background_detail/heritage/other
		),
		/decl/background_category/religion =  list(
			/decl/background_detail/religion/ancestors,
			/decl/background_detail/religion/folk_deity,
			/decl/background_detail/religion/anima_materialism,
			/decl/background_detail/religion/virtuist,
			/decl/background_detail/religion/other
		)
	)

