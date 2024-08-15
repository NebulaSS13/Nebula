/datum/preferences
	var/list/gear_list //Custom/fluff item loadouts.
	var/gear_slot = 1  //The current gear save slot
	var/total_loadout_cost = 0
	var/list/total_loadout_selections = list()

/datum/preferences/proc/Gear()
	return LAZYACCESS(gear_list, gear_slot)

/datum/category_item/player_setup_item/loadout
	name = "Loadout"
	sort_order = 1
	var/current_tab
	var/hide_unavailable_gear = 0

/datum/category_item/player_setup_item/loadout/New()
	decls_repository.get_decls_of_subtype(/decl/loadout_option) // Pre-fetch the gear decls to make sure the globals are populated.
	..()

/datum/category_item/player_setup_item/loadout/load_character(datum/pref_record_reader/R)
	pref.gear_list = R.read("gear_list")
	pref.gear_slot = R.read("gear_slot")

/datum/category_item/player_setup_item/loadout/save_character(datum/pref_record_writer/W)
	W.write("gear_list", pref.gear_list)
	W.write("gear_slot", pref.gear_slot)

/datum/category_item/player_setup_item/loadout/proc/skill_check(var/list/jobs, var/list/skills_required)
	for(var/datum/job/J in jobs)
		. = TRUE
		for(var/R in skills_required)
			if(pref.get_total_skill_value(J, R) < skills_required[R])
				. = FALSE
				break
		if(.)
			return

/decl/loadout_option/proc/can_afford(var/mob/user, var/datum/preferences/pref)
	if(cost > 0 && (pref.total_loadout_cost + cost) > get_config_value(/decl/config/num/max_gear_cost))
		return FALSE
	var/decl/loadout_category/LC = GET_DECL(category)
	if(!LC || pref.total_loadout_selections[category] >= LC.max_selections)
		return FALSE
	return TRUE

/decl/loadout_option/proc/can_be_taken_by(var/mob/user, var/datum/preferences/pref)

	if(!category)
		return FALSE

	if(whitelisted)
		if(!user)
			return FALSE
		var/found_species = FALSE
		for(var/species in whitelisted)
			if(is_species_whitelisted(user, species))
				found_species = TRUE
				break
		if(!found_species)
			return FALSE

	if(required_traits)
		for(var/trait in required_traits)
			if(!(trait in pref.traits))
				return FALSE

	if(faction_restricted)
		var/has_correct_faction = FALSE
		for(var/token in ALL_CULTURAL_TAGS)
			if(pref.cultural_info[token] in faction_restricted)
				has_correct_faction = TRUE
				break
		if(!has_correct_faction)
			return FALSE

	return TRUE

/datum/category_item/player_setup_item/loadout/sanitize_character()

	var/loadout_slots = get_config_value(/decl/config/num/loadout_slots)
	pref.gear_slot = sanitize_integer(pref.gear_slot, 1, loadout_slots, initial(pref.gear_slot))
	if(!islist(pref.gear_list))
		pref.gear_list = list()

	if(pref.gear_list.len < loadout_slots)
		pref.gear_list.len = loadout_slots

	for(var/index = 1 to loadout_slots)

		pref.total_loadout_cost = 0
		pref.total_loadout_selections = list()
		var/list/gears = pref.gear_list[index]
		if(istype(gears))
			for(var/gear_id in gears)
				var/mob/user = preference_mob()
				var/decl/loadout_option/LO = decls_repository.get_decl_by_id_or_var(gear_id, /decl/loadout_option)

				if(!istype(LO))
					gears -= gear_id
					continue

				// Swap names for UIDs to grandfather in old saves.
				if(LO.uid != gear_id)
					gears[LO.uid] = gears[gear_id]
					gears -= gear_id
					gear_id = LO.uid

				if(LO && (GET_DECL(LO.category) in global.using_map.loadout_categories) && LO.can_be_taken_by(user, pref) && LO.can_afford(user, pref))
					pref.total_loadout_cost += LO.cost
					pref.total_loadout_selections[LO.category] = (pref.total_loadout_selections[LO.category] + 1)
		else
			pref.gear_list[index] = list()

