/datum/chemical_reaction/recipe/cafe
	hidden_from_codex = FALSE

/datum/chemical_reaction/recipe/cafe/coffee
	name = "Coffee"
	result = /decl/material/liquid/drink/coffee
	required_reagents = list(/decl/material/liquid/water = 5, /decl/material/liquid/nutriment/coffee = 1)
	result_amount = 5
	minimum_temperature = 70 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The solution thickens into a steaming dark brown beverage."

/datum/chemical_reaction/recipe/cafe/coffee/instant
	name = "Instant Coffee"
	required_reagents = list(/decl/material/liquid/water = 5, /decl/material/liquid/nutriment/coffee/instant = 1)
	maximum_temperature = INFINITY
	minimum_temperature = 0
	mix_message = "The solution thickens into dark brown beverage."

/datum/chemical_reaction/recipe/cafe/tea
	name = "Black tea"
	result = /decl/material/liquid/drink/tea/black
	required_reagents = list(/decl/material/liquid/water = 5, /decl/material/liquid/nutriment/tea = 1)
	result_amount = 5
	minimum_temperature = 70 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The solution thickens into a steaming black beverage."

/datum/chemical_reaction/recipe/cafe/tea/instant
	name = "Instant Black tea"
	required_reagents = list(/decl/material/liquid/water = 5, /decl/material/liquid/nutriment/tea/instant = 1)
	maximum_temperature = INFINITY
	minimum_temperature = 0
	mix_message = "The solution thickens into black beverage."

/datum/chemical_reaction/recipe/cafe/hot_coco
	name = "Hot Coco"
	result = /decl/material/liquid/drink/hot_coco
	required_reagents = list(/decl/material/liquid/water = 5, /decl/material/liquid/nutriment/coco = 1)
	result_amount = 5
	minimum_temperature = 70 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The solution thickens into a steaming brown beverage."
