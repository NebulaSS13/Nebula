/decl/material/liquid/ethanol
	name = "ethanol" //Parent class for all alcoholic reagents.
	lore_text = "A well-known alcohol with a variety of applications."
	taste_description = "pure alcohol"
	color = "#404030"
	touch_met = 5
	fuel_value = 0.75
	solvent_power = MAT_SOLVENT_MODERATE

	heating_message = "boils away its water content, leaving pure ethanol."
	heating_point = T100C + 10
	heating_products = list(
		/decl/material/liquid/ethanol = 0.75,
		/decl/material/liquid/water =   0.25
	)
	bypass_heating_products_for_root_type = /decl/material/liquid/ethanol

	chilling_message = "separates as its water content freezes, leaving pure ethanol."
	chilling_point = T0C - 10
	chilling_products = list(
		/decl/material/liquid/ethanol = 0.75,
		/decl/material/liquid/water =   0.25
	)
	bypass_cooling_products_for_root_type = /decl/material/liquid/ethanol
	affect_blood_on_ingest = FALSE // prevents automatic toxins/inebriation as though injected

	var/nutriment_factor = 0
	var/hydration_factor = 0
	var/strength = 10 // This is, essentially, units between stages - the lower, the stronger. Less fine tuning, more clarity.
	var/alcohol_toxicity = 1
	var/adj_temp = 0
	var/targ_temp = 310
	var/halluci = 0

	glass_name = "ethanol"
	glass_desc = "A well-known alcohol with a variety of applications."
	value = 1.2

/decl/material/liquid/ethanol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.adjustToxLoss(removed * 2 * alcohol_toxicity)
	M.add_chemical_effect(CE_ALCOHOL_TOXIC, alcohol_toxicity)