/datum/category_item/player_setup_item/loadout/proc/recalculate_loadout_cost()

	pref.total_loadout_cost = 0
	pref.total_loadout_selections = list()

	var/list/gears = pref.gear_list[pref.gear_slot]
	for(var/i = 1; i <= gears.len; i++)
		var/decl/loadout_option/G = decls_repository.get_decl_by_id_or_var(gears[i], /decl/loadout_option)
		if(G)
			pref.total_loadout_cost += G.cost
			pref.total_loadout_selections[G.category] = (pref.total_loadout_selections[G.category] + 1)

/datum/category_item/player_setup_item/loadout/content()
	. = list()

	recalculate_loadout_cost()
	var/fcolor = COLOR_CYAN_BLUE
	var/max_gear_cost = get_config_value(/decl/config/num/max_gear_cost)
	if(pref.total_loadout_cost < max_gear_cost)
		fcolor = COLOR_FONT_ORANGE
	. += "<table align = 'center' width = 100%>"
	. += "<tr><td colspan=3><center>"
	. += "<a href='byond://?src=\ref[src];prev_slot=1'>\<\<</a><b><font color = '[fcolor]'>\[[pref.gear_slot]\]</font> </b><a href='byond://?src=\ref[src];next_slot=1'>\>\></a>"

	if(max_gear_cost < INFINITY)
		. += "<b><font color = '[fcolor]'>[pref.total_loadout_cost]/[max_gear_cost]</font> loadout points spent.</b>"

	. += "<a href='byond://?src=\ref[src];clear_loadout=1'>Clear Loadout</a>"
	. += "<a href='byond://?src=\ref[src];toggle_hiding=1'>[hide_unavailable_gear ? "Show all" : "Hide unavailable"]</a></center></td></tr>"

	. += "<tr><td colspan=3><center><b>"
	var/firstcat = 1
	current_tab = current_tab || global.using_map.loadout_categories[1].type
	var/decl/loadout_category/current_category_decl = GET_DECL(current_tab)
	for(var/decl/loadout_category/LC as anything in global.using_map.loadout_categories)

		if(firstcat)
			firstcat = FALSE
		else
			. += " |"

		var/category_cost = 0
		for(var/gear in LC.gear)
			var/decl/loadout_option/G = LC.gear[gear]
			if(gear in pref.gear_list[pref.gear_slot])
				category_cost += G.cost

		if(category == current_category_decl.type)
			. += " <span class='linkOn'>[LC.name] - [category_cost]</span> "
		else
			var/category_selections
			if(LC.max_selections < INFINITY)
				category_selections = " - [LC.max_selections - pref.total_loadout_selections[category]] remaining"
			if(category_cost)
				. += " <a href='byond://?src=\ref[src];select_category=\ref[LC]'><font color = '#e67300'>[LC.name] - [category_cost][category_selections]</font></a> "
			else
				. += " <a href='byond://?src=\ref[src];select_category=\ref[LC]'>[LC.name] - 0[category_selections]</a> "

	. += "</b></center></td></tr>"
	. += "<tr><td colspan=3><hr></td></tr>"
	. += "<tr><td colspan=3><b><center>Current loadout</b><hr><small>Lower-layered gear is equipped before higher-layered gear.<small></center></td></tr>"
	. += "<tr><td colspan=3><hr></td></tr>"

	var/current_loadout = pref.gear_list[pref.gear_slot]
	if(length(current_loadout))

		var/list/other_gear = list()
		var/i = 0
		for(var/gear in current_loadout)
			var/decl/loadout_option/G = decls_repository.get_decl_by_id(gear, validate_decl_type = FALSE)
			if(istype(G))
				if(G.slot)
					i++
					. += "<tr><td colspan=2><center>Layer [i]: [G.name]</center></td><td><a href='byond://?src=\ref[src];gear=\ref[G];layer_lower=1'>Layer under</a><a href='byond://?src=\ref[src];gear=\ref[G];layer_higher=1'>Layer over</a><a href='byond://?src=\ref[src];toggle_gear=\ref[G]'>Remove</a></td></tr>"
				else
					other_gear += "<tr><td colspan=2><center>[G.name]</center></td><td><a href='byond://?src=\ref[src];toggle_gear=\ref[G]'>Remove</a></td></tr>"

		if(length(other_gear))
			. += "<tr><td colspan=3><b><hr><center>Other gear</b><hr></center></td></tr>"
			. += other_gear

	else
		. += "<tr><td colspan=3><center>No equipment selected.</center></td></tr>"

	. += "<tr><td colspan=3><hr></td></tr>"
	. += "<tr><td colspan=3><b><center>[current_category_decl.name]</center></b></td></tr>"
	. += "<tr><td colspan=3><hr></td></tr>"
	var/jobs = list()
	for(var/job_title in (pref.job_medium|pref.job_low|pref.job_high))
		var/datum/job/J = SSjobs.get_by_title(job_title)
		if(J)
			dd_insertObjectList(jobs, J)

	var/mob/user = preference_mob()
	for(var/gear_id in current_category_decl.gear)

		var/decl/loadout_option/G = current_category_decl.gear[gear_id]
		if(!G.can_be_taken_by(user, pref))
			continue

		var/ticked = (G.uid in pref.gear_list[pref.gear_slot])
		var/list/entry = list()
		entry += "<tr style='vertical-align:top;'><td width=25%><a style='white-space:normal;' [ticked ? "class='linkOn' " : ""]href='byond://?src=\ref[src];toggle_gear=\ref[G]'>[G.name]</a></td>"
		entry += "<td width = 10% style='vertical-align:top'>[G.cost]</td>"
		entry += "<td><font size=2>[G.get_description(get_gear_metadata(G, TRUE))]</font>"

		var/allowed = 1
		if(allowed && G.allowed_roles)
			var/good_job = 0
			var/bad_job = 0
			entry += "<br><i>"
			var/list/jobchecks = list()
			for(var/datum/job/J in jobs)
				if(J.type in G.allowed_roles)
					jobchecks += "<font color=55cc55>[J.title]</font>"
					good_job = 1
				else
					jobchecks += "<font color=cc5555>[J.title]</font>"
					bad_job = 1
			allowed = good_job || !bad_job
			entry += "[english_list(jobchecks)]</i>"

		if(allowed && G.allowed_branches)
			var/list/branches = list()
			for(var/datum/job/J in jobs)
				if(pref.branches[J.title])
					branches |= pref.branches[J.title]
			if(length(branches))
				var/list/branch_checks = list()
				var/good_branch = 0
				entry += "<br><i>"
				for(var/branch in branches)
					var/datum/mil_branch/player_branch = mil_branches.get_branch(branch)
					if(player_branch.type in G.allowed_branches)
						branch_checks += "<font color=55cc55>[player_branch.name]</font>"
						good_branch = 1
					else
						branch_checks += "<font color=cc5555>[player_branch.name]</font>"
				allowed = good_branch

				entry += "[english_list(branch_checks)]</i>"

		if(allowed && G.allowed_skills)
			var/list/skills_required = list()//make it into instances? instead of path
			for(var/skill in G.allowed_skills)
				var/decl/hierarchy/skill/instance = GET_DECL(skill)
				skills_required[instance] = G.allowed_skills[skill]

			allowed = skill_check(jobs, skills_required)//Checks if a single job has all the skills required

			entry += "<br><i>"
			var/list/skill_checks = list()
			for(var/R in skills_required)
				var/decl/hierarchy/skill/S = R
				var/skill_entry
				skill_entry += "[S.levels[skills_required[R]]]"
				if(allowed)
					skill_entry = "<font color=55cc55>[skill_entry] [R]</font>"
				else
					skill_entry = "<font color=cc5555>[skill_entry] [R]</font>"
				skill_checks += skill_entry

			entry += "[english_list(skill_checks)]</i>"

		entry += "</tr>"
		if(ticked)
			entry += "<tr><td colspan=3>"
			for(var/datum/gear_tweak/tweak in G.gear_tweaks)
				var/contents = tweak.get_contents(get_tweak_metadata(G, tweak))
				if(contents)
					entry += " <a href='byond://?src=\ref[src];gear=\ref[G];tweak=\ref[tweak]'>[contents]</a>"
			entry += "</td></tr>"
		if(!hide_unavailable_gear || allowed || ticked)
			. += entry
	. += "</table>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/loadout/proc/get_gear_metadata(var/decl/loadout_option/G, var/readonly)
	var/list/gear = pref.gear_list[pref.gear_slot]
	. = gear[G.uid]
	if(!.)
		. = list()
		if(!readonly)
			gear[G.uid] = .

