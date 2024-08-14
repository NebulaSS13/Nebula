/datum/seed/cotton
	name = "cotton"
	product_name = "cotton"
	display_name = "cotton"
	product_material = /decl/material/solid/organic/plantmatter/pith/husk
	chems = list(
		/decl/material/liquid/nutriment/plant_oil = list(3,10),
		/decl/material/solid/organic/cloth = list(10,1)
	)
	slice_product = null
	slice_amount = 0

/datum/seed/cotton/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"wheat")
	set_trait(TRAIT_PRODUCT_COLOUR, "#ffffff")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

// Chili plants/variants.
/datum/seed/chili
	name = "chili"
	product_name = "chili"
	display_name = "chili plants"
	chems = list(/decl/material/liquid/capsaicin = list(3,5), /decl/material/liquid/nutriment = list(1,25))
	mutants = list("icechili")
	grown_tag = "chili"

/datum/seed/chili/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"chili")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ed3300")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 7)

/datum/seed/chili/ice
	name = "icechili"
	product_name = "chilly pepper"
	display_name = "chilly pepper plant"
	mutants = null
	chems = list(/decl/material/liquid/frostoil = list(3,5), /decl/material/liquid/nutriment = list(1,50))
	grown_tag = "icechili"

/datum/seed/chili/ice/New()
	..()
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_PRODUCT_COLOUR,"#00edc6")

// Berry plants/variants.
/datum/seed/berry
	name = "berries"
	product_name = "berries"
	display_name = "berry bush"
	mutants = list("glowberries","poisonberries","blueberries")
	chems = list(/decl/material/liquid/nutriment = list(1,10), /decl/material/liquid/drink/juice/berry = list(10,10))
	grown_tag = "berries"
	slice_product = /obj/item/food/processed_grown/crushed
	slice_amount = 3

/datum/seed/berry/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"berry")
	set_trait(TRAIT_PRODUCT_COLOUR,"#fa1616")
	set_trait(TRAIT_PLANT_ICON,"bush")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/berry/blue
	name = "blueberries"
	product_name = "blueberries"
	display_name = "blueberry bush"
	mutants = list("berries","poisonberries","glowberries")
	chems = list(/decl/material/liquid/nutriment = list(1,10), /decl/material/liquid/drink/juice/berry = list(10,10))
	grown_tag = "blueberries"

/datum/seed/berry/blue/New()
	..()
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_COLOUR,"#1c225c")
	set_trait(TRAIT_WATER_CONSUMPTION, 5)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.2)

/datum/seed/berry/glow
	name = "glowberries"
	product_name = "glowberries"
	display_name = "glowberry bush"
	mutants = null
	chems = list(/decl/material/liquid/nutriment = list(1,10), /decl/material/solid/metal/uranium = list(3,5))

/datum/seed/berry/glow/New()
	..()
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#006622")
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_COLOUR,"#c9fa16")
	set_trait(TRAIT_WATER_CONSUMPTION, 3)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.25)

/datum/seed/berry/poison
	name = "poisonberries"
	product_name = "poison berries"
	display_name = "poison berry bush"
	mutants = list("deathberries")
	chems = list(
		/decl/material/liquid/nutriment = list(1),
		/decl/material/liquid/bromide = list(3,5),
		/decl/material/liquid/poisonberryjuice = list(10,5)
	)

/datum/seed/berry/poison/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#6dc961")
	set_trait(TRAIT_WATER_CONSUMPTION, 3)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.25)

/datum/seed/berry/poison/death
	name = "deathberries"
	product_name = "death berries"
	display_name = "death berry bush"
	mutants = null
	chems = list(
		/decl/material/liquid/nutriment = list(1),
		/decl/material/liquid/bromide = list(3,3),
		/decl/material/gas/carbon_monoxide = list(1,5)
	)

/datum/seed/berry/poison/death/New()
	..()
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,50)
	set_trait(TRAIT_PRODUCT_COLOUR,"#7a5454")
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.35)

// Nettles/variants.
/datum/seed/nettle
	name = "nettle"
	product_name = "nettle"
	display_name = "nettle patch"
	mutants = list("deathnettle")
	chems = list(/decl/material/liquid/nutriment = list(1,50), /decl/material/liquid/acid = list(0,1))
	grown_tag = "nettle"
	slice_product = /obj/item/food/processed_grown/chopped
	slice_amount = 3

/datum/seed/nettle/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_STINGS,1)
	set_trait(TRAIT_PLANT_ICON,"bush5")
	set_trait(TRAIT_PRODUCT_ICON,"nettles")
	set_trait(TRAIT_PRODUCT_COLOUR,"#728a54")

/datum/seed/nettle/death
	name = "deathnettle"
	product_name = "death nettle"
	display_name = "death nettle patch"
	mutants = null
	chems = list(/decl/material/liquid/nutriment = list(1,50), /decl/material/liquid/acid/polyacid = list(0,1))
	grown_tag = "deathnettle"

/datum/seed/nettle/death/New()
	..()
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_PRODUCT_COLOUR,"#8c5030")
	set_trait(TRAIT_PLANT_COLOUR,"#634941")

//Tomatoes/variants.
/datum/seed/tomato
	name = "tomato"
	product_name = "tomato"
	display_name = "tomato plant"
	mutants = list("bluetomato","bloodtomato")
	chems = list(/decl/material/liquid/nutriment = list(1,10), /decl/material/liquid/drink/juice/tomato = list(10,10))
	grown_tag = "tomato"

