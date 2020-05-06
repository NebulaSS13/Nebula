/* Food */
/decl/material/nutriment
	name = "nutriment"
	lore_text = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	taste_mult = 4
	metabolism = REM * 4
	hidden_from_codex = TRUE // They don't need to generate a codex entry, their recipes will do that.
	color = "#664330"
	value = 1.2
	var/nutriment_factor = 10 // Per unit
	var/hydration_factor = 0 // Per unit
	var/injectable = 0

/decl/material/nutriment/mix_data(var/datum/reagents/reagents, var/list/newdata, var/newamount)

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

/decl/material/nutriment/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!injectable)
		M.adjustToxLoss(0.2 * removed)
		return
	affect_ingest(M, alien, removed, holder)

/decl/material/nutriment/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.heal_organ_damage(0.5 * removed, 0) //what

	adjust_nutrition(M, alien, removed)
	M.add_chemical_effect(CE_BLOODRESTORE, 4 * removed)

/decl/material/nutriment/proc/adjust_nutrition(var/mob/living/carbon/M, var/alien, var/removed)
	var/nut_removed = removed
	var/hyd_removed = removed
	if(nutriment_factor)
		M.adjust_nutrition(nutriment_factor * nut_removed) // For hunger and fatness
	if(hydration_factor)
		M.adjust_hydration(hydration_factor * hyd_removed) // For thirst

/decl/material/nutriment/slime_meat
	name = "slime-meat"
	lore_text = "Mollusc meat, or slug meat - something slimy, anyway."
	scannable = 1
	taste_description = "cold, bitter slime"
	overdose = 10
	hydration_factor = 6

/decl/material/nutriment/glucose
	name = "glucose"
	color = "#ffffff"
	scannable = 1
	injectable = 1

/decl/material/nutriment/bread
	name = "bread"

/decl/material/nutriment/bread/cake
	name = "cake"

/decl/material/nutriment/protein
	name = "animal protein"
	taste_description = "some sort of protein"
	color = "#440000"

