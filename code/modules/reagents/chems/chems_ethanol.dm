/decl/reagent/ethanol
	name = "ethanol" //Parent class for all alcoholic reagents.
	description = "A well-known alcohol with a variety of applications."
	taste_description = "pure alcohol"
	color = "#404030"
	touch_met = 5
	fuel_value = 0.75
	hidden_from_codex = TRUE // They don't need to generate a codex entry, their recipes will do that.

	var/nutriment_factor = 0
	var/hydration_factor = 0
	var/strength = 10 // This is, essentially, units between stages - the lower, the stronger. Less fine tuning, more clarity.
	var/toxicity = 1

	var/druggy = 0
	var/adj_temp = 0
	var/targ_temp = 310
	var/halluci = 0

	glass_name = "ethanol"
	glass_desc = "A well-known alcohol with a variety of applications."
	value = 1.2

/decl/reagent/ethanol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustToxLoss(removed * 2 * toxicity)

/decl/reagent/ethanol/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjust_nutrition(nutriment_factor * removed)
	M.adjust_hydration(hydration_factor * removed)
	var/strength_mod = 1
	M.add_chemical_effect(CE_ALCOHOL, 1)
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
		M.add_chemical_effect(CE_ALCOHOL_TOXIC, toxicity)
	if(effective_dose >= strength * 7) // Pass out
		M.Paralyse(20)
		M.Sleeping(30)

	if(druggy != 0)
		M.druggy = max(M.druggy, druggy)

	if(adj_temp > 0 && M.bodytemperature < targ_temp) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(targ_temp, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && M.bodytemperature > targ_temp)
		M.bodytemperature = min(targ_temp, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

	if(halluci)
		M.adjust_hallucination(halluci, halluci)

/decl/reagent/ethanol/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if(istype(O, /obj/item/paper))
		var/obj/item/paper/paperaffected = O
		paperaffected.clearpaper()
		to_chat(usr, "The solution dissolves the ink on the paper.")
		return
	if(istype(O, /obj/item/book))
		if(REAGENT_VOLUME(holder, type) < 5)
			return
		if(istype(O, /obj/item/book/tome))
			to_chat(usr, "<span class='notice'>The solution does nothing. Whatever this is, it isn't normal ink.</span>")
			return
		var/obj/item/book/affectedbook = O
		affectedbook.dat = null
		to_chat(usr, "<span class='notice'>The solution dissolves the ink on the book.</span>")

/decl/reagent/ethanol/absinthe
	name = "absinthe"
	description = "Watch out that the Green Fairy doesn't come for you!"
	taste_description = "death and licorice"
	taste_mult = 1.5
	color = "#33ee00"
	strength = 12

	glass_name = "absinthe"
	glass_desc = "Wormwood, anise, oh my."

/decl/reagent/ethanol/ale
	name = "ale"
	description = "A dark alchoholic beverage made by malted barley and yeast."
	taste_description = "hearty barley ale"
	color = "#4c3100"
	strength = 50

	glass_name = "ale"
	glass_desc = "A freezing container of delicious ale"

/decl/reagent/ethanol/beer
	name = "beer"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
	taste_description = "piss water"
	color = "#ffd300"
	strength = 50
	nutriment_factor = 1

	glass_name = "beer"
	glass_desc = "A freezing container of beer"

/decl/reagent/ethanol/beer/good
	taste_description = "beer"

/decl/reagent/ethanol/beer/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.jitteriness = max(M.jitteriness - 3, 0)

/decl/reagent/ethanol/bluecuracao
	name = "blue curacao"
	description = "Exotically blue, fruity drink, distilled from oranges."
	taste_description = "oranges"
	taste_mult = 1.1
	color = "#0000cd"
	strength = 15

	glass_name = "blue curacao"
	glass_desc = "Exotically blue, fruity drink, distilled from oranges."

/decl/reagent/ethanol/cognac
	name = "cognac"
	description = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
	taste_description = "rich and smooth alcohol"
	taste_mult = 1.1
	color = "#ab3c05"
	strength = 15

	glass_name = "cognac"
	glass_desc = "Damn, you feel like some kind of French aristocrat just by holding this."

/decl/reagent/ethanol/gin
	name = "gin"
	description = "It's gin. In space. I say, good sir."
	taste_description = "an alcoholic christmas tree"
	color = "#0064c6"
	strength = 15

	glass_name = "gin"
	glass_desc = "A crystal clear glass of Griffeater gin."

//Base type for alchoholic drinks containing coffee
/decl/reagent/ethanol/coffee
	overdose = 45

/decl/reagent/ethanol/coffee/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.dizziness = max(0, M.dizziness - 5)
	M.drowsyness = max(0, M.drowsyness - 3)
	M.sleeping = max(0, M.sleeping - 2)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))