/datum/seed/tomato/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"tomato")
	set_trait(TRAIT_PRODUCT_COLOUR,"#d10000")
	set_trait(TRAIT_PLANT_ICON,"bush3")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.25)

/datum/seed/tomato/blood
	name = "bloodtomato"
	product_name = "blood tomato"
	display_name = "blood tomato plant"
	mutants = list("killer")
	chems = list(/decl/material/liquid/nutriment = list(1,10), /decl/material/liquid/blood = list(1,5))
	splat_type = /obj/effect/decal/cleanable/blood/splatter

/datum/seed/tomato/blood/New()
	..()
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_COLOUR,"#ff0000")

/datum/seed/tomato/killer
	name = "killertomato"
	product_name = "killer tomato"
	display_name = "killer tomato plant"
	mutants = null
	can_self_harvest = 1
	product_type = /mob/living/simple_animal/tomato

/datum/seed/tomato/killer/New()
	..()
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_PRODUCT_COLOUR,"#a86747")

/datum/seed/tomato/blue
	name = "bluetomato"
	product_name = "blue tomato"
	display_name = "blue tomato plant"
	mutants = list("quantumato")
	chems = list(/decl/material/liquid/nutriment = list(1,20), /decl/material/liquid/lube = list(1,5))

/datum/seed/tomato/blue/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#4d86e8")
	set_trait(TRAIT_PLANT_COLOUR,"#070aad")

/datum/seed/tomato/blue/teleport
	name = "quantumato"
	product_name = "quantumato"
	display_name = "quantumato plant"
	mutants = null
	chems = list(
		/decl/material/liquid/nutriment = list(1,20),
		/decl/material/liquid/ethanol/bluecuracao = list(10,5)
	)

/datum/seed/tomato/blue/teleport/New()
	..()
	set_trait(TRAIT_TELEPORTING,1)
	set_trait(TRAIT_PRODUCT_COLOUR,"#00e5ff")
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#4da4a8")

//Eggplants/varieties.
/datum/seed/eggplant
	name = "eggplant"
	product_name = "eggplant"
	display_name = "eggplant vine"
	mutants = list("realeggplant")
	chems = list(/decl/material/liquid/nutriment = list(1,10))
	grown_tag = "eggplant"

/datum/seed/eggplant/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"eggplant")
	set_trait(TRAIT_PRODUCT_COLOUR,"#892694")
	set_trait(TRAIT_PLANT_ICON,"bush4")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 7)

//Apples/varieties.
/datum/seed/apple
	name = "apple"
	product_name = "apple"
	display_name = "apple tree"
	mutants = list("poisonapple","goldapple")
	chems = list(/decl/material/liquid/nutriment = list(1,10), /decl/material/liquid/drink/juice/apple = list(10,10))
	grown_tag = "apple"

/datum/seed/apple/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"apple")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ff540a")
	set_trait(TRAIT_PLANT_ICON,"tree2")
	set_trait(TRAIT_FLESH_COLOUR,"#e8e39b")
	set_trait(TRAIT_IDEAL_LIGHT, 4)
	set_trait(TRAIT_PHOTOSYNTHESIS, 1)

/datum/seed/apple/poison
	name = "poisonapple"
	mutants = null
	chems = list(/decl/material/liquid/cyanide = list(1,5))

/datum/seed/apple/gold
	name = "goldapple"
	product_name = "golden apple"
	display_name = "gold apple tree"
	mutants = null
	chems = list(/decl/material/liquid/nutriment = list(1,10), /decl/material/solid/metal/gold = list(1,5))
	grown_tag = "goldapple"

/datum/seed/apple/gold/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,10)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_COLOUR,"#ffdd00")
	set_trait(TRAIT_PLANT_COLOUR,"#d6b44d")

//Ambrosia/varieties.
/datum/seed/ambrosia
	name = "ambrosiavulgaris"
	product_name = "ambrosia vulgaris"
	display_name = "ambrosia vulgaris patch"
	mutants = list("ambrosiadeus")
	chems = list(
		/decl/material/liquid/nutriment = list(1),
		/decl/material/liquid/psychoactives = list(1,8),
		/decl/material/liquid/burn_meds = list(1,8,1),
		/decl/material/liquid/brute_meds = list(1,10,1),
		/decl/material/liquid/bromide = list(1,10)
	)
	grown_tag = "ambrosiavulgaris"
	slice_product = /obj/item/food/processed_grown/chopped
	slice_amount = 3

/datum/seed/ambrosia/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"ambrosia")
	set_trait(TRAIT_PRODUCT_COLOUR,"#9fad55")
	set_trait(TRAIT_PLANT_ICON,"ambrosia")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/datum/seed/ambrosia/deus
	name = "ambrosiadeus"
	product_name = "ambrosia deus"
	display_name = "ambrosia deus patch"
	mutants = null
	chems = list(
		/decl/material/liquid/nutriment = list(1),
		/decl/material/liquid/brute_meds = list(1,8),
		/decl/material/liquid/antidepressants = list(1,8,1),
		/decl/material/liquid/stimulants = list(1,8,1),
		/decl/material/liquid/amphetamines = list(1,10,1),
		/decl/material/liquid/psychoactives = list(1,10)
	)
	grown_tag = "ambrosiadeus"

