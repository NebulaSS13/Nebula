/* Food */
/decl/reagent/nutriment
	name = "nutriment"
	description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	taste_mult = 4
	metabolism = REM * 4
	hidden_from_codex = TRUE // They don't need to generate a codex entry, their recipes will do that.
	color = "#664330"
	value = 1.2
	var/nutriment_factor = 10 // Per unit
	var/hydration_factor = 0 // Per unit
	var/injectable = 0

/decl/reagent/nutriment/mix_data(var/datum/reagents/reagents, var/list/newdata, var/newamount)

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

/decl/reagent/nutriment/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!injectable)
		M.adjustToxLoss(0.2 * removed)
		return
	affect_ingest(M, alien, removed, holder)

/decl/reagent/nutriment/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.heal_organ_damage(0.5 * removed, 0) //what

	adjust_nutrition(M, alien, removed)
	M.add_chemical_effect(CE_BLOODRESTORE, 4 * removed)

/decl/reagent/nutriment/proc/adjust_nutrition(var/mob/living/carbon/M, var/alien, var/removed)
	var/nut_removed = removed
	var/hyd_removed = removed
	if(nutriment_factor)
		M.adjust_nutrition(nutriment_factor * nut_removed) // For hunger and fatness
	if(hydration_factor)
		M.adjust_hydration(hydration_factor * hyd_removed) // For thirst

/decl/reagent/nutriment/slime_meat
	name = "slime-meat"
	description = "Mollusc meat, or slug meat - something slimy, anyway."
	scannable = 1
	taste_description = "cold, bitter slime"
	overdose = 10
	hydration_factor = 6

/decl/reagent/nutriment/glucose
	name = "glucose"
	color = "#ffffff"
	scannable = 1
	injectable = 1

/decl/reagent/nutriment/bread
	name = "bread"

/decl/reagent/nutriment/bread/cake
	name = "cake"

/decl/reagent/nutriment/protein
	name = "animal protein"
	taste_description = "some sort of protein"
	color = "#440000"