/decl/reagent/ethanol/coffee/affect_overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	M.make_jittery(5)

/decl/reagent/ethanol/coffee/kahlua
	name = "coffee liqueur"
	description = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936!"
	taste_description = "spiked coffee"
	taste_mult = 1.1
	color = "#4c3100"
	strength = 15

	glass_name = "RR coffee liquor"
	glass_desc = "DAMN, THIS THING LOOKS ROBUST"

/decl/reagent/ethanol/melonliquor
	name = "melon liqueur"
	description = "A relatively sweet and fruity 46 proof liqueur."
	taste_description = "fruity alcohol"
	color = "#138808" // rgb: 19, 136, 8
	strength = 50

	glass_name = "melon liqueur"
	glass_desc = "A relatively sweet and fruity 46 proof liquor."

/decl/reagent/ethanol/rum
	name = "rum"
	description = "Yohoho and all that."
	taste_description = "spiked butterscotch"
	taste_mult = 1.1
	color = "#ecb633"
	strength = 15

	glass_name = "rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"

/decl/reagent/ethanol/sake
	name = "sake"
	description = "Anime's favorite drink."
	taste_description = "dry alcohol"
	color = "#dddddd"
	strength = 25

	glass_name = "sake"
	glass_desc = "A glass of sake."

/decl/reagent/ethanol/tequilla
	name = "tequila"
	description = "A strong and mildly flavoured, mexican produced spirit. Feeling thirsty hombre?"
	taste_description = "paint stripper"
	color = "#ffff91"
	strength = 25

	glass_name = "tequilla"
	glass_desc = "Now all that's missing is the weird colored shades!"

/decl/reagent/ethanol/thirteenloko
	name = "Thirteen Loko"
	description = "A potent mixture of caffeine and alcohol."
	taste_description = "jitters and death"
	color = "#102000"
	strength = 25
	nutriment_factor = 1

	glass_name = "Thirteen Loko"
	glass_desc = "This is a glass of Thirteen Loko, it appears to be of the highest quality. The drink, not the glass."

