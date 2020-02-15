/datum/chemical_reaction/recipe/cafe
	hidden_from_codex = TRUE

/datum/chemical_reaction/cafe/icecoffee
	name = "Iced Coffee"
	result = /datum/reagent/drink/coffee/icecoffee
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled coffee."

/datum/chemical_reaction/cafe/icesoylatte
	name = "Iced Soy Latte"
	result = /datum/reagent/drink/coffee/icecoffee/soy_latte
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee/soy_latte = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled soy latte."

/datum/chemical_reaction/cafe/icecafelatte
	name = "Iced Cafe Latte"
	result = /datum/reagent/drink/coffee/icecoffee/cafe_latte
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee/cafe_latte = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled cafe latte."

/datum/chemical_reaction/recipe/cafe/soy_latte
	name = "Soy Latte"
	result = /datum/reagent/drink/coffee/soy_latte
	required_reagents = list(/datum/reagent/drink/coffee = 1, /datum/reagent/drink/milk/soymilk = 1)
	result_amount = 2
	mix_message = "The soy milk suffuses the coffee with pale shades."

/datum/chemical_reaction/recipe/cafe/cafe_latte
	name = "Cafe Latte"
	result = /datum/reagent/drink/coffee/cafe_latte
	required_reagents = list(/datum/reagent/drink/coffee = 1, /datum/reagent/drink/milk = 1)
	result_amount = 2
	mix_message = "The milk suffuses the coffee with pale shades."

/datum/chemical_reaction/recipe/cafe/mocha_latte
	name = "Mocha Latte"
	result = /datum/reagent/drink/coffee/cafe_latte/mocha
	required_reagents = list(/datum/reagent/drink/coffee/cafe_latte = 2, /datum/reagent/drink/syrup_chocolate = 1)
	result_amount = 3
	mix_message = "The chocolate swirls into the latte."

/datum/chemical_reaction/recipe/cafe/soy_mocha_latte
	name = "Mocha Soy Latte"
	result = /datum/reagent/drink/coffee/soy_latte/mocha
	required_reagents = list(/datum/reagent/drink/coffee/soy_latte = 3, /datum/reagent/drink/syrup_chocolate = 1)
	result_amount = 4
	mix_message = "The chocolate swirls into the latte."

/datum/chemical_reaction/recipe/cafe/ice_mocha_latte
	name = "Iced Mocha Latte"
	result = /datum/reagent/drink/coffee/icecoffee/cafe_latte/mocha
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee/cafe_latte/mocha = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled mocha latte."

/datum/chemical_reaction/recipe/cafe/ice_soy_mocha_latte
	name = "Iced Soy Mocha Latte"
	result = /datum/reagent/drink/coffee/icecoffee/soy_latte/mocha
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee/soy_latte/mocha = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled soy mocha latte."

/datum/chemical_reaction/recipe/cafe/pumpkin_latte
	name = "Pumpkin Spice Latte"
	result = /datum/reagent/drink/coffee/cafe_latte/pumpkin
	required_reagents = list(/datum/reagent/drink/coffee/cafe_latte = 2, /datum/reagent/drink/syrup_pumpkin = 1)
	result_amount = 3
	mix_message = "The pumpkin spice swirls into the latte."

/datum/chemical_reaction/recipe/cafe/soy_pumpkin_latte
	name = "Pumpkin Spice Soy Latte"
	result = /datum/reagent/drink/coffee/soy_latte/pumpkin
	required_reagents = list(/datum/reagent/drink/coffee/soy_latte = 3, /datum/reagent/drink/syrup_pumpkin = 1)
	result_amount = 4
	mix_message = "The pumpkin spice swirls into the latte."

/datum/chemical_reaction/recipe/cafe/ice_pumpkin_latte
	name = "Iced Pumpkin Spice Latte"
	result = /datum/reagent/drink/coffee/icecoffee/cafe_latte/pumpkin
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee/cafe_latte/pumpkin = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled pumpkin spice latte."

/datum/chemical_reaction/recipe/cafe/ice_soy_pumpkin_latte
	name = "Iced Pumpkin Spice Soy Latte"
	result = /datum/reagent/drink/coffee/icecoffee/soy_latte/pumpkin
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee/soy_latte/pumpkin = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled pumpkin spice soy latte."

/datum/chemical_reaction/recipe/cafe/coffee
	name = "Coffee"
	result = /datum/reagent/drink/coffee
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/coffee = 1)
	result_amount = 5
	minimum_temperature = 70 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The solution thickens into a steaming dark brown beverage."

/datum/chemical_reaction/recipe/cafe/coffee/instant
	name = "Instant Coffee"
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/coffee/instant = 1)
	maximum_temperature = INFINITY
	minimum_temperature = 0
	mix_message = "The solution thickens into dark brown beverage."

/datum/chemical_reaction/recipe/cafe/tea
	name = "Black tea"
	result = /datum/reagent/drink/tea
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/tea = 1)
	result_amount = 5
	minimum_temperature = 70 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The solution thickens into a steaming black beverage."

/datum/chemical_reaction/recipe/cafe/tea/instant
	name = "Instant Black tea"
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/tea/instant = 1)
	maximum_temperature = INFINITY
	minimum_temperature = 0
	mix_message = "The solution thickens into black beverage."

/datum/chemical_reaction/recipe/cafe/hot_coco
	name = "Hot Coco"
	result = /datum/reagent/drink/hot_coco
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/coco = 1)
	result_amount = 5
	minimum_temperature = 70 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The solution thickens into a steaming brown beverage."

