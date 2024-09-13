/datum/seed/mollusc
	name = "mollusc"
	product_name = "mollusc"
	display_name = "mollusc bed"
	product_type = /obj/item/mollusc
	seed_noun = SEED_NOUN_EGGS
	mutants = null
	allergen_flags = ALLERGEN_FISH

/datum/seed/mollusc/New()
	..()
	set_trait(TRAIT_MATURATION,        10)
	set_trait(TRAIT_PRODUCTION,        1)
	set_trait(TRAIT_YIELD,             3)
	set_trait(TRAIT_POTENCY,           1)
	set_trait(TRAIT_PRODUCT_ICON,      "mollusc")
	set_trait(TRAIT_PLANT_ICON,        "mollusc")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_IDEAL_HEAT,        288)
	set_trait(TRAIT_LIGHT_TOLERANCE,   6)
	set_trait(TRAIT_PRODUCT_COLOUR,    "#aaabba")
	set_trait(TRAIT_PLANT_COLOUR,      "#aaabba")

/datum/seed/mollusc/clam
	name = "clam"
	product_name = "clam"
	display_name = "clam bed"
	product_type = /obj/item/mollusc/clam/fished

/datum/seed/mollusc/clam/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR, "#9aaca6")
	set_trait(TRAIT_PLANT_COLOUR,   "#9aaca6")

/datum/seed/mollusc/barnacle
	name = "barnacle"
	product_name = "barnacle"
	display_name = "barnacle bed"
	product_type = /obj/item/mollusc/barnacle/fished

/datum/seed/mollusc/barnacle/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR, "#c1c0b6")
	set_trait(TRAIT_PLANT_COLOUR,   "#c1c0b6")
