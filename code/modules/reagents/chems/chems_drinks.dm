/decl/material/drink
	name = "drink"
	description = "Uh, some kind of drink."
	color = "#e78108"
	hidden_from_codex = TRUE // They don't need to generate a codex entry, their recipes will do that.
	value = 1.2

	var/nutrition = 0 // Per unit
	var/hydration = 6 // Per unit
	var/adj_dizzy = 0 // Per tick
	var/adj_drowsy = 0
	var/adj_sleepy = 0
	var/adj_temp = 0

/decl/material/drink/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustToxLoss(removed) // Probably not a good idea; not very deadly though

/decl/material/drink/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(nutrition)
		M.adjust_nutrition(nutrition * removed)
	if(hydration)
		M.adjust_hydration(hydration * removed)
	M.dizziness = max(0, M.dizziness + adj_dizzy)
	M.drowsyness = max(0, M.drowsyness + adj_drowsy)
	M.sleeping = max(0, M.sleeping + adj_sleepy)
	if(adj_temp > 0 && M.bodytemperature < 310) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(310, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && M.bodytemperature > 310)
		M.bodytemperature = min(310, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

// Juices
/decl/material/drink/juice/affect_ingest(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.immunity = min(M.immunity + 0.25, M.immunity_norm*1.5)

/decl/material/drink/juice/banana
	name = "banana juice"
	description = "The raw essence of a banana."
	taste_description = "banana"
	color = "#c3af00"

	glass_name = "banana juice"
	glass_desc = "The raw essence of a banana. HONK!"

/decl/material/drink/juice/berry
	name = "berry juice"
	description = "A delicious blend of several different kinds of berries."
	taste_description = "berries"
	color = "#990066"

	glass_name = "berry juice"
	glass_desc = "Berry juice. Or maybe it's jam. Who cares?"

/decl/material/drink/juice/carrot
	name = "carrot juice"
	description = "It is just like a carrot but without crunching."
	taste_description = "carrots"
	color = "#ff8c00" // rgb: 255, 140, 0

	glass_name = "carrot juice"
	glass_desc = "It is just like a carrot but without crunching."

/decl/material/drink/juice/carrot/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.reagents.add_reagent(/decl/material/eyedrops, removed * 0.2)

/decl/material/drink/juice/grape
	name = "grape juice"
	description = "It's grrrrrape!"
	taste_description = "grapes"
	color = "#863333"

	glass_name = "grape juice"
	glass_desc = "It's grrrrrape!"

/decl/material/drink/juice/lemon
	name = "lemon juice"
	description = "This juice is VERY sour."
	taste_description = "sourness"
	taste_mult = 1.1
	color = "#afaf00"

	glass_name = "lemon juice"
	glass_desc = "Sour..."

/decl/material/drink/juice/lime
	name = "lime juice"
	description = "The sweet-sour juice of limes."
	taste_description = "unbearable sourness"
	taste_mult = 1.1
	color = "#365e30"

	glass_name = "lime juice"
	glass_desc = "A glass of sweet-sour lime juice"

/decl/material/drink/juice/lime/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.adjustToxLoss(-0.5 * removed)

/decl/material/drink/juice/orange
	name = "orange juice"
	description = "Both delicious AND rich in Vitamin C, what more do you need?"
	taste_description = "oranges"
	color = "#e78108"

	glass_name = "orange juice"
	glass_desc = "Vitamins! Yay!"

/decl/material/drink/juice/orange/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.adjustOxyLoss(-2 * removed)

/decl/material/toxin/poisonberryjuice // It has more in common with toxins than drinks... but it's a juice
	name = "poison berry juice"
	description = "A tasty juice blended from various kinds of very deadly and toxic berries."
	taste_description = "berries"
	color = "#863353"
	strength = 5

	glass_name = "poison berry juice"
	glass_desc = "A glass of deadly juice."

/decl/material/drink/juice/potato
	name = "potato juice"
	description = "Juice of the potato. Bleh."
	taste_description = "sadness and potatoes"
	nutrition = 2
	color = "#302000"

	glass_name = "potato juice"
	glass_desc = "Juice from a potato. Bleh."

/decl/material/drink/juice/garlic
	name = "garlic juice"
	description = "Who would even drink this?"
	taste_description = "bad breath"
	nutrition = 1
	color = "#eeddcc"

	glass_name = "garlic juice"
	glass_desc = "Who would even drink juice from garlic?"

/decl/material/drink/juice/onion
	name = "onion juice"
	description = "Juice from an onion, for when you need to cry."
	taste_description = "stinging tears"
	nutrition = 1
	color = "#ffeedd"

	glass_name = "onion juice"
	glass_desc = "Juice from an onion, for when you need to cry."

/decl/material/drink/juice/tomato
	name = "tomato juice"
	description = "Tomatoes made into juice. What a waste of big, juicy tomatoes, huh?"
	taste_description = "tomatoes"
	color = "#731008"

	glass_name = "tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

/decl/material/drink/juice/tomato/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.heal_organ_damage(0, 0.5 * removed)

/decl/material/drink/juice/watermelon
	name = "watermelon juice"
	description = "Delicious juice made from watermelon."
	taste_description = "sweet watermelon"
	color = "#b83333"

	glass_name = "watermelon juice"
	glass_desc = "Delicious juice made from watermelon."

/decl/material/drink/juice/turnip
	name = "turnip juice"
	description = "Delicious (?) juice made from turnips."
	taste_description = "turnip and uncertainty"
	color = "#b1166e"

	glass_name = "turnip juice"
	glass_desc = "Delicious (?) juice made from turnips."

/decl/material/drink/juice/apple
	name = "apple juice"
	description = "Delicious sweet juice made from apples."
	taste_description = "sweet apples"
	color = "#c07c40"

	glass_name = "apple juice"
	glass_desc = "Delicious juice made from apples."

/decl/material/drink/juice/pear
	name = "pear juice"
	description = "Delicious sweet juice made from pears."
	taste_description = "sweet pears"
	color = "#ffff66"

	glass_name = "pear juice"
	glass_desc = "Delicious juice made from pears."

// Everything else

/decl/material/drink/milk
	name = "milk"
	description = "An opaque white liquid produced by tiplods."
	taste_description = "milk"
	color = "#dfdfdf"

	glass_name = "milk"
	glass_desc = "White and nutritious goodness!"

/decl/material/drink/milk/chocolate
	name =  "chocolate milk"
	description = "A mixture of perfectly healthy milk and delicious chocolate."
	taste_description = "chocolate milk"
	color = "#74533b"

	glass_name = "chocolate milk"
	glass_desc = "Deliciously fattening!"

/decl/material/drink/milk/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.heal_organ_damage(0.5 * removed, 0)
	holder.remove_reagent(/decl/material/capsaicin, 10 * removed)

/decl/material/drink/milk/cream
	name = "cream"
	description = "The fatty, still liquid part of milk."
	taste_description = "creamy milk"
	color = "#dfd7af"

	glass_name = "cream"
	glass_desc = "Ewwww..."

/decl/material/drink/milk/soymilk
	name = "soy milk"
	description = "An opaque white liquid made from soybeans."
	taste_description = "soy milk"
	color = "#dfdfc7"

	glass_name = "soy milk"
	glass_desc = "White and nutritious soy goodness!"

/decl/material/drink/coffee
	name = "coffee"
	description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
	taste_description = "bitterness"
	taste_mult = 1.3
	color = "#482000"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	adj_temp = 25
	overdose = 60

	glass_name = "coffee"
	glass_desc = "Don't drop it, or you'll send scalding liquid and glass shards everywhere."

/decl/material/drink/coffee/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(adj_temp > 0)
		holder.remove_reagent(/decl/material/frostoil, 10 * removed)
	var/volume = REAGENT_VOLUME(holder, type)
	if(volume > 15)
		M.add_chemical_effect(CE_PULSE, 1)
	if(volume > 45)
		M.add_chemical_effect(CE_PULSE, 1)

/decl/material/nutriment/coffee/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.add_chemical_effect(CE_PULSE, 2)

/decl/material/drink/coffee/affect_overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	M.make_jittery(5)
	M.add_chemical_effect(CE_PULSE, 1)

/decl/material/drink/coffee/icecoffee
	name = "iced coffee"
	description = "Coffee and ice, refreshing and cool."
	taste_description = "bitter coldness"
	color = "#102838"
	adj_temp = -5

	glass_name = "iced coffee"
	glass_desc = "A drink to perk you up and refresh you!"
	glass_special = list(DRINK_ICE)

/decl/material/drink/coffee/soy_latte
	name = "soy latte"
	description = "A nice and tasty beverage while you are reading your nature books."
	taste_description = "bitter creamy coffee"
	color = "#c65905"
	adj_temp = 5

	glass_name = "soy latte"
	glass_desc = "A nice and refreshing beverage while you are reading your nature books."

/decl/material/drink/coffee/soy_latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.heal_organ_damage(0.5 * removed, 0)

/decl/material/drink/coffee/icecoffee/soy_latte
	name = "iced soy latte"
	description = "A nice and tasty beverage while you are reading your nature books. This one's cold."
	taste_description = "cold bitter creamy coffee"
	color = "#c65905"

	glass_name = "iced soy latte"
	glass_desc = "A nice and refreshing beverage while you are reading your nature books. This one's cold."

/decl/material/drink/coffee/icecoffee/soy_latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.heal_organ_damage(0.5 * removed, 0)

/decl/material/drink/coffee/cafe_latte
	name = "cafe latte"
	description = "A nice, strong and tasty beverage while you are reading."
	taste_description = "bitter creamy coffee"
	color = "#c65905"
	adj_temp = 5

	glass_name = "cafe latte"
	glass_desc = "A nice, strong and refreshing beverage while you are reading."

/decl/material/drink/coffee/cafe_latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.heal_organ_damage(0.5 * removed, 0)

/decl/material/drink/coffee/icecoffee/cafe_latte
	name = "iced cafe latte"
	description = "A nice, strong and refreshing beverage while you are reading. This one's cold."
	taste_description = "cold bitter creamy coffee"
	color = "#c65905"

	glass_name = "iced cafe latte"
	glass_desc = "A nice, strong and refreshing beverage while you are reading. This one's cold."

/decl/material/drink/coffee/icecoffee/cafe_latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.heal_organ_damage(0.5 * removed, 0)

/decl/material/drink/coffee/cafe_latte/mocha
	name = "mocha latte"
	description = "Coffee and chocolate, smooth and creamy."
	taste_description = "bitter creamy chocolate"

	glass_name = "mocha latte"
	glass_desc = "Coffee and chocolate, smooth and creamy."

/decl/material/drink/coffee/soy_latte/mocha
	name = "mocha soy latte"
	description = "Coffee, soy, and chocolate, smooth and creamy."
	taste_description = "bitter creamy chocolate"

	glass_name = "mocha soy latte"
	glass_desc = "Coffee, soy, and chocolate, smooth and creamy."

/decl/material/drink/coffee/icecoffee/cafe_latte/mocha
	name = "iced mocha latte"
	description = "Coffee and chocolate, smooth and creamy. This one's cold."
	taste_description = "cold bitter creamy chocolate"

	glass_name = "iced mocha latte"
	glass_desc = "Coffee and chocolate, smooth and creamy. This one's cold."

/decl/material/drink/coffee/icecoffee/soy_latte/mocha
	name = "iced soy mocha latte"
	description = "Coffee, soy, and chocolate, smooth and creamy. This one's cold."
	taste_description = "cold bitter creamy chocolate"

	glass_name = "iced soy mocha latte"
	glass_desc = "Coffee, soy, and chocolate, smooth and creamy. This one's cold."

/decl/material/drink/coffee/cafe_latte/pumpkin
	name = "pumpkin spice latte"
	description = "Smells and tastes like Autumn."
	taste_description = "bitter creamy pumpkin spice"

	glass_name = "pumpkin spice latte"
	glass_desc = "Smells and tastes like Autumn."

/decl/material/drink/coffee/soy_latte/pumpkin
	name = "pumpkin spice soy latte"
	description = "Smells and tastes like Autumn."
	taste_description = "bitter creamy pumpkin spice"

	glass_name = "pumpkin spice soy latte"
	glass_desc = "Smells and tastes like Autumn."

/decl/material/drink/coffee/icecoffee/cafe_latte/pumpkin
	name = "iced pumpkin spice latte"
	description = "Smells and tastes like Autumn. This one's cold"
	taste_description = "cold bitter creamy pumpkin spice"

	glass_name = "iced pumpkin spice latte"
	glass_desc = "Smells and tastes like Autumn. This one's cold."

/decl/material/drink/coffee/icecoffee/soy_latte/pumpkin
	name = "iced pumpkin spice soy latte"
	description = "Smells and tastes like Autumn. This one's cold"
	taste_description = "cold bitter creamy pumpkin spice"

	glass_name = "iced pumpkin spice soy latte"
	glass_desc = "Smells and tastes like Autumn. This one's cold."

/decl/material/drink/hot_coco
	name = "hot chocolate"
	description = "Made with love! And cocoa beans."
	taste_description = "creamy chocolate"
	color = "#403010"
	nutrition = 2
	adj_temp = 5

	glass_name = "hot chocolate"
	glass_desc = "Made with love! And cocoa beans."

/decl/material/drink/sodawater
	name = "soda water"
	description = "Carbonated water, the most boring carbonated drink known to science."
	taste_description = "bubbles"
	color = "#619494"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_temp = -5

	glass_name = "soda water"
	glass_desc = "A glass of fizzy soda water."
	glass_special = list(DRINK_FIZZ)

/decl/material/drink/grapesoda
	name = "grape soda"
	description = "Grapes made into a fine drank."
	taste_description = "grape soda"
	color = "#421c52"
	adj_drowsy = -3

	glass_name = "grape soda"
	glass_desc = "Looks like a delicious drink!"
	glass_special = list(DRINK_FIZZ)

/decl/material/drink/tonic
	name = "tonic water"
	description = "It tastes strange but at least the quinine keeps the Space Malaria at bay."
	taste_description = "tart and fresh"
	color = "#619494"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	adj_temp = -5

	glass_name = "tonic water"
	glass_desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."

/decl/material/drink/lemonade
	name = "lemonade"
	description = "Oh the nostalgia..."
	taste_description = "tartness"
	color = "#ffff00"
	adj_temp = -5

	glass_name = "lemonade"
	glass_desc = "Oh the nostalgia..."
	glass_special = list(DRINK_FIZZ)

/decl/material/drink/citrusseltzer
	name = "citrus seltzer"
	description = "A tasty blend of fizz and citrus."
	taste_description = "tart and tasty"
	color = "#cccc99"
	adj_temp = -5

	glass_name = "citrus seltzer"
	glass_desc = "A tasty blend of fizz and citrus."
	glass_special = list(DRINK_FIZZ)

/decl/material/drink/orangecola
	name = "orange cola"
	description = "A traditional cola experience with a refreshing spritz of orange citrus flavour."
	taste_description = "orange and cola"
	color = "#9f3400"
	adj_temp = -2

	glass_name = "orange cola"
	glass_desc = "It's an unpleasant shade of muddy brown, and smells like over-ripe citrus."

/decl/material/drink/milkshake
	name = "milkshake"
	description = "Glorious brainfreezing mixture."
	taste_description = "creamy vanilla"
	color = "#aee5e4"
	adj_temp = -9

	glass_name = "milkshake"
	glass_desc = "Glorious brainfreezing mixture."

/decl/material/drink/rewriter
	name = "Rewriter"
	description = "The secret of the sanctuary of the Libarian..."
	taste_description = "a bad night out"
	color = "#485000"
	adj_temp = -5

	glass_name = "Rewriter"
	glass_desc = "The secret of the sanctuary of the Libarian..."

/decl/material/drink/rewriter/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.make_jittery(5)

/decl/material/drink/mutagencola
	name = "mutagen cola"
	description = "The energy of a radioactive isotope in beverage form."
	taste_description = "cancer"
	color = "#100800"
	adj_temp = -5
	adj_sleepy = -2

	glass_name = "mutagen cola"
	glass_desc = "The unstable energy of a radioactive isotope in beverage form."
	glass_special = list(DRINK_FIZZ)

/decl/material/drink/mutagencola/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	M.make_jittery(20)
	M.druggy = max(M.druggy, 30)
	M.dizziness += 5
	M.drowsyness = 0

/decl/material/drink/grenadine
	name = "grenadine syrup"
	description = "Made in the modern day with proper pomegranate substitute. Who uses real fruit, anyways?"
	taste_description = "100% pure pomegranate"
	color = "#ff004f"

	glass_name = "grenadine syrup"
	glass_desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."

/decl/material/drink/cola
	name = "cola"
	description = "A refreshing beverage."
	taste_description = "cola"
	color = "#100800"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = "cola"
	glass_desc = "A glass of refreshing cola."
	glass_special = list(DRINK_FIZZ)

/decl/material/drink/citrussoda
	name = "citrus soda"
	description = "Fizzy and tangy."
	taste_description = "sweet citrus soda"
	color = "#102000"
	adj_drowsy = -7
	adj_sleepy = -1
	adj_temp = -5

	glass_name = "citrus soda"
	glass_desc = "A glass of fizzy citrus soda."
	glass_special = list(DRINK_FIZZ)

/decl/material/drink/cherrycola
	name = "cherry soda"
	description = "A delicious blend of 42 different flavours"
	taste_description = "cherry soda"
	color = "#102000"
	adj_drowsy = -6
	adj_temp = -5

	glass_name = "cherry soda"
	glass_desc = "A glass of cherry soda, a delicious blend of 42 flavours."

/decl/material/drink/lemonade
	name = "lemonade"
	description = "Tastes like a hull breach in your mouth."
	taste_description = "a hull breach"
	color = "#202800"
	adj_temp = -8

	glass_name = "lemonade"
	glass_desc = "A glass of lemonade. It helps keep you cool."
	glass_special = list(DRINK_FIZZ)

/decl/material/drink/lemon_lime
	name = "lemon-lime soda"
	description = "A tangy substance made of 0.5% natural citrus!"
	taste_description = "tangy lime and lemon soda"
	color = "#878f00"
	adj_temp = -8

	glass_name = "lemon lime soda"
	glass_desc = "A tangy substance made of 0.5% natural citrus!"
	glass_special = list(DRINK_FIZZ)

/decl/material/drink/doctor_delight
	name = "The Doctor's Delight"
	description = "Tasty drink that keeps you healthy and doctors bored.  Just the way they like it."
	taste_description = "homely fruit"
	color = "#ff8cff"
	nutrition = 1

	glass_name = "The Doctor's Delight"
	glass_desc = "A healthy mixture of juices, guaranteed to keep you healthy until the next exile decides to put a few new holes in you."

/decl/material/drink/doctor_delight/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.adjustOxyLoss(-4 * removed)
	M.heal_organ_damage(2 * removed, 2 * removed)
	M.adjustToxLoss(-2 * removed)
	if(M.dizziness)
		M.dizziness = max(0, M.dizziness - 15)
	if(M.confused)
		M.confused = max(0, M.confused - 5)

/decl/material/drink/dry_ramen
	name = "dry ramen"
	description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
	taste_description = "dry and cheap noodles"
	nutrition = 1
	color = "#302000"

/decl/material/drink/hot_ramen
	name = "hot ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	taste_description = "wet and cheap noodles"
	color = "#302000"
	nutrition = 5
	adj_temp = 5

/decl/material/drink/hell_ramen
	name = "hell ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	taste_description = "wet and cheap noodles on fire"
	color = "#302000"
	nutrition = 5

/decl/material/drink/hell_ramen/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.bodytemperature += 10 * TEMPERATURE_DAMAGE_COEFFICIENT

/decl/material/drink/nothing
	name = "nothing"
	description = "Absolutely nothing."
	taste_description = "nothing"

	glass_name = "nothing"
	glass_desc = "Absolutely nothing."

/decl/material/drink/tea
	name = "black tea"
	description = "Tasty black tea, it has antioxidants, it's good for you!"
	taste_description = "tart black tea"
	color = "#101000"
	adj_dizzy = -2
	adj_drowsy = -1
	adj_sleepy = -3
	adj_temp = 20

	glass_name = "black tea"
	glass_desc = "Tasty black tea, it has antioxidants, it's good for you!"

/decl/material/drink/tea/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.adjustToxLoss(-0.5 * removed)

/decl/material/drink/tea/icetea
	name = "iced black tea"
	description = "It's the black tea you know and love, but now it's cold."
	taste_description = "cold black tea"
	adj_temp = -5

	glass_name = "iced black tea"
	glass_desc = "It's the black tea you know and love, but now it's cold."
	glass_special = list(DRINK_ICE)

/decl/material/drink/tea/icetea/sweet
	name = "sweet black tea"
	description = "It's the black tea you know and love, but now it's cold. And sweet."
	taste_description = "sweet tea"

	glass_name = "sweet black tea"
	glass_desc = "It's the black tea you know and love, but now it's cold. And sweet."

/decl/material/drink/tea/barongrey
	name = "Baron Grey tea"
	description = "Black tea prepared with standard orange flavoring. Much less fancy than the bergamot in Earl Grey, but the chances of you getting any of that stuff out here is pretty slim."
	taste_description = "tangy black tea"

	glass_name = "Baron Grey tea"
	glass_desc = "Black tea prepared with standard orange flavoring. Much less fancy than the bergamot in Earl Grey, but the chances of you getting any of that stuff out here is pretty slim."

/decl/material/drink/tea/barongrey/latte
	name = "London Fog"
	description = "A blend of Earl Grey (Or more likely Baron Grey) and steamed milk, making a pleasant tangy tea latte."
	taste_description = "creamy, tangy black tea"

	glass_name = "London Fog"
	glass_desc = "A blend of Earl Grey (Or more likely Baron Grey) and steamed milk, making a pleasant tangy tea latte."

/decl/material/drink/tea/barongrey/soy_latte
	name = "soy London Fog"
	description = "A blend of Earl Grey (Or more likely Baron Grey) and steamed soy milk, making a pleasant tangy tea latte."
	taste_description = "creamy, tangy black tea"

	glass_name = "Soy London Fog"
	glass_desc = "A blend of Earl Grey (Or more likely Baron Grey) and steamed soy milk, making a pleasant tangy tea latte."

/decl/material/drink/tea/icetea/barongrey/latte
	name = "iced London Fog"
	description = "A blend of Earl Grey (Or more likely Baron Grey) and steamed milk, making a pleasant tangy tea latte. This one's cold."
	taste_description = "cold, creamy, tangy black tea"

	glass_name = "iced london fog"
	glass_desc = "A blend of Earl Grey (Or more likely Baron Grey) and steamed milk, making a pleasant tangy tea latte. This one's cold."

/decl/material/drink/tea/icetea/barongrey/soy_latte
	name = "iced soy London Fog"
	description = "A blend of Earl Grey (Or more likely Baron Grey) and steamed soy milk, making a pleasant tangy tea latte. This one's cold."
	taste_description = "cold, creamy, tangy black tea"

	glass_name = "iced soy london fog"
	glass_desc = "A blend of Earl Grey (Or more likely Baron Grey) and steamed soy milk, making a pleasant tangy tea latte. This one's cold."

//green tea
/decl/material/drink/tea/green
	name = "green tea"
	description = "Subtle green tea, it has antioxidants, it's good for you!"
	taste_description = "subtle green tea"
	color = "#b4cd94"

	glass_name = "green tea"
	glass_desc = "Subtle green tea, it has antioxidants, it's good for you!"

/decl/material/drink/tea/icetea/green
	name = "iced green tea"
	description = "It's the green tea you know and love, but now it's cold."
	taste_description = "cold green tea"
	color = "#b4cd94"

	glass_name = "iced green tea"
	glass_desc = "It's the green tea you know and love, but now it's cold."

/decl/material/drink/tea/icetea/green/sweet
	name = "sweet green tea"
	description = "It's the green tea you know and love, but now it's cold. And sweet."
	taste_description = "sweet green tea"
	color = "#b4cd94"

	glass_name = "sweet green tea"
	glass_desc = "It's the green tea you know and love, but now it's cold. And sweet."

/decl/material/drink/tea/icetea/green/sweet/mint
	name = "mint tea"
	description = "Iced green tea prepared with mint and sugar. Refreshing!"
	taste_description = "refreshing mint tea"

	glass_name = "mint tea"
	glass_desc = "Iced green tea prepared with mint and sugar. Refreshing!"

/decl/material/drink/tea/chai
	name = "chai"
	description = "A spiced, dark tea. Goes great with milk."
	taste_description = "spiced black tea"
	color = "#151000"

	glass_name = "chai"
	glass_desc = "A spiced, dark tea. Goes great with milk."

/decl/material/drink/tea/icetea/chai
	name = "iced chai"
	description = "It's the chai tea you know and love, but now it's cold."
	taste_description = "cold spiced black tea"
	color = "#151000"

	glass_name = "iced chai"
	glass_desc = "It's the spiced tea you know and love, but now it's cold."

/decl/material/drink/tea/icetea/chai/sweet
	name = "sweet chai"
	description = "It's the chai tea you know and love, but now it's cold. And sweet."
	taste_description = "sweet spiced black tea"

	glass_name = "sweet chai"
	glass_desc = "It's the chai tea you know and love, but now it's cold. And sweet."

/decl/material/drink/tea/chai/latte
	name = "chai latte"
	description = "A warm, inviting cup of spiced, dark tea mixed with steamed milk."
	taste_description = "creamy spiced tea"
	color = "#c8a988"

	glass_name = "chai latte"
	glass_desc = "A warm, inviting cup of spiced, dark tea mixed with steamed milk."

/decl/material/drink/tea/chai/soy_latte
	name = "soy chai latte"
	description = "A warm, inviting cup of spiced, dark tea mixed with steamed soy milk."
	taste_description = "creamy spiced tea"
	color = "#c8a988"

	glass_name = "soy chai latte"
	glass_desc = "A warm, inviting cup of spiced, dark tea mixed with steamed soy milk."

/decl/material/drink/tea/icetea/chai/latte
	name = "iced chai latte"
	description = "A warm, inviting cup of spiced, dark tea mixed with steamed milk. This one's cold."
	taste_description = "cold creamy spiced tea"
	color = "#c8a988"

	glass_name = "iced chai latte"
	glass_desc = "A warm, inviting cup of spiced, dark tea mixed with steamed milk. This one's cold."

/decl/material/drink/tea/icetea/chai/soy_latte
	name = "iced soy chai latte"
	description = "A warm, inviting cup of spiced, dark tea mixed with steamed soy milk. This one's cold."
	taste_description = "cold creamy spiced tea"
	color = "#c8a988"

	glass_name = "iced soy chai latte"
	glass_desc = "A warm, inviting cup of spiced, dark tea mixed with steamed soy milk. This one's cold."

/decl/material/drink/tea/red
	name = "redbush tea"
	description = "A caffeine-free dark red tea, flavorful and full of antioxidants."
	taste_description = "nutty red tea"
	color = "#ab4c3a"

	glass_name = "redbush tea"
	glass_desc = "A caffeine-free dark red tea, flavorful and full of antioxidants."

/decl/material/drink/tea/icetea/red
	name = "iced redbush tea"
	description = "It's the red tea you know and love, but now it's cold."
	taste_description = "cold nutty red tea"
	color = "#ab4c3a"

	glass_name = "iced redbush tea"
	glass_desc = "It's the red tea you know and love, but now it's cold."

/decl/material/drink/tea/icetea/red/sweet
	name = "sweet redbush tea"
	description = "It's the red tea you know and love, but now it's cold. And sweet."
	taste_description = "sweet nutty red tea"

	glass_name = "sweet redbush tea"
	glass_desc = "It's the red tea you know and love, but now it's cold. And sweet."

/decl/material/drink/syrup_chocolate
	name = "chocolate syrup"
	description = "Thick chocolate syrup used to flavor drinks."
	taste_description = "chocolate"
	color = "#542a0c"

	glass_name = "chocolate syrup"
	glass_desc = "Thick chocolate syrup used to flavor drinks."

/decl/material/drink/syrup_caramel
	name = "caramel syrup"
	description = "Thick caramel syrup used to flavor drinks."
	taste_description = "caramel"
	color = "#85461e"

	glass_name = "caramel syrup"
	glass_desc = "Thick caramel syrup used to flavor drinks."

/decl/material/drink/syrup_vanilla
	name = "vanilla syrup"
	description = "Thick vanilla syrup used to flavor drinks."
	taste_description = "vanilla"
	color = "#f3e5ab"

	glass_name = "vanilla syrup"
	glass_desc = "Thick vanilla syrup used to flavor drinks."

/decl/material/drink/syrup_pumpkin
	name = "pumpkin spice syrup"
	description = "Thick spiced pumpkin syrup used to flavor drinks."
	taste_description = "spiced pumpkin"
	color = "#d88b4c"

	glass_name = "pumpkin spice syrup"
	glass_desc = "Thick spiced pumpkin syrup used to flavor drinks."

// Non-Alcoholic Drinks
/decl/material/drink/fools_gold
	name = "Fool's Gold"
	description = "A non-alcoholic beverage typically served as an alternative to whiskey."
	taste_description = "watered down whiskey"
	color = "#e78108"
	glass_name = "fools gold"
	glass_desc = "A non-alcoholic beverage typically served as an alternative to whiskey."

/decl/material/drink/snowball
	name = "Snowball"
	description = "A cold pick-me-up frequently drunk in scientific outposts and academic fields."
	taste_description = "intellectual thought and brain-freeze"
	color = "#eeecea"
	adj_temp = -5
	glass_name = "snowball"
	glass_desc = "A cold pick-me-up frequently drunk in scientific outposts and academic fields."

/decl/material/drink/browndwarf
	name = "Brown Dwarf"
	description = "A large gas body made of chocolate that has failed to sustain nuclear fusion."
	taste_description = "dark chocolatey matter"
	color = "#44371f"
	glass_name = "brown dwarf"
	glass_desc = "A large gas body made of chocolate that has failed to sustain nuclear fusion."

/decl/material/drink/gingerbeer
	name = "ginger beer"
	description = "A hearty, non-alcoholic beverage brewed from ginger."
	taste_description = "carbonated ginger"
	color = "#44371f"
	glass_name = "ginger beer"
	glass_desc = "A hearty, non-alcoholic beverage brewed from ginger."

/decl/material/drink/beastenergy
	name = "Beast Energy"
	description = "A bottle of 100% pure energy."
	taste_description = "your heart crying"
	color = "#d69115"
	glass_name = "beast energy"
	glass_desc = "Why would you drink this without mixer?"

/decl/material/drink/beastenergy/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.drowsyness = max(0, M.drowsyness - 7)
	M.make_jittery(2)
	M.add_chemical_effect(CE_PULSE, 1)

/decl/material/drink/kefir
	name = "kefir"
	description = "Fermented milk. Actually very tasty."
	taste_description = "sharp, frothy yougurt"
	color = "#ece4e3"
	glass_name = "Kefir"
	glass_desc = "Fermented milk, looks a lot like yougurt."
