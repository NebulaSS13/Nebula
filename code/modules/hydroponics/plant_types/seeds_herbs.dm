/datum/seed/herb
	abstract_type = /datum/seed/herb
	allergen_flags = ALLERGEN_NONE // Do not make people allergic to the only medicine available on Shadyhills

/datum/seed/herb/New()
	..()
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/herb/yarrow
	name = "yarrow"
	product_name = "yarrow flower"
	display_name = "yarrow patch"
	chems = list(
		/decl/material/liquid/nutriment         = list(1,20),
		/decl/material/liquid/brute_meds/yarrow = list(1, 1)
	)
	dried_chems = list(/decl/material/liquid/brute_meds/yarrow = list(10,10))

/datum/seed/herb/yarrow/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#e9e2c2")
	set_trait(TRAIT_PRODUCT_ICON,"flower4")
	set_trait(TRAIT_PLANT_COLOUR,"#6b8c5e")
	set_trait(TRAIT_PLANT_ICON,"flower4")

/datum/seed/herb/aloe
	name = "aloe"
	product_name = "aloe vera"
	display_name = "aloe patch"
	chems = list(
		/decl/material/liquid/nutriment      = list(1,5),
		/decl/material/liquid/burn_meds/aloe = list(10,10)
	)

/datum/seed/herb/aloe/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#2d7746")
	set_trait(TRAIT_PRODUCT_ICON,"grass")
	set_trait(TRAIT_PLANT_COLOUR,"#2d7746")
	set_trait(TRAIT_PLANT_ICON,"ambrosia")

/datum/seed/herb/ginseng
	name = "ginseng"
	product_name = "ginseng root"
	display_name = "ginseng patch"
	chems = list(
		/decl/material/liquid/nutriment          = list(1,20),
		/decl/material/liquid/antitoxins/ginseng = list(1, 1)
	)
	dried_chems = list(/decl/material/liquid/antitoxins/ginseng = list(10,10))

/datum/seed/herb/ginseng/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#ddbb7c")
	set_trait(TRAIT_PRODUCT_ICON,"pod")
	set_trait(TRAIT_PLANT_COLOUR,"#6b8c5e")
	set_trait(TRAIT_PLANT_ICON,"grass")

/datum/seed/herb/valerian
	name = "valerian"
	product_name = "valerian flower"
	display_name = "valerian patch"
	chems = list(
		/decl/material/liquid/nutriment          = list(1,20),
		/decl/material/liquid/sedatives/valerian = list(1, 1)
	)
	dried_chems = list(/decl/material/liquid/sedatives/valerian = list(10,10))

/datum/seed/herb/valerian/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#e9c2c2")
	set_trait(TRAIT_PRODUCT_ICON,"flower4")
	set_trait(TRAIT_PLANT_COLOUR,"#6b8c5e")
	set_trait(TRAIT_PLANT_ICON,"flower4")

/datum/seed/herb/foxglove
	name = "foxglove"
	product_name = "foxglove flower"
	display_name = "foxglove patch"
	chems = list(
		/decl/material/liquid/nutriment           = list(1,20),
		/decl/material/liquid/stabilizer/foxglove = list(1, 1)
	)
	dried_chems = list(/decl/material/liquid/stabilizer/foxglove = list(10,10))

/datum/seed/herb/foxglove/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#e9c2c2")
	set_trait(TRAIT_PRODUCT_ICON,"flowers")
	set_trait(TRAIT_PLANT_COLOUR,"#6b8c5e")
	set_trait(TRAIT_PLANT_ICON,"bush7")
