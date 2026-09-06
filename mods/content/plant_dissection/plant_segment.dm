/datum/plant_segment
	abstract_type = /datum/plant_segment

	var/name
	var/desc

	/// Icon to use for segment overlays on growns.
	var/grown_icon
	/// Base icon state to use for segment overlays on growns. Will be suffixed with a
	/// number indicating which segment it is, if there are more than one. ie "[grown_icon_state]1"
	var/grown_icon_state

	/// Icon to use for harvested segments.
	var/segment_icon = 'mods/content/plant_dissection/icons/segment.dmi'
	/// Icon state to use for harvested segments.
	var/segment_icon_state

	/// List of reagents provided by this segment.
	var/list/reagents
	/// Summary var for above used in volume calc for growns.
	var/list/total_reagent_volume_by_state

	/// Category type used for reagent and physical composition data on /datum/seed.
	var/plant_segment_type = PLANT_SEG_BODY

	/// Whether or not this segment should attempt to overlay on grown products.
	var/contributes_to_fruit_icon = FALSE
	var/contributes_to_reagents = TRUE

	var/examine_info
	var/examine_info_skill = SKILL_BOTANY
	var/examine_info_rank = SKILL_BASIC

	var/dissect_amount = 1 // can be int or 2-entry list for rand bounds
	var/dissect_tool = TOOL_SCALPEL
	var/dissect_skill = SKILL_BOTANY
	var/dissect_skill_requirement = SKILL_ADEPT

/datum/plant_segment/New(var/_name, var/_desc, var/_amt, var/_reagents, var/_examine_info, var/_examine_skill_rank, var/_examine_skill)
	if(_name)
		name = _name
	if(_desc)
		desc = _desc
	if(_reagents)
		reagents = _reagents
	if(_examine_info)
		examine_info = _examine_info
	if(_examine_skill_rank)
		examine_info_rank = _examine_skill_rank
	if(_examine_skill)
		examine_info_skill = _examine_skill
	dissect_amount = _amt
	reagents = _reagents
	total_reagent_volume_by_state = list()
	if(length(reagents))
		for(var/state in reagents)
			total_reagent_volume_by_state[state] = 0
			for(var/rid in reagents[state])
				total_reagent_volume_by_state[state] += reagents[rid]
	..()

/datum/plant_segment/proc/can_harvest_with(var/obj/item/prop, var/mob/user)
	return FALSE

/datum/plant_segment/proc/on_harvest(var/obj/item/prop, var/mob/user, var/obj/item/food/grown/fruit)
	var/obj/item/product = new /obj/item/food/grown/segment(get_turf(fruit), prop?.material?.type, TRUE, fruit.seed, src, fruit)
	user.put_in_hands(product)
	to_chat(user, SPAN_NOTICE("You remove \a [product] from \the [fruit][prop ? " with \the [prop]" : ""]."))
	fruit.remove_segment(src)
	return TRUE

/datum/plant_segment/proc/apply_fruit_appearance(var/obj/item/food/grown/fruit, var/count = 0)
	return

/datum/plant_segment/petal
	segment_icon_state = "petal"
	dissect_tool = null
	plant_segment_type = PLANT_SEG_PETAL
	contributes_to_reagents = FALSE

/datum/plant_segment/stamen
	segment_icon_state = "stamen"
	plant_segment_type = PLANT_SEG_STAMEN

/datum/plant_segment/stigma
	segment_icon_state = "stigma"
	plant_segment_type = PLANT_SEG_STIGMA
	contributes_to_reagents = FALSE
