/decl/species
	available_background_info = list(
		/decl/background_category/citizenship = list(
			/decl/background_detail/citizenship/scg,
			/decl/background_detail/citizenship/fivearrows,
			/decl/background_detail/citizenship/almach,
			/decl/background_detail/citizenship/earthnation,
			/decl/background_detail/citizenship/stateless
		),
		/decl/background_category/faction =   list(
			/decl/background_detail/faction/nanotrasen,
			/decl/background_detail/faction/other
		),
		/decl/background_category/heritage =   list(
			/decl/background_detail/heritage/sif,
			/decl/background_detail/heritage/kara,
			/decl/background_detail/heritage/earth,
			/decl/background_detail/heritage/other
		),
		/decl/background_category/religion =  list(/decl/background_detail/religion/other)
	)

	default_background_info = list(
		/decl/background_category/citizenship = /decl/background_detail/citizenship/scg,
		/decl/background_category/faction   = /decl/background_detail/faction/nanotrasen,
		/decl/background_category/heritage   = /decl/background_detail/heritage/sif,
		/decl/background_category/religion  = /decl/background_detail/religion/other
	)


/datum/appearance_descriptor/age/polaris_human
	name = "age"
	standalone_value_descriptors = list(
		"an infant" =      1,
		"a toddler" =      3,
		"a child" =       12,
		"a teenager" =    19,
		"a young adult" = 28,
		"an adult" =      45,
		"middle-aged" =   65,
		"aging" =         90,
		"elderly" =      110
	)

/decl/species/human
	description = "Humanity originated in the Sol system, \
	and over the last five centuries have spread colonies across a wide swathe of space. \
	They hold a wide range of beliefs and creeds.<br/><br/> \
	While the Sol-based Solar Confederate Government governs over most of their far-ranging populations, \
	powerful corporate interests, fledgling splinter states, rampant cyber and bio-augmentation, \
	and secretive factions make life on most human worlds a tumultuous affair."

/decl/bodytype
	age_descriptor = /datum/appearance_descriptor/age/polaris_human
