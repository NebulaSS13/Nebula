/* Food */
/decl/material/liquid/nutriment
	name = "nutriment"
	lore_text = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	taste_mult = 4
	metabolism = REM * 4
	color = "#664330"
	value = 1.2
	fruit_descriptor = "nutritious"
	uid = "chem_nutriment"
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE // Please, no more animal protein or glowsap or corn oil atmosphere.
	fishing_bait_value = 0.65
	compost_value = 1
	nutriment_factor = 10

	// Technically a room-temperature solid, but saves
	// repathing it to /solid all over the codebase.
	melting_point    = 323
	ignition_point   = 353
	boiling_point    = 373
	accelerant_value =   0.65

/decl/material/liquid/nutriment/Initialize()
	solid_name = name   // avoid 'frozen sugar'
	liquid_name = name  // avoid 'molten honey'
	return ..()

/decl/material/liquid/nutriment/slime_meat
	name = "slime-meat"
	lore_text = "Mollusc meat, or slug meat - something slimy, anyway."
	scannable = 1
	taste_description = "cold, bitter slime"
	overdose = 10
	hydration_factor = 6
	uid = "chem_nutriment_slime"

/decl/material/liquid/nutriment/glucose
	name = "glucose"
	color = "#ffffff"
	scannable = 1
	injectable_nutrition = TRUE
	uid = "chem_nutriment_glucose"

/decl/material/liquid/nutriment/bread
	name = "bread"
	uid = "chem_nutriment_bread"

/decl/material/liquid/nutriment/bread/cake
	name = "cake"
	uid = "chem_nutriment_cake"

//vegetamarian alternative that is safe for vegans to ingest//rewired it from its intended nutriment/protein/egg/softtofu because it would not actually work, going with plan B, more recipes.
/decl/material/liquid/nutriment/plant_protein
	name = "plant protein"
	lore_text = "A gooey pale paste."
	taste_description = "healthy sadness"
	color = "#ffffff"
	uid = "chem_nutriment_plant"

/decl/material/liquid/nutriment/plant_oil
	name = "plant oil"
	lore_text = "A thin yellow oil pressed from vegetables or nuts. Useful as fuel, or in cooking."
	uid = "chem_nutriment_plant_oil"
	melting_point = 273
	boiling_point = 373
	taste_description = "oily blandness"
	burn_product = /decl/material/gas/carbon_monoxide
	ignition_point = T0C+150
	accelerant_value = FUEL_VALUE_ACCELERANT
	gas_flags = XGM_GAS_FUEL

/decl/material/liquid/nutriment/honey
	name = "honey"
	lore_text = "A golden yellow syrup, loaded with sugary sweetness."
	taste_description = "sweetness"
	nutriment_factor = 10
	color = "#ffff00"
	fruit_descriptor = "rich"
	uid = "chem_nutriment_honey"
	melting_point = 273
	boiling_point = 373

/decl/material/liquid/nutriment/flour
	name = "flour"
	lore_text = "This is what you rub all over yourself to pretend to be a ghost."
	taste_description = "chalky wheat"
	nutriment_factor = 1
	color = "#ffffff"
	slipperiness = -1
	uid = "chem_nutriment_flour"

/decl/material/liquid/nutriment/flour/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	..()
	new /obj/effect/decal/cleanable/flour(T)

/decl/material/liquid/nutriment/batter
	name = "batter"
	codex_name = "plain batter"
	lore_text = "A gooey mixture of eggs and flour, a base for turning wheat into food."
	taste_description = "blandness"
	nutriment_factor = 3
	color = "#ffd592"
	slipperiness = -1
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_nutriment_batter"
	melting_point = 273
	boiling_point = 373

/decl/material/liquid/nutriment/batter/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	..()
	new /obj/effect/decal/cleanable/pie_smudge(T)

/decl/material/liquid/nutriment/batter/cakebatter
	name = "cake batter"
	codex_name = null
	lore_text = "A gooey mixture of eggs, flour and sugar, a important precursor to cake!"
	taste_description = "sweetness"
	color = "#ffe992"
	uid = "chem_nutriment_cakebatter"

/decl/material/liquid/nutriment/coffee
	name = "ground coffee"
	lore_text = "A bitter powder made by grinding coffee beans."
	taste_description = "bitterness"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#482000"
	fruit_descriptor = "bitter"
	uid = "chem_nutriment_coffeepowder"

/decl/material/liquid/nutriment/coffee/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	M.add_chemical_effect(CE_PULSE, 2)

/decl/material/liquid/nutriment/coffee/instant
	name = "instant coffee powder"
	lore_text = "A bitter powder made by processing coffee beans."
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_nutriment_instantcoffee"

/decl/material/liquid/nutriment/tea
	name = "tea leaves"
	lore_text = "A dark, tart powder made from black tea leaves."
	taste_description = "tartness"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#101000"
	uid = "chem_nutriment_teapowder"

/decl/material/liquid/nutriment/tea/instant
	name = "instant tea powder"
	uid = "chem_nutriment_instanttea"

/decl/material/liquid/nutriment/coco
	name = "coco powder"
	lore_text = "A fatty, bitter paste made from coco beans."
	taste_description = "bitterness"
	taste_mult = 1.3
	nutriment_factor = 5
	color = "#302000"
	fruit_descriptor = "bitter"
	uid = "chem_nutriment_cocoa"

