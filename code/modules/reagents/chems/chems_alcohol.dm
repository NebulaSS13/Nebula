/decl/material/liquid/alcohol
	abstract_type = /decl/material/liquid/alcohol
	color = "#404030"
	touch_met = 5
	ignition_point = T0C+150
	accelerant_value = FUEL_VALUE_ACCELERANT
	solvent_power = MAT_SOLVENT_MODERATE

	boiling_point = null // Pure ethanol boils, the rest has to separate first.

	heating_message = "boils away its water content, leaving pure alcohol."
	heating_point = T0C + 78.37
	heating_products = list(
		/decl/material/liquid/alcohol/ethanol = 0.75,
		/decl/material/liquid/water           = 0.25
	)

	chilling_message = "separates as its water content freezes, leaving pure alcohol."
	chilling_point = T0C
	chilling_products = list(
		/decl/material/liquid/alcohol/ethanol = 0.75,
		/decl/material/solid/ice              = 0.25
	)
	affect_blood_on_ingest = FALSE // prevents automatic toxins/inebriation as though injected
	affect_blood_on_inhale = FALSE

	value = 1.2

	var/strength = 10 // This is, essentially, units between stages - the lower, the stronger. Less fine tuning, more clarity.
	var/alcohol_toxicity = 1
	var/adj_temp = 0
	var/targ_temp = 310
	var/halluci = 0

/decl/material/liquid/alcohol/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	M.take_damage(removed * 2 * alcohol_toxicity, TOX)
	M.add_chemical_effect(CE_ALCOHOL_TOXIC, alcohol_toxicity)

/decl/material/liquid/alcohol/affect_inhale(mob/living/M, removed, datum/reagents/holder)
	if(M.has_trait(/decl/trait/metabolically_inert))
		return
	..()
	affect_ingest(M, removed, holder) // a bit of a hack, but it avoids code duplication

