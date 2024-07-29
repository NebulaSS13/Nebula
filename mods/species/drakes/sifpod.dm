/decl/recipe/roast_sifpod
	fruit = list("sifpod" = 1)
	reagent_mix = REAGENT_REPLACE // Clear the sifsap.
	result = /obj/item/food/roast_sifpod

/datum/seed/sifpod
	name = "sifpod"
	product_name = "sivian pod"
	display_name = "sivian pod"
	grown_tag = "sifpod"
	backyard_grilling_product = /obj/item/food/roast_sifpod
	backyard_grilling_announcement = "crackles and pops as the roast hull splits open."
	chems = list(
		/decl/material/liquid/nutriment = list(1,5),
		/decl/material/liquid/sifsap    = list(10,20)
	)

/datum/seed/sifpod/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,10)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,12)
	set_trait(TRAIT_PRODUCT_ICON,"alien3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#0720c3")
	set_trait(TRAIT_PLANT_ICON,"tree5")
	set_trait(TRAIT_FLESH_COLOUR,"#05157d")
	set_trait(TRAIT_IDEAL_LIGHT, 1)

/obj/item/food/roast_sifpod
	name = "roast sifpod"
	desc = "A charred and blackened sifpod, roasted to kill the toxins and split open to reveal steaming blue-green fruit jelly within. A popular campfire snack."
	icon = 'mods/species/drakes/icons/sifpod.dmi'
	icon_state = ICON_STATE_WORLD
	nutriment_amt = 4
	nutriment_desc = list(
		"sweet, tart fruit jelly" = 4,
		"pungent muskiness"       = 1
	)
	bitesize = 3