/decl/reagent/ethanol/thirteenloko/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.drowsyness = max(0, M.drowsyness - 7)
	if (M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	M.make_jittery(5)
	M.add_chemical_effect(CE_PULSE, 2)

/decl/reagent/ethanol/vermouth
	name = "vermouth"
	description = "You suddenly feel a craving for a martini..."
	taste_description = "dry alcohol"
	taste_mult = 1.3
	color = "#91ff91" // rgb: 145, 255, 145
	strength = 15

	glass_name = "vermouth"
	glass_desc = "You wonder why you're even drinking this straight."

/decl/reagent/ethanol/vodka
	name = "vodka"
	description = "Number one drink AND fueling choice for Independents around the galaxy."
	taste_description = "grain alcohol"
	color = "#0064c8" // rgb: 0, 100, 200
	strength = 15

	glass_name = "vodka"
	glass_desc = "The glass contain wodka. Xynta."

/decl/reagent/ethanol/vodka/premium
	name = "premium vodka"
	description = "Premium distilled vodka imported directly from the Gilgamesh Colonial Confederation."
	taste_description = "clear kvass"
	color = "#aaddff" // rgb: 170, 221, 255 - very light blue.
	strength = 10

/decl/reagent/ethanol/whiskey
	name = "whiskey"
	description = "A superb and well-aged single-malt whiskey. Damn."
	taste_description = "molasses"
	color = "#4c3100"
	strength = 25

	glass_name = "whiskey"
	glass_desc = "The silky, smokey whiskey goodness inside the glass makes the drink look very classy."

/decl/reagent/ethanol/wine
	name = "wine"
	description = "An premium alchoholic beverage made from distilled grape juice."
	taste_description = "bitter sweetness"
	color = "#7e4043" // rgb: 126, 64, 67
	strength = 15

	glass_name = "wine"
	glass_desc = "A very classy looking drink."

/decl/reagent/ethanol/wine/premium
	name = "white wine"
	description = "An exceptionally expensive alchoholic beverage made from distilled white grapes."
	taste_description = "white velvet"
	color = "#ffddaa" // rgb: 255, 221, 170 - a light cream
	strength = 20

/decl/reagent/ethanol/herbal
	name = "herbal liquor"
	description = "A complex blend of herbs, spices and roots mingle in this old Earth classic."
	taste_description = "a sweet summer garden"
	color = "#dfff00"
	strength = 13

	glass_name = "herbal liquor"
	glass_desc = "It's definitely green. Or is it yellow?"

/decl/reagent/ethanol/hooch
	name = "hooch"
	description = "Either someone's failure at cocktail making or attempt in alchohol production. In any case, do you really want to drink that?"
	taste_description = "pure resignation"
	color = "#4c3100"
	strength = 25
	toxicity = 2

	glass_name = "Hooch"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/decl/reagent/ethanol/irish_cream
	name = "Irish cream"
	description = "Whiskey-imbued cream."
	taste_description = "creamy alcohol"
	color = "#dddd9a"
	strength = 25

	glass_name = "Irish cream"
	glass_desc = "It's cream, mixed with whiskey."

/decl/reagent/ethanol/mead
	name = "mead"
	description = "A Viking's drink, though a cheap one."
	taste_description = "sweet, sweet alcohol"
	color = "#ffbb00"
	strength = 30
	nutriment_factor = 1

	glass_name = "mead"
	glass_desc = "A Viking's beverage, though a cheap one."

/decl/reagent/ethanol/moonshine
	name = "moonshine"
	description = "You've really hit rock bottom now... your liver packed its bags and left last night."
	taste_description = "bitterness"
	taste_mult = 2.5
	color = "#0064c8"
	strength = 12

	glass_name = "moonshine"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/decl/reagent/ethanol/pwine
	name = "poison wine"
	description = "Is this even wine? Toxic! Hallucinogenic! Probably consumed in boatloads by your superiors!"
	taste_description = "purified alcoholic death"
	color = "#000000"
	strength = 10
	druggy = 50
	halluci = 10
	glass_name = "???"
	glass_desc = "A black ichor with an oily purple sheer on top. Are you sure you should drink this?"

/decl/reagent/ethanol/pwine/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
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

/decl/reagent/ethanol/aged_whiskey // I have no idea what this is and where it comes from.  //It comes from Dinnlan now 
	name = "aged whiskey"
	description = "A well-aged whiskey of high quality. Probably imported. Just a sip'll do it, but that burn will leave you wanting more."
	color = "#523600"
	strength = 25

	glass_name = "aged whiskey"
	glass_desc = "A well-aged whiskey of high quality. Probably imported."

/decl/reagent/ethanol/applecider
	name = "apple cider"
	description = "A refreshing glass of apple cider."
	taste_description = "cool apple cider"
	color = "#cac089"
	strength = 50

	glass_name = "apple cider"
	glass_desc = "A refreshing glass of apple cider."

/decl/reagent/ethanol/champagne
	name = "champagne"
	description = "Smooth sparkling wine, produced in the same region of France as it has for centuries."
	taste_description = "a superior taste of sparkling wine"
	color = "#e8dfc1"
	strength = 25

	glass_name = "champagne"
	glass_desc = "Smooth sparkling wine, produced in the same region of France as it has for centuries."

/decl/reagent/ethanol/jagermeister
	name = "Jagermeister"
	description = "A special blend of alcohol, herbs, and spices. It has remained a popular Earther drink."
	taste_description = "herbs, spices, and alcohol"
	color = "#596e3e"
	strength = 20

	glass_name = "jagermeister"
	glass_desc = "A special blend of alcohol, herbs, and spices. It has remained a popular Earther drink."

/decl/reagent/ethanol/kvass
	name = "kvass"
	description = "An alcoholic drink commonly made from bread."
	taste_description = "vkusnyy kvas, ypa!"
	color = "#362f22"
	strength = 30

	glass_name = "kvass"
	glass_desc = "An alcoholic drink commonly made from bread."
