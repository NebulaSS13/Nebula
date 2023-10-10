var/global/list/gear_datums = list()

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
	if(cost > 0 && (pref.total_loadout_cost + cost) > config.max_gear_cost)
		return FALSE
	var/decl/loadout_category/LC = GET_DECL(category)
	if(!LC || pref.total_loadout_selections[category] >= LC.max_selections)
		return FALSE
	return TRUE

/decl/loadout_option/proc/can_be_taken_by(var/mob/user, var/datum/preferences/pref)

	if(!category)
		return FALSE

	if(!name || !(name in global.gear_datums))
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

	pref.gear_slot = sanitize_integer(pref.gear_slot, 1, config.loadout_slots, initial(pref.gear_slot))
	if(!islist(pref.gear_list))
		pref.gear_list = list()

	if(pref.gear_list.len < config.loadout_slots)
		pref.gear_list.len = config.loadout_slots

	for(var/index = 1 to config.loadout_slots)

		pref.total_loadout_cost = 0
		pref.total_loadout_selections = list()
		var/list/gears = pref.gear_list[index]
		if(istype(gears))
			for(var/gear_name in gears)
				var/mob/user = preference_mob()
				var/decl/loadout_option/LO = global.gear_datums[gear_name]
				if(!LO || !LO.can_be_taken_by(user, pref) || !LO.can_afford(user, pref))
					gears -= gear_name
				else
					pref.total_loadout_cost += LO.cost
					pref.total_loadout_selections[LO.category] = (pref.total_loadout_selections[LO.category] + 1)
		else
			pref.gear_list[index] = list()

/datum/category_item/player_setup_item/loadout/proc/recalculate_loadout_cost()

	pref.total_loadout_cost = 0
	pref.total_loadout_selections = list()

	var/list/gears = pref.gear_list[pref.gear_slot]
	for(var/i = 1; i <= gears.len; i++)
		var/decl/loadout_option/G = global.gear_datums[gears[i]]
		if(G)
			pref.total_loadout_cost += G.cost
			pref.total_loadout_selections[G.category] = (pref.total_loadout_selections[G.category] + 1)