/decl/material/liquid/alcohol/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)

	if(M.has_trait(/decl/trait/metabolically_inert))
		return

	..()

	M.add_chemical_effect(CE_ALCOHOL, 1)
	var/strength_mod = (M.get_trait_level(/decl/trait/malus/ethanol) * 2.5) || 1

	var/effective_dose = CHEM_DOSE(M, src) * strength_mod * (1 + REAGENT_VOLUME(holder, src)/60) //drinking a LOT will make you go down faster
	if(effective_dose >= strength) // Early warning
		ADJ_STATUS(M, STAT_DIZZY, 6) // It is decreased at the speed of 3 per tick
	if(effective_dose >= strength * 2) // Slurring
		M.add_chemical_effect(CE_PAINKILLER, 150/strength)
		SET_STATUS_MAX(M, STAT_SLUR, 30)
	if(effective_dose >= strength * 3) // Confusion - walking in random directions
		M.add_chemical_effect(CE_PAINKILLER, 150/strength)
		SET_STATUS_MAX(M, STAT_CONFUSE, 20)
	if(effective_dose >= strength * 4) // Blurry vision
		M.add_chemical_effect(CE_PAINKILLER, 150/strength)
		SET_STATUS_MAX(M, STAT_BLURRY, 10)
	if(effective_dose >= strength * 5) // Drowsyness - periodically falling asleep
		M.add_chemical_effect(CE_PAINKILLER, 150/strength)
		SET_STATUS_MAX(M, STAT_DROWSY, 20)
	if(effective_dose >= strength * 6) // Toxic dose
		M.add_chemical_effect(CE_ALCOHOL_TOXIC, alcohol_toxicity)
	if(effective_dose >= strength * 7) // Pass out
		SET_STATUS_MAX(M, STAT_PARA, 20)
		SET_STATUS_MAX(M, STAT_ASLEEP, 30)
	if(euphoriant)
		SET_STATUS_MAX(M, STAT_DRUGGY, euphoriant)

	if(adj_temp > 0 && M.bodytemperature < targ_temp) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(targ_temp, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && M.bodytemperature > targ_temp)
		M.bodytemperature = min(targ_temp, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

	if(halluci)
		M.adjust_hallucination(halluci, halluci)

// Somewhat a dummy type for 'pure ethanol' to avoid having to set dirtiness/heating products/etc on literally everything else.
/decl/material/liquid/alcohol/ethanol
	name              = "ethanol"
	lore_text         = "A well-known alcohol with a variety of applications."
	taste_description = "pure alcohol"
	glass_name        = "ethanol"
	glass_desc        = "A well-known alcohol with a variety of applications."
	dirtiness         = DIRTINESS_STERILE
	uid               = "chem_ethanol"

	// Uncomment when refining spirits is less annoying, specifically when we have more precise temperature control.
	// boiling_point     = T0C + 78.37
	// can_boil_to_gas   = TRUE
	// temperature_burn_milestone_material = /decl/material/liquid/alcohol/ethanol

	// Pure ethanol does not separate.
	heating_point     = null
	heating_products  = null
	chilling_point    = null
	chilling_products = null

/decl/material/liquid/alcohol/absinthe
	name = "absinthe"
	lore_text = "Watch out that the Green Fairy doesn't come for you!"
	taste_description = "death and licorice"
	taste_mult = 1.5
	color = "#33ee00"
	strength = 12
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE

	glass_name = "absinthe"
	glass_desc = "Wormwood, anise, oh my."
	uid = "chem_ethanol_absinthe"

/decl/material/liquid/alcohol/ale
	name = "ale"
	lore_text = "A dark alcoholic beverage made by malted barley and yeast."
	taste_description = "hearty barley ale"
	color = "#4c3100"
	strength = 50
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE

	glass_name = "ale"
	glass_desc = "A freezing container of delicious ale"
	uid = "chem_ethanol_ale"

/decl/material/liquid/alcohol/beer
	name = "beer"
	codex_name = "plain beer"
	lore_text = "An alcoholic beverage made from malted grains, hops, yeast, and water."
	taste_description = "piss water"
	color = "#ffd300"
	strength = 50
	nutriment_factor = 1
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE

	glass_name = "beer"
	glass_desc = "A freezing container of beer"
	uid = "chem_ethanol_beer"

/decl/material/liquid/alcohol/beer/good
	uid = "chem_ethanol_beer_good"
	codex_name = "premium beer"
	taste_description = "beer"

/decl/material/liquid/alcohol/beer/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	if(M.has_trait(/decl/trait/metabolically_inert))
		return
	ADJ_STATUS(M, STAT_JITTER, -3)

/decl/material/liquid/alcohol/bluecuracao
	name = "blue curacao"
	lore_text = "Exotically blue, fruity drink, distilled from oranges."
	taste_description = "oranges"
	taste_mult = 1.1
	color = "#0000cd"
	strength = 15
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_bluecuracao"

	glass_name = "blue curacao"
	glass_desc = "Exotically blue, fruity drink, distilled from oranges."

/decl/material/liquid/alcohol/cognac
	name = "cognac"
	lore_text = "A sweet and strongly alcoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
	taste_description = "rich and smooth alcohol"
	taste_mult = 1.1
	color = "#ab3c05"
	strength = 15
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_cognac"

	glass_name = "cognac"
	glass_desc = "Damn, you feel like some kind of French aristocrat just by holding this."

/decl/material/liquid/alcohol/gin
	name = "gin"
	lore_text = "It's gin. In space. I say, good sir."
	taste_description = "an alcoholic christmas tree"
	color = "#0064c6"
	strength = 15
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_gin"

	glass_name = "gin"
	glass_desc = "A crystal clear glass of Griffeater gin."

//Base type for alcoholic drinks containing coffee
/decl/material/liquid/alcohol/coffee
	name = "coffee liqueur"
	lore_text = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936!"
	taste_description = "spiked coffee"
	taste_mult = 1.1
	color = "#4c3100"
	strength = 15
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_coffee"
	glass_name = "coffee liqueur"
	glass_desc = "Guaranteed to perk you up."
	overdose = 45

/decl/material/liquid/alcohol/coffee/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()

	if(M.has_trait(/decl/trait/metabolically_inert))
		return

	ADJ_STATUS(M, STAT_DIZZY, -5)
	ADJ_STATUS(M, STAT_DROWSY, -3)
	ADJ_STATUS(M, STAT_ASLEEP, -2)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))

/decl/material/liquid/alcohol/coffee/affect_overdose(mob/living/victim, total_dose)
	ADJ_STATUS(victim, STAT_JITTER, 5)

/decl/material/liquid/alcohol/melonliquor
	name = "melon liqueur"
	lore_text = "A relatively sweet and fruity 46 proof liqueur."
	taste_description = "fruity alcohol"
	color = "#138808" // rgb: 19, 136, 8
	strength = 50
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_melon"

	glass_name = "melon liqueur"
	glass_desc = "A relatively sweet and fruity 46 proof liquor."

/decl/material/liquid/alcohol/rum
	name = "dark rum"
	lore_text = "Yohoho and all that."
	taste_description = "spiked butterscotch"
	taste_mult = 1.1
	color = "#ecb633"
	strength = 15
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_rum"

	glass_name = "rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"

/decl/material/liquid/alcohol/sake
	name = "sake"
	lore_text = "Anime's favorite drink."
	taste_description = "dry alcohol"
	color = "#dddddd"
	strength = 25
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_sake"

	glass_name = "sake"
	glass_desc = "A glass of sake."

/decl/material/liquid/alcohol/tequila
	name = "tequila"
	lore_text = "A strong and mildly flavoured, mexican produced spirit. Feeling thirsty hombre?"
	taste_description = "paint stripper"
	color = "#ffff91"
	strength = 25
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_tequila"

	glass_name = "tequila"
	glass_desc = "Now all that's missing is the weird colored shades!"

/decl/material/liquid/alcohol/thirteenloko
	name = "Thirteen Loko"
	lore_text = "A potent mixture of caffeine and alcohol."
	taste_description = "jitters and death"
	color = "#102000"
	strength = 25
	nutriment_factor = 1
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_thirteenloko"

	glass_name = "Thirteen Loko"
	glass_desc = "This is a glass of Thirteen Loko, it appears to be of the highest quality. The drink, not the glass."

/decl/material/liquid/alcohol/thirteenloko/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()

	if(M.has_trait(/decl/trait/metabolically_inert))
		return

	ADJ_STATUS(M, STAT_DROWSY, -7)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	ADJ_STATUS(M, STAT_JITTER, 5)
	M.add_chemical_effect(CE_PULSE, 2)

/decl/material/liquid/alcohol/vermouth
	name = "vermouth"
	lore_text = "You suddenly feel a craving for a martini..."
	taste_description = "dry alcohol"
	taste_mult = 1.3
	color = "#91ff91" // rgb: 145, 255, 145
	strength = 15
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_vermouth"

	glass_name = "vermouth"
	glass_desc = "You wonder why you're even drinking this straight."

/decl/material/liquid/alcohol/vodka
	name = "vodka"
	codex_name = "plain vodka"
	lore_text = "High-proof grain alcohol, useful for cocktails... and as bootleg rocket fuel, for those prone to amateur rocketry or trade sanctions."
	taste_description = "grain alcohol"
	color = "#0064c8" // rgb: 0, 100, 200
	strength = 15
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_vodka"

	glass_name = "vodka"
	glass_desc = "The glass contain wodka. Xynta."

/decl/material/liquid/alcohol/vodka/premium
	name = "premium vodka"
	codex_name = null
	lore_text = "Premium distilled vodka made from real, planet-grown potatoes."
	taste_description = "clear kvass"
	color = "#aaddff" // rgb: 170, 221, 255 - very light blue.
	strength = 10
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_premiumvodka"

/decl/material/liquid/alcohol/whiskey
	name = "malt whiskey"
	lore_text = "A superb and well-aged single-malt whiskey. Damn."
	taste_description = "molasses"
	color = "#4c3100"
	strength = 25
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_whiskey"

	glass_name = "whiskey"
	glass_desc = "The silky, smokey whiskey goodness inside the glass makes the drink look very classy."

/decl/material/liquid/alcohol/wine
	name = "red wine"
	lore_text = "An premium alcoholic beverage made from distilled grape juice."
	taste_description = "bitter sweetness"
	color = "#7e4043" // rgb: 126, 64, 67
	strength = 15
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_wine"

	glass_name = "red wine"
	glass_desc = "A very classy looking drink."

/decl/material/liquid/alcohol/wine/premium
	name = "white wine"
	lore_text = "An exceptionally expensive alcoholic beverage made from distilled white grapes."
	taste_description = "white velvet"
	color = "#ffddaa" // rgb: 255, 221, 170 - a light cream
	strength = 20
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_whitewine"

/decl/material/liquid/alcohol/herbal
	name = "herbal liquor"
	lore_text = "A complex blend of herbs, spices and roots mingle in this old Earth classic."
	taste_description = "a sweet summer garden"
	color = "#dfff00"
	strength = 13
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_herbal"

	glass_name = "herbal liquor"
	glass_desc = "It's definitely green. Or is it yellow?"

