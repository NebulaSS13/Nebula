/obj/item/organ/internal/eyes/yinglet
	relative_size = 15
	eye_icon = 'icons/mob/human_races/species/yinglet/eyes.dmi'

// Copied from vox stomach, upstream Baycode.
/obj/item/organ/internal/stomach/yinglet
	name = "scav stomach"
	var/global/list/gains_nutriment_from_inedible_reagents = list(
		/datum/reagent/woodpulp =      3,
		/datum/reagent/anfo/plus =     2,
		/datum/reagent/ultraglue =     1,
		/datum/reagent/anfo =          1,
		/datum/reagent/coolant =       1,
		/datum/reagent/lube =          1,
		/datum/reagent/lube/oil =      1,
		/datum/reagent/space_cleaner = 1,
		/datum/reagent/napalm =        1,
		/datum/reagent/napalm/b =      1,
		/datum/reagent/thermite =      1,
		/datum/reagent/foaming_agent = 1,
		/datum/reagent/surfactant =    1,
		/datum/reagent/paint =         1
	)

/obj/item/organ/internal/stomach/yinglet/Process()
	. = ..()
	if(is_usable())
		// Handle some post-metabolism reagent processing for generally inedible foods.
		if(ingested.total_volume > 0)
			for(var/datum/reagent/R in ingested.reagent_list)
				var/inedible_nutriment_amount = gains_nutriment_from_inedible_reagents[R.type]
				if(inedible_nutriment_amount > 0)
					owner.adjust_nutrition(inedible_nutriment_amount)

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