/datum/category_item/player_setup_item/loadout/content()
	. = list()

	recalculate_loadout_cost()
	var/fcolor = COLOR_CYAN_BLUE
	if(pref.total_loadout_cost < config.max_gear_cost)
		fcolor = COLOR_FONT_ORANGE
	. += "<table align = 'center' width = 100%>"
	. += "<tr><td colspan=3><center>"
	. += "<a href='?src=\ref[src];prev_slot=1'>\<\<</a><b><font color = '[fcolor]'>\[[pref.gear_slot]\]</font> </b><a href='?src=\ref[src];next_slot=1'>\>\></a>"

	if(config.max_gear_cost < INFINITY)
		. += "<b><font color = '[fcolor]'>[pref.total_loadout_cost]/[config.max_gear_cost]</font> loadout points spent.</b>"

	. += "<a href='?src=\ref[src];clear_loadout=1'>Clear Loadout</a>"
	. += "<a href='?src=\ref[src];toggle_hiding=1'>[hide_unavailable_gear ? "Show all" : "Hide unavailable"]</a></center></td></tr>"

	. += "<tr><td colspan=3><center><b>"
	var/firstcat = 1
	var/decl/loadout_category/current_category_decl = GET_DECL(current_tab || /decl/loadout_category)
	var/list/all_loadout_categories = decls_repository.get_decls_of_type(/decl/loadout_category)
	for(var/category in all_loadout_categories)

		if(firstcat)
			firstcat = FALSE
		else
			. += " |"

		var/decl/loadout_category/LC = all_loadout_categories[category]
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
				. += " <a href='?src=\ref[src];select_category=[LC.name]'><font color = '#e67300'>[LC.name] - [category_cost][category_selections]</font></a> "
			else
				. += " <a href='?src=\ref[src];select_category=[LC.name]'>[LC.name] - 0[category_selections]</a> "

	. += "</b></center></td></tr>"

	. += "<tr><td colspan=3><hr></td></tr>"
	. += "<tr><td colspan=3><b><center>[current_category_decl.name]</center></b></td></tr>"
	. += "<tr><td colspan=3><hr></td></tr>"
	var/jobs = list()
	for(var/job_title in (pref.job_medium|pref.job_low|pref.job_high))
		var/datum/job/J = SSjobs.get_by_title(job_title)
		if(J)
			dd_insertObjectList(jobs, J)

	var/mob/user = preference_mob()
	for(var/gear_name in current_category_decl.gear)

		var/decl/loadout_option/G = current_category_decl.gear[gear_name]
		if(!G.can_be_taken_by(user, pref))
			continue

		var/ticked = (G.name in pref.gear_list[pref.gear_slot])
		var/list/entry = list()
		entry += "<tr style='vertical-align:top;'><td width=25%><a style='white-space:normal;' [ticked ? "class='linkOn' " : ""]href='?src=\ref[src];toggle_gear=\ref[G]'>[G.name]</a></td>"
		entry += "<td width = 10% style='vertical-align:top'>[G.cost]</td>"
		entry += "<td><font size=2>[G.get_description(get_gear_metadata(G,1))]</font>"

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
					entry += " <a href='?src=\ref[src];gear=\ref[G];tweak=\ref[tweak]'>[contents]</a>"
			entry += "</td></tr>"
		if(!hide_unavailable_gear || allowed || ticked)
			. += entry
	. += "</table>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/loadout/proc/get_gear_metadata(var/decl/loadout_option/G, var/readonly)
	var/list/gear = pref.gear_list[pref.gear_slot]
	. = gear[G.name]
	if(!.)
		. = list()
		if(!readonly)
			gear[G.name] = .

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
		if(!istype(TG) || global.gear_datums[TG.name] != TG)
			return TOPIC_REFRESH
		if(TG.name in pref.gear_list[pref.gear_slot])
			pref.gear_list[pref.gear_slot] -= TG.name
		else if(TG.can_afford(preference_mob(), pref))
			pref.gear_list[pref.gear_slot] += TG.name
		return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["gear"] && href_list["tweak"])
		var/decl/loadout_option/gear = locate(href_list["gear"])
		var/datum/gear_tweak/tweak = locate(href_list["tweak"])
		if(!tweak || !istype(gear) || !(tweak in gear.gear_tweaks) || global.gear_datums[gear.name] != gear)
			return TOPIC_NOACTION
		var/metadata = tweak.get_metadata(user, get_tweak_metadata(gear, tweak))
		if(!metadata || !CanUseTopic(user))
			return TOPIC_NOACTION
		set_tweak_metadata(gear, tweak, metadata)
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list["next_slot"])
		pref.gear_slot = pref.gear_slot+1
		if(pref.gear_slot > config.loadout_slots)
			pref.gear_slot = 1
		recalculate_loadout_cost()
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list["prev_slot"])
		pref.gear_slot = pref.gear_slot-1
		if(pref.gear_slot < 1)
			pref.gear_slot = config.loadout_slots
		recalculate_loadout_cost()
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list["select_category"])
		var/list/all_loadout_categories = decls_repository.get_decls_of_type(/decl/loadout_category)
		for(var/category in all_loadout_categories)
			var/decl/loadout_category/LC = all_loadout_categories[category]
			if(LC.name == href_list["select_category"])
				current_tab = category
				break
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
	var/name                              // Name/index. Must be unique.
	var/description                       // Description of this gear. If left blank will default to the description of the pathed item.
	var/path                              // Path of item.
	var/cost = 1                          // Number of points used. Items in general cost 1 point, storage/armor/gloves/special use costs 2 points.
	var/slot                              // Slot to equip to.
	var/list/allowed_roles                // Roles that can spawn with this item.
	var/list/allowed_branches             // Service branches that can spawn with it.
	var/list/allowed_skills               // Skills required to spawn with this item.
	var/flags                             // Special tweaks in new
	var/custom_setup_proc                 // Special tweak in New
	var/list/custom_setup_proc_arguments  // Special tweak in New
	var/category = /decl/loadout_category // Type to use for categorization and organization.
	var/list/gear_tweaks = list()         // List of datums which will alter the item after it has been spawned.

	var/list/faction_restricted // List of types of cultural datums that will allow this loadout option.
	var/whitelisted             // Species name to check the whitelist for.

	abstract_type = /decl/loadout_option

