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
	preview_outfit = /decl/hierarchy/outfit/job/generic/fantasy
	base_external_prosthetics_model = null

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
