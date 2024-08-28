/decl/species/human
	description = "Humans are a kind of tall, furless ape common to the downlands and the warmer parts of the Nine Mothers, \
	as well as more remote locales. Although they lack the natural ferocity of hnoll, and are larger and clumsier than kobaloi, \
	they are often stubborn and tenacious, as well as quick-witted and clever with their hands. In the downlands, humans are more \
	numerous than either kobaloi or hnoll, but were considered second-class citizens under the hnoll-ruled Imperial Aegis that \
	'civilized' them in the distant past; an attitude that survives to this day in some isolated pockets of the Splinter Kingdoms."
	available_bodytypes = list(
		/decl/bodytype/human,
		/decl/bodytype/human/masculine
	)
	preview_outfit = /decl/outfit/job/generic/fantasy
	base_external_prosthetics_model = /decl/bodytype/prosthetic/wooden

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