/decl/loadout_option/Initialize()
	. = ..()

	if(name && (!global.using_map.loadout_blacklist || !(type in global.using_map.loadout_blacklist)))
		global.gear_datums[name] = src
		var/decl/loadout_category/LC = GET_DECL(category)
		ADD_SORTED(LC.gear, name, /proc/cmp_text_asc)
		LC.gear[name] = src

	if(FLAGS_EQUALS(flags, GEAR_HAS_TYPE_SELECTION|GEAR_HAS_SUBTYPE_SELECTION))
		CRASH("May not have both type and subtype selection tweaks")
	if(!description)
		var/obj/O = path
		description = initial(O.desc)
	if(flags & GEAR_HAS_COLOR_SELECTION)
		gear_tweaks += gear_tweak_free_color_choice()
	if(flags & GEAR_HAS_TYPE_SELECTION)
		gear_tweaks += new /datum/gear_tweak/path/type(path)
	if(flags & GEAR_HAS_SUBTYPE_SELECTION)
		gear_tweaks += new /datum/gear_tweak/path/subtype(path)
	if(flags & GEAR_HAS_CUSTOM_SELECTION)
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
	else if(isnull(cost) || cost < 0)
		. += "invalid cost"
	else if(!path)
		. += "missing path definition"

/decl/loadout_option/proc/get_gear_tweak_options()
	. = list()

/decl/loadout_option/proc/get_description(var/metadata)
	. = description
	for(var/datum/gear_tweak/gt in gear_tweaks)
		. = gt.tweak_description(., metadata["[gt]"])

/datum/gear_data
	var/path
	var/location

/datum/gear_data/New(var/path, var/location)
	src.path = path
	src.location = location

/decl/loadout_option/proc/spawn_item(user, location, metadata)
	var/datum/gear_data/gd = new(path, location)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		gt.tweak_gear_data(islist(metadata) && metadata["[gt]"], gd)
	var/item = new gd.path(gd.location)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		gt.tweak_item(user, item, islist(metadata) && metadata["[gt]"])
	. = item
	if(metadata && !islist(metadata))
		PRINT_STACK_TRACE("Loadout spawn_item() proc received non-null non-list metadata: '[json_encode(metadata)]'")

/decl/loadout_option/proc/spawn_on_mob(mob/living/carbon/human/wearer, metadata)
	var/obj/item/item = spawn_and_validate_item(wearer, metadata)
	if(!item)
		return

	var/obj/item/old_item = wearer.get_equipped_item(slot)
	if(wearer.equip_to_slot_if_possible(item, slot, del_on_fail = TRUE, force = TRUE, delete_old_item = FALSE))
		. = item
		if(!old_item)
			return
		wearer.unequip(old_item)
		if(old_item.type != item.type)
			place_in_storage_or_drop(wearer, old_item)
		else
			qdel(old_item)

/decl/loadout_option/proc/spawn_in_storage_or_drop(mob/living/carbon/human/wearer, metadata)
	var/obj/item/item = spawn_and_validate_item(wearer, metadata)
	if(!item)
		return

	place_in_storage_or_drop(wearer, item)

/decl/loadout_option/proc/place_in_storage_or_drop(mob/living/carbon/human/wearer, obj/item/item)
	var/atom/placed_in = wearer.equip_to_storage(item)
	if(placed_in)
		to_chat(wearer, SPAN_NOTICE("Placing \the [item] in your [placed_in.name]!"))
	else if(wearer.equip_to_appropriate_slot(item))
		to_chat(wearer, SPAN_NOTICE("Placing \the [item] in your inventory!"))
	else if(wearer.put_in_hands(item))
		to_chat(wearer, SPAN_NOTICE("Placing \the [item] in your hands!"))
	else
		to_chat(wearer, SPAN_DANGER("Dropping \the [item] on the ground!"))

/decl/loadout_option/proc/spawn_and_validate_item(mob/living/carbon/human/H, metadata)
	PRIVATE_PROC(TRUE)

	var/obj/item/item = spawn_item(H, H, metadata)
	if(QDELETED(item))
		return

	if(!(flags & GEAR_NO_FINGERPRINTS))
		item.add_fingerprint(H)

	if(flags & GEAR_NO_EQUIP)
		return

	return item