/datum/seed/ambrosia/deus/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#a3f0ad")
	set_trait(TRAIT_PLANT_COLOUR,"#2a9c61")

//Mushrooms/varieties.
/datum/seed/mushroom
	name = "mushrooms"
	product_name = "chanterelle"
	seed_noun = SEED_NOUN_SPORES
	display_name = "chanterelle mushroom patch"
	mutants = list("reishi","amanita","plumphelmet")
	chems = list(/decl/material/liquid/nutriment = list(1,25))
	splat_type = /obj/effect/vine
	grown_tag = "mushroom"
	slice_product = /obj/item/food/processed_grown/chopped
	slice_amount = 3

/datum/seed/mushroom/make_splat(var/turf/T, var/obj/item/thrown)
	if(!splat_type || (locate(splat_type) in T))
		return
	new splat_type(T, src)
	// No further logic; the vine will handle it.

/datum/seed/mushroom/New()
	..()
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,1)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#dbda72")
	set_trait(TRAIT_PLANT_COLOUR,"#d9c94e")
	set_trait(TRAIT_PLANT_ICON,"mushroom")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_IDEAL_HEAT, 288)
	set_trait(TRAIT_LIGHT_TOLERANCE, 6)

/datum/seed/mushroom/mold
	name = "mold"
	product_name = "brown mold"
	display_name = "brown mold patch"
	mutants = null

/datum/seed/mushroom/mold/New()
	..()
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_YIELD,-1)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom5")
	set_trait(TRAIT_PRODUCT_COLOUR,"#7a5f20")
	set_trait(TRAIT_PLANT_COLOUR,"#7a5f20")
	set_trait(TRAIT_PLANT_ICON,"mushroom9")

/datum/seed/mushroom/plump
	name = "plumphelmet"
	product_name = "plump helmet"
	display_name = "plump helmet mushroom patch"
	mutants = list("walkingmushroom","towercap")
	chems = list(/decl/material/liquid/nutriment = list(2,10))
	grown_tag = "plumphelmet"

/datum/seed/mushroom/plump/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,2)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom10")
	set_trait(TRAIT_PRODUCT_COLOUR,"#b57bb0")
	set_trait(TRAIT_PLANT_COLOUR,"#9e4f9d")
	set_trait(TRAIT_PLANT_ICON,"mushroom2")
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.35)

/datum/seed/mushroom/plump/walking
	name = "walkingmushroom"
	product_name = "walking mushroom"
	display_name = "walking mushroom patch"
	mutants = null
	can_self_harvest = 1
	product_type = /mob/living/simple_animal/mushroom

/datum/seed/mushroom/plump/walking/New()
	..()
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_YIELD,1)
	set_trait(TRAIT_PRODUCT_COLOUR,"#fac0f2")
	set_trait(TRAIT_PLANT_COLOUR,"#c4b1c2")

/datum/seed/mushroom/hallucinogenic
	name = "reishi"
	product_name = "reishi"
	display_name = "reishi patch"
	mutants = list("libertycap","glowbell")
	chems = list(/decl/material/liquid/nutriment = list(1,50), /decl/material/liquid/psychotropics = list(3,5))

/datum/seed/mushroom/hallucinogenic/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom11")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ffb70f")
	set_trait(TRAIT_PLANT_COLOUR,"#f58a18")
	set_trait(TRAIT_PLANT_ICON,"mushroom6")

/datum/seed/mushroom/hallucinogenic/strong
	name = "libertycap"
	product_name = "liberty cap"
	display_name = "liberty cap mushroom patch"
	mutants = null
	chems = list(/decl/material/liquid/nutriment = list(1), /decl/material/liquid/sedatives = list(3,3), /decl/material/liquid/psychoactives = list(1,25))

/datum/seed/mushroom/hallucinogenic/strong/New()
	..()
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom8")
	set_trait(TRAIT_PRODUCT_COLOUR,"#f2e550")
	set_trait(TRAIT_PLANT_COLOUR,"#d1ca82")
	set_trait(TRAIT_PLANT_ICON,"mushroom3")

/datum/seed/mushroom/poison
	name = "amanita"
	product_name = "fly amanita"
	display_name = "fly amanita mushroom patch"
	mutants = list("destroyingangel","plastic")
	chems = list(/decl/material/liquid/nutriment = list(1), /decl/material/liquid/amatoxin = list(3,3), /decl/material/liquid/psychotropics = list(1,25))

/datum/seed/mushroom/poison/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ff4545")
	set_trait(TRAIT_PLANT_COLOUR,"#e0ddba")
	set_trait(TRAIT_PLANT_ICON,"mushroom4")

/datum/seed/mushroom/poison/death
	name = "destroyingangel"
	product_name = "destroying angel"
	display_name = "destroying angel mushroom patch"
	mutants = null
	chems = list(/decl/material/liquid/nutriment = list(1,50), /decl/material/liquid/amatoxin = list(13,3), /decl/material/liquid/psychotropics = list(1,25))

/datum/seed/mushroom/poison/death/New()
	..()
	set_trait(TRAIT_MATURATION,12)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,35)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ede8ea")
	set_trait(TRAIT_PLANT_COLOUR,"#e6d8dd")
	set_trait(TRAIT_PLANT_ICON,"mushroom5")