/decl/reagent/nutriment/protein/adjust_nutrition(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjust_nutrition(nutriment_factor * removed)

/decl/reagent/nutriment/protein/egg
	name = "egg yolk"
	taste_description = "egg"
	color = "#ffffaa"

//vegetamarian alternative that is safe for vegans to ingest//rewired it from its intended nutriment/protein/egg/softtofu because it would not actually work, going with plan B, more recipes.

/decl/reagent/nutriment/plant_protein
	name = "plant protein"
	description = "A gooey pale paste."
	taste_description = "healthy sadness"
	color = "#ffffff"

/decl/reagent/nutriment/honey
	name = "honey"
	description = "A golden yellow syrup, loaded with sugary sweetness."
	taste_description = "sweetness"
	nutriment_factor = 10
	color = "#ffff00"

/decl/reagent/nutriment/flour
	name = "flour"
	description = "This is what you rub all over yourself to pretend to be a ghost."
	taste_description = "chalky wheat"
	nutriment_factor = 1
	color = "#ffffff"

/decl/reagent/nutriment/flour/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(istype(T, /turf/simulated))
		var/turf/simulated/slip = T
		new /obj/effect/decal/cleanable/flour(slip)
		slip.unwet_floor(TRUE)

/decl/reagent/nutriment/batter
	name = "batter"
	description = "A gooey mixture of eggs and flour, a base for turning wheat into food."
	taste_description = "blandness"
	nutriment_factor = 3
	color = "#ffd592"

/decl/reagent/nutriment/batter/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(istype(T, /turf/simulated))
		var/turf/simulated/slip = T
		new /obj/effect/decal/cleanable/pie_smudge(slip)
		slip.unwet_floor(TRUE)

/decl/reagent/nutriment/batter/cakebatter
	name = "cake batter"
	description = "A gooey mixture of eggs, flour and sugar, a important precursor to cake!"
	taste_description = "sweetness"
	color = "#ffe992"

/decl/reagent/nutriment/coffee
	name = "coffee powder"
	description = "A bitter powder made by grinding coffee beans."
	taste_description = "bitterness"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#482000"

/decl/reagent/nutriment/coffee/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.add_chemical_effect(CE_PULSE, 2)

/decl/reagent/nutriment/coffee/instant
	name = "instant coffee powder"
	description = "A bitter powder made by processing coffee beans."

/decl/reagent/nutriment/tea
	name = "tea powder"
	description = "A dark, tart powder made from black tea leaves."
	taste_description = "tartness"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#101000"

/decl/reagent/nutriment/tea/instant
	name = "instant tea powder"

/decl/reagent/nutriment/coco
	name = "coco powder"
	description = "A fatty, bitter paste made from coco beans."
	taste_description = "bitterness"
	taste_mult = 1.3
	nutriment_factor = 5
	color = "#302000"

/decl/reagent/nutriment/instantjuice
	name = "juice concentrate"
	description = "Dehydrated, powdered juice of some kind."
	taste_mult = 1.3
	nutriment_factor = 1

/decl/reagent/nutriment/instantjuice/grape
	name = "grape concentrate"
	description = "Dehydrated, powdered grape juice."
	taste_description = "dry grapes"
	color = "#863333"

/decl/reagent/nutriment/instantjuice/orange
	name = "orange concentrate"
	description = "Dehydrated, powdered orange juice."
	taste_description = "dry oranges"
	color = "#e78108"

/decl/reagent/nutriment/instantjuice/watermelon
	name = "watermelon concentrate"
	description = "Dehydrated, powdered watermelon juice."
	taste_description = "dry sweet watermelon"
	color = "#b83333"

/decl/reagent/nutriment/instantjuice/apple
	name = "apple concentrate"
	description = "Dehydrated, powdered apple juice."
	taste_description = "dry sweet apples"
	color = "#c07c40"

/decl/reagent/nutriment/soysauce
	name = "soy sauce"
	description = "A salty sauce made from the soy plant."
	taste_description = "umami"
	taste_mult = 1.1
	nutriment_factor = 2
	color = "#792300"

/decl/reagent/nutriment/ketchup
	name = "ketchup"
	description = "Ketchup, catsup, whatever. It's tomato paste."
	taste_description = "ketchup"
	nutriment_factor = 5
	color = "#731008"

/decl/reagent/nutriment/banana_cream
	name = "banana cream"
	description = "A creamy confection that tastes of banana."
	taste_description = "banana"
	color = "#f6dfaa"

/decl/reagent/nutriment/barbecue
	name = "barbecue sauce"
	description = "Barbecue sauce for barbecues and long shifts."
	taste_description = "barbecue"
	nutriment_factor = 5
	color = "#4f330f"

/decl/reagent/nutriment/garlicsauce
	name = "garlic sauce"
	description = "Garlic sauce, perfect for spicing up a plate of garlic."
	taste_description = "garlic"
	nutriment_factor = 4
	color = "#d8c045"

/decl/reagent/nutriment/rice
	name = "rice"
	description = "Enjoy the great taste of nothing."
	taste_description = "rice"
	taste_mult = 0.4
	nutriment_factor = 1
	color = "#ffffff"

/decl/reagent/nutriment/rice/chazuke
	name = "chazuke"
	description = "Green tea over rice. How rustic!"
	taste_description = "green tea and rice"
	taste_mult = 0.4
	nutriment_factor = 1
	color = "#f1ffdb"

/decl/reagent/nutriment/cherryjelly
	name = "cherry jelly"
	description = "Totally the best. Only to be spread on foods with excellent lateral symmetry."
	taste_description = "cherry"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#801e28"

/decl/reagent/nutriment/cornoil
	name = "corn oil"
	description = "An oil derived from various types of corn."
	taste_description = "slime"
	taste_mult = 0.1
	nutriment_factor = 20
	color = "#302000"

/decl/reagent/nutriment/cornoil/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(istype(T, /turf/simulated) && REAGENT_VOLUME(holder, src) >= 3)
		var/turf/simulated/slip = T
		slip.wet_floor()

/decl/reagent/nutriment/sprinkles
	name = "sprinkles"
	description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	taste_description = "childhood whimsy"
	nutriment_factor = 1
	color = "#ff00ff"

/decl/reagent/nutriment/sugar
	name = "sugar"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	taste_description = "sugar"
	taste_mult = 3
	color = "#ffffff"
	scannable = 1
	nutriment_factor = 3
	glass_name = "sugar"
	glass_desc = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	glass_icon = DRINK_ICON_NOISY

/decl/reagent/nutriment/vinegar
	name = "vinegar"
	description = "A weak solution of acetic acid. Usually used for seasoning food."
	taste_description = "vinegar"
	color = "#e8dfd0"
	taste_mult = 3

/decl/reagent/nutriment/mayo
	name = "mayonnaise"
	description = "A mixture of egg yolk with lemon juice or vinegar. Usually put on bland food to make it more edible."
	taste_description = "mayo"
	color = "#efede8"
	taste_mult = 2