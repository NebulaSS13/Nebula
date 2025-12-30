/proc/cmp_appearance_data(var/datum/appearance_data/a, var/datum/appearance_data/b)
	return b.priority - a.priority

/proc/cmp_camera_ctag_asc(var/obj/machinery/camera/a, var/obj/machinery/camera/b)
	return sorttext(b.c_tag, a.c_tag)

/proc/cmp_camera_ctag_dsc(var/obj/machinery/camera/a, var/obj/machinery/camera/b)
	return sorttext(a.c_tag, b.c_tag)

/proc/cmp_crew_sensor_modifier(var/crew_sensor_modifier/a, var/crew_sensor_modifier/b)
	return b.priority - a.priority

/proc/cmp_follow_holder(var/datum/follow_holder/a, var/datum/follow_holder/b)
	if(a.sort_order == b.sort_order)
		return sorttext(b.get_name(), a.get_name())

	return a.sort_order - b.sort_order

/proc/cmp_name_or_type_asc(atom/a, atom/b)
	return sorttext("[b]", "[a]")

/proc/cmp_name_asc(atom/a, atom/b)
	return sorttext(b.name, a.name)

/proc/cmp_name_dsc(atom/a, atom/b)
	return sorttext(a.name, b.name)

/proc/cmp_numeric_asc(a,b)
	return a - b

/proc/cmp_numeric_dsc(a,b)
	return b - a

/proc/cmp_subsystem_display(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return sorttext(b.name, a.name)

/proc/cmp_subsystem_init(datum/controller/subsystem/a, datum/controller/subsystem/b)
	var/a_init_order = ispath(a) ? initial(a.init_order) : a.init_order
	var/b_init_order = ispath(b) ? initial(b.init_order) : b.init_order

	return b_init_order - a_init_order	//uses initial() so it can be used on types

/proc/cmp_subsystem_priority(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return a.priority - b.priority

/proc/cmp_text_asc(a,b)
	return sorttext(b, a)

/proc/cmp_text_dsc(a,b)
	return sorttext(a, b)

/proc/cmp_list_name_key_asc(var/list/a, var/list/b)
	return sorttext(b["name"], a["name"])

/proc/cmp_list_name_key_dsc(var/list/a, var/list/b)
	return sorttext(a["name"], b["name"])

/proc/cmp_qdel_item_time(datum/qdel_item/A, datum/qdel_item/B)
	. = B.hard_delete_time - A.hard_delete_time
	if (!. && B.qdels && A.qdels) // sort by time per call
		. = (B.destroy_time / B.qdels) - (A.destroy_time / A.qdels)
	if (!.)
		. = B.destroy_time - A.destroy_time
	if (!.)
		. = B.failures - A.failures
	if (!.)
		. = B.qdels - A.qdels

/proc/cmp_unit_test_priority(datum/unit_test/A, datum/unit_test/B)
	. = A.priority - B.priority
	if (!.)
		. = sorttext(B, A)

/proc/cmp_timer(datum/timedevent/a, datum/timedevent/b)
	return a.timeToRun - b.timeToRun

/proc/cmp_clientcolor_priority(datum/client_color/A, datum/client_color/B)
	return B.priority - A.priority

/proc/cmp_power_component_priority(obj/item/stock_parts/power/A, obj/item/stock_parts/power/B)
	return B.priority - A.priority

/proc/cmp_fusion_reaction_asc(var/decl/fusion_reaction/A, var/decl/fusion_reaction/B)
	return A.priority - B.priority

/proc/cmp_fusion_reaction_des(var/decl/fusion_reaction/A, var/decl/fusion_reaction/B)
	return B.priority - A.priority

/proc/cmp_human_examine_priority(decl/human_examination/a, decl/human_examination/b)
	return a.priority - b.priority

/proc/cmp_program(var/datum/computer_file/program/A, var/datum/computer_file/program/B)
	return cmp_text_asc(A.filedesc, B.filedesc)

/proc/cmp_accounts_asc(var/datum/computer_file/data/account/A, var/datum/computer_file/data/account/B)
	return cmp_text_asc(A.login, B.login)

/proc/cmp_planelayer(atom/A, atom/B)
	return (B.plane - A.plane) || (B.layer - A.layer)

/proc/cmp_currency_denomination_des(var/datum/denomination/A, var/datum/denomination/B)
	. = B.marked_value - A.marked_value

/proc/cmp_cocktail_des(var/decl/cocktail/A, var/decl/cocktail/B)
	. = B.mix_priority() - A.mix_priority()

/proc/cmp_mob_sortvalue_asc(mob/a, mob/b)
	. = a.mob_sort_value - b.mob_sort_value

/proc/cmp_mob_sortvalue_des(mob/a, mob/b)
	. = b.mob_sort_value - a.mob_sort_value

/proc/cmp_rcon_tag_asc(var/obj/machinery/power/smes/buildable/a, var/obj/machinery/power/smes/buildable/b)
	return sorttext(b.RCon_tag, a.RCon_tag)

/proc/cmp_category_groups(var/datum/category_group/A, var/datum/category_group/B)
	return A.sort_order - B.sort_order

/proc/cmp_job_asc(var/datum/job/A, var/datum/job/B)
	return A.get_occupations_tab_sort_score() - B.get_occupations_tab_sort_score()

/proc/cmp_job_desc(var/datum/job/A, var/datum/job/B)
	return B.get_occupations_tab_sort_score() - A.get_occupations_tab_sort_score()

/proc/cmp_lobby_option_asc(var/datum/lobby_option/A, var/datum/lobby_option/B)
	return A.sort_priority - B.sort_priority

/proc/cmp_files_sort(datum/computer_file/a, datum/computer_file/b)
	. = istype(b, /datum/computer_file/directory) - istype(a, /datum/computer_file/directory) // Prioritize directories over other files.
	if(!.)
		return sorttext(b.filename, a.filename)

/proc/cmp_submap_archetype_asc(var/decl/submap_archetype/A, var/decl/submap_archetype/B)
	return A.sort_priority - B.sort_priority

/proc/cmp_submap_asc(var/datum/submap/A, var/datum/submap/B)
	return A.archetype.sort_priority - B.archetype.sort_priority

/proc/cmp_gripper_asc(datum/inventory_slot/gripper/a, datum/inventory_slot/gripper/b)
	return a.hand_sort_priority - b.hand_sort_priority

/proc/cmp_decl_uid_asc(decl/a, decl/b)
	return sorttext(b.uid, a.uid)

/proc/cmp_decl_sort_value_asc(decl/a, decl/b)
	return a.sort_order - b.sort_order

/proc/cmp_inventory_slot_desc(datum/inventory_slot/a, datum/inventory_slot/b)
	return b.quick_equip_priority - a.quick_equip_priority

/proc/cmp_skill_category_asc(decl/skill_category/a, decl/skill_category/b)
	return a.sort_priority - b.sort_priority

/proc/cmp_skill_asc(decl/skill/a, decl/skill/b)
	if(length(a.prerequisites))
		var/decl/skill/prerequisite = GET_DECL(a.prerequisites[1])
		if(b == prerequisite)
			return 1 // goes before
		return cmp_skill_asc(GET_DECL(a.prerequisites[1]), b)
	if(length(b.prerequisites))
		var/decl/skill/prerequisite = GET_DECL(b.prerequisites[1])
		if(a == prerequisite)
			return -1 // goes after
		return cmp_skill_asc(a, GET_DECL(b.prerequisites[1]))
	return cmp_name_or_type_asc(a, b)

/proc/cmp_priority_list(list/A, list/B)
	return A["priority"] - B["priority"]