/datum/seed/mushroom/towercap
	name = "towercap"
	product_name = "dwarf towercap"
	display_name = "dwarf towercap thicket"
	chems = list(/decl/material/solid/organic/wood = list(10,1))
	mutants = null
	product_type = /obj/item/stack/material/log/towercap

/obj/item/stack/material/log/towercap
	material = /decl/material/solid/organic/wood/fungal

/datum/seed/mushroom/towercap/New()
	..()
	set_trait(TRAIT_MATURATION,15)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom7")
	set_trait(TRAIT_PRODUCT_COLOUR,"#d3aca3")
	set_trait(TRAIT_PLANT_COLOUR,"#dcd9d9")
	set_trait(TRAIT_PLANT_ICON,"mushroom8")

/datum/seed/mushroom/glowbell
	name = "glowbell"
	product_name = "glowbell"
	display_name = "glowbell patch"
	mutants = list("weepingmoon", "caverncandle")
	chems = list(/decl/material/liquid/glowsap = list(1,20))

/datum/seed/mushroom/glowbell/New()
	..()
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_MATURATION,15)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,30)
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#9eefff")
	set_trait(TRAIT_PRODUCT_ICON,"mushroom2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#90d7f0")
	set_trait(TRAIT_PLANT_COLOUR,"#75bdd7")
	set_trait(TRAIT_PLANT_ICON,"mushroom2")

/datum/seed/mushroom/weepingmoon
	name = "weepingmoon"
	product_name = "weeping moon"
	display_name = "weeping moon patch"
	mutants = null
	chems = list(/decl/material/liquid/glowsap = list(1,20))

/datum/seed/mushroom/weepingmoon/New()
	..()
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_MATURATION,15)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,30)
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#9eefff")
	set_trait(TRAIT_PRODUCT_ICON,"mushroom4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#90d7f0")
	set_trait(TRAIT_PLANT_COLOUR,"#75bdd7")
	set_trait(TRAIT_PLANT_ICON,"mushroom4")

/datum/seed/mushroom/caverncandle
	name = "caverncandle"
	product_name = "caverncandle"
	display_name = "cavern candle patch"
	mutants = null
	chems = list(/decl/material/liquid/glowsap = list(1,20))

/datum/seed/mushroom/caverncandle/New()
	..()
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_MATURATION,15)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,30)
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#9eefff")
	set_trait(TRAIT_PRODUCT_ICON,"mushroom3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#90d7f0")
	set_trait(TRAIT_PLANT_COLOUR,"#75bdd7")
	set_trait(TRAIT_PLANT_ICON,"mushroom3")

/datum/seed/mushroom/plastic
	name = "plastic"
	product_name = "plastellium"
	display_name = "plastellium patch"
	mutants = null
	chems = list(/decl/material/liquid/plasticide = list(1,10))

/datum/seed/mushroom/plastic/New()
	..()
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom6")
	set_trait(TRAIT_PRODUCT_COLOUR,"#e6e6e6")
	set_trait(TRAIT_PLANT_COLOUR,"#e6e6e6")
	set_trait(TRAIT_PLANT_ICON,"mushroom10")

//Flowers/varieties
/datum/seed/flower
	name = "harebells"
	product_name = "harebell"
	display_name = "harebell patch"
	chems = list(/decl/material/liquid/nutriment = list(1,20))
	slice_product = /obj/item/food/processed_grown/crushed
	slice_amount = 3

/datum/seed/flower/New()
	..()
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_PRODUCT_ICON,"flower5")
	set_trait(TRAIT_PRODUCT_COLOUR,"#c492d6")
	set_trait(TRAIT_PLANT_COLOUR,"#6b8c5e")
	set_trait(TRAIT_PLANT_ICON,"flower")
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/flower/poppy
	name = "poppies"
	product_name = "poppy"
	display_name = "poppy patch"
	chems = list(
		/decl/material/liquid/nutriment = list(1,20),
		/decl/material/liquid/painkillers/strong = list(1,10)
	)
	grown_tag = "poppy"

/datum/seed/flower/poppy/New()
	..()
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_PRODUCT_ICON,"flower3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#b33715")
	set_trait(TRAIT_PLANT_ICON,"flower3")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/flower/sunflower
	name = "sunflowers"
	product_name = "sunflower"
	display_name = "sunflower patch"
	chems = list(
		/decl/material/liquid/nutriment/plant_oil = list(10,10)
	)

/datum/seed/flower/sunflower/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCT_ICON,"flower2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#fff700")
	set_trait(TRAIT_PLANT_ICON,"flower2")
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/flower/lavender
	name = "lavender"
	product_name = "lavender"
	display_name = "lavender patch"
	chems = list(/decl/material/liquid/nutriment = list(1,20), /decl/material/liquid/brute_meds = list(1,10))

/datum/seed/flower/lavender/New()
	..()
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_PRODUCT_ICON,"flower6")
	set_trait(TRAIT_PRODUCT_COLOUR,"#b57edc")
	set_trait(TRAIT_PLANT_COLOUR,"#6b8c5e")
	set_trait(TRAIT_PLANT_ICON,"flower4")
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.05)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)

//Grapes/varieties
/datum/seed/grapes
	name = "grapes"
	product_name = "grapes"
	display_name = "grapevine"
	mutants = list("greengrapes")
	chems = list(/decl/material/liquid/nutriment = list(1,10), /decl/material/liquid/nutriment/sugar = list(1,5), /decl/material/liquid/drink/juice/grape = list(10,10))
	slice_product = /obj/item/food/processed_grown/crushed
	slice_amount = 3