/datum/category_item/player_setup_item/loadout/proc/get_tweak_metadata(var/decl/loadout_option/G, var/datum/gear_tweak/tweak)
	var/list/metadata = get_gear_metadata(G)
	. = metadata["[tweak]"]
	if(!.)
		. = tweak.get_default()
		metadata["[tweak]"] = .

/datum/category_item/player_setup_item/loadout/proc/set_tweak_metadata(var/decl/loadout_option/G, var/datum/gear_tweak/tweak, var/new_metadata)
	var/list/metadata = get_gear_metadata(G)
	metadata["[tweak]"] = new_metadata

/datum/category_item/player_setup_item/loadout/OnTopic(href, href_list, user)
	if(href_list["toggle_gear"])
		var/decl/loadout_option/TG = locate(href_list["toggle_gear"])
		if(!istype(TG))
			return TOPIC_REFRESH
		if(TG.uid in pref.gear_list[pref.gear_slot])
			pref.gear_list[pref.gear_slot] -= TG.uid
		else if(TG.can_afford(preference_mob(), pref))
			pref.gear_list[pref.gear_slot] += TG.uid
		return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["gear"])

		var/decl/loadout_option/gear = locate(href_list["gear"])
		if(!istype(gear))
			return TOPIC_NOACTION

		if(href_list["layer_lower"] || href_list["layer_higher"])

			var/list/current_gear = pref.gear_list[pref.gear_slot]
			var/current_index = current_gear.Find(gear.uid)

			if(href_list["layer_lower"] && current_index > 1)
				current_index--
			else if(href_list["layer_higher"] && current_index > 0 && current_index < length(current_gear))
				current_index++
			else
				return TOPIC_NOACTION

			var/old_val = current_gear[gear.uid]
			current_gear -= gear.uid
			current_gear.Insert(current_index, gear.uid)
			if(!isnull(old_val))
				current_gear[gear.uid] = old_val // preserve tweaks

			return TOPIC_REFRESH_UPDATE_PREVIEW

		if(href_list["tweak"])
			var/datum/gear_tweak/tweak = locate(href_list["tweak"])
			if(!istype(tweak) || !(tweak in gear.gear_tweaks))
				return TOPIC_NOACTION
			var/metadata = tweak.get_metadata(user, get_tweak_metadata(gear, tweak))
			if(!metadata || !CanUseTopic(user))
				return TOPIC_NOACTION
			set_tweak_metadata(gear, tweak, metadata)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["next_slot"])
		pref.gear_slot = pref.gear_slot+1
		if(pref.gear_slot > get_config_value(/decl/config/num/loadout_slots))
			pref.gear_slot = 1
		recalculate_loadout_cost()
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list["prev_slot"])
		pref.gear_slot = pref.gear_slot-1
		if(pref.gear_slot < 1)
			pref.gear_slot = get_config_value(/decl/config/num/loadout_slots)
		recalculate_loadout_cost()
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list["select_category"])
		var/decl/loadout_category/LC = locate(href_list["select_category"])
		if(istype(LC) && (LC in global.using_map.loadout_categories))
			current_tab = LC.type
		else
			current_tab = global.using_map.loadout_categories[1].type
		return TOPIC_REFRESH
	if(href_list["clear_loadout"])
		var/list/gear = pref.gear_list[pref.gear_slot]
		gear.Cut()
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list["toggle_hiding"])
		hide_unavailable_gear = !hide_unavailable_gear
		return TOPIC_REFRESH
	return ..()