/decl/material/liquid/nutriment/instantjuice
	name = "juice concentrate"
	lore_text = "Dehydrated, powdered juice of some kind."
	taste_mult = 1.3
	nutriment_factor = 1
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_nutriment_juice"

/decl/material/liquid/nutriment/instantjuice/grape
	name = "grape concentrate"
	lore_text = "Dehydrated, powdered grape juice."
	taste_description = "dry grapes"
	color = "#863333"
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_nutriment_juice_grape"

/decl/material/liquid/nutriment/instantjuice/orange
	name = "orange concentrate"
	lore_text = "Dehydrated, powdered orange juice."
	taste_description = "dry oranges"
	color = "#e78108"
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_nutriment_juice_orange"

/decl/material/liquid/nutriment/instantjuice/watermelon
	name = "watermelon concentrate"
	lore_text = "Dehydrated, powdered watermelon juice."
	taste_description = "dry sweet watermelon"
	color = "#b83333"
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_nutriment_juice_watermelon"

/decl/material/liquid/nutriment/instantjuice/apple
	name = "apple concentrate"
	lore_text = "Dehydrated, powdered apple juice."
	taste_description = "dry sweet apples"
	color = "#c07c40"
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_nutriment_juice_apple"

/decl/material/liquid/nutriment/soysauce
	name = "soy sauce"
	lore_text = "A salty sauce made from the soy plant."
	taste_description = "umami"
	taste_mult = 1.1
	nutriment_factor = 2
	color = "#792300"
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_nutriment_soysauce"
	melting_point = 273
	boiling_point = 373

/decl/material/liquid/nutriment/ketchup
	name = "ketchup"
	lore_text = "Ketchup, catsup, whatever. It's tomato paste."
	taste_description = "ketchup"
	nutriment_factor = 5
	color = "#731008"
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_nutriment_ketchup"
	melting_point = 273
	boiling_point = 373

/decl/material/liquid/nutriment/banana_cream
	name = "banana cream"
	lore_text = "A creamy confection that tastes of banana."
	taste_description = "banana"
	color = "#f6dfaa"
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_nutriment_bananacream"
	melting_point = 273
	boiling_point = 373

/decl/material/liquid/nutriment/barbecue
	name = "barbecue sauce"
	lore_text = "Barbecue sauce for barbecues and long shifts."
	taste_description = "barbecue"
	nutriment_factor = 5
	color = "#4f330f"
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_nutriment_bbqsauce"
	melting_point = 273
	boiling_point = 373

/decl/material/liquid/nutriment/garlicsauce
	name = "garlic sauce"
	lore_text = "Garlic sauce, perfect for spicing up a plate of garlic."
	taste_description = "garlic"
	nutriment_factor = 4
	color = "#d8c045"
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_nutriment_garlicsauce"
	melting_point = 273
	boiling_point = 373

/decl/material/liquid/nutriment/rice
	name = "rice"
	lore_text = "Enjoy the great taste of nothing."
	taste_description = "rice"
	taste_mult = 0.4
	nutriment_factor = 1
	color = "#ffffff"
	uid = "chem_nutriment_rice"
	reagent_overlay_base = "rice_base"
	reagent_overlay = "soup_meatballs"

/decl/material/liquid/nutriment/cherryjelly
	name = "cherry jelly"
	lore_text = "Totally the best. Only to be spread on foods with excellent lateral symmetry."
	taste_description = "cherry"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#801e28"
	fruit_descriptor = "sweet"
	uid = "chem_nutriment_cherryjelly"
	melting_point = 273
	boiling_point = 373

/decl/material/liquid/nutriment/cornoil
	name = "corn oil"
	lore_text = "An oil derived from various types of corn."
	taste_description = "slime"
	taste_mult = 0.1
	nutriment_factor = 20
	color = "#302000"
	slipperiness = 8
	uid = "chem_nutriment_cornoil"
	melting_point = 273
	boiling_point = 373

/decl/material/liquid/nutriment/sprinkles
	name = "sprinkles"
	lore_text = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	taste_description = "childhood whimsy"
	nutriment_factor = 1
	color = "#ff00ff"
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_nutriment_sprinkles"

/decl/material/liquid/nutriment/sugar
	name = "sugar"
	lore_text = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	taste_description = "sugar"
	taste_mult = 3
	color = "#ffffff"
	scannable = 1
	nutriment_factor = 3
	glass_name = "sugar"
	glass_desc = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	glass_icon = DRINK_ICON_NOISY
	fruit_descriptor = "sweet"
	hidden_from_codex = FALSE
	uid = "chem_nutriment_sugar"

/decl/material/liquid/nutriment/vinegar
	name = "vinegar"
	lore_text = "A weak solution of acetic acid. Usually used for seasoning food."
	taste_description = "vinegar"
	color = "#e8dfd0"
	taste_mult = 3
	uid = "chem_nutriment_vinegar"
	melting_point = 273
	boiling_point = 373

/decl/material/liquid/nutriment/mayo
	name = "mayonnaise"
	lore_text = "A mixture of egg yolk with lemon juice or vinegar. Usually put on bland food to make it more edible."
	taste_description = "mayo"
	color = "#efede8"
	taste_mult = 2
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_nutriment_mayonnaise"