/datum/seed/grapes/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"grapes")
	set_trait(TRAIT_PRODUCT_COLOUR,"#bb6ac4")
	set_trait(TRAIT_PLANT_COLOUR,"#378f2e")
	set_trait(TRAIT_PLANT_ICON,"vine")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/grapes/green
	name = "greengrapes"
	product_name = "green grapes"
	display_name = "green grapevine"
	mutants = null
	chems = list(/decl/material/liquid/nutriment = list(1,10), /decl/material/liquid/burn_meds = list(3,5), /decl/material/liquid/drink/juice/grape = list(10,10))

/datum/seed/grapes/green/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"42ed2f")

//Everything else
/datum/seed/peanuts
	name = "peanut"
	product_name = "peanut"
	display_name = "peanut vine"
	chems = list(
		/decl/material/liquid/nutriment = list(1,10),
		/decl/material/liquid/nutriment/plant_oil = list(1,10)
	)
	slice_product = /obj/item/food/processed_grown/chopped
	slice_amount = 3

/datum/seed/peanuts/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"nuts")
	set_trait(TRAIT_PRODUCT_COLOUR,"#c4ae7a")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/datum/seed/peppercorn
	name = "peppercorn"
	product_name = "peppercorn"
	display_name = "black pepper plant"
	chems = list(/decl/material/solid/blackpepper = list(10,10))
	slice_product = /obj/item/food/processed_grown/crushed
	slice_amount = 3

/datum/seed/peppercorn/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"nuts")
	set_trait(TRAIT_PRODUCT_COLOUR,"#4d4d4d")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/datum/seed/cabbage
	name = "cabbage"
	product_name = "cabbage"
	display_name = "cabbage patch"
	chems = list(/decl/material/liquid/nutriment = list(1,10))
	grown_tag = "cabbage"
	slice_product = /obj/item/food/processed_grown/chopped
	slice_amount = 3

/datum/seed/cabbage/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"cabbage")
	set_trait(TRAIT_PRODUCT_COLOUR,"#84bd82")
	set_trait(TRAIT_PLANT_COLOUR,"#6d9c6b")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/banana
	name = "banana"
	product_name = "banana"
	display_name = "banana tree"
	chems = list(/decl/material/liquid/drink/juice/banana = list(10,10), /decl/material/solid/potassium = list(2,3))
	trash_type = /obj/item/bananapeel
	grown_tag = "banana"

/datum/seed/banana/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_ICON,"bananas")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ffec1f")
	set_trait(TRAIT_PLANT_COLOUR,"#69ad50")
	set_trait(TRAIT_PLANT_ICON,"tree4")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_PHOTOSYNTHESIS, 1)

/datum/seed/corn
	name = "corn"
	product_name = "corn"
	display_name = "ears of corn"
	chems = list(/decl/material/liquid/nutriment = list(1,10), /decl/material/liquid/nutriment/cornoil = list(1,10))
	grown_tag = "corn"
	trash_type = /obj/item/corncob
	backyard_grilling_product = /obj/item/food/popcorn
	backyard_grilling_announcement = "pops enthusiastically!"
	slice_product = /obj/item/food/processed_grown/chopped
	slice_amount = 3

/datum/seed/corn/New()
	..()
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"corn")
	set_trait(TRAIT_PRODUCT_COLOUR,"#fff23b")
	set_trait(TRAIT_PLANT_COLOUR,"#87c969")
	set_trait(TRAIT_PLANT_ICON,"corn")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/potato
	name = "potato"
	product_name = "potato"
	display_name = "potato patch"
	chems = list(/decl/material/liquid/nutriment = list(1,10), /decl/material/liquid/drink/juice/potato = list(10,10))
	grown_tag = "potato"
	grown_is_seed = TRUE
	min_seed_extracted = 0
	max_seed_extracted = 0
	slice_product = /obj/item/food/processed_grown/sticks
	slice_amount = 3

/datum/seed/potato/New()
	..()
	set_trait(TRAIT_PRODUCES_POWER,1)
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"potato")
	set_trait(TRAIT_PRODUCT_COLOUR,"#d4cab4")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/garlic
	name = "garlic"
	product_name = "garlic"
	display_name = "garlic plant"
	chems = list(/decl/material/liquid/nutriment = list(1,10), /decl/material/liquid/drink/juice/garlic = list(10,10))
	grown_tag = "garlic"
	slice_product = /obj/item/food/processed_grown/crushed
	slice_amount = 3
	grown_is_seed = TRUE
	min_seed_extracted = 0
	max_seed_extracted = 0

/datum/seed/garlic/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,12)
	set_trait(TRAIT_PRODUCT_ICON,"bulb")
	set_trait(TRAIT_PRODUCT_COLOUR,"#fff8dd")
	set_trait(TRAIT_PLANT_ICON,"stalk")
	set_trait(TRAIT_WATER_CONSUMPTION, 7)

/datum/seed/onion
	name = "onion"
	product_name = "onion"
	display_name = "onion patch"
	chems = list(/decl/material/liquid/nutriment = list(1,10), /decl/material/liquid/drink/juice/onion = list(10,10))
	grown_tag = "onion"
	slice_product = /obj/item/food/processed_grown/chopped
	slice_amount = 3