/decl/material/liquid/ethanol/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()

	if(M.HasTrait(/decl/trait/metabolically_inert))
		return

	M.adjust_nutrition(nutriment_factor * removed)
	M.adjust_hydration(hydration_factor * removed)

	M.add_chemical_effect(CE_ALCOHOL, 1)
	var/strength_mod = (M.GetTraitLevel(/decl/trait/malus/ethanol) * 2.5) || 1

	var/effective_dose = M.chem_doses[type] * strength_mod * (1 + REAGENT_VOLUME(holder, type)/60) //drinking a LOT will make you go down faster
	if(effective_dose >= strength) // Early warning
		M.make_dizzy(6) // It is decreased at the speed of 3 per tick
	if(effective_dose >= strength * 2) // Slurring
		M.add_chemical_effect(CE_PAINKILLER, 150/strength)
		M.slurring = max(M.slurring, 30)
	if(effective_dose >= strength * 3) // Confusion - walking in random directions
		M.add_chemical_effect(CE_PAINKILLER, 150/strength)
		M.confused = max(M.confused, 20)
	if(effective_dose >= strength * 4) // Blurry vision
		M.add_chemical_effect(CE_PAINKILLER, 150/strength)
		M.eye_blurry = max(M.eye_blurry, 10)
	if(effective_dose >= strength * 5) // Drowsyness - periodically falling asleep
		M.add_chemical_effect(CE_PAINKILLER, 150/strength)
		M.drowsyness = max(M.drowsyness, 20)
	if(effective_dose >= strength * 6) // Toxic dose
		M.add_chemical_effect(CE_ALCOHOL_TOXIC, alcohol_toxicity)
	if(effective_dose >= strength * 7) // Pass out
		M.Paralyse(20)
		M.Sleeping(30)

	if(euphoriant)
		M.adjust_drugged(euphoriant, euphoriant_max)

	if(adj_temp > 0 && M.bodytemperature < targ_temp) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(targ_temp, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && M.bodytemperature > targ_temp)
		M.bodytemperature = min(targ_temp, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

	if(halluci)
		M.adjust_hallucination(halluci, halluci)

/decl/material/liquid/ethanol/absinthe
	name = "absinthe"
	lore_text = "Watch out that the Green Fairy doesn't come for you!"
	taste_description = "death and licorice"
	taste_mult = 1.5
	color = "#33ee00"
	strength = 12

	glass_name = "absinthe"
	glass_desc = "Wormwood, anise, oh my."

/decl/material/liquid/ethanol/ale
	name = "ale"
	lore_text = "A dark alchoholic beverage made by malted barley and yeast."
	taste_description = "hearty barley ale"
	color = "#4c3100"
	strength = 50

	glass_name = "ale"
	glass_desc = "A freezing container of delicious ale"

/decl/material/liquid/ethanol/beer
	name = "beer"
	lore_text = "An alcoholic beverage made from malted grains, hops, yeast, and water."
	taste_description = "piss water"
	color = "#ffd300"
	strength = 50
	nutriment_factor = 1

	glass_name = "beer"
	glass_desc = "A freezing container of beer"

/decl/material/liquid/ethanol/beer/good
	taste_description = "beer"

/decl/material/liquid/ethanol/beer/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(M.HasTrait(/decl/trait/metabolically_inert))
		return

	M.jitteriness = max(M.jitteriness - 3, 0)

/decl/material/liquid/ethanol/bluecuracao
	name = "blue curacao"
	lore_text = "Exotically blue, fruity drink, distilled from oranges."
	taste_description = "oranges"
	taste_mult = 1.1
	color = "#0000cd"
	strength = 15

	glass_name = "blue curacao"
	glass_desc = "Exotically blue, fruity drink, distilled from oranges."

/decl/material/liquid/ethanol/cognac
	name = "cognac"
	lore_text = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
	taste_description = "rich and smooth alcohol"
	taste_mult = 1.1
	color = "#ab3c05"
	strength = 15

	glass_name = "cognac"
	glass_desc = "Damn, you feel like some kind of French aristocrat just by holding this."

/decl/material/liquid/ethanol/gin
	name = "gin"
	lore_text = "It's gin. In space. I say, good sir."
	taste_description = "an alcoholic christmas tree"
	color = "#0064c6"
	strength = 15

	glass_name = "gin"
	glass_desc = "A crystal clear glass of Griffeater gin."

//Base type for alchoholic drinks containing coffee
/decl/material/liquid/ethanol/coffee
	overdose = 45

/decl/material/liquid/ethanol/coffee/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()

	if(M.HasTrait(/decl/trait/metabolically_inert))
		return

	M.dizziness = max(0, M.dizziness - 5)
	M.drowsyness = max(0, M.drowsyness - 3)
	M.sleeping = max(0, M.sleeping - 2)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))

/decl/material/liquid/ethanol/coffee/affect_overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	M.make_jittery(5)

/decl/material/liquid/ethanol/coffee/kahlua
	name = "coffee liqueur"
	lore_text = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936!"
	taste_description = "spiked coffee"
	taste_mult = 1.1
	color = "#4c3100"
	strength = 15

	glass_name = "RR coffee liquor"
	glass_desc = "DAMN, THIS THING LOOKS ROBUST"

/decl/material/liquid/ethanol/melonliquor
	name = "melon liqueur"
	lore_text = "A relatively sweet and fruity 46 proof liqueur."
	taste_description = "fruity alcohol"
	color = "#138808" // rgb: 19, 136, 8
	strength = 50

	glass_name = "melon liqueur"
	glass_desc = "A relatively sweet and fruity 46 proof liquor."

/decl/material/liquid/ethanol/rum
	name = "rum"
	lore_text = "Yohoho and all that."
	taste_description = "spiked butterscotch"
	taste_mult = 1.1
	color = "#ecb633"
	strength = 15

	glass_name = "rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"