/decl/material/nutriment/protein/adjust_nutrition(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjust_nutrition(nutriment_factor * removed)

/decl/material/nutriment/protein/egg
	name = "egg yolk"
	taste_description = "egg"
	color = "#ffffaa"

//vegetamarian alternative that is safe for vegans to ingest//rewired it from its intended nutriment/protein/egg/softtofu because it would not actually work, going with plan B, more recipes.

/decl/material/nutriment/plant_protein
	name = "plant protein"
	lore_text = "A gooey pale paste."
	taste_description = "healthy sadness"
	color = "#ffffff"

/decl/material/nutriment/honey
	name = "honey"
	lore_text = "A golden yellow syrup, loaded with sugary sweetness."
	taste_description = "sweetness"
	nutriment_factor = 10
	color = "#ffff00"

/decl/material/nutriment/flour
	name = "flour"
	lore_text = "This is what you rub all over yourself to pretend to be a ghost."
	taste_description = "chalky wheat"
	nutriment_factor = 1
	color = "#ffffff"

/decl/material/nutriment/flour/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(istype(T, /turf/simulated))
		var/turf/simulated/slip = T
		new /obj/effect/decal/cleanable/flour(slip)
		slip.unwet_floor(TRUE)

/decl/material/nutriment/batter
	name = "batter"
	lore_text = "A gooey mixture of eggs and flour, a base for turning wheat into food."
	taste_description = "blandness"
	nutriment_factor = 3
	color = "#ffd592"

/decl/material/nutriment/batter/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(istype(T, /turf/simulated))
		var/turf/simulated/slip = T
		new /obj/effect/decal/cleanable/pie_smudge(slip)
		slip.unwet_floor(TRUE)

/decl/material/nutriment/batter/cakebatter
	name = "cake batter"
	lore_text = "A gooey mixture of eggs, flour and sugar, a important precursor to cake!"
	taste_description = "sweetness"
	color = "#ffe992"

/decl/material/nutriment/coffee
	name = "coffee powder"
	lore_text = "A bitter powder made by grinding coffee beans."
	taste_description = "bitterness"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#482000"

/decl/material/nutriment/coffee/instant
	name = "instant coffee powder"
	lore_text = "A bitter powder made by processing coffee beans."

/decl/material/nutriment/tea
	name = "tea powder"
	lore_text = "A dark, tart powder made from black tea leaves."
	taste_description = "tartness"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#101000"

/decl/material/nutriment/tea/instant
	name = "instant tea powder"

/decl/material/nutriment/coco
	name = "coco powder"
	lore_text = "A fatty, bitter paste made from coco beans."
	taste_description = "bitterness"
	taste_mult = 1.3
	nutriment_factor = 5
	color = "#302000"

/decl/material/nutriment/instantjuice
	name = "juice concentrate"
	lore_text = "Dehydrated, powdered juice of some kind."
	taste_mult = 1.3
	nutriment_factor = 1

/decl/material/nutriment/instantjuice/grape
	name = "grape concentrate"
	lore_text = "Dehydrated, powdered grape juice."
	taste_description = "dry grapes"
	color = "#863333"

/decl/material/nutriment/instantjuice/orange
	name = "orange concentrate"
	lore_text = "Dehydrated, powdered orange juice."
	taste_description = "dry oranges"
	color = "#e78108"

/decl/material/nutriment/instantjuice/watermelon
	name = "watermelon concentrate"
	lore_text = "Dehydrated, powdered watermelon juice."
	taste_description = "dry sweet watermelon"
	color = "#b83333"

/decl/material/nutriment/instantjuice/apple
	name = "apple concentrate"
	lore_text = "Dehydrated, powdered apple juice."
	taste_description = "dry sweet apples"
	color = "#c07c40"

/decl/material/nutriment/soysauce
	name = "soy sauce"
	lore_text = "A salty sauce made from the soy plant."
	taste_description = "umami"
	taste_mult = 1.1
	nutriment_factor = 2
	color = "#792300"

/decl/material/nutriment/ketchup
	name = "ketchup"
	lore_text = "Ketchup, catsup, whatever. It's tomato paste."
	taste_description = "ketchup"
	nutriment_factor = 5
	color = "#731008"

/decl/material/nutriment/banana_cream
	name = "banana cream"
	lore_text = "A creamy confection that tastes of banana."
	taste_description = "banana"
	color = "#f6dfaa"

/decl/material/nutriment/barbecue
	name = "barbecue sauce"
	lore_text = "Barbecue sauce for barbecues and long shifts."
	taste_description = "barbecue"
	nutriment_factor = 5
	color = "#4f330f"

/decl/material/nutriment/garlicsauce
	name = "garlic sauce"
	lore_text = "Garlic sauce, perfect for spicing up a plate of garlic."
	taste_description = "garlic"
	nutriment_factor = 4
	color = "#d8c045"

/decl/material/nutriment/rice
	name = "rice"
	lore_text = "Enjoy the great taste of nothing."
	taste_description = "rice"
	taste_mult = 0.4
	nutriment_factor = 1
	color = "#ffffff"

/decl/material/nutriment/rice/chazuke
	name = "chazuke"
	lore_text = "Green tea over rice. How rustic!"
	taste_description = "green tea and rice"
	taste_mult = 0.4
	nutriment_factor = 1
	color = "#f1ffdb"

/decl/material/nutriment/cherryjelly
	name = "cherry jelly"
	lore_text = "Totally the best. Only to be spread on foods with excellent lateral symmetry."
	taste_description = "cherry"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#801e28"

/decl/material/nutriment/cornoil
	name = "corn oil"
	lore_text = "An oil derived from various types of corn."
	taste_description = "slime"
	taste_mult = 0.1
	nutriment_factor = 20
	color = "#302000"

/decl/material/nutriment/cornoil/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(istype(T, /turf/simulated) && REAGENT_VOLUME(holder, src) >= 3)
		var/turf/simulated/slip = T
		slip.wet_floor()

/decl/material/nutriment/sprinkles
	name = "sprinkles"
	lore_text = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	taste_description = "childhood whimsy"
	nutriment_factor = 1
	color = "#ff00ff"

/decl/material/nutriment/mint
	name = "mint"
	lore_text = "Also known as Mentha."
	taste_description = "sweet mint"
	color = "#07aab2"

/decl/material/nutriment/sugar
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

/decl/material/nutriment/vinegar
	name = "vinegar"
	lore_text = "A weak solution of acetic acid. Usually used for seasoning food."
	taste_description = "vinegar"
	color = "#e8dfd0"
	taste_mult = 3

/decl/material/nutriment/mayo
	name = "mayonnaise"
	lore_text = "A mixture of egg yolk with lemon juice or vinegar. Usually put on bland food to make it more edible."
	taste_description = "mayo"
	color = "#efede8"
	taste_mult = 2