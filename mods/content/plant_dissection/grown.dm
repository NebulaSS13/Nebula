/obj/item/food/grown
	var/examine_info
	var/examine_info_skill = SKILL_BOTANY
	var/examine_info_rank = SKILL_BASIC
	var/can_dissect = TRUE
	var/list/segments

/obj/item/food/grown/set_seed()
	..()
	if(!seed || !can_dissect)
		return
	var/list/all_segments = seed.get_physical_composition()
	if(!length(all_segments))
		can_dissect = FALSE
		return
	for(var/datum/plant_segment/segment as anything in all_segments)
		var/add_seg = 0
		if(islist(segment.dissect_amount))
			add_seg = rand(segment.dissect_amount[1], segment.dissect_amount[2])
		else if(isnum(segment.dissect_amount))
			add_seg = segment.dissect_amount
		if(add_seg)
			LAZYSET(segments, segment, add_seg)

/obj/item/food/grown/initialize_reagents(populate)
	var/segment_amount = 0
	for(var/datum/plant_segment/segment as anything in segments)
		if(segment.contributes_to_reagents)
			segment_amount += LAZYACCESS(segment.total_reagent_volume_by_state, (PLANT_STATE_FRESH))
	chem_volume = max(chem_volume, segment_amount)
	return ..()

/obj/item/food/grown/Destroy()
	segments = null
	return ..()

/obj/item/food/grown/update_grown_icon()
	. = ..()
	if(can_dissect && length(segments))
		var/list/segment_count = list()
		for(var/datum/plant_segment/segment as anything in segments)
			if(!segment.grown_icon || !segment.grown_icon_state)
				continue
			for(var/i = 1 to segments[segment])
				add_overlay(image(segment.grown_icon, "[segment.grown_icon_state][++segment_count[segment.name]]"))

/obj/item/food/grown/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1 && can_dissect && examine_info && (!examine_info_skill || !examine_info_rank || user.skill_check(examine_info_skill, examine_info_rank)))
		. += examine_info

/obj/item/food/grown/get_examine_hints(mob/user, distance, infix, suffix)
	. = ..()
	if(distance > 1 || !can_dissect)
		return

	var/list/fruit_segment_strings = list()
	for(var/datum/plant_segment/segment as anything in segments)
		if(!segment.dissect_skill || !segment.dissect_skill_requirement || user.skill_check(segment.dissect_skill, segment.dissect_skill_requirement))
			var/decl/tool_archetype/tool = segment.dissect_tool && GET_DECL(segment.dissect_tool)
			var/segment_string_index = tool?.name ? ADD_ARTICLE(tool.name) : "your hands"
			LAZYINITLIST(fruit_segment_strings[segment_string_index])
			fruit_segment_strings[segment_string_index][segment.name] += LAZYACCESS(segments, segment)

	for(var/segment_ind in fruit_segment_strings)
		var/list/segment_strings_count = list()
		for(var/segment_string in fruit_segment_strings[segment_ind])
			segment_strings_count += "[fruit_segment_strings[segment_ind][segment_string]] [segment_string]\s"
		if(length(segment_strings_count))
			LAZYADD(., SPAN_NOTICE("With [segment_ind], you could harvest [english_list(segment_strings_count)]."))

/obj/item/food/grown/attackby(obj/item/W, mob/living/user)
	if(can_dissect && !user?.check_intent(I_FLAG_HARM))
		for(var/datum/plant_segment/segment as anything in segments)
			if(!segment.dissect_tool || !W.get_tool_quality(segment.dissect_tool))
				continue
			segment.on_harvest(W, user, src)
			return TRUE
	return ..()

/obj/item/food/grown/attack_self(mob/user)
	if(can_dissect)
		for(var/datum/plant_segment/segment as anything in segments)
			if(segment.dissect_tool)
				continue
			if(!segment.dissect_skill || !segment.dissect_skill_requirement || user.skill_check(segment.dissect_skill, segment.dissect_skill_requirement))
				segment.on_harvest(null, user, src)
				return TRUE
	return ..()

/obj/item/food/grown/proc/remove_segment(var/datum/plant_segment/segment)

	if(!can_dissect || !(segment in segments))
		return

	if(reagents?.total_volume && segment.contributes_to_reagents)
		for(var/rid in segment.reagents)
			reagents.remove_reagent(rid, segment.reagents[rid])

	segments[segment]--
	if(segments[segment] <= 0)
		LAZYREMOVE(segments, segment)
		update_icon()

	if(!length(segments) && !QDELETED(src))
		qdel(src)