/datum/chemical_reaction/recipe/cafe/icetea
	name = "Iced Tea"
	result = /datum/reagent/drink/tea/icetea
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the tea."

/datum/chemical_reaction/recipe/cafe/sweettea
	name = "Sweet Tea"
	result = /datum/reagent/drink/tea/icetea/sweet
	required_reagents = list(/datum/reagent/drink/tea/icetea = 2, /datum/reagent/nutriment/sugar = 1)
	result_amount = 3
	mix_message = "The ice clinks together in the sweet tea."

/datum/chemical_reaction/recipe/cafe/barongrey
	name = "Baron Grey Tea"
	result = /datum/reagent/drink/tea/barongrey
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/drink/juice/orange = 1)
	result_amount = 3
	mix_message = "The juice swirls into the tea."

/datum/chemical_reaction/recipe/cafe/latte_barongrey
	name = "London Fog"
	result = /datum/reagent/drink/tea/barongrey/latte
	required_reagents = list(/datum/reagent/drink/tea/barongrey = 2, /datum/reagent/drink/milk = 1)
	result_amount = 3
	mix_message = "The milk swirls into the tea."

/datum/chemical_reaction/recipe/cafe/soy_latte_barongrey
	name = "Soy London Fog"
	result = /datum/reagent/drink/tea/barongrey/soy_latte
	required_reagents = list(/datum/reagent/drink/tea/barongrey = 2, /datum/reagent/drink/milk/soymilk = 1)
	result_amount = 3
	mix_message = "The soy swirls into the tea."

/datum/chemical_reaction/recipe/cafe/ice_latte_barongrey
	name = "Iced London Fog"
	result = /datum/reagent/drink/tea/icetea/barongrey/latte
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/barongrey/latte = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled london fog."

/datum/chemical_reaction/recipe/cafe/ice_soy_latte_barongrey
	name = "Iced Soy London Fog"
	result = /datum/reagent/drink/tea/icetea/barongrey/soy_latte
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/barongrey/soy_latte = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled soy london fog."

/datum/chemical_reaction/recipe/cafe/icetea_green
	name = "Iced Green Tea"
	result = /datum/reagent/drink/tea/icetea/green
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/green = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the tea."

/datum/chemical_reaction/recipe/cafe/sweettea_green
	name = "Sweet Green Tea"
	result = /datum/reagent/drink/tea/icetea/green/sweet
	required_reagents = list(/datum/reagent/drink/tea/icetea/green = 2, /datum/reagent/nutriment/sugar = 1)
	result_amount = 3
	mix_message = "The ice clinks together in the sweet tea."

/datum/chemical_reaction/recipe/cafe/maghreb_tea
	name = "Maghrebi tea"
	result = /datum/reagent/drink/tea/icetea/green/sweet/mint
	required_reagents = list(/datum/reagent/drink/tea/icetea/green/sweet = 3)
	catalysts = list(/datum/reagent/nutriment/mint)
	result_amount = 3
	mix_message = "The mint swirls into the drink."

/datum/chemical_reaction/recipe/cafe/icetea_chai
	name = "Iced Chai Tea"
	result = /datum/reagent/drink/tea/icetea/chai
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/chai = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the tea."

/datum/chemical_reaction/recipe/cafe/sweettea_chai
	name = "Iced Chai Tea"
	result = /datum/reagent/drink/tea/icetea/chai/sweet
	required_reagents = list(/datum/reagent/drink/tea/icetea/chai = 2, /datum/reagent/nutriment/sugar = 1)
	result_amount = 3
	mix_message = "The ice clinks together in the sweet tea."

/datum/chemical_reaction/recipe/cafe/latte_chai
	name = "Chai Latte"
	result = /datum/reagent/drink/tea/chai/latte
	required_reagents = list(/datum/reagent/drink/tea/chai = 2, /datum/reagent/drink/milk = 1)
	result_amount = 3
	mix_message = "The milk swirls into the drink."

/datum/chemical_reaction/recipe/cafe/soy_latte_chai
	name = "Chai Soy Latte"
	result = /datum/reagent/drink/tea/chai/soy_latte
	required_reagents = list(/datum/reagent/drink/tea/chai = 2, /datum/reagent/drink/milk/soymilk = 1)
	result_amount = 3
	mix_message = "The milk swirls into the drink."

/datum/chemical_reaction/recipe/cafe/ice_latte_chai
	name = "Iced Chai Latte"
	result = /datum/reagent/drink/tea/icetea/chai/latte
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/chai/latte = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled chai latte."

/datum/chemical_reaction/recipe/cafe/ice_soy_latte_chai
	name = "Iced Chai Soy Latte"
	result = /datum/reagent/drink/tea/icetea/chai/soy_latte
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/chai/soy_latte = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled chai soy latte."

/datum/chemical_reaction/recipe/cafe/icetea_red
	name = "Iced Rooibos tea"
	result = /datum/reagent/drink/tea/icetea/red
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/red = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the tea."

/datum/chemical_reaction/recipe/cafe/sweettea_red
	name = "Iced Rooibos tea"
	result = /datum/reagent/drink/tea/icetea/red/sweet
	required_reagents = list(/datum/reagent/drink/tea/icetea/red = 2, /datum/reagent/nutriment/sugar = 1)
	result_amount = 3
	mix_message = "The ice clinks together in the sweet tea."
