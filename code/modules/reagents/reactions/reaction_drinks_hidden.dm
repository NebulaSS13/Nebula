/datum/chemical_reaction/recipe/rehydrate
	result_amount = 3
	hidden_from_codex = TRUE

/datum/chemical_reaction/recipe/rehydrate/grapejuice
	name = "Grape Juice"
	result = /datum/reagent/drink/juice/grape
	required_reagents = list(/datum/reagent/water = 3, /datum/reagent/nutriment/instantjuice/grape = 1)
	mix_message = "The solution settles into a purplish-red beverage."

/datum/chemical_reaction/recipe/rehydrate/orangejuice
	name = "Orange Juice"
	result = /datum/reagent/drink/juice/orange
	required_reagents = list(/datum/reagent/water = 3, /datum/reagent/nutriment/instantjuice/orange = 1)
	mix_message = "The solution settles into an orange beverage."

/datum/chemical_reaction/recipe/rehydrate/watermelonjuice
	name = "Watermelon Juice"
	result = /datum/reagent/drink/juice/watermelon
	required_reagents = list(/datum/reagent/water = 3, /datum/reagent/nutriment/instantjuice/watermelon = 1)
	mix_message = "The solution settles into a red beverage."

/datum/chemical_reaction/recipe/rehydrate/applejuice
	name = "Apple Juice"
	result = /datum/reagent/drink/juice/apple
	required_reagents = list(/datum/reagent/water = 3, /datum/reagent/nutriment/instantjuice/apple = 1)
	mix_message = "The solution settles into a clear brown beverage."