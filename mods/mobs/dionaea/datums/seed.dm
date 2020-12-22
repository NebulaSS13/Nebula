/datum/seed/diona
	name = "diona"
	seed_name = "diona"
	seed_noun = SEED_NOUN_NODES
	display_name = "diona nymph pods"
	can_self_harvest = 1
	product_type = /mob/living/carbon/alien/diona

/datum/seed/diona/New()
	..()
	set_trait(TRAIT_IMMUTABLE,1)
	set_trait(TRAIT_ENDURANCE,8)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,10)
	set_trait(TRAIT_YIELD,1)
	set_trait(TRAIT_POTENCY,30)
	set_trait(TRAIT_PRODUCT_ICON,"diona")
	set_trait(TRAIT_PRODUCT_COLOUR,"#799957")
	set_trait(TRAIT_PLANT_COLOUR,"#66804b")
	set_trait(TRAIT_PLANT_ICON,"alien4")

/obj/item/seeds/diona
	seed_type = "diona"

/decl/hierarchy/supply_pack/hydroponics/exoticseeds/Initialize()
	contains[/obj/item/seeds/diona] = 2
	. = ..()