/datum/seed/onion/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"bulb")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ffeedd")
	set_trait(TRAIT_PLANT_ICON,"stalk")
	set_trait(TRAIT_WATER_CONSUMPTION, 5)

/datum/seed/soybean
	name = "soybeans"
	product_name = "soybeans"
	display_name = "soybean patch"
	chems = list(
		/decl/material/liquid/nutriment = list(1,20),
		/decl/material/liquid/nutriment/plant_oil = list(3,20),
		/decl/material/liquid/drink/milk/soymilk = list(7,20)
	)
	grown_tag = "soybeans"
	slice_product = /obj/item/food/processed_grown/chopped
	slice_amount = 3

/datum/seed/soybean/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"bean")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ebe7c0")
	set_trait(TRAIT_PLANT_ICON,"stalk")

/datum/seed/wheat
	name = "wheat"
	product_name = "wheat"
	display_name = "wheat patch"
	chems = list(/decl/material/liquid/nutriment = list(1,25), /decl/material/liquid/nutriment/flour = list(15,15))
	grown_tag = "wheat"
	slice_product = /obj/item/food/processed_grown/crushed
	slice_amount = 3

/datum/seed/wheat/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"wheat")
	set_trait(TRAIT_PRODUCT_COLOUR,"#dbd37d")
	set_trait(TRAIT_PLANT_COLOUR,"#bfaf82")
	set_trait(TRAIT_PLANT_ICON,"stalk2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/rice
	name = "rice"
	product_name = "rice"
	display_name = "rice paddy"
	chems = list(/decl/material/liquid/nutriment = list(1,25), /decl/material/liquid/nutriment/rice = list(10,15))
	grown_tag = "rice"
	slice_product = /obj/item/food/processed_grown/crushed
	slice_amount = 3

/datum/seed/rice/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"rice")
	set_trait(TRAIT_PRODUCT_COLOUR,"#d5e6d1")
	set_trait(TRAIT_PLANT_COLOUR,"#8ed17d")
	set_trait(TRAIT_PLANT_ICON,"stalk2")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/carrots
	name = "carrot"
	product_name = "carrot"
	display_name = "carrot patch"
	chems = list(/decl/material/liquid/nutriment = list(1,20), /decl/material/liquid/eyedrops = list(3,5), /decl/material/liquid/drink/juice/carrot = list(10,20))
	grown_tag = "carrot"
	slice_product = /obj/item/food/processed_grown/sticks
	slice_amount = 3

/datum/seed/carrots/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"carrot")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ff9900")
	set_trait(TRAIT_PLANT_ICON,"carrot")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/weeds
	name = "weeds"
	product_name = "weed"
	display_name = "weeds"

/datum/seed/weeds/New()
	..()
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,-1)
	set_trait(TRAIT_POTENCY,-1)
	set_trait(TRAIT_IMMUTABLE,-1)
	set_trait(TRAIT_PRODUCT_ICON,"flower4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#fceb2b")
	set_trait(TRAIT_PLANT_COLOUR,"#59945a")
	set_trait(TRAIT_PLANT_ICON,"bush6")

/datum/seed/whitebeets
	name = "whitebeet"
	product_name = "white-beet"
	display_name = "white-beet patch"
	chems = list(/decl/material/liquid/nutriment = list(0,20), /decl/material/liquid/nutriment/sugar = list(1,5))
	grown_tag = "whitebeet"
	slice_product = /obj/item/food/processed_grown/chopped
	slice_amount = 3

/datum/seed/whitebeets/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"carrot2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#eef5b0")
	set_trait(TRAIT_PLANT_COLOUR,"#4d8f53")
	set_trait(TRAIT_PLANT_ICON,"carrot2")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/sugarcane
	name = "sugarcane"
	product_name = "sugarcane"
	display_name = "sugarcane patch"
	chems = list(/decl/material/liquid/nutriment/sugar = list(4,5))

/datum/seed/sugarcane/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"stalk")
	set_trait(TRAIT_PRODUCT_COLOUR,"#b4d6bd")
	set_trait(TRAIT_PLANT_COLOUR,"#6bbd68")
	set_trait(TRAIT_PLANT_ICON,"stalk3")
	set_trait(TRAIT_IDEAL_HEAT, 298)

/datum/seed/watermelon
	name = "watermelon"
	product_name = "watermelon"
	display_name = "watermelon vine"
	product_w_class = ITEM_SIZE_LARGE
	chems = list(/decl/material/liquid/nutriment = list(1,6), /decl/material/liquid/drink/juice/watermelon = list(10,6))
	slice_product = /obj/item/food/processed_grown/slice/large

/datum/seed/watermelon/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,1)
	set_trait(TRAIT_PRODUCT_ICON,"vine")
	set_trait(TRAIT_PRODUCT_COLOUR,"#326b30")
	set_trait(TRAIT_PLANT_COLOUR,"#257522")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_FLESH_COLOUR,"#f22c2c")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/pumpkin
	name = "pumpkin"
	product_name = "pumpkin"
	display_name = "pumpkin vine"
	product_w_class = ITEM_SIZE_LARGE
	chems = list(/decl/material/liquid/nutriment = list(1,6))
	grown_tag = "pumpkin"
	slice_product = /obj/item/clothing/head/pumpkinhead
	slice_amount = 1

