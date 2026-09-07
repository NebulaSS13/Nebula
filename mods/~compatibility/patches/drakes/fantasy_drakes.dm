// Rename grafadreka
/decl/species/grafadreka
	name = "Meredrake"
	name_plural = "Meredrakes"
	description = "Meredrakes, sometimes called mire-drakes, are large reptillian pack predators, widely assumed to be cousins to true dragons. \
	They are commonly found living in caves or burrows bordering grassland or forest, and while they prefer to hunt deer or rabbits, they will sometimes attack travellers if pickings are slim enough. \
	While they are not domesticated, they can be habituated and trained as working animals if captured young enough."

/decl/language/grafadreka
	desc = "Hiss hiss, feed me rabbits."

/decl/material/liquid/sifsap
	name = "drake spittle"
	lore_text = "A complex chemical slurry brewed up in the gullet of meredrakes."

/decl/mob_modifier/sifsap_salve
	name = "Drakespittle Salve"
	desc = "glowing spittle"

/decl/bodytype/quadruped/grafadreka
	base_color           = "#8f974a"
	base_eye_color       = "#d95763"
	default_sprite_accessories = list(
		SAC_MARKINGS = list(
			/decl/sprite_accessory/marking/grafadreka                 = list(SAM_COLOR = "#b6b99a"),
			/decl/sprite_accessory/marking/grafadreka/bioluminescence = list(SAM_COLOR = "#d95763"),
			/decl/sprite_accessory/marking/grafadreka/claws           = list(SAM_COLOR = "#3a3b2c")
		)
	)
