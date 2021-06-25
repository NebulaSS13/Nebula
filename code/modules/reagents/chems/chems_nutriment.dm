/* Food */
/decl/material/liquid/nutriment
	name = "nutriment"
	lore_text = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	taste_mult = 4
	metabolism = REM * 4
	hidden_from_codex = TRUE // They don't need to generate a codex entry, their recipes will do that.
	color = "#664330"
	value = 1.2
	fruit_descriptor = "nutritious"

	var/nutriment_factor = 10 // Per unit
	var/hydration_factor = 0 // Per unit
	var/injectable = 0

/decl/material/liquid/nutriment/mix_data(var/datum/reagents/reagents, var/list/newdata, var/newamount)

	if(!islist(newdata) || !newdata.len)
		return

	//add the new taste data
	var/data = ..()
	for(var/taste in newdata)
		if(taste in data)
			data[taste] += newdata[taste]
		else
			data[taste] = newdata[taste]

	//cull all tastes below 10% of total
	var/totalFlavor = 0
	for(var/taste in data)
		totalFlavor += data[taste]
	if(totalFlavor)
		for(var/taste in data)
			if(data[taste]/totalFlavor < 0.1)
				data -= taste
	. = data

/decl/material/liquid/nutriment/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!injectable)
		M.adjustToxLoss(0.2 * removed)
		return
	affect_ingest(M, alien, removed, holder)

