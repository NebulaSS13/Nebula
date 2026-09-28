/datum/seed/grapes/eyebulbs
	name         = "eyebulbs"
	product_name = "eyebulb"
	display_name = "eyebulbs"
	grown_tag    = "eyebulbs"
	mutants      = null

/datum/seed/grapes/eyebulbs/New()
	..()
	set_trait(TRAIT_PLANT_COLOUR,"#471a73")
	set_trait(TRAIT_PRODUCT_COLOUR,"#131217")

	clear_chemical_composition()
	set_chemical_amount(/decl/material/liquid/nutriment, list(1,3))
	set_chemical_amount(/decl/material/liquid/eyedrops, list(3,5))

//Wabback / varieties.
/datum/seed/wabback
	abstract_type = /datum/seed/wabback

/datum/seed/wabback/New()
	..()
	set_trait(TRAIT_IDEAL_LIGHT, 5)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,3)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"carrot2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#e6edfa")
	set_trait(TRAIT_PLANT_ICON,"chute")
	set_trait(TRAIT_PLANT_COLOUR, "#0650ce")
	set_trait(TRAIT_WATER_CONSUMPTION, 10)
	set_trait(TRAIT_ALTER_TEMP, -1)
	set_trait(TRAIT_CARNIVOROUS,1)
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_SPREAD,1)

/datum/seed/wabback/white
	name         = "whitewabback"
	product_name = "white wabback"
	seed_noun    = "nodes"
	display_name = "white wabback"
	grown_tag    = "wabback"
	mutants      = list(
		/datum/seed/wabback/black::name,
		/datum/seed/wabback/wild::name
	)
	product_type = /obj/item/stack/material/bolt/mapped/cloth

/datum/seed/wabback/white/New()
	..()
	set_chemical_amount(/decl/material/liquid/nutriment,   list(1,10))
	set_chemical_amount(/decl/material/solid/organic/meat, list(1,5))
	set_chemical_amount(/decl/material/liquid/enzyme,      list(0,3))

/datum/seed/wabback/black
	name         = "blackwabback"
	product_name = "black wabback"
	display_name = "black wabback"
	mutants      = null

/datum/seed/wabback/black/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#2e2f32")
	set_trait(TRAIT_CARNIVOROUS,2)

	set_chemical_amount(/decl/material/liquid/nutriment,    list(1,3))
	set_chemical_amount(/decl/material/solid/organic/meat,  list(1,10))
	set_chemical_amount(/decl/material/liquid/presyncopics, list(0, 1))

/datum/seed/wabback/wild
	name         = "wildwabback"
	product_name = "wild wabback"
	display_name = "wild wabback"
	mutants      = list("whitewabback")

/datum/seed/wabback/wild/New()
	..()

	set_trait(TRAIT_IDEAL_LIGHT, 3)
	set_trait(TRAIT_WATER_CONSUMPTION, 7)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.1)
	set_trait(TRAIT_YIELD,5)

	set_chemical_amount(/decl/material/liquid/nutriment,   list(1,15))
	set_chemical_amount(/decl/material/solid/organic/meat, list(0,2))
	set_chemical_amount(/decl/material/liquid/enzyme,      list(0,1))

/datum/seed/cavebulbs
	name = "cavebulbs"
	product_name = "cavebulb"
	display_name = "cavebulbs"

/datum/seed/cavebulbs/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCT_ICON,"flower2")
	set_trait(TRAIT_PLANT_ICON,"flower2")
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#ff9900")
	set_trait(TRAIT_PRODUCT_COLOUR,"#c78a30")
	set_trait(TRAIT_PLANT_COLOUR,"#82602e")

	clear_chemical_composition()
	set_chemical_amount(/decl/material/liquid/nutriment, list(1,10))
	set_chemical_amount(/decl/material/solid/spices, list(1,10))

// TODO: port frostbelle icons to xenobotany system
/datum/seed/flower/frostbelle
	name = "frostbelles"
	product_name = "frostbelle"
	display_name = "frostbelle patch"

/datum/seed/flower/frostbelle/New()
	. = ..()

	clear_chemical_composition()
	set_chemical_amount(/decl/material/liquid/painkillers/strong, list(1, 0))
	set_chemical_amount(/decl/material/liquid/sifsap, list(5, 5))
	set_chemical_amount(/decl/material/liquid/hallucinogenics, list(5, 5))