/datum/seed/pumpkin/show_slice_message(mob/user, obj/item/tool, obj/item/food/grown/sliced)
	sliced.visible_message(SPAN_NOTICE("\The [user] carves a face into \the [sliced] with \the [tool]."))
	return TRUE

/datum/seed/pumpkin/show_slice_message_poor(mob/user, obj/item/tool, obj/item/food/grown/sliced)
	sliced.visible_message(SPAN_NOTICE("\The [user] crudely carves a face into \the [sliced] with \the [tool]."))
	return TRUE

/datum/seed/pumpkin/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"vine2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#f9ab28")
	set_trait(TRAIT_PLANT_COLOUR,"#bae8c1")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/citrus
	name = "lime"
	product_name = "lime"
	display_name = "lime tree"
	chems = list(/decl/material/liquid/nutriment = list(1,20), /decl/material/liquid/drink/juice/lime = list(10,20))
	grown_tag = "lime"

/datum/seed/citrus/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#3af026")
	set_trait(TRAIT_PLANT_ICON,"tree")
	set_trait(TRAIT_FLESH_COLOUR,"#3af026")
	set_trait(TRAIT_PHOTOSYNTHESIS, 1)

/datum/seed/citrus/lemon
	name = "lemon"
	product_name = "lemon"
	display_name = "lemon tree"
	chems = list(/decl/material/liquid/nutriment = list(1,20), /decl/material/liquid/drink/juice/lemon = list(10,20))
	grown_tag = "lemon"

/datum/seed/citrus/lemon/New()
	..()
	set_trait(TRAIT_PRODUCES_POWER,1)
	set_trait(TRAIT_PRODUCT_COLOUR,"#f0e226")
	set_trait(TRAIT_FLESH_COLOUR,"#f0e226")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_PHOTOSYNTHESIS, 1)

/datum/seed/citrus/orange
	name = "orange"
	product_name = "orange"
	display_name = "orange tree"
	grown_tag = "orange"
	chems = list(/decl/material/liquid/nutriment = list(1,20), /decl/material/liquid/drink/juice/orange = list(10,20))

/datum/seed/citrus/orange/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#ffc20a")
	set_trait(TRAIT_FLESH_COLOUR,"#ffc20a")
	set_trait(TRAIT_PHOTOSYNTHESIS, 1)

/datum/seed/grass
	name = "grass"
	product_name = "grass"
	display_name = "grass patch"
	chems = list(/decl/material/liquid/nutriment = list(1,20))
	grown_tag = "grass"
	product_type = /obj/item/stack/material/bundle/grass
	slice_product = /obj/item/food/processed_grown/chopped
	slice_amount = 3

/datum/seed/grass/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,2)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_PRODUCT_ICON,"grass")
	set_trait(TRAIT_PRODUCT_COLOUR,"#09ff00")
	set_trait(TRAIT_PLANT_COLOUR,"#07d900")
	set_trait(TRAIT_PLANT_ICON,"grass")
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)
	set_trait(TRAIT_PHOTOSYNTHESIS, 1)

/datum/seed/cocoa
	name = "cocoa"
	product_name = "cacao"
	display_name = "cacao tree"
	chems = list(/decl/material/liquid/nutriment = list(1,10), /decl/material/liquid/nutriment/coco = list(4,5))
	slice_product = /obj/item/food/processed_grown/crushed
	slice_amount = 3

/datum/seed/cocoa/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#cca935")
	set_trait(TRAIT_PLANT_ICON,"tree2")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_PHOTOSYNTHESIS, 1)

/datum/seed/cherries
	name = "cherry"
	product_name = "cherry"
	seed_noun = SEED_NOUN_PITS
	display_name = "cherry tree"
	chems = list(/decl/material/liquid/nutriment = list(1,15), /decl/material/liquid/nutriment/sugar = list(1,15), /decl/material/liquid/nutriment/cherryjelly = list(10,15))
	grown_tag = "cherries"
	slice_product = /obj/item/food/processed_grown/crushed
	slice_amount = 3

/datum/seed/cherries/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"cherry")
	set_trait(TRAIT_PRODUCT_COLOUR,"#a80000")
	set_trait(TRAIT_PLANT_ICON,"tree2")
	set_trait(TRAIT_PLANT_COLOUR,"#2f7d2d")
	set_trait(TRAIT_PHOTOSYNTHESIS, 1)

/datum/seed/kudzu
	name = "kudzu"
	product_name = "kudzu"
	display_name = "kudzu vine"
	chems = list(/decl/material/liquid/nutriment = list(1,50), /decl/material/liquid/antitoxins = list(1,25))
	slice_product = /obj/item/food/processed_grown/chopped
	slice_amount = 3

/datum/seed/kudzu/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_SPREAD,2)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#96d278")
	set_trait(TRAIT_PLANT_COLOUR,"#6f7a63")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)

/datum/seed/shand
	name = "shand"
	product_name = "S'randar's hand"
	display_name = "S'randar's hand patch"
	chems = list(/decl/material/liquid/brute_meds = list(0,10))
	grown_tag = "shand"
	slice_product = /obj/item/food/processed_grown/chopped
	slice_amount = 3