/decl/material/liquid/alcohol/hooch
	name = "hooch"
	lore_text = "Either someone's failure at cocktail making or attempt in alchohol production. In any case, do you really want to drink that?"
	taste_description = "pure resignation"
	color = "#4c3100"
	strength = 25
	alcohol_toxicity = 2
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_hooch"

	glass_name = "Hooch"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/decl/material/liquid/alcohol/irish_cream
	name = "Irish cream"
	lore_text = "Whiskey-imbued cream."
	taste_description = "creamy alcohol"
	color = "#dddd9a"
	strength = 25
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_irishcream"

	glass_name = "Irish cream"
	glass_desc = "It's cream, mixed with whiskey."

/decl/material/liquid/alcohol/mead
	name = "mead"
	lore_text = "A Viking's drink, though a cheap one."
	taste_description = "sweet, sweet alcohol"
	color = "#ffbb00"
	strength = 30
	nutriment_factor = 1
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_mead"

	glass_name = "mead"
	glass_desc = "A Viking's beverage, though a cheap one."

/decl/material/liquid/alcohol/moonshine
	name = "moonshine"
	lore_text = "You've really hit rock bottom now... your liver packed its bags and left last night."
	taste_description = "bitterness"
	taste_mult = 2.5
	color = "#0064c8"
	strength = 12
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_moonshine"

	glass_name = "moonshine"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/decl/material/liquid/alcohol/pwine
	name = "poison wine"
	lore_text = "Is this even wine? Toxic! Hallucinogenic! Probably consumed in boatloads by your superiors!"
	taste_description = "purified alcoholic death"
	color = "#000000"
	strength = 10
	halluci = 10
	glass_name = "???"
	glass_desc = "A black ichor with an oily purple sheer on top. Are you sure you should drink this?"
	euphoriant = 50
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_poisonwine"

/decl/material/liquid/alcohol/pwine/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()

	if(M.has_trait(/decl/trait/metabolically_inert))
		return

	var/dose = CHEM_DOSE(M, src)
	if(dose > 30)
		M.take_damage(2 * removed, TOX)
	if(dose > 60 && ishuman(M) && prob(5))
		var/mob/living/human/H = M
		var/obj/item/organ/internal/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
		if(heart)
			if(dose < 120)
				heart.take_damage(10 * removed, 0)
			else
				heart.take_damage(100, 0)

/decl/material/liquid/alcohol/aged_whiskey // I have no idea what this is and where it comes from.  //It comes from Dinnlan now
	name = "aged whiskey"
	lore_text = "A well-aged whiskey of high quality. Probably imported. Just a sip'll do it, but that burn will leave you wanting more."
	color = "#523600"
	strength = 25
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_agedwhiskey"

	glass_name = "aged whiskey"
	glass_desc = "A well-aged whiskey of high quality. Probably imported."

/decl/material/liquid/alcohol/cider_apple
	name = "apple cider"
	lore_text = "A refreshing glass of apple cider."
	taste_description = "cool apple cider"
	color = "#cac089"
	strength = 50
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_applecider"

	glass_name = "apple cider"
	glass_desc = "A refreshing glass of apple cider."

/decl/material/liquid/alcohol/cider_pear
	name = "pear cider"
	lore_text = "A refreshing glass of pear cider."
	taste_description = "cool pear cider"
	color = "#cac089"
	strength = 50
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_pearcider"

	glass_name = "pear cider"
	glass_desc = "A refreshing glass of pear cider."

/decl/material/liquid/alcohol/champagne
	name = "champagne"
	lore_text = "Smooth sparkling wine, produced in the same region of France as it has been for centuries."
	taste_description = "bitterness and fizz"
	color = "#a89410"
	strength = 18
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_champagne"

	glass_name = "champagne"
	glass_desc = "Sparkling white wine, produced in the same region of France as it has been for centuries."
	glass_special = list(DRINK_FIZZ)

/decl/material/liquid/alcohol/jagermeister
	name = "Jagermeister"
	lore_text = "A special blend of alcohol, herbs, and spices. It has remained a popular Earther drink."
	taste_description = "herbs, spices, and alcohol"
	color = "#596e3e"
	strength = 20
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_jagermeister"

	glass_name = "jagermeister"
	glass_desc = "A special blend of alcohol, herbs, and spices. It has remained a popular Earther drink."

/decl/material/liquid/alcohol/kvass
	name = "kvass"
	lore_text = "An alcoholic drink commonly made from bread."
	taste_description = "vkusnyy kvas, ypa!"
	color = "#362f22"
	strength = 30
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_ethanol_kvass"

	glass_name = "kvass"
	glass_desc = "An alcoholic drink commonly made from bread."