/decl/loadout_category
	var/name = "Miscellaneous"
	var/max_selections = INFINITY
	var/list/gear = list()

/decl/loadout_option
	abstract_type = /decl/loadout_option
	decl_flags = DECL_FLAG_MANDATORY_UID

	/// Name/index.
	var/name
	/// Description of this gear. If left blank will default to the description of the pathed item.
	var/description
	/// Path of item.
	var/path
	/// Number of points used. Items in general cost 1 point, storage/armor/gloves/special use costs 2 points.
	var/cost = 1
	/// Slot to equip to.
	var/slot
	/// Roles that can spawn with this item.
	var/list/allowed_roles
	/// Service branches that can spawn with it.
	var/list/allowed_branches
	/// Skills required to spawn with this item.
	var/list/allowed_skills
	/// Special tweaks in new
	var/loadout_flags
	/// Special tweak in New
	var/custom_setup_proc
	/// Special tweak in New
	var/list/custom_setup_proc_arguments
	/// Type to use for categorization and organization.
	var/category = /decl/loadout_category
	/// List of datums which will alter the item after it has been spawned.
	var/list/gear_tweaks = list()
	/// Whether or not this equipment should replace pre-existing equipment.
	var/replace_equipped = TRUE
	/// List of types of cultural datums that will allow this loadout option.
	var/list/faction_restricted
	/// Species name to check the whitelist for.
	var/whitelisted
	/// If true, will try to apply tweaks and customisation to an already-existing instance of the spawn path.
	var/apply_to_existing_if_possible = FALSE
	/// A list of trait types that the character must have for this loadout option to be available.
	var/list/required_traits