/datum/seed/shand/New()
	..()
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"alien3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#378c61")
	set_trait(TRAIT_PLANT_COLOUR,"#378c61")
	set_trait(TRAIT_PLANT_ICON,"tree5")
	set_trait(TRAIT_IDEAL_HEAT, 283)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/mtear
	name = "mtear"
	product_name = "Messa's tear"
	display_name = "Messa's tear patch"
	chems = list(/decl/material/liquid/nutriment/honey = list(1,10), /decl/material/liquid/burn_meds = list(3,5))
	grown_tag = "mtear"
	slice_product = /obj/item/food/processed_grown/chopped
	slice_amount = 3

/datum/seed/mtear/New()
	..()
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"alien4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#4cc5c7")
	set_trait(TRAIT_PLANT_COLOUR,"#4cc789")
	set_trait(TRAIT_PLANT_ICON,"bush7")
	set_trait(TRAIT_IDEAL_HEAT, 283)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/tobacco
	name = "tobacco"
	product_name = "tobacco"
	display_name = "tobacco plant"
	mutants = list("finetobacco", "puretobacco", "badtobacco")
	chems = list(/decl/material/solid/tobacco = list(1,10))
	slice_product = /obj/item/food/processed_grown/chopped
	slice_amount = 3
	product_w_class = ITEM_SIZE_TINY // so that it can fit in bags of tobacco

/datum/seed/tobacco/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_PRODUCT_ICON,"tobacco")
	set_trait(TRAIT_PRODUCT_COLOUR,"#749733")
	set_trait(TRAIT_PLANT_COLOUR,"#749733")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_IDEAL_HEAT, 299)
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/tobacco/finetobacco
	name = "finetobacco"
	product_name = "fine tobacco"
	display_name = "fine tobacco plant"
	chems = list(/decl/material/solid/tobacco/fine = list(1,10))

/datum/seed/tobacco/finetobacco/New()
	..()
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_PRODUCT_COLOUR,"#33571b")
	set_trait(TRAIT_PLANT_COLOUR,"#33571b")
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.20)

/datum/seed/tobacco/puretobacco //provides the pure nicotine reagent
	name = "puretobacco"
	product_name = "succulent tobacco"
	display_name = "succulent tobacco plant"
	chems = list(/decl/material/liquid/nicotine = list(1,10))

/datum/seed/tobacco/puretobacco/New()
	..()
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_PRODUCT_COLOUR,"#b7c61a")
	set_trait(TRAIT_PLANT_COLOUR,"#b7c61a")
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.30)

/datum/seed/tobacco/bad
	name = "badtobacco"
	product_name = "low-grade tobacco"
	display_name = "low-grade tobacco plant"
	mutants = list("tobacco")
	chems = list(/decl/material/solid/tobacco/bad = list(1,10))

/datum/seed/algae
	name = "algae"
	product_name = "algae"
	display_name = "algae patch"
	chems = list(
		/decl/material/liquid/nutriment = list(2,12),
		/decl/material/liquid/bromide = list(3,8)
	)
	grown_tag = "algae"
	exude_gasses = list(/decl/material/gas/methyl_bromide = 3)
	slice_product = /obj/item/food/processed_grown/crushed
	slice_amount = 3

/datum/seed/algae/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"algae")
	set_trait(TRAIT_PRODUCT_COLOUR,"#84bd82")
	set_trait(TRAIT_PLANT_COLOUR,"#6d9c6b")
	set_trait(TRAIT_PLANT_ICON,"algae")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/bamboo
	name = "bamboo"
	product_name = "bamboo"
	display_name = "bamboo thicket"
	chems = list(/decl/material/solid/organic/wood/bamboo = list(6,1))
	mutants = null
	slice_product = /obj/item/food/processed_grown/chopped
	slice_amount = 3

/datum/seed/bamboo/New()
	..()
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,1)
	set_trait(TRAIT_PRODUCT_ICON,"stalk")
	set_trait(TRAIT_PRODUCT_COLOUR, WOOD_COLOR_GENERIC)
	set_trait(TRAIT_PLANT_COLOUR,"#99bc20")
	set_trait(TRAIT_PLANT_ICON,"stalk3")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/tea
	name = "tea"
	product_name = "tea leaf"
	display_name = "tea plant"
	chems = list(/decl/material/liquid/nutriment = list(1))
	dried_chems = list(/decl/material/liquid/nutriment/tea = list(10,10))
	slice_product = /obj/item/food/processed_grown/chopped
	slice_amount = 3

/datum/seed/tea/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,TRUE)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_PRODUCT_ICON,"tobacco")
	set_trait(TRAIT_PRODUCT_COLOUR,"#749733")
	set_trait(TRAIT_PLANT_COLOUR,"#749733")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_IDEAL_HEAT, 299)
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/coffee
	name = "coffee"
	product_name = "coffee cherries"
	display_name = "coffee plant"
	chems = list(/decl/material/liquid/nutriment = list(1))
	roasted_chems = list(/decl/material/liquid/nutriment/coffee = list(10,10))
	backyard_grilling_product = /obj/item/food/grown/grilled
	backyard_grilling_announcement = "roasts and darkens."
	product_material = /decl/material/solid/organic/plantmatter/pith
	slice_product = /obj/item/food/processed_grown/crushed
	slice_amount = 3

/datum/seed/coffee/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,TRUE)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#a80000")
	set_trait(TRAIT_PLANT_COLOUR,"#749733")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_IDEAL_HEAT, 299)
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)
