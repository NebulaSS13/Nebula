/datum/reagent/ethanol
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

/datum/reagent/ethanol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(removed * 2 * toxicity)
	return

/datum/reagent/ethanol/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjust_nutrition(nutriment_factor * removed)
	M.adjust_hydration(hydration_factor * removed)
	var/strength_mod = 1
	M.add_chemical_effect(CE_ALCOHOL, 1)
	var/effective_dose = M.chem_doses[type] * strength_mod * (1 + volume/60) //drinking a LOT will make you go down faster

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

/datum/reagent/ethanol/touch_obj(var/obj/O)
	if(istype(O, /obj/item/paper))
		var/obj/item/paper/paperaffected = O
		paperaffected.clearpaper()
		to_chat(usr, "The solution dissolves the ink on the paper.")
		return
	if(istype(O, /obj/item/book))
		if(volume < 5)
			return
		if(istype(O, /obj/item/book/tome))
			to_chat(usr, "<span class='notice'>The solution does nothing. Whatever this is, it isn't normal ink.</span>")
			return
		var/obj/item/book/affectedbook = O
		affectedbook.dat = null
		to_chat(usr, "<span class='notice'>The solution dissolves the ink on the book.</span>")

/datum/reagent/ethanol/absinthe
	name = "absinthe"
	description = "Watch out that the Green Fairy doesn't come for you!"
	taste_description = "death and licorice"
	taste_mult = 1.5
	color = "#33ee00"
	strength = 12

	glass_name = "absinthe"
	glass_desc = "Wormwood, anise, oh my."

/datum/reagent/ethanol/ale
	name = "ale"
	description = "A dark alchoholic beverage made by malted barley and yeast."
	taste_description = "hearty barley ale"
	color = "#4c3100"
	strength = 50

	glass_name = "ale"
	glass_desc = "A freezing container of delicious ale"

/datum/reagent/ethanol/beer
	name = "beer"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
	taste_description = "piss water"
	color = "#ffd300"
	strength = 50
	nutriment_factor = 1

	glass_name = "beer"
	glass_desc = "A freezing container of beer"

/datum/reagent/ethanol/beer/good
	taste_description = "beer"

/datum/reagent/ethanol/beer/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.jitteriness = max(M.jitteriness - 3, 0)

/datum/reagent/ethanol/bluecuracao
	name = "blue Curacao"
	description = "Exotically blue, fruity drink, distilled from oranges."
	taste_description = "oranges"
	taste_mult = 1.1
	color = "#0000cd"
	strength = 15

	glass_name = "blue curacao"
	glass_desc = "Exotically blue, fruity drink, distilled from oranges."

/datum/reagent/ethanol/cognac
	name = "cognac"
	description = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
	taste_description = "rich and smooth alcohol"
	taste_mult = 1.1
	color = "#ab3c05"
	strength = 15

	glass_name = "cognac"
	glass_desc = "Damn, you feel like some kind of French aristocrat just by holding this."

/datum/reagent/ethanol/gin
	name = "gin"
	description = "It's gin. In space. I say, good sir."
	taste_description = "an alcoholic christmas tree"
	color = "#0064c6"
	strength = 15

	glass_name = "gin"
	glass_desc = "A crystal clear glass of Griffeater gin."

//Base type for alchoholic drinks containing coffee
/datum/reagent/ethanol/coffee
	overdose = 45

/datum/reagent/ethanol/coffee/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.dizziness = max(0, M.dizziness - 5)
	M.drowsyness = max(0, M.drowsyness - 3)
	M.sleeping = max(0, M.sleeping - 2)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/ethanol/coffee/affect_overdose(var/mob/living/carbon/M, var/alien)
	M.make_jittery(5)

/datum/reagent/ethanol/coffee/kahlua
	name = "coffee liqueur"
	description = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936!"
	taste_description = "spiked latte"
	taste_mult = 1.1
	color = "#4c3100"
	strength = 15

	glass_name = "RR coffee liquor"
	glass_desc = "DAMN, THIS THING LOOKS ROBUST"