/decl/material/liquid/nutriment/affect_ingest(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	adjust_nutrition(M, alien, removed)

	if(M.HasTrait(/decl/trait/metabolically_inert))
		return

	M.heal_organ_damage(0.5 * removed, 0) //what
	M.add_chemical_effect(CE_BLOODRESTORE, 4 * removed)

/decl/material/liquid/nutriment/proc/adjust_nutrition(var/mob/living/carbon/M, var/alien, var/removed)
	var/nut_removed = removed
	var/hyd_removed = removed
	if(nutriment_factor)
		M.adjust_nutrition(nutriment_factor * nut_removed) // For hunger and fatness
	if(hydration_factor)
		M.adjust_hydration(hydration_factor * hyd_removed) // For thirst

/decl/material/liquid/nutriment/slime_meat
	name = "slime-meat"
	lore_text = "Mollusc meat, or slug meat - something slimy, anyway."
	scannable = 1
	taste_description = "cold, bitter slime"
	overdose = 10
	hydration_factor = 6

/decl/material/liquid/nutriment/glucose
	name = "glucose"
	color = "#ffffff"
	scannable = 1
	injectable = 1

/decl/material/liquid/nutriment/bread
	name = "bread"

/decl/material/liquid/nutriment/bread/cake
	name = "cake"

/decl/material/liquid/nutriment/protein
	name = "animal protein"
	taste_description = "some sort of protein"
	color = "#440000"

/decl/material/liquid/nutriment/protein/adjust_nutrition(mob/living/carbon/M, alien, removed)
	var/malus_level = M.GetTraitLevel(/decl/trait/malus/animal_protein)
	var/malus_factor = malus_level ? malus_level * 0.25 : 0

	M.adjustToxLoss(removed * malus_factor)
	M.adjust_nutrition(nutriment_factor * removed * (1 - malus_factor))

/decl/material/liquid/nutriment/protein/egg
	name = "egg yolk"
	taste_description = "egg"
	color = "#ffffaa"

//vegetamarian alternative that is safe for vegans to ingest//rewired it from its intended nutriment/protein/egg/softtofu because it would not actually work, going with plan B, more recipes.

/decl/material/liquid/nutriment/plant_protein
	name = "plant protein"
	lore_text = "A gooey pale paste."
	taste_description = "healthy sadness"
	color = "#ffffff"

/decl/material/liquid/nutriment/honey
	name = "honey"
	lore_text = "A golden yellow syrup, loaded with sugary sweetness."
	taste_description = "sweetness"
	nutriment_factor = 10
	color = "#ffff00"
	fruit_descriptor = "rich"

/decl/material/liquid/nutriment/flour
	name = "flour"
	lore_text = "This is what you rub all over yourself to pretend to be a ghost."
	taste_description = "chalky wheat"
	nutriment_factor = 1
	color = "#ffffff"
	slipperiness = -1

/decl/material/liquid/nutriment/flour/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	..()
	new /obj/effect/decal/cleanable/flour(T)

/decl/material/liquid/nutriment/batter
	name = "batter"
	lore_text = "A gooey mixture of eggs and flour, a base for turning wheat into food."
	taste_description = "blandness"
	nutriment_factor = 3
	color = "#ffd592"
	slipperiness = -1

/decl/material/liquid/nutriment/batter/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	..()
	new /obj/effect/decal/cleanable/pie_smudge(T)

/decl/material/liquid/nutriment/batter/cakebatter
	name = "cake batter"
	lore_text = "A gooey mixture of eggs, flour and sugar, a important precursor to cake!"
	taste_description = "sweetness"
	color = "#ffe992"

/decl/material/liquid/nutriment/coffee
	name = "coffee powder"
	lore_text = "A bitter powder made by grinding coffee beans."
	taste_description = "bitterness"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#482000"
	fruit_descriptor = "bitter"

/decl/material/liquid/nutriment/coffee/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.add_chemical_effect(CE_PULSE, 2)

/decl/material/liquid/nutriment/coffee/instant
	name = "instant coffee powder"
	lore_text = "A bitter powder made by processing coffee beans."

/decl/material/liquid/nutriment/tea
	name = "tea powder"
	lore_text = "A dark, tart powder made from black tea leaves."
	taste_description = "tartness"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#101000"

/decl/material/liquid/nutriment/tea/instant
	name = "instant tea powder"

/decl/material/liquid/nutriment/coco
	name = "coco powder"
	lore_text = "A fatty, bitter paste made from coco beans."
	taste_description = "bitterness"
	taste_mult = 1.3
	nutriment_factor = 5
	color = "#302000"
	fruit_descriptor = "bitter"

/decl/material/liquid/nutriment/instantjuice
	name = "juice concentrate"
	lore_text = "Dehydrated, powdered juice of some kind."
	taste_mult = 1.3
	nutriment_factor = 1

/decl/material/liquid/nutriment/instantjuice/grape
	name = "grape concentrate"
	lore_text = "Dehydrated, powdered grape juice."
	taste_description = "dry grapes"
	color = "#863333"

/decl/material/liquid/nutriment/instantjuice/orange
	name = "orange concentrate"
	lore_text = "Dehydrated, powdered orange juice."
	taste_description = "dry oranges"
	color = "#e78108"

/decl/material/liquid/nutriment/instantjuice/watermelon
	name = "watermelon concentrate"
	lore_text = "Dehydrated, powdered watermelon juice."
	taste_description = "dry sweet watermelon"
	color = "#b83333"

/decl/material/liquid/nutriment/instantjuice/apple
	name = "apple concentrate"
	lore_text = "Dehydrated, powdered apple juice."
	taste_description = "dry sweet apples"
	color = "#c07c40"

/decl/material/liquid/nutriment/soysauce
	name = "soy sauce"
	lore_text = "A salty sauce made from the soy plant."
	taste_description = "umami"
	taste_mult = 1.1
	nutriment_factor = 2
	color = "#792300"

/decl/material/liquid/nutriment/ketchup
	name = "ketchup"
	lore_text = "Ketchup, catsup, whatever. It's tomato paste."
	taste_description = "ketchup"
	nutriment_factor = 5
	color = "#731008"

/decl/material/liquid/nutriment/banana_cream
	name = "banana cream"
	lore_text = "A creamy confection that tastes of banana."
	taste_description = "banana"
	color = "#f6dfaa"

/decl/material/liquid/nutriment/barbecue
	name = "barbecue sauce"
	lore_text = "Barbecue sauce for barbecues and long shifts."
	taste_description = "barbecue"
	nutriment_factor = 5
	color = "#4f330f"

/decl/material/liquid/nutriment/garlicsauce
	name = "garlic sauce"
	lore_text = "Garlic sauce, perfect for spicing up a plate of garlic."
	taste_description = "garlic"
	nutriment_factor = 4
	color = "#d8c045"

/decl/material/liquid/nutriment/rice
	name = "rice"
	lore_text = "Enjoy the great taste of nothing."
	taste_description = "rice"
	taste_mult = 0.4
	nutriment_factor = 1
	color = "#ffffff"

/decl/material/liquid/nutriment/rice/chazuke
	name = "chazuke"
	lore_text = "Green tea over rice. How rustic!"
	taste_description = "green tea and rice"
	taste_mult = 0.4
	nutriment_factor = 1
	color = "#f1ffdb"

/decl/material/liquid/nutriment/cherryjelly
	name = "cherry jelly"
	lore_text = "Totally the best. Only to be spread on foods with excellent lateral symmetry."
	taste_description = "cherry"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#801e28"
	fruit_descriptor = "sweet"

/decl/material/liquid/nutriment/cornoil
	name = "corn oil"
	lore_text = "An oil derived from various types of corn."
	taste_description = "slime"
	taste_mult = 0.1
	nutriment_factor = 20
	color = "#302000"
	slipperiness = 8

/decl/material/liquid/nutriment/sprinkles
	name = "sprinkles"
	lore_text = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	taste_description = "childhood whimsy"
	nutriment_factor = 1
	color = "#ff00ff"

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

/decl/material/liquid/nutriment/vinegar
	name = "vinegar"
	lore_text = "A weak solution of acetic acid. Usually used for seasoning food."
	taste_description = "vinegar"
	color = "#e8dfd0"
	taste_mult = 3

/decl/material/liquid/nutriment/mayo
	name = "mayonnaise"
	lore_text = "A mixture of egg yolk with lemon juice or vinegar. Usually put on bland food to make it more edible."
	taste_description = "mayo"
	color = "#efede8"
	taste_mult = 2

//Fats
//=========================
/decl/material/liquid/nutriment/triglyceride
	name = "triglyceride"
	lore_text = "More commonly known as fat, the third macronutrient, with over double the energy content of carbs and protein"

	nutriment_factor = 27//The caloric ratio of carb/protein/fat is 4:4:9
	color = "#cccccc"
	taste_description = "fat"

/decl/material/liquid/nutriment/triglyceride/oil
	//Having this base class incase we want to add more variants of oil
	name = "Oil"
	lore_text = "Oils are liquid fats."
	color = "#c79705"
	touch_met = 1.5
	var/lastburnmessage = 0
	taste_description = "some sort of oil"
	taste_mult = 0.1

/decl/material/liquid/nutriment/triglyceride/oil/initialize_data(var/newdata) // Called when the reagent is created.
	return ..() || list("temperature" = T20C, "lastburnmessage" = 0)

/decl/material/liquid/nutriment/triglyceride/oil/touch_turf(var/turf/simulated/T, var/datum/reagents/holder)
	if(!istype(T))
		return

	if(holder.reagent_volumes[type] >= 3)
		T.wet_floor()

//Handles setting the temperature when oils are mixed
/decl/material/liquid/nutriment/mix_data(var/datum/reagents/reagents, var/list/newdata, var/newamount)
	if(!islist(newdata) || !newdata.len)
		return

	var/data = ..()
	var/volume = REAGENT_VOLUME(reagents, type)
	var/ouramount = volume - newamount
	if (ouramount <= 0 || !data["temperature"] || !volume)
		//If we get here, then this reagent has just been created, just copy the temperature exactly
		data["temperature"] = newdata["temperature"]

	else
		//Our temperature is set to the mean of the two mixtures, taking volume into account
		var/total = (data["temperature"] * ouramount) + (newdata["temperature"] * newamount)
		data["temperature"] = total / volume

	return data


//Calculates a scaling factor for scalding damage, based on the temperature of the oil and creature's heat resistance
/decl/material/liquid/nutriment/triglyceride/oil/proc/heatdamage(var/mob/living/carbon/M, var/datum/reagents/holder)
	var/threshold = 360//Human heatdamage threshold
	var/decl/species/S = M.get_species(1)
	if (S && istype(S))
		threshold = S.heat_level_1

	var/data = REAGENT_DATA(holder, type)

	//If temperature is too low to burn, return a factor of 0. no damage
	if (data["temperature"] < threshold)
		return 0

	//Step = degrees above heat level 1 for 1.0 multiplier
	var/step = 60
	if (S && istype(S))
		step = (S.heat_level_2 - S.heat_level_1)*1.5

	. = data["temperature"] - threshold
	. /= step
	. = min(., 2.5)//Cap multiplier at 2.5

/decl/material/liquid/nutriment/triglyceride/oil/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/dfactor = heatdamage(M)
	if (dfactor)
		var/data = REAGENT_DATA(holder, type)
		LAZYINITLIST(holder.reagent_data)
		M.take_organ_damage(0, removed * 1.5 * dfactor)
		data["temperature"] -= (6 * removed) / (1 + REAGENT_VOLUME(holder, type)*0.1)//Cools off as it burns you
		if (LAZYACCESS(holder.reagent_data[type], "lastburnmessage")+100 < world.time)
			to_chat(M, SPAN_DANGER("The hot oil clings to your skin and burns you!"))
			LAZYSET(holder.reagent_data[type], "lastburnmessage", world.time)

/decl/material/liquid/nutriment/triglyceride/oil/corn
	name = "Corn Oil"
	lore_text = "An oil derived from corn."
	taste_description = "corn oil"

/*
	Coatings are used in cooking. Dipping food items in a reagent container with a coating in it
	allows it to be covered in that, which will add a masked overlay to the sprite.

	Coatings have both a raw and a cooked image. Raw coating is generally unhealthy
	Generally coatings are intended for deep frying foods
*/

/decl/material/liquid/nutriment/coating
	nutriment_factor = 6 //Less dense than the food itself, but coatings still add extra calories
	var/icon_raw
	var/icon_cooked
	var/coated_adj = "coated"
	var/cooked_name = "coating"
	taste_description = "some sort of frying coating"

/decl/material/liquid/nutriment/coating/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	//We'll assume that the batter isnt going to be regurgitated and eaten by someone else. Only show this once
	var/list/data = REAGENT_DATA(holder, type)
	if (!data["cooked"])
		//Raw coatings will sometimes cause vomiting
		if (prob(1))
			to_chat(M, "This raw [name] tastes disgusting!")
			if (ishuman(M))
				var/mob/living/carbon/human/H = M
				H.vomit()
	..()

/decl/material/liquid/nutriment/coating/initialize_data(var/newdata) // Called when the reagent is created.
	. = ..()
	if (!.)
		. = list()
	else
		if (isnull(.["cooked"]))
			.["cooked"] = FALSE
		return .
	.["cooked"] = FALSE

/decl/material/liquid/nutriment/coating/mix_data(var/datum/reagents/reagents, var/newdata, var/newamount)
	. = ..()
	if(newamount > (REAGENT_VOLUME(reagents, type)/2)) // take whatever the majority is
		.["cooked"] = newdata["cooked"]

/decl/material/liquid/nutriment/coating/batter
	name = "batter mix"
	cooked_name = "batter"
	color = "#f5f4e9"
	icon_raw = "batter_raw"
	icon_cooked = "batter_cooked"
	coated_adj = "battered"
	taste_description = "batter"

/decl/material/liquid/nutriment/coating/beerbatter
	name = "beer batter mix"
	cooked_name = "beer batter"
	color = "#f5f4e9"
	icon_raw = "batter_raw"
	icon_cooked = "batter_cooked"
	coated_adj = "beer-battered"
	taste_description = "beer-batter"

/decl/material/liquid/nutriment/coating/beerbatter/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_ALCOHOL, removed*0.02) //Very slightly alcoholic

// From Synnono's Cooking Expansion on Aurora
/decl/material/liquid/nutriment/browniemix
	name = "Brownie Mix"
	lore_text = "A dry mix for making delicious brownies."
	color = "#441a03"
	nutriment_factor = 5
	taste_mult = 1.3
	taste_description = "chocolate"
