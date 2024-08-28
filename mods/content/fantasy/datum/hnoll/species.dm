/datum/appearance_descriptor/age/hnoll
	standalone_value_descriptors = list(
		"an infant"     = 1,
		"a toddler"     = 3,
		"a child"       = 7,
		"an adolescent" = 13,
		"a young adult" = 18,
		"an adult"      = 30,
		"middle-aged"   = 55,
		"aging"         = 80,
		"elderly"       = 140
	)

/decl/species/hnoll
	name                = SPECIES_HNOLL
	name_plural         = "Hnoll"
	description         = "The hnoll are thickly-furred, powerfully built bipeds with a notable resemblance to the steppe \
	hyenas that often decorate their coinage and art. The oldest hnoll cultures make their home on the Grass Ocean and the \
	slopes of the Nine Mothers, and the hnoll conquest of the downlands centuries in the past was the inciting moment of \
	the continent-spanning Imperial Aegis. Hnoll culture is usually matriarchial, favouring stoutness of body and will, \
	devotion to community, and loyalty to the family over individual glory or strength of arms."
	hidden_from_codex   = FALSE
	available_bodytypes = list(/decl/bodytype/hnoll)
	preview_outfit      = /decl/outfit/job/generic/fantasy
	spawn_flags         = SPECIES_CAN_JOIN
	flesh_color         = "#ae7d32"
	hunger_factor       = DEFAULT_HUNGER_FACTOR * 1.2
	thirst_factor       = DEFAULT_THIRST_FACTOR * 1.2
	gluttonous          = GLUT_TINY
	move_trail          = /obj/effect/decal/cleanable/blood/tracks/paw
	base_external_prosthetics_model = null

	unarmed_attacks = list(
		/decl/natural_attack/stomp,
		/decl/natural_attack/kick,
		/decl/natural_attack/punch,
		/decl/natural_attack/bite/sharp
	)

	available_background_info = list(
		/decl/background_category/homeworld = list(
			/decl/background_detail/location/fantasy,
			/decl/background_detail/location/fantasy/mountains,
			/decl/background_detail/location/fantasy/steppe,
			/decl/background_detail/location/fantasy/woods,
			/decl/background_detail/location/other
		),
		/decl/background_category/faction =   list(
			/decl/background_detail/faction/fantasy,
			/decl/background_detail/faction/fantasy/barbarian,
			/decl/background_detail/faction/fantasy/centrist,
			/decl/background_detail/faction/fantasy/aegis,
			/decl/background_detail/faction/fantasy/primitivist,
			/decl/background_detail/faction/other
		),
		/decl/background_category/heritage =   list(
			/decl/background_detail/heritage/fantasy,
			/decl/background_detail/heritage/fantasy/steppe,
			/decl/background_detail/heritage/fantasy/hnoll,
			/decl/background_detail/heritage/fantasy/hnoll/aegis,
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

	default_emotes = list(
		/decl/emote/visible/tail/swish,
		/decl/emote/visible/tail/wag,
		/decl/emote/visible/tail/sway,
		/decl/emote/visible/tail/qwag,
		/decl/emote/visible/tail/fastsway,
		/decl/emote/visible/tail/swag,
		/decl/emote/visible/tail/stopsway
	)

/decl/species/hnoll/handle_additional_hair_loss(var/mob/living/human/H, var/defer_body_update = TRUE)
	. = H?.set_skin_colour(rgb(189, 171, 143))
