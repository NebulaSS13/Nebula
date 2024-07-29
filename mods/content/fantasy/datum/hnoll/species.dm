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
	preview_outfit      = /decl/hierarchy/outfit/job/generic/fantasy
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

	available_cultural_info = list(
		TAG_HOMEWORLD = list(
			/decl/cultural_info/location/fantasy,
			/decl/cultural_info/location/fantasy/mountains,
			/decl/cultural_info/location/fantasy/steppe,
			/decl/cultural_info/location/fantasy/woods,
			/decl/cultural_info/location/other
		),
		TAG_FACTION =   list(
			/decl/cultural_info/faction/fantasy,
			/decl/cultural_info/faction/fantasy/barbarian,
			/decl/cultural_info/faction/fantasy/centrist,
			/decl/cultural_info/faction/fantasy/aegis,
			/decl/cultural_info/faction/fantasy/primitivist,
			/decl/cultural_info/faction/other
		),
		TAG_CULTURE =   list(
			/decl/cultural_info/culture/fantasy,
			/decl/cultural_info/culture/fantasy/steppe,
			/decl/cultural_info/culture/fantasy/hnoll,
			/decl/cultural_info/culture/fantasy/hnoll/aegis,
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
