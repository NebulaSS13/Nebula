/datum/seed/herb
	abstract_type = /datum/seed/herb
	allergen_flags = ALLERGEN_NONE // Do not make people allergic to the only medicine available on Shadyhills
	produces_pollen = 0.5

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

/datum/seed/herb/yarrow/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#e9e2c2")
	set_trait(TRAIT_PRODUCT_ICON,"flower4")
	set_trait(TRAIT_PLANT_COLOUR,"#6b8c5e")
	set_trait(TRAIT_PLANT_ICON,"flower4")
	set_chemical_amount(/decl/material/liquid/nutriment,         list(1,20))
	set_chemical_amount(/decl/material/liquid/brute_meds/yarrow, list(1, 1))
	set_chemical_amount(/decl/material/liquid/brute_meds/yarrow, list(10,10), _state = PLANT_STATE_DRIED)

/datum/seed/herb/aloe
	name = "aloe"
	product_name = "aloe vera"
	display_name = "aloe patch"

/datum/seed/herb/aloe/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#2d7746")
	set_trait(TRAIT_PRODUCT_ICON,"grass")
	set_trait(TRAIT_PLANT_COLOUR,"#2d7746")
	set_trait(TRAIT_PLANT_ICON,"ambrosia")
	set_chemical_amount(/decl/material/liquid/nutriment,      list(1,5))
	set_chemical_amount(/decl/material/liquid/burn_meds/aloe, list(10,10))

/datum/seed/herb/ginseng
	name = "ginseng"
	product_name = "ginseng root"
	display_name = "ginseng patch"

/datum/seed/herb/ginseng/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#ddbb7c")
	set_trait(TRAIT_PRODUCT_ICON,"pod")
	set_trait(TRAIT_PLANT_COLOUR,"#6b8c5e")
	set_trait(TRAIT_PLANT_ICON,"grass")
	set_chemical_amount(/decl/material/liquid/nutriment,          list(1,20))
	set_chemical_amount(/decl/material/liquid/antitoxins/ginseng, list(1, 1))
	set_chemical_amount(/decl/material/liquid/antitoxins/ginseng, list(10,10), _state = PLANT_STATE_DRIED)

/datum/seed/herb/valerian
	name = "valerian"
	product_name = "valerian flower"
	display_name = "valerian patch"

/datum/seed/herb/valerian/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#e9c2c2")
	set_trait(TRAIT_PRODUCT_ICON,"flower4")
	set_trait(TRAIT_PLANT_COLOUR,"#6b8c5e")
	set_trait(TRAIT_PLANT_ICON,"flower4")
	set_chemical_amount(/decl/material/liquid/nutriment, list(1,20))
	set_chemical_amount(/decl/material/liquid/sedatives/valerian, list(1, 1))
	set_chemical_amount(/decl/material/liquid/sedatives/valerian, list(10,10), _state = PLANT_STATE_DRIED)

/datum/seed/herb/foxglove
	name = "foxglove"
	product_name = "foxglove flower"
	display_name = "foxglove patch"

/datum/seed/herb/foxglove/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#e9c2c2")
	set_trait(TRAIT_PRODUCT_ICON,"flowers")
	set_trait(TRAIT_PLANT_COLOUR,"#6b8c5e")
	set_trait(TRAIT_PLANT_ICON,"bush7")
	set_chemical_amount(/decl/material/liquid/nutriment,           list(1,20))
	set_chemical_amount(/decl/material/liquid/stabilizer/foxglove, list(1, 1))
	set_chemical_amount(/decl/material/liquid/stabilizer/foxglove, list(10,10), _state = PLANT_STATE_DRIED)