/datum/reagent/ethanol/melonliquor
	name = "melon liqueur"
	description = "A relatively sweet and fruity 46 proof liqueur."
	taste_description = "fruity alcohol"
	color = "#138808" // rgb: 19, 136, 8
	strength = 50

	glass_name = "melon liqueur"
	glass_desc = "A relatively sweet and fruity 46 proof liquor."

/datum/reagent/ethanol/rum
	name = "rum"
	description = "Yohoho and all that."
	taste_description = "spiked butterscotch"
	taste_mult = 1.1
	color = "#ecb633"
	strength = 15

	glass_name = "rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"

/datum/reagent/ethanol/sake
	name = "sake"
	description = "Anime's favorite drink."
	taste_description = "dry alcohol"
	color = "#dddddd"
	strength = 25

	glass_name = "sake"
	glass_desc = "A glass of sake."

/datum/reagent/ethanol/tequilla
	name = "tequila"
	description = "A strong and mildly flavoured, mexican produced spirit. Feeling thirsty hombre?"
	taste_description = "paint stripper"
	color = "#ffff91"
	strength = 25

	glass_name = "tequilla"
	glass_desc = "Now all that's missing is the weird colored shades!"

/datum/reagent/ethanol/thirteenloko
	name = "Thirteen Loko"
	description = "A potent mixture of caffeine and alcohol."
	taste_description = "jitters and death"
	color = "#102000"
	strength = 25
	nutriment_factor = 1

	glass_name = "Thirteen Loko"
	glass_desc = "This is a glass of Thirteen Loko, it appears to be of the highest quality. The drink, not the glass."