/decl/material/liquid/ethanol/sake
	name = "sake"
	lore_text = "Anime's favorite drink."
	taste_description = "dry alcohol"
	color = "#dddddd"
	strength = 25

	glass_name = "sake"
	glass_desc = "A glass of sake."

/decl/material/liquid/ethanol/tequilla
	name = "tequila"
	lore_text = "A strong and mildly flavoured, mexican produced spirit. Feeling thirsty hombre?"
	taste_description = "paint stripper"
	color = "#ffff91"
	strength = 25

	glass_name = "tequilla"
	glass_desc = "Now all that's missing is the weird colored shades!"

/decl/material/liquid/ethanol/thirteenloko
	name = "Thirteen Loko"
	lore_text = "A potent mixture of caffeine and alcohol."
	taste_description = "jitters and death"
	color = "#102000"
	strength = 25
	nutriment_factor = 1

	glass_name = "Thirteen Loko"
	glass_desc = "This is a glass of Thirteen Loko, it appears to be of the highest quality. The drink, not the glass."

/decl/material/liquid/ethanol/thirteenloko/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()

	if(M.HasTrait(/decl/trait/metabolically_inert))
		return

	M.drowsyness = max(0, M.drowsyness - 7)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	M.make_jittery(5)
	M.add_chemical_effect(CE_PULSE, 2)

/decl/material/liquid/ethanol/vermouth
	name = "vermouth"
	lore_text = "You suddenly feel a craving for a martini..."
	taste_description = "dry alcohol"
	taste_mult = 1.3
	color = "#91ff91" // rgb: 145, 255, 145
	strength = 15

	glass_name = "vermouth"
	glass_desc = "You wonder why you're even drinking this straight."

/decl/material/liquid/ethanol/vodka
	name = "vodka"
	lore_text = "Number one drink AND fueling choice for Independents around the galaxy."
	taste_description = "grain alcohol"
	color = "#0064c8" // rgb: 0, 100, 200
	strength = 15

	glass_name = "vodka"
	glass_desc = "The glass contain wodka. Xynta."

/decl/material/liquid/ethanol/vodka/premium
	name = "premium vodka"
	lore_text = "Premium distilled vodka imported directly from the Gilgamesh Colonial Confederation."
	taste_description = "clear kvass"
	color = "#aaddff" // rgb: 170, 221, 255 - very light blue.
	strength = 10

/decl/material/liquid/ethanol/whiskey
	name = "whiskey"
	lore_text = "A superb and well-aged single-malt whiskey. Damn."
	taste_description = "molasses"
	color = "#4c3100"
	strength = 25

	glass_name = "whiskey"
	glass_desc = "The silky, smokey whiskey goodness inside the glass makes the drink look very classy."

/decl/material/liquid/ethanol/wine
	name = "wine"
	lore_text = "An premium alchoholic beverage made from distilled grape juice."
	taste_description = "bitter sweetness"
	color = "#7e4043" // rgb: 126, 64, 67
	strength = 15

	glass_name = "wine"
	glass_desc = "A very classy looking drink."

/decl/material/liquid/ethanol/wine/premium
	name = "white wine"
	lore_text = "An exceptionally expensive alchoholic beverage made from distilled white grapes."
	taste_description = "white velvet"
	color = "#ffddaa" // rgb: 255, 221, 170 - a light cream
	strength = 20

/decl/material/liquid/ethanol/herbal
	name = "herbal liquor"
	lore_text = "A complex blend of herbs, spices and roots mingle in this old Earth classic."
	taste_description = "a sweet summer garden"
	color = "#dfff00"
	strength = 13

	glass_name = "herbal liquor"
	glass_desc = "It's definitely green. Or is it yellow?"

/decl/material/liquid/ethanol/hooch
	name = "hooch"
	lore_text = "Either someone's failure at cocktail making or attempt in alchohol production. In any case, do you really want to drink that?"
	taste_description = "pure resignation"
	color = "#4c3100"
	strength = 25
	alcohol_toxicity = 2

	glass_name = "Hooch"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/decl/material/liquid/ethanol/irish_cream
	name = "Irish cream"
	lore_text = "Whiskey-imbued cream."
	taste_description = "creamy alcohol"
	color = "#dddd9a"
	strength = 25

	glass_name = "Irish cream"
	glass_desc = "It's cream, mixed with whiskey."

/decl/material/liquid/ethanol/mead
	name = "mead"
	lore_text = "A Viking's drink, though a cheap one."
	taste_description = "sweet, sweet alcohol"
	color = "#ffbb00"
	strength = 30
	nutriment_factor = 1

	glass_name = "mead"
	glass_desc = "A Viking's beverage, though a cheap one."

/decl/material/liquid/ethanol/moonshine
	name = "moonshine"
	lore_text = "You've really hit rock bottom now... your liver packed its bags and left last night."
	taste_description = "bitterness"
	taste_mult = 2.5
	color = "#0064c8"
	strength = 12

	glass_name = "moonshine"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/decl/material/liquid/ethanol/pwine
	name = "poison wine"
	lore_text = "Is this even wine? Toxic! Hallucinogenic! Probably consumed in boatloads by your superiors!"
	taste_description = "purified alcoholic death"
	color = "#000000"
	strength = 10
	halluci = 10
	glass_name = "???"
	glass_desc = "A black ichor with an oily purple sheer on top. Are you sure you should drink this?"
	euphoriant = 50
	euphoriant_max = 50

/decl/material/liquid/ethanol/pwine/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()

	if(M.HasTrait(/decl/trait/metabolically_inert))
		return

	if(M.chem_doses[type] > 30)
		M.adjustToxLoss(2 * removed)
	if(M.chem_doses[type] > 60 && ishuman(M) && prob(5))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/heart/L = H.internal_organs_by_name[BP_HEART]
		if (L && istype(L))
			if(M.chem_doses[type] < 120)
				L.take_internal_damage(10 * removed, 0)
			else
				L.take_internal_damage(100, 0)

/decl/material/liquid/ethanol/aged_whiskey // I have no idea what this is and where it comes from.  //It comes from Dinnlan now 
	name = "aged whiskey"
	lore_text = "A well-aged whiskey of high quality. Probably imported. Just a sip'll do it, but that burn will leave you wanting more."
	color = "#523600"
	strength = 25

	glass_name = "aged whiskey"
	glass_desc = "A well-aged whiskey of high quality. Probably imported."

/decl/material/liquid/ethanol/applecider
	name = "apple cider"
	lore_text = "A refreshing glass of apple cider."
	taste_description = "cool apple cider"
	color = "#cac089"
	strength = 50

	glass_name = "apple cider"
	glass_desc = "A refreshing glass of apple cider."

/decl/material/liquid/ethanol/champagne
	name = "champagne"
	lore_text = "Smooth sparkling wine, produced in the same region of France as it has for centuries."
	taste_description = "a superior taste of sparkling wine"
	color = "#e8dfc1"
	strength = 25

	glass_name = "champagne"
	glass_desc = "Smooth sparkling wine, produced in the same region of France as it has for centuries."

/decl/material/liquid/ethanol/jagermeister
	name = "Jagermeister"
	lore_text = "A special blend of alcohol, herbs, and spices. It has remained a popular Earther drink."
	taste_description = "herbs, spices, and alcohol"
	color = "#596e3e"
	strength = 20

	glass_name = "jagermeister"
	glass_desc = "A special blend of alcohol, herbs, and spices. It has remained a popular Earther drink."

/decl/material/liquid/ethanol/kvass
	name = "kvass"
	lore_text = "An alcoholic drink commonly made from bread."
	taste_description = "vkusnyy kvas, ypa!"
	color = "#362f22"
	strength = 30

	glass_name = "kvass"
	glass_desc = "An alcoholic drink commonly made from bread."
