/decl/reagent/drink
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

/decl/reagent/drink/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustToxLoss(removed) // Probably not a good idea; not very deadly though

/decl/reagent/drink/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
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
/decl/reagent/drink/juice/affect_ingest(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.immunity = min(M.immunity + 0.25, M.immunity_norm*1.5)

/decl/reagent/drink/juice/banana
	name = "banana juice"
	description = "The raw essence of a banana."
	taste_description = "banana"
	color = "#c3af00"

	glass_name = "banana juice"
	glass_desc = "The raw essence of a banana. HONK!"

/decl/reagent/drink/juice/berry
	name = "berry juice"
	description = "A delicious blend of several different kinds of berries."
	taste_description = "berries"
	color = "#990066"

	glass_name = "berry juice"
	glass_desc = "Berry juice. Or maybe it's jam. Who cares?"

/decl/reagent/drink/juice/carrot
	name = "carrot juice"
	description = "It is just like a carrot but without crunching."
	taste_description = "carrots"
	color = "#ff8c00" // rgb: 255, 140, 0

	glass_name = "carrot juice"
	glass_desc = "It is just like a carrot but without crunching."

/decl/reagent/drink/juice/carrot/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.reagents.add_reagent(/decl/reagent/eyedrops, removed * 0.2)

/decl/reagent/drink/juice/grape
	name = "grape juice"
	description = "It's grrrrrape!"
	taste_description = "grapes"
	color = "#863333"

	glass_name = "grape juice"
	glass_desc = "It's grrrrrape!"

/decl/reagent/drink/juice/lemon
	name = "lemon juice"
	description = "This juice is VERY sour."
	taste_description = "sourness"
	taste_mult = 1.1
	color = "#afaf00"

	glass_name = "lemon juice"
	glass_desc = "Sour..."

/decl/reagent/drink/juice/lime
	name = "lime juice"
	description = "The sweet-sour juice of limes."
	taste_description = "unbearable sourness"
	taste_mult = 1.1
	color = "#365e30"

	glass_name = "lime juice"
	glass_desc = "A glass of sweet-sour lime juice"

/decl/reagent/drink/juice/lime/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.adjustToxLoss(-0.5 * removed)

/decl/reagent/drink/juice/orange
	name = "orange juice"
	description = "Both delicious AND rich in Vitamin C, what more do you need?"
	taste_description = "oranges"
	color = "#e78108"

	glass_name = "orange juice"
	glass_desc = "Vitamins! Yay!"

/decl/reagent/drink/juice/orange/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.adjustOxyLoss(-2 * removed)

/decl/reagent/toxin/poisonberryjuice // It has more in common with toxins than drinks... but it's a juice
	name = "poison berry juice"
	description = "A tasty juice blended from various kinds of very deadly and toxic berries."
	taste_description = "berries"
	color = "#863353"
	strength = 5

	glass_name = "poison berry juice"
	glass_desc = "A glass of deadly juice."

/decl/reagent/drink/juice/potato
	name = "potato juice"
	description = "Juice of the potato. Bleh."
	taste_description = "sadness and potatoes"
	nutrition = 2
	color = "#302000"

	glass_name = "potato juice"
	glass_desc = "Juice from a potato. Bleh."

/decl/reagent/drink/juice/garlic
	name = "garlic juice"
	description = "Who would even drink this?"
	taste_description = "bad breath"
	nutrition = 1
	color = "#eeddcc"

	glass_name = "garlic juice"
	glass_desc = "Who would even drink juice from garlic?"

/decl/reagent/drink/juice/onion
	name = "onion juice"
	description = "Juice from an onion, for when you need to cry."
	taste_description = "stinging tears"
	nutrition = 1
	color = "#ffeedd"

	glass_name = "onion juice"
	glass_desc = "Juice from an onion, for when you need to cry."

/decl/reagent/drink/juice/tomato
	name = "tomato juice"
	description = "Tomatoes made into juice. What a waste of big, juicy tomatoes, huh?"
	taste_description = "tomatoes"
	color = "#731008"

	glass_name = "tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

/decl/reagent/drink/juice/tomato/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.heal_organ_damage(0, 0.5 * removed)

/decl/reagent/drink/juice/watermelon
	name = "watermelon juice"
	description = "Delicious juice made from watermelon."
	taste_description = "sweet watermelon"
	color = "#b83333"

	glass_name = "watermelon juice"
	glass_desc = "Delicious juice made from watermelon."

/decl/reagent/drink/juice/turnip
	name = "turnip juice"
	description = "Delicious (?) juice made from turnips."
	taste_description = "turnip and uncertainty"
	color = "#b1166e"

	glass_name = "turnip juice"
	glass_desc = "Delicious (?) juice made from turnips."

/decl/reagent/drink/juice/apple
	name = "apple juice"
	description = "Delicious sweet juice made from apples."
	taste_description = "sweet apples"
	color = "#c07c40"

	glass_name = "apple juice"
	glass_desc = "Delicious juice made from apples."

/decl/reagent/drink/juice/pear
	name = "pear juice"
	description = "Delicious sweet juice made from pears."
	taste_description = "sweet pears"
	color = "#ffff66"

	glass_name = "pear juice"
	glass_desc = "Delicious juice made from pears."

// Everything else

/decl/reagent/drink/milk
	name = "milk"
	description = "An opaque white liquid produced by tiplods."
	taste_description = "milk"
	color = "#dfdfdf"

	glass_name = "milk"
	glass_desc = "White and nutritious goodness!"

/decl/reagent/drink/milk/chocolate
	name =  "chocolate milk"
	description = "A mixture of perfectly healthy milk and delicious chocolate."
	taste_description = "chocolate milk"
	color = "#74533b"

	glass_name = "chocolate milk"
	glass_desc = "Deliciously fattening!"

/decl/reagent/drink/milk/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.heal_organ_damage(0.5 * removed, 0)
	holder.remove_reagent(/decl/reagent/capsaicin, 10 * removed)

/decl/reagent/drink/milk/cream
	name = "cream"
	description = "The fatty, still liquid part of milk."
	taste_description = "creamy milk"
	color = "#dfd7af"

	glass_name = "cream"
	glass_desc = "Ewwww..."

/decl/reagent/drink/milk/soymilk
	name = "soy milk"
	description = "An opaque white liquid made from soybeans."
	taste_description = "soy milk"
	color = "#dfdfc7"

	glass_name = "soy milk"
	glass_desc = "White and nutritious soy goodness!"

/decl/reagent/drink/coffee
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
	var/list/flavour_modifiers = list()

/decl/reagent/drink/coffee/Initialize()
	. = ..()
	var/list/syrups = decls_repository.get_decls_of_subtype(/decl/reagent/drink/syrup)
	for(var/stype in syrups)
		var/inserted
		var/decl/reagent/drink/syrup/syrup = syrups[stype]
		for(var/i = 1 to length(flavour_modifiers))
			var/decl/reagent/drink/syrup/osyrup = flavour_modifiers[i]
			if(syrup.coffee_priority <= osyrup.coffee_priority)
				flavour_modifiers.Insert(i, syrup)
				inserted = TRUE
				break
		if(!inserted)
			flavour_modifiers += syrup

/decl/reagent/drink/coffee/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(adj_temp > 0)
		holder.remove_reagent(/decl/reagent/frostoil, 10 * removed)
	var/volume = REAGENT_VOLUME(holder, type)
	if(volume > 15)
		M.add_chemical_effect(CE_PULSE, 1)
	if(volume > 45)
		M.add_chemical_effect(CE_PULSE, 1)

/decl/reagent/drink/coffee/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.add_chemical_effect(CE_PULSE, 2)

/decl/reagent/drink/coffee/affect_overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	M.make_jittery(5)
	M.add_chemical_effect(CE_PULSE, 1)

/decl/reagent/drink/coffee/build_presentation_name_from_reagents(var/obj/item/prop, var/supplied)

	var/is_flavoured
	for(var/decl/reagent/drink/syrup/syrup in flavour_modifiers)
		if(prop.reagents.has_reagent(syrup.type))
			is_flavoured = TRUE
			. = "[.][syrup.coffee_modifier] "

	var/milk =  REAGENT_VOLUME(prop.reagents, /decl/reagent/drink/milk)
	var/soy =   REAGENT_VOLUME(prop.reagents, /decl/reagent/drink/milk/soymilk)
	var/cream = REAGENT_VOLUME(prop.reagents, /decl/reagent/drink/milk/cream)
	var/chai =  REAGENT_VOLUME(prop.reagents, /decl/reagent/drink/tea/chai) ? "dirty " : ""
	if(!soy && !milk && !cream)
		if(is_flavoured)
			. = "[.]flavoured [chai]coffee"
		else
			. = "[.][chai]coffee"
	else if((milk+cream) > soy)
		. = "[.][chai]latte"
	else
		. = "[.][chai]soy latte"
	. = ..(prop, .)

/decl/reagent/drink/hot_coco
	name = "hot chocolate"
	description = "Made with love! And cocoa beans."
	taste_description = "creamy chocolate"
	color = "#403010"
	nutrition = 2
	adj_temp = 5

	glass_name = "hot chocolate"
	glass_desc = "Made with love! And cocoa beans."

/decl/reagent/drink/sodawater
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

/decl/reagent/drink/grapesoda
	name = "grape soda"
	description = "Grapes made into a fine drank."
	taste_description = "grape soda"
	color = "#421c52"
	adj_drowsy = -3

	glass_name = "grape soda"
	glass_desc = "Looks like a delicious drink!"
	glass_special = list(DRINK_FIZZ)

/decl/reagent/drink/tonic
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

/decl/reagent/drink/lemonade
	name = "lemonade"
	description = "Oh the nostalgia..."
	taste_description = "tartness"
	color = "#ffff00"
	adj_temp = -5

	glass_name = "lemonade"
	glass_desc = "Oh the nostalgia..."
	glass_special = list(DRINK_FIZZ)

/decl/reagent/drink/citrusseltzer
	name = "citrus seltzer"
	description = "A tasty blend of fizz and citrus."
	taste_description = "tart and tasty"
	color = "#cccc99"
	adj_temp = -5

	glass_name = "citrus seltzer"
	glass_desc = "A tasty blend of fizz and citrus."
	glass_special = list(DRINK_FIZZ)

/decl/reagent/drink/orangecola
	name = "orange cola"
	description = "A traditional cola experience with a refreshing spritz of orange citrus flavour."
	taste_description = "orange and cola"
	color = "#9f3400"
	adj_temp = -2

	glass_name = "orange cola"
	glass_desc = "It's an unpleasant shade of muddy brown, and smells like over-ripe citrus."

/decl/reagent/drink/milkshake
	name = "milkshake"
	description = "Glorious brainfreezing mixture."
	taste_description = "creamy vanilla"
	color = "#aee5e4"
	adj_temp = -9

	glass_name = "milkshake"
	glass_desc = "Glorious brainfreezing mixture."

/decl/reagent/drink/rewriter
	name = "Rewriter"
	description = "The secret of the sanctuary of the Libarian..."
	taste_description = "a bad night out"
	color = "#485000"
	adj_temp = -5

	glass_name = "Rewriter"
	glass_desc = "The secret of the sanctuary of the Libarian..."

/decl/reagent/drink/rewriter/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.make_jittery(5)

/decl/reagent/drink/mutagencola
	name = "mutagen cola"
	description = "The energy of a radioactive isotope in beverage form."
	taste_description = "cancer"
	color = "#100800"
	adj_temp = -5
	adj_sleepy = -2

	glass_name = "mutagen cola"
	glass_desc = "The unstable energy of a radioactive isotope in beverage form."
	glass_special = list(DRINK_FIZZ)

/decl/reagent/drink/mutagencola/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	M.make_jittery(20)
	M.druggy = max(M.druggy, 30)
	M.dizziness += 5
	M.drowsyness = 0

/decl/reagent/drink/grenadine
	name = "grenadine syrup"
	description = "Made in the modern day with proper pomegranate substitute. Who uses real fruit, anyways?"
	taste_description = "100% pure pomegranate"
	color = "#ff004f"

	glass_name = "grenadine syrup"
	glass_desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."

/decl/reagent/drink/cola
	name = "cola"
	description = "A refreshing beverage."
	taste_description = "cola"
	color = "#100800"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = "cola"
	glass_desc = "A glass of refreshing cola."
	glass_special = list(DRINK_FIZZ)

/decl/reagent/drink/citrussoda
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

/decl/reagent/drink/cherrycola
	name = "cherry soda"
	description = "A delicious blend of 42 different flavours"
	taste_description = "cherry soda"
	color = "#102000"
	adj_drowsy = -6
	adj_temp = -5

	glass_name = "cherry soda"
	glass_desc = "A glass of cherry soda, a delicious blend of 42 flavours."

/decl/reagent/drink/lemonade
	name = "lemonade"
	description = "Tastes like a hull breach in your mouth."
	taste_description = "a hull breach"
	color = "#202800"
	adj_temp = -8

	glass_name = "lemonade"
	glass_desc = "A glass of lemonade. It helps keep you cool."
	glass_special = list(DRINK_FIZZ)

/decl/reagent/drink/lemon_lime
	name = "lemon-lime soda"
	description = "A tangy substance made of 0.5% natural citrus!"
	taste_description = "tangy lime and lemon soda"
	color = "#878f00"
	adj_temp = -8

	glass_name = "lemon lime soda"
	glass_desc = "A tangy substance made of 0.5% natural citrus!"
	glass_special = list(DRINK_FIZZ)

/decl/reagent/drink/doctor_delight
	name = "The Doctor's Delight"
	description = "Tasty drink that keeps you healthy and doctors bored.  Just the way they like it."
	taste_description = "homely fruit"
	color = "#ff8cff"
	nutrition = 1

	glass_name = "The Doctor's Delight"
	glass_desc = "A healthy mixture of juices, guaranteed to keep you healthy until the next exile decides to put a few new holes in you."

/decl/reagent/drink/doctor_delight/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.adjustOxyLoss(-4 * removed)
	M.heal_organ_damage(2 * removed, 2 * removed)
	M.adjustToxLoss(-2 * removed)
	if(M.dizziness)
		M.dizziness = max(0, M.dizziness - 15)
	if(M.confused)
		M.confused = max(0, M.confused - 5)

/decl/reagent/drink/dry_ramen
	name = "dry ramen"
	description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
	taste_description = "dry and cheap noodles"
	nutrition = 1
	color = "#302000"

/decl/reagent/drink/hot_ramen
	name = "hot ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	taste_description = "wet and cheap noodles"
	color = "#302000"
	nutrition = 5
	adj_temp = 5

/decl/reagent/drink/hell_ramen
	name = "hell ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	taste_description = "wet and cheap noodles on fire"
	color = "#302000"
	nutrition = 5

/decl/reagent/drink/hell_ramen/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.bodytemperature += 10 * TEMPERATURE_DAMAGE_COEFFICIENT

/decl/reagent/drink/nothing
	name = "nothing"
	description = "Absolutely nothing."
	taste_description = "nothing"

	glass_name = "nothing"
	glass_desc = "Absolutely nothing."

/decl/reagent/drink/tea/build_presentation_name_from_reagents(var/obj/item/prop, var/supplied)
	. = supplied || glass_name
	if(prop.reagents.has_reagent(/decl/reagent/nutriment/sugar) || prop.reagents.has_reagent(/decl/reagent/nutriment/honey))
		. = "sweet [.]"
	if(prop.reagents.has_reagent(/decl/reagent/drink/syrup/mint))
		. = "mint [.]"
	. = ..(prop, .)

/decl/reagent/drink/tea/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.adjustToxLoss(-0.5 * removed)

/decl/reagent/drink/tea/black
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

/decl/reagent/drink/tea/black/build_presentation_name_from_reagents(var/obj/item/prop, var/supplied)
	if(prop.reagents.has_reagent(/decl/reagent/drink/juice/orange))
		if(prop.reagents.has_reagent(/decl/reagent/drink/milk))
			. = "London Fog"
		else if(prop.reagents.has_reagent(/decl/reagent/drink/milk/soymilk))
			. = "soy London Fog"
		else
			. = "Baron Grey"
	. = ..(prop, .)

//green tea
/decl/reagent/drink/tea/green
	name = "green tea"
	description = "Subtle green tea, it has antioxidants, it's good for you!"
	taste_description = "subtle green tea"
	color = "#b4cd94"

	glass_name = "green tea"
	glass_desc = "Subtle green tea, it has antioxidants, it's good for you!"

/decl/reagent/drink/tea/chai
	name = "chai"
	description = "A spiced, dark tea. Goes great with milk."
	taste_description = "spiced black tea"
	color = "#151000"

	glass_name = "chai"
	glass_desc = "A spiced, dark tea. Goes great with milk."

/decl/reagent/drink/tea/chai/build_presentation_name_from_reagents(var/obj/item/prop, var/supplied)
	if(prop.reagents.has_reagent(/decl/reagent/drink/milk))
		. = "chai latte"
	else if(prop.reagents.has_reagent(/decl/reagent/drink/milk))
		. = "soy chai latte"
	. = ..(prop, .)

/decl/reagent/drink/tea/red
	name = "redbush tea"
	description = "A caffeine-free dark red tea, flavorful and full of antioxidants."
	taste_description = "nutty red tea"
	color = "#ab4c3a"

	glass_name = "redbush tea"
	glass_desc = "A caffeine-free dark red tea, flavorful and full of antioxidants."

/decl/reagent/drink/syrup
	var/coffee_priority
	var/coffee_modifier

/decl/reagent/drink/syrup/Initialize()
	. = ..()
	if(!coffee_modifier)
		coffee_modifier = taste_description

/decl/reagent/drink/syrup/mint
	name = "mint flavouring"
	description = "Strong mint flavouring, also known as mentha."
	taste_description = "mint"
	color = "#07aab2"
	coffee_priority = 1

	glass_name = "mint flavouring"
	glass_desc = "Also known as mentha."

/decl/reagent/drink/syrup/chocolate
	name = "chocolate syrup"
	description = "Thick chocolate syrup used to flavor drinks."
	taste_description = "chocolate"
	color = "#542a0c"
	coffee_modifier = "mocha"
	coffee_priority = 5

	glass_name = "chocolate syrup"
	glass_desc = "Thick chocolate syrup used to flavor drinks."

/decl/reagent/drink/syrup/caramel
	name = "caramel syrup"
	description = "Thick caramel syrup used to flavor drinks."
	taste_description = "caramel"
	color = "#85461e"
	coffee_priority = 2

	glass_name = "caramel syrup"
	glass_desc = "Thick caramel syrup used to flavor drinks."

/decl/reagent/drink/syrup/vanilla
	name = "vanilla syrup"
	description = "Thick vanilla syrup used to flavor drinks."
	taste_description = "vanilla"
	color = "#f3e5ab"
	coffee_priority = 3

	glass_name = "vanilla syrup"
	glass_desc = "Thick vanilla syrup used to flavor drinks."

/decl/reagent/drink/syrup/pumpkin
	name = "pumpkin spice syrup"
	description = "Thick spiced pumpkin syrup used to flavor drinks."
	taste_description = "pumpkin spice"
	color = "#d88b4c"
	coffee_priority = 4

	glass_name = "pumpkin spice syrup"
	glass_desc = "Thick spiced pumpkin syrup used to flavor drinks."

// Non-Alcoholic Drinks
/decl/reagent/drink/fools_gold
	name = "Fool's Gold"
	description = "A non-alcoholic beverage typically served as an alternative to whiskey."
	taste_description = "watered down whiskey"
	color = "#e78108"
	glass_name = "fools gold"
	glass_desc = "A non-alcoholic beverage typically served as an alternative to whiskey."

/decl/reagent/drink/snowball
	name = "Snowball"
	description = "A cold pick-me-up frequently drunk in scientific outposts and academic fields."
	taste_description = "intellectual thought and brain-freeze"
	color = "#eeecea"
	adj_temp = -5
	glass_name = "snowball"
	glass_desc = "A cold pick-me-up frequently drunk in scientific outposts and academic fields."

/decl/reagent/drink/browndwarf
	name = "Brown Dwarf"
	description = "A large gas body made of chocolate that has failed to sustain nuclear fusion."
	taste_description = "dark chocolatey matter"
	color = "#44371f"
	glass_name = "brown dwarf"
	glass_desc = "A large gas body made of chocolate that has failed to sustain nuclear fusion."

/decl/reagent/drink/gingerbeer
	name = "ginger beer"
	description = "A hearty, non-alcoholic beverage brewed from ginger."
	taste_description = "carbonated ginger"
	color = "#44371f"
	glass_name = "ginger beer"
	glass_desc = "A hearty, non-alcoholic beverage brewed from ginger."

/decl/reagent/drink/beastenergy
	name = "Beast Energy"
	description = "A bottle of 100% pure energy."
	taste_description = "your heart crying"
	color = "#d69115"
	glass_name = "beast energy"
	glass_desc = "Why would you drink this without mixer?"

/decl/reagent/drink/beastenergy/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.drowsyness = max(0, M.drowsyness - 7)
	M.make_jittery(2)
	M.add_chemical_effect(CE_PULSE, 1)

/decl/reagent/drink/kefir
	name = "kefir"
	description = "Fermented milk. Actually very tasty."
	taste_description = "sharp, frothy yougurt"
	color = "#ece4e3"
	glass_name = "Kefir"
	glass_desc = "Fermented milk, looks a lot like yougurt."
