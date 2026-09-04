/datum/unit_test/icon_test/food_shall_have_icon_states/assemble_skipped_types()
	..()
	skip_types |= typesof(/obj/item/food/grown/segment)

/obj/item/food/grown/segment
	name = "abstract segment"
	is_spawnable_type = FALSE
	seeds_extracted = TRUE // no seed extraction from petals or stamen
	can_dissect = FALSE
	var/datum/plant_segment/segment_data

/obj/item/food/grown/segment/Initialize(mapload, material_key, skip_plate = FALSE, _seed, datum/plant_segment/_segment, obj/item/_source)
	if(!_segment)
		PRINT_STACK_TRACE("Dissected segment created with no segment datum.")
		return INITIALIZE_HINT_QDEL
	segment_data = _segment
	plant_segment_type = segment_data.plant_segment_type
	. = ..()
	update_desc()

/obj/item/food/grown/segment/Destroy()
	. = ..()
	segment_data = null

/obj/item/food/grown/segment/update_base_name()
	// to allow for 'dried nightweave stamen' etc
	if(seed)
		base_name = "[seed.product_name] [segment_data.name]"
	else
		base_name = segment_data.name

/obj/item/food/grown/segment/update_desc()
	base_desc = segment_data.desc // Don't bother doing the descriptor stuff from /grown
	desc = base_desc

/obj/item/food/grown/segment/update_grown_icon()
	. = ..()
	set_icon(segment_data.segment_icon)
	icon_state = segment_data.segment_icon_state

/obj/item/food/grown/segment/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1 && segment_data.examine_info && (!segment_data.examine_info_skill || !segment_data.examine_info_rank || user.skill_check(segment_data.examine_info_skill, segment_data.examine_info_rank)))
		. += segment_data.examine_info
