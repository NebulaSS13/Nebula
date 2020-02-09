/obj/item/organ/internal/eyes/yinglet
	relative_size = 15
	eye_icon = 'icons/mob/human_races/species/yinglet/eyes.dmi'

// Copied from vox stomach, upstream Baycode.
/obj/item/organ/internal/stomach/yinglet
	name = "scav stomach"
	var/global/list/gains_nutriment_from_inedible_reagents = list(
		/datum/reagent/woodpulp =      3,
		/datum/reagent/anfo/plus =     2,
		/datum/reagent/anfo =          1,
		/datum/reagent/lube =          1,
		/datum/reagent/cleaner =       1,
		/datum/reagent/foaming_agent = 1,
		/datum/reagent/surfactant =    1,
		/datum/reagent/paint =         1
	)
	var/global/list/gains_nutriment_from_matter = list(
		MAT_WOOD =            TRUE,
		MAT_MAHOGANY =        TRUE,
		MAT_MAPLE =           TRUE,
		MAT_EBONY =           TRUE,
		MAT_WALNUT =          TRUE,
		MAT_LEATHER_GENERIC = TRUE,
		MAT_PLASTIC =         TRUE,
		MAT_CARDBOARD =       TRUE,
		MAT_CLOTH =           TRUE,
		MAT_ROCK_SALT =       TRUE
	)

/obj/item/organ/internal/stomach/yinglet/Process()
	. = ..()
	if(!is_usable())
		return
	// Handle some post-metabolism reagent processing for generally inedible foods.
	var/total_nutriment = 0
	if(ingested.total_volume > 0)
		for(var/datum/reagent/R in ingested.reagent_list)
			total_nutriment += gains_nutriment_from_inedible_reagents[R.type]
	for(var/obj/item/food in contents)
		for(var/mat in food.matter)
			if(!gains_nutriment_from_matter[mat])
				continue
			var/digested = min(food.matter[mat], rand(200,500))
			food.matter[mat] -= digested
			digested *= 0.75
			if(food.matter[mat] <= 0)
				food.matter -= mat
			if(!LAZYLEN(food.matter))
				qdel(food)
			total_nutriment += digested/100
	// Apply to reagents.
	total_nutriment = Floor(total_nutriment)
	if(total_nutriment > 0 && owner)
		owner.adjust_nutrition(total_nutriment)

/obj/item/organ/external/chest/yinglet
	max_damage = 45
	min_broken_damage = 25

/obj/item/organ/external/groin/yinglet
	max_damage = 45
	min_broken_damage = 25

/obj/item/organ/external/head/yinglet
	max_damage = 45
	min_broken_damage = 25

/obj/item/organ/external/arm/yinglet
	max_damage = 25
	min_broken_damage = 15

/obj/item/organ/external/arm/right/yinglet
	max_damage = 25
	min_broken_damage = 15

/obj/item/organ/external/leg/yinglet
	max_damage = 25
	min_broken_damage = 15

/obj/item/organ/external/leg/right/yinglet
	max_damage = 25
	min_broken_damage = 15

/obj/item/organ/external/hand/yinglet
	max_damage = 20
	min_broken_damage = 10

/obj/item/organ/external/hand/right/yinglet
	max_damage = 20
	min_broken_damage = 10

/obj/item/organ/external/foot/yinglet
	max_damage = 20
	min_broken_damage = 10

/obj/item/organ/external/foot/right/yinglet
	max_damage = 20
	min_broken_damage = 10
