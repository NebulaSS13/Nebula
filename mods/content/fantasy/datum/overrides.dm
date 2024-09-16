/decl/species
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
	default_background_info = list(
		/decl/background_category/homeworld = /decl/background_detail/location/fantasy,
		/decl/background_category/faction   = /decl/background_detail/faction/fantasy,
		/decl/background_category/heritage   = /decl/background_detail/heritage/fantasy,
		/decl/background_category/religion  = /decl/background_detail/religion/other
	)

// Rename grafadreka
/decl/species/grafadreka
	name = "Meredrake"
	name_plural = "Meredrakes"
	description = "Meredrakes, sometimes called mire-drakes, are large reptillian pack predators, widely assumed to be cousins to true dragons. \
	They are commonly found living in caves or burrows bordering grassland or forest, and while they prefer to hunt deer or rabbits, they will sometimes attack travellers if pickings are slim enough. \
	While they are not domesticated, they can be habituated and trained as working animals if captured young enough."

/decl/sprite_accessory/marking/grafadreka
	species_allowed = list("Meredrake")

/decl/language/grafadreka
	desc = "Hiss hiss, feed me rabbits."

/decl/material/liquid/sifsap
	name = "drake spittle"
	lore_text = "A complex chemical slurry brewed up in the gullet of meredrakes."

/obj/aura/sifsap_salve
	name = "Drakespittle Salve"
	descriptor = "glowing spittle"

// Rename wooden prostheses
/decl/bodytype/prosthetic/wooden
	name = "carved wooden" // weird to call it 'crude' when it's cutting-edge for the setting