/decl/loadout_option/Initialize()

	if(get_config_value(/decl/config/toggle/allow_loadout_customization))
		loadout_flags |= GEAR_HAS_CUSTOM_SELECTION

	. = ..()

	if(!global.using_map.loadout_blacklist || !(type in global.using_map.loadout_blacklist))
		var/decl/loadout_category/LC = GET_DECL(category)
		ADD_SORTED(LC.gear, uid, /proc/cmp_text_asc)
		LC.gear[uid] = src

	if(FLAGS_EQUALS(loadout_flags, GEAR_HAS_TYPE_SELECTION|GEAR_HAS_SUBTYPE_SELECTION))
		CRASH("May not have both type and subtype selection tweaks")
	if(!description)
		var/obj/O = path
		description = initial(O.desc)
	if(loadout_flags & GEAR_HAS_COLOR_SELECTION)
		gear_tweaks += gear_tweak_free_color_choice()
	if(loadout_flags & GEAR_HAS_TYPE_SELECTION)
		gear_tweaks += new /datum/gear_tweak/path/type(path)
	if(loadout_flags & GEAR_HAS_SUBTYPE_SELECTION)
		gear_tweaks += new /datum/gear_tweak/path/subtype(path)
	if(loadout_flags & GEAR_HAS_CUSTOM_SELECTION)
		gear_tweaks += gear_tweak_free_name
		gear_tweaks += gear_tweak_free_desc
	if(custom_setup_proc)
		gear_tweaks += new/datum/gear_tweak/custom_setup(custom_setup_proc, custom_setup_proc_arguments)
	var/options = get_gear_tweak_options()
	for(var/tweak in options)
		var/optargs = options[tweak]
		if(optargs)
			gear_tweaks += new tweak(optargs)
		else
			gear_tweaks += new tweak

/decl/loadout_option/validate()
	. = ..()
	if(!name)
		. += "missing display name"
	if(isnull(cost) || cost < 0)
		. += "invalid cost"
	if(!path)
		. += "missing path definition"
	if(!ispath(category, /decl/loadout_category))
		. += "null or invalid category: [category || "NULL"]"