/datum/reagent/ethanol/thirteenloko/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.drowsyness = max(0, M.drowsyness - 7)
	if (M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	M.make_jittery(5)
	M.add_chemical_effect(CE_PULSE, 2)

/datum/reagent/ethanol/vermouth
	name = "vermouth"
	description = "You suddenly feel a craving for a martini..."
	taste_description = "dry alcohol"
	taste_mult = 1.3
	color = "#91ff91" // rgb: 145, 255, 145
	strength = 15

	glass_name = "vermouth"
	glass_desc = "You wonder why you're even drinking this straight."

/datum/reagent/ethanol/vodka
	name = "vodka"
	description = "Number one drink AND fueling choice for Independents around the galaxy."
	taste_description = "grain alcohol"
	color = "#0064c8" // rgb: 0, 100, 200
	strength = 15

	glass_name = "vodka"
	glass_desc = "The glass contain wodka. Xynta."

/datum/reagent/ethanol/vodka/premium
	name = "premium vodka"
	description = "Premium distilled vodka imported directly from the Gilgamesh Colonial Confederation."
	taste_description = "clear kvass"
	color = "#aaddff" // rgb: 170, 221, 255 - very light blue.
	strength = 10

/datum/reagent/ethanol/whiskey
	name = "whiskey"
	description = "A superb and well-aged single-malt whiskey. Damn."
	taste_description = "molasses"
	color = "#4c3100"
	strength = 25

	glass_name = "whiskey"
	glass_desc = "The silky, smokey whiskey goodness inside the glass makes the drink look very classy."

/datum/reagent/ethanol/wine
	name = "wine"
	description = "An premium alchoholic beverage made from distilled grape juice."
	taste_description = "bitter sweetness"
	color = "#7e4043" // rgb: 126, 64, 67
	strength = 15

	glass_name = "wine"
	glass_desc = "A very classy looking drink."

/datum/reagent/ethanol/wine/premium
	name = "white wine"
	description = "An exceptionally expensive alchoholic beverage made from distilled white grapes."
	taste_description = "white velvet"
	color = "#ffddaa" // rgb: 255, 221, 170 - a light cream
	strength = 20

/datum/reagent/ethanol/herbal
	name = "herbal liquor"
	description = "A complex blend of herbs, spices and roots mingle in this old Earth classic."
	taste_description = "a sweet summer garden"
	color = "#dfff00"
	strength = 13

	glass_name = "herbal liquor"
	glass_desc = "It's definitely green. Or is it yellow?"

// Cocktails
/datum/reagent/ethanol/acid_spit
	name = "Acid Spit"
	description = "A drink for the daring, can be deadly if incorrectly prepared!"
	taste_description = "stomach acid"
	color = "#365000"
	strength = 30

	glass_name = "Acid Spit"
	glass_desc = "A drink from the company archives. Made from live aliens."

/datum/reagent/ethanol/alliescocktail
	name = "Allies cocktail"
	description = "A drink made from your allies, not as sweet as when made from your enemies."
	taste_description = "bitter yet free"
	color = "#d8ac45"
	strength = 25

	glass_name = "Allies cocktail"
	glass_desc = "A drink made from your allies."

/datum/reagent/ethanol/aloe
	name = "Aloe"
	description = "So very, very, very good."
	taste_description = "sweet 'n creamy"
	color = "#b7ea75"
	strength = 15

	glass_name = "Aloe"
	glass_desc = "Very, very, very good."

/datum/reagent/ethanol/amasec
	name = "Amasec"
	description = "Official drink of the Gun Club!"
	taste_description = "dark and metallic"
	color = "#ff975d"
	strength = 25

	glass_name = "Amasec"
	glass_desc = "Always handy before COMBAT!!!"

/datum/reagent/ethanol/andalusia
	name = "Andalusia"
	description = "A nice, strangely named drink."
	taste_description = "lemons"
	color = "#f4ea4a"
	strength = 15

	glass_name = "Andalusia"
	glass_desc = "A nice, strange named drink."

/datum/reagent/ethanol/antifreeze
	name = "Anti-freeze"
	description = "Ultimate refreshment."
	taste_description = "Jack Frost's piss"
	color = "#56deea"
	strength = 12
	adj_temp = 20
	targ_temp = 330

	glass_name = "Anti-freeze"
	glass_desc = "The ultimate refreshment."

/datum/reagent/ethanol/atomicbomb
	name = "Atomic Bomb"
	description = "Nuclear proliferation never tasted so good."
	taste_description = "da bomb"
	color = "#666300"
	strength = 10
	druggy = 50

	glass_name = "Atomic Bomb"
	glass_desc = "We cannot take legal responsibility for your actions after imbibing."

/datum/reagent/ethanol/coffee/b52
	name = "B-52"
	description = "Coffee, Irish Cream, and cognac. You will get bombed."
	taste_description = "angry and irish"
	taste_mult = 1.3
	color = "#997650"
	strength = 12

	glass_name = "B-52"
	glass_desc = "Kahlua, Irish cream, and congac. You will get bombed."

/datum/reagent/ethanol/bahama_mama
	name = "Bahama Mama"
	description = "Tropical cocktail."
	taste_description = "lime and orange"
	color = "#ff7f3b"
	strength = 25

	glass_name = "Bahama Mama"
	glass_desc = "Tropical cocktail"

/datum/reagent/ethanol/bananahonk
	name = "Banana Mama"
	description = "A drink from Clown Heaven."
	taste_description = "a bad joke"
	nutriment_factor = 1
	color = "#ffff91"
	strength = 12

	glass_name = "Banana Honk"
	glass_desc = "A drink from Banana Heaven."

/datum/reagent/ethanol/barefoot
	name = "Barefoot"
	description = "Barefoot and pregnant"
	taste_description = "creamy berries"
	color = "#ffcdea"
	strength = 30

	glass_name = "Barefoot"
	glass_desc = "Barefoot and pregnant"

/datum/reagent/ethanol/beepsky_smash
	name = "Beepsky Smash"
	description = "Deny drinking this and prepare for THE LAW."
	taste_description = "JUSTICE"
	taste_mult = 2
	color = "#404040"
	strength = 12

	glass_name = "Beepsky Smash"
	glass_desc = "Heavy, hot and strong. Just like the Iron fist of the LAW."

/datum/reagent/ethanol/beepsky_smash/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.Stun(2)

/datum/reagent/ethanol/bilk
	name = "bilk"
	description = "This appears to be beer mixed with milk. Disgusting."
	taste_description = "desperation and lactate"
	color = "#895c4c"
	strength = 50
	nutriment_factor = 2

	glass_name = "bilk"
	glass_desc = "A brew of milk and beer. For those alcoholics who fear osteoporosis."

/datum/reagent/ethanol/black_russian
	name = "Black Russian"
	description = "For the lactose-intolerant. Still as classy as a White Russian."
	taste_description = "bitterness"
	color = "#360000"
	strength = 15

	glass_name = "Black Russian"
	glass_desc = "For the lactose-intolerant. Still as classy as a White Russian."

/datum/reagent/ethanol/bloody_mary
	name = "Bloody Mary"
	description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Or at least you THINK the red stuff is tomato juice."
	taste_description = "tomatoes with a hint of lime"
	color = "#b40000"
	strength = 15

	glass_name = "Bloody Mary"
	glass_desc = "Tomato juice, mixed with Vodka and a lil' bit of lime. Tastes like liquid murder."

/datum/reagent/ethanol/booger
	name = "Booger"
	description = "Ewww..."
	taste_description = "sweet 'n creamy"
	color = "#8cff8c"
	strength = 30

	glass_name = "Booger"
	glass_desc = "Ewww..."

/datum/reagent/ethanol/coffee/brave_bull
	name = "Brave Bull"
	description = "It's just as effective as Dutch-Courage!"
	taste_description = "alcoholic bravery"
	taste_mult = 1.1
	color = "#4c3100"
	strength = 15

	glass_name = "Brave Bull"
	glass_desc = "Tequilla and coffee liquor, brought together in a mouthwatering mixture. Drink up."

/datum/reagent/ethanol/changelingsting
	name = "Changeling Sting"
	description = "You take a tiny sip and feel a burning sensation..."
	taste_description = "your brain coming out your nose"
	color = "#2e6671"
	strength = 10

	glass_name = "Changeling Sting"
	glass_desc = "A stingy drink."

/datum/reagent/ethanol/martini
	name = "classic martini"
	description = "Vermouth with Gin. Not quite how 007 enjoyed it, but still delicious."
	taste_description = "dry class"
	color = "#0064c8"
	strength = 25

	glass_name = "classic martini"
	glass_desc = "Damn, the bartender even stirred it, not shook it."

/datum/reagent/ethanol/cuba_libre
	name = "Cuba Libre"
	description = "Rum, mixed with cola. Viva la revolucion."
	taste_description = "cola"
	color = "#3e1b00"
	strength = 30

	glass_name = "Cuba Libre"
	glass_desc = "A classic mix of rum and cola."

/datum/reagent/ethanol/demonsblood
	name = "Demons Blood"
	description = "AHHHH!!!!"
	taste_description = "sweet tasting iron"
	taste_mult = 1.5
	color = "#820000"
	strength = 15

	glass_name = "Demons' Blood"
	glass_desc = "Just looking at this thing makes the hair at the back of your neck stand up."

/datum/reagent/ethanol/devilskiss
	name = "Devils Kiss"
	description = "Creepy time!"
	taste_description = "bitter iron"
	color = "#a68310"
	strength = 15

	glass_name = "Devil's Kiss"
	glass_desc = "Creepy time!"

/datum/reagent/ethanol/driestmartini
	name = "driest martini"
	description = "Only for the experienced. You think you see sand floating in the glass."
	taste_description = "a beach"
	nutriment_factor = 1
	color = "#2e6671"
	strength = 12

	glass_name = "driest martini"
	glass_desc = "Only for the experienced. You think you see sand floating in the glass."

/datum/reagent/ethanol/ginfizz
	name = "gin fizz"
	description = "Refreshingly lemony, deliciously dry."
	taste_description = "dry, tart lemons"
	color = "#ffffae"
	strength = 30

	glass_name = "gin fizz"
	glass_desc = "Refreshingly lemony, deliciously dry."

/datum/reagent/ethanol/grog
	name = "grog"
	description = "Watered-down rum, pirate approved!"
	taste_description = "a poor excuse for alcohol"
	color = "#ffbb00"
	strength = 100

	glass_name = "grog"
	glass_desc = "A fine and cepa drink for Space."

/datum/reagent/ethanol/erikasurprise
	name = "Erika Surprise"
	description = "The surprise is, it's green!"
	taste_description = "tartness and bananas"
	color = "#2e6671"
	strength = 15

	glass_name = "Erika Surprise"
	glass_desc = "The surprise is, it's green!"

/datum/reagent/ethanol/livergeist
	name = "The Livergeist"
	description = "Looking at this beverage, you can faintly hear your liver swear it'll come back to haunt you."
	taste_description = "your liver being ripped out of your body, but in the best, most delicious meaning of those words."
	taste_mult = 5
	color = "#7f00ff"
	strength = 10
	glass_name = "The Livergeist"
	glass_desc = "Looking at this beverage, you can faintly hear your liver swear it'll come back to haunt you."

/datum/reagent/ethanol/gintonic
	name = "gin and tonic"
	description = "An all time classic, mild cocktail."
	taste_description = "mild tartness" //???
	color = "#0064c8"
	strength = 50

	glass_name = "gin and tonic"
	glass_desc = "A mild but still great cocktail. Drink up, like a true Englishman."

/datum/reagent/ethanol/goldschlager
	name = "cinnamon schnapps"
	description = "100 proof cinnamon schnapps, made for alcoholic teen girls on spring break."
	taste_description = "burning cinnamon"
	taste_mult = 1.3
	color = "#f4e46d"
	strength = 15

	glass_name = "Goldschlager"
	glass_desc = "100 proof that teen girls will drink anything with gold in it."

/datum/reagent/ethanol/hippies_delight
	name = "Hippies' Delight"
	description = "You just don't get it maaaan."
	taste_description = "giving peace a chance"
	color = "#ff88ff"
	strength = 15
	druggy = 50

	glass_name = "Hippie's Delight"
	glass_desc = "A drink enjoyed by people during the 1960's."

/datum/reagent/ethanol/hooch
	name = "hooch"
	description = "Either someone's failure at cocktail making or attempt in alchohol production. In any case, do you really want to drink that?"
	taste_description = "pure resignation"
	color = "#4c3100"
	strength = 25
	toxicity = 2

	glass_name = "Hooch"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/datum/reagent/ethanol/iced_beer
	name = "iced beer"
	description = "A beer which is so cold the air around it freezes."
	taste_description = "refreshingly cold"
	color = "#ffd300"
	strength = 50
	adj_temp = -20
	targ_temp = 270

	glass_name = "iced beer"
	glass_desc = "A beer so frosty, the air around it freezes."
	glass_special = list(DRINK_ICE)

/datum/reagent/ethanol/irishslammer
	name = "Irish Slammer"
	description = "Mmm, tastes like chocolate cake..."
	taste_description = "delicious anger"
	color = "#2e6671"
	strength = 15

	glass_name = "Irish slammer"
	glass_desc = "An Irish slammer, mixed with cream, whiskey, and ale."

/datum/reagent/ethanol/coffee/irishcoffee
	name = "Irish coffee"
	description = "Coffee, and alcohol. More fun than a Mimosa to drink in the morning."
	taste_description = "giving up on the day"
	color = "#4c3100"
	strength = 15

	glass_name = "Irish coffee"
	glass_desc = "Coffee and alcohol. More fun than a Mimosa to drink in the morning."

/datum/reagent/ethanol/irish_cream
	name = "Irish cream"
	description = "Whiskey-imbued cream, what else would you expect from the Irish."
	taste_description = "creamy alcohol"
	color = "#dddd9a"
	strength = 25

	glass_name = "Irish cream"
	glass_desc = "It's cream, mixed with whiskey. What else would you expect from the Irish?"

/datum/reagent/ethanol/longislandicedtea
	name = "Long Island Iced Tea"
	description = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
	taste_description = "a mixture of cola and alcohol"
	color = "#895b1f"
	strength = 12

	glass_name = "Long Island iced tea"
	glass_desc = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."

/datum/reagent/ethanol/manhattan
	name = "Manhattan"
	description = "The Detective's undercover drink of choice. He never could stomach gin..."
	taste_description = "mild dryness"
	color = "#c13600"
	strength = 15

	glass_name = "Manhattan"
	glass_desc = "The Detective's undercover drink of choice. He never could stomach gin..."

/datum/reagent/ethanol/manhattan_proj
	name = "Manhattan Project"
	description = "A scientist's drink of choice, for pondering ways to blow stuff up."
	taste_description = "death, the destroyer of worlds"
	color = "#c15d00"
	strength = 10
	druggy = 30

	glass_name = "Manhattan Project"
	glass_desc = "A scientist's drink of choice, for pondering ways to blow stuff up."

/datum/reagent/ethanol/manly_dorf
	name = "Manly Dorf"
	description = "Beer and Ale, brought together in a delicious mix. Intended for true men only."
	taste_description = "hair on your chest and your chin"
	color = "#4c3100"
	strength = 25

	glass_name = "Manly Dorf"
	glass_desc = "A manly concotion made from Ale and Beer. Intended for true men only."

/datum/reagent/ethanol/margarita
	name = "margarita"
	description = "On the rocks with salt on the rim. Arriba~!"
	taste_description = "dry and salty"
	color = "#8cff8c"
	strength = 15

	glass_name = "margarita"
	glass_desc = "On the rocks with salt on the rim. Arriba~!"

/datum/reagent/ethanol/mead
	name = "mead"
	description = "A Viking's drink, though a cheap one."
	taste_description = "sweet, sweet alcohol"
	color = "#ffbb00"
	strength = 30
	nutriment_factor = 1

	glass_name = "mead"
	glass_desc = "A Viking's beverage, though a cheap one."

/datum/reagent/ethanol/moonshine
	name = "moonshine"
	description = "You've really hit rock bottom now... your liver packed its bags and left last night."
	taste_description = "bitterness"
	taste_mult = 2.5
	color = "#0064c8"
	strength = 12

	glass_name = "moonshine"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/datum/reagent/ethanol/neurotoxin
	name = "Neurotoxin"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	taste_description = "a numbing sensation"
	color = "#2e2e61"
	strength = 10

	glass_name = "Neurotoxin"
	glass_desc = "A drink that is guaranteed to knock you silly."
	glass_icon = DRINK_ICON_NOISY
	glass_special = list("neuroright")

/datum/reagent/ethanol/neurotoxin/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.Weaken(3)
	M.add_chemical_effect(CE_PULSE, -1)

/datum/reagent/ethanol/patron
	name = "Patron"
	description = "Tequila with silver in it, a favorite of alcoholic women in the club scene."
	taste_description = "metallic and expensive"
	color = "#585840"
	strength = 30

	glass_name = "Patron"
	glass_desc = "Drinking patron in the bar, with all the subpar ladies."

/datum/reagent/ethanol/pwine
	name = "poison wine"
	description = "Is this even wine? Toxic! Hallucinogenic! Probably consumed in boatloads by your superiors!"
	taste_description = "purified alcoholic death"
	color = "#000000"
	strength = 10
	druggy = 50
	halluci = 10

	glass_name = "???"
	glass_desc = "A black ichor with an oily purple sheer on top. Are you sure you should drink this?"

/datum/reagent/ethanol/pwine/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
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

/datum/reagent/ethanol/red_mead
	name = "red mead"
	description = "The true Viking's drink! Even though it has a strange red color."
	taste_description = "sweet and salty alcohol"
	color = "#c73c00"
	strength = 30

	glass_name = "red mead"
	glass_desc = "A true Viking's beverage, though its color is strange."

/datum/reagent/ethanol/sbiten
	name = "sbiten"
	description = "A spicy mead! Might be a little hot for the little guys!"
	taste_description = "hot and spice"
	color = "#ffa371"
	strength = 15
	adj_temp = 50
	targ_temp = 360

	glass_name = "Sbiten"
	glass_desc = "A spicy mix of Mead and Spice. Very hot."

/datum/reagent/ethanol/screwdrivercocktail
	name = "Screwdriver"
	description = "Vodka, mixed with plain ol' orange juice. The result is surprisingly delicious."
	taste_description = "oranges"
	color = "#a68310"
	strength = 15

	glass_name = "Screwdriver"
	glass_desc = "A simple, yet superb mixture of Vodka and orange juice. Just the thing for the tired engineer."

/datum/reagent/ethanol/ships_surgeon
	name = "Ship's Surgeon"
	description = "Rum and Dr. Gibb. Served ice cold, like the scalpel."
	taste_description = "black comedy"
	color = "#524d0f"
	strength = 15

	glass_name = "ship's surgeon"
	glass_desc = "Rum qualified for surgical practice by Dr. Gibb. Smooth and steady."

/datum/reagent/ethanol/silencer
	name = "Silencer"
	description = "A drink from Mime Heaven."
	taste_description = "a pencil eraser"
	taste_mult = 1.2
	nutriment_factor = 1
	color = "#ffffff"
	strength = 12

	glass_name = "Silencer"
	glass_desc = "A drink from mime Heaven."

/datum/reagent/ethanol/singulo
	name = "Singulo"
	description = "A blue-space beverage!"
	taste_description = "concentrated matter"
	color = "#2e6671"
	strength = 10

	glass_name = "Singulo"
	glass_desc = "A blue-space beverage."

/datum/reagent/ethanol/snowwhite
	name = "Snow White"
	description = "A cold refreshment"
	taste_description = "refreshing cold"
	color = "#ffffff"
	strength = 30

	glass_name = "Snow White"
	glass_desc = "A cold refreshment."

/datum/reagent/ethanol/suidream
	name = "Sui Dream"
	description = "Comprised of: White soda, blue curacao, melon liquor."
	taste_description = "fruit"
	color = "#00a86b"
	strength = 100

	glass_name = "Sui Dream"
	glass_desc = "A froofy, fruity, and sweet mixed drink. Understanding the name only brings shame."

/datum/reagent/ethanol/syndicatebomb
	name = "Syndicate Bomb"
	description = "Tastes like terrorism!"
	taste_description = "purified antagonism"
	color = "#2e6671"
	strength = 10

	glass_name = "Syndicate Bomb"
	glass_desc = "Tastes like terrorism!"

/datum/reagent/ethanol/tequilla_sunrise
	name = "Tequila Sunrise"
	description = "Tequila and orange juice. Much like a Screwdriver, only Mexican~"
	taste_description = "oranges"
	color = "#ffe48c"
	strength = 25

	glass_name = "Tequilla Sunrise"
	glass_desc = "Oh great, now you feel nostalgic about sunrises back on Terra..."

/datum/reagent/ethanol/threemileisland
	name = "Three Mile Island Iced Tea"
	description = "Made for a woman, strong enough for a man."
	taste_description = "dry"
	color = "#666340"
	strength = 10
	druggy = 50

	glass_name = "Three Mile Island iced tea"
	glass_desc = "A glass of this is sure to prevent a meltdown."

/datum/reagent/ethanol/toxins_special
	name = "Toxins Special"
	description = "This thing is ON FIRE! CALL THE DAMN SHUTTLE!"
	taste_description = "spicy toxins"
	color = "#7f00ff"
	strength = 10
	adj_temp = 15
	targ_temp = 330

	glass_name = "Toxins Special"
	glass_desc = "Whoah, this thing is on FIRE"

/datum/reagent/ethanol/vodkamartini
	name = "vodka martini"
	description = "Vodka with Gin. Not quite how 007 enjoyed it, but still delicious."
	taste_description = "shaken, not stirred"
	color = "#0064c8"
	strength = 12

	glass_name = "vodka martini"
	glass_desc ="A bastardisation of the classic martini. Still great."


/datum/reagent/ethanol/vodkatonic
	name = "vodka and tonic"
	description = "For when a gin and tonic isn't russian enough."
	taste_description = "tart bitterness"
	color = "#0064c8" // rgb: 0, 100, 200
	strength = 15

	glass_name = "vodka and tonic"
	glass_desc = "For when a gin and tonic isn't Russian enough."


/datum/reagent/ethanol/white_russian
	name = "White Russian"
	description = "That's just, like, your opinion, man..."
	taste_description = "bitter cream"
	color = "#a68340"
	strength = 15

	glass_name = "White Russian"
	glass_desc = "A very nice looking drink. But that's just, like, your opinion, man."


/datum/reagent/ethanol/whiskey_cola
	name = "whiskey cola"
	description = "Whiskey, mixed with cola. Surprisingly refreshing."
	taste_description = "cola"
	color = "#3e1b00"
	strength = 25

	glass_name = "whiskey cola"
	glass_desc = "An innocent-looking mixture of cola and Whiskey. Delicious."


/datum/reagent/ethanol/whiskeysoda
	name = "whiskey soda"
	description = "For the more refined griffon."
	color = "#eab300"
	strength = 15

	glass_name = "whiskey soda"
	glass_desc = "Ultimate refreshment."

/datum/reagent/ethanol/aged_whiskey // I have no idea what this is and where it comes from.  //It comes from Dinnlan now 
	name = "aged whiskey"
	description = "A well-aged whiskey of high quality. Probably imported. Just a sip'll do it, but that burn will leave you wanting more."
	color = "#523600"
	strength = 25

	glass_name = "aged whiskey"
	glass_desc = "A well-aged whiskey of high quality. Probably imported."

/datum/reagent/ethanol/applecider
	name = "apple cider"
	description = "A refreshing glass of apple cider."
	taste_description = "cool apple cider"
	color = "#cac089"
	strength = 50

	glass_name = "apple cider"
	glass_desc = "A refreshing glass of apple cider."

/datum/reagent/ethanol/arak
	name = "Arak"
	description = "An unsweetened aniseed and grape mixture."
	taste_description = "oil and licorice"
	color = "#f7f6e0"
	strength = 20

	glass_name = "arak"
	glass_desc = "An unsweetened mixture of aniseed and grape."

/datum/reagent/ethanol/champagne
	name = "champagne"
	description = "Smooth sparkling wine, produced in the same region of France as it has for centuries."
	taste_description = "a superior taste of sparkling wine"
	color = "#e8dfc1"
	strength = 25

	glass_name = "champagne"
	glass_desc = "Smooth sparkling wine, produced in the same region of France as it has for centuries."

/datum/reagent/ethanol/sawbonesdismay
	name = "Sawbones' Dismay"
	description = "The Tradehouse Surgeon general doesn't recommend mixing stimulants and depressants, but who listens to those warnings, anyhow?"
	taste_description = "a pick-me-up and put-me-down"
	color = "#996862"
	strength = 10

	glass_name = "Sawbones' Dismay"
	glass_desc = "The Tradehouse Surgeon general doesn't recommend mixing stimulants and depressants, but who listens to those warnings, anyhow?"

/datum/reagent/ethanol/jagermeister
	name = "Jagermeister"
	description = "A special blend of alcohol, herbs, and spices. It has remained a popular Earther drink."
	taste_description = "herbs, spices, and alcohol"
	color = "#596e3e"
	strength = 20

	glass_name = "jagermeister"
	glass_desc = "A special blend of alcohol, herbs, and spaces. It has remained a popular Earther drink."

/datum/reagent/ethanol/kvass
	name = "kvass"
	description = "An alcoholic drink commonly made from bread."
	taste_description = "vkusnyy kvas, ypa!"
	color = "#362f22"
	strength = 30

	glass_name = "kvass"
	glass_desc = "An alcoholic drink commonly made from bread."

/datum/reagent/ethanol/vodkacola
	name = "vodka cola"
	description = "A refreshing mix of vodka and cola."
	taste_description = "vodka and cola"
	color = "#474238"
	strength = 15
	glass_name = "vodka cola"
	glass_desc = "A refreshing mix of vodka and cola."