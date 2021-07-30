// Aspects are basically skills + stats + feats all rolled into one. You get to choose a certain number
// of them at character generation and they will alter some interactions with the world. Very WIP.
var/global/list/aspect_datums = list()     // Raw datums, no index.
var/global/list/aspect_categories = list() // Containers for ease of printing data.

/datum/aspect_category
	var/name
	var/list/aspects = list()
	var/hide_from_chargen = TRUE

/datum/aspect_category/New(var/newcategory)
	..()
	name = newcategory

/mob
	var/list/personal_aspects
	var/need_aspect_sort

/decl/aspect
	var/name                                             // Name/unique index.
	var/desc = "An aspect is a trait of your character." // Flavour text.
	var/aspect_cost = 1                                  // Number of points spent or gained by taking this aspect
	var/category                                         // Header for root aspects in char prefs.
	var/decl/aspect/parent                               // Parent/prerequisite for this aspect.
	var/list/children                                    // Aspects with this aspect as a parent
	var/list/incompatible_with                           // Typelist of aspects that prevent this one from being taken
	var/available_at_chargen = TRUE                      // Whether or not aspect is shown in chargen prefs
	var/aspect_flags = 0
	var/transfer_with_mind = TRUE
	var/sort_value = 0
	var/list/blocked_species

/decl/aspect/Initialize()
	. = ..()
	
	// This is here until there are positive traits to balance out the negative ones;
	// currently the cost calc serves no purpose and looks really silly sitting at -14/5.
	aspect_cost = 0
	// End temp set.

	if(!name)
		return

	if(category)
		var/datum/aspect_category/AC = global.aspect_categories[category]
		if(!istype(AC))
			AC = new(category)
			global.aspect_categories[category] = AC
		AC.aspects += src
		if(AC.hide_from_chargen && available_at_chargen)
			AC.hide_from_chargen = FALSE

	if(ispath(parent))
		parent = GET_DECL(parent)
	if(istype(parent))
		LAZYDISTINCTADD(parent.children, src)

/decl/aspect/proc/applies_to_organ(var/organ)
	return FALSE

/decl/aspect/proc/is_available_to(var/datum/preferences/pref)
	if(!name)
		return FALSE
	for(var/blacklisted_type in incompatible_with)
		if(blacklisted_type in pref.aspects)
			return FALSE
	if(blocked_species && (pref.species in blocked_species))
		return FALSE
	return TRUE

/decl/aspect/dd_SortValue()
	return sort_value

/decl/aspect/proc/apply(var/mob/living/carbon/human/holder)
	return (istype(holder))

// Called by preferences selection for HTML display.
/decl/aspect/proc/get_aspect_selection_data(var/datum/category_item/player_setup_item/aspects/caller, var/list/ticked_aspects = list(), var/recurse_level = 0, var/ignore_children_if_unticked = 1, var/ignore_unticked)

	var/ticked = (type in ticked_aspects)
	if((ignore_unticked && !ticked) || (caller && !is_available_to(caller.pref)))
		return ""

	var/result = "<tr><td width=50%>"
	if(recurse_level)
		for(var/x = 1 to recurse_level)
			result += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"

	var/incompatible_aspect_taken = FALSE
	for(var/aspect in incompatible_with)
		if(aspect in ticked_aspects)
			incompatible_aspect_taken = TRUE
			break

	if(istype(caller) && (ticked || caller.get_aspect_total() + aspect_cost <= config.max_character_aspects) && !incompatible_aspect_taken)
		result += "<a href='?src=\ref[caller];toggle_aspect=\ref[src]'>[ticked ? "<font color='#E67300'>[name]</font>" : "[name]"] ([aspect_cost])</a>"
	else
		result += ticked ? "<font color='#E67300'>[name]</font>" : "[name]"

	result += "</td><td>"
	if(ticked)
		result += "<font size=1><b>[desc]</b></font>"
	else
		result += "<font size=1><i>[desc]</i></font>"

	result += "</td></tr>"
	if(LAZYLEN(children) && !(ignore_children_if_unticked && !ticked))
		for(var/decl/aspect/A in children)
			result += A.get_aspect_selection_data(caller, ticked_aspects, (recurse_level+1), ignore_children_if_unticked)
	return result

/mob/proc/get_aspect_data(var/mob/show_to)

	if(!LAZYLEN(personal_aspects))
		to_chat(show_to, SPAN_WARNING("That mob has no aspects."))
		return

	var/aspect_cost = 0
	for(var/decl/aspect/A as anything in personal_aspects)
		aspect_cost += A.aspect_cost

	var/dat = list("<b>[aspect_cost]/[config.max_character_aspects] points spent.</b>")
	for(var/aspect_category in global.aspect_categories)
		var/datum/aspect_category/AC = global.aspect_categories[aspect_category]
		if(!istype(AC))
			continue
		var/printed_cat
		for(var/decl/aspect/A as anything in AC.aspects)
			if(A in personal_aspects)
				if(!printed_cat)
					printed_cat = 1
					dat += "<br><b>[AC.name]:</b>"
				dat += "<br>[A.name]: <font size=1><i>[A.desc]</i></font>"
		if(printed_cat)
			dat += "<hr>"

	var/datum/browser/written/popup = new((show_to || usr), "aspect_summary_\ref[src]", "Aspect Summary")
	popup.set_content(jointext(dat, null))
	popup.open()

/mob/verb/show_own_aspects()
	set category = "IC"
	set name = "Show Own Aspects"
	get_aspect_data(src)

/datum/admins/proc/show_aspects()
	set category = "Admin"
	set name = "Show Aspects"
	if(!check_rights(R_INVESTIGATE)) 
		return
	var/mob/M = input("Select mob.", "Select mob.") as null|anything in global.living_mob_list_
	if(M)
		M.get_aspect_data(usr)

/mob/proc/apply_aspects(var/aspect_types = 0)
	var/do_update = FALSE
	if(LAZYLEN(personal_aspects))
		if(need_aspect_sort)
			personal_aspects = dd_sortedObjectList(personal_aspects)
			need_aspect_sort = FALSE
		for(var/decl/aspect/A as anything in personal_aspects)
			if(!aspect_types || (aspect_types & A.aspect_flags))
				A.apply(src)
				do_update = TRUE
	return do_update

/mob/living/carbon/human/apply_aspects(var/aspect_type)
	. = ..(aspect_type)
	if(.)
		update_body()
		update_icon()