/decl/loadout_option/proc/get_gear_tweak_options()
	. = list()

/decl/loadout_option/proc/get_description(var/metadata)
	. = description
	for(var/datum/gear_tweak/gt in gear_tweaks)
		. = gt.tweak_description(., metadata["[gt]"])

/datum/gear_data
	var/path
	var/location
	var/material

/datum/gear_data/New(var/path, var/location, var/material)
	src.path = path
	src.location = location
	src.material = material

/decl/loadout_option/proc/spawn_item(user, location, metadata, obj/item/existing_item)
	var/datum/gear_data/gd = new(path, location)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		gt.tweak_gear_data(islist(metadata) && metadata["[gt]"], gd)
	var/obj/item/item
	if(isitem(existing_item))
		item = existing_item
		if(gd.material)
			item.set_material(gd.material)
	else
		item = new gd.path(gd.location, gd.material)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		gt.tweak_item(user, item, (islist(metadata) && metadata["[gt]"]))
	. = item
	if(metadata && !islist(metadata))
		PRINT_STACK_TRACE("Loadout spawn_item() proc received non-null non-list metadata: '[json_encode(metadata)]'")

/decl/loadout_option/proc/spawn_on_mob(mob/living/human/wearer, metadata)

	var/obj/item/item = spawn_and_validate_item(wearer, metadata)
	if(!item)
		return

	item.loadout_setup(wearer, metadata)

	var/obj/item/old_item = wearer.get_equipped_item(slot)
	var/attached_as_accessory = FALSE
	if(istype(old_item, /obj/item/clothing) && istype(item, /obj/item/clothing))
		var/obj/item/clothing/worn = old_item
		if(worn.can_attach_accessory(item, wearer))
			worn.attach_accessory(wearer, item)
			attached_as_accessory = TRUE
			return TRUE

	if(!attached_as_accessory && wearer.equip_to_slot_if_possible(item, slot, del_on_fail = TRUE, force = TRUE, delete_old_item = FALSE, ignore_equipped = replace_equipped))
		if(old_item && wearer.get_equipped_item(slot) != old_item)
			item.handle_loadout_equip_replacement(old_item)
			if(old_item.loadout_should_keep(item, wearer))
				place_in_storage_or_drop(wearer, old_item)
			else
				qdel(old_item)
		return item

/decl/loadout_option/proc/spawn_in_storage_or_drop(mob/living/human/wearer, metadata)
	var/obj/item/item = spawn_and_validate_item(wearer, metadata)
	if(!item)
		return

	place_in_storage_or_drop(wearer, item)

/decl/loadout_option/proc/place_in_storage_or_drop(mob/living/human/wearer, obj/item/item)
	var/atom/placed_in = wearer.equip_to_storage(item)
	if(placed_in)
		to_chat(wearer, SPAN_NOTICE("Placing \the [item] in your [placed_in.name]!"))
	else if(wearer.equip_to_appropriate_slot(item))
		to_chat(wearer, SPAN_NOTICE("Placing \the [item] in your inventory!"))
	else if(wearer.put_in_hands(item))
		to_chat(wearer, SPAN_NOTICE("Placing \the [item] in your hands!"))
	else
		to_chat(wearer, SPAN_DANGER("Dropping \the [item] on the ground!"))

/decl/loadout_option/proc/can_replace_existing(obj/item/candidate)
	return istype(candidate, path)

/decl/loadout_option/proc/spawn_and_validate_item(mob/living/human/H, metadata)
	PRIVATE_PROC(TRUE)

	var/obj/item/item
	if(apply_to_existing_if_possible)
		for(var/obj/item/candidate in H.get_equipped_items(include_carried = TRUE))
			if(can_replace_existing(candidate))
				item = candidate
				break

	item = spawn_item(H, H, metadata, item)

	if(QDELETED(item))
		return

	if(!(loadout_flags & GEAR_NO_FINGERPRINTS))
		item.add_fingerprint(H)

	if(loadout_flags & GEAR_NO_EQUIP)
		return

	return item
