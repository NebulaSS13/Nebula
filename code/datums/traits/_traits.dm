// Traits in general are abstract modifiers kept on the mob and checked in various places.
// Selectable traits are basically skills + stats + feats all rolled into one. You get to choose a
// certain number of them at character generation and they will alter some interactions with the world.

/hook/startup/proc/initialize_trait_trees()
	// Precache/build trait trees.
	for(var/decl/trait/trait in decls_repository.get_decls_of_type_unassociated(/decl/trait))
		trait.build_references()
	return 1

/mob/living
	var/list/traits

/mob/living/proc/has_trait(trait_type, trait_level = TRAIT_LEVEL_EXISTS)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	return (trait_type in traits) && (!trait_level || traits[trait_type] >= trait_level)

/mob/living/proc/GetTraitLevel(trait_type)
	SHOULD_NOT_SLEEP(TRUE)
	var/traits = get_traits()
	if(!traits)
		return null
	return traits[trait_type]

/mob/proc/get_traits()
	SHOULD_NOT_SLEEP(TRUE)
	return null

/mob/living/get_traits()
	RETURN_TYPE(/list)
	var/decl/species/our_species = get_species()
	return traits || our_species?.traits

/mob/living/proc/set_trait(trait_type, trait_level)
	SHOULD_NOT_SLEEP(TRUE)
	var/decl/species/our_species = get_species()
	var/decl/trait/trait = GET_DECL(trait_type)
	if(!trait.validate_level(trait_level))
		return FALSE

	if(our_species && !traits) // If species traits haven't been setup before, check if we need to do so now
		var/species_level = our_species.traits[trait_type]
		if(species_level == trait_level) // Matched the default species trait level, ignore
			return TRUE
		traits = our_species.traits.Copy() // The setup is to simply copy the species list of traits

	if(!(trait_type in traits))
		LAZYSET(traits, trait_type, trait_level)
		trait.apply_trait(src)
	return TRUE

/mob/living/proc/RemoveTrait(trait_type, canonize = TRUE)
	var/decl/species/our_species = get_species()
	// If traits haven't been set up, but we're trying to remove a trait that exists on the species then set up traits
	if(!traits && LAZYISIN(our_species?.traits, trait_type))
		traits = our_species.traits.Copy()
	if(LAZYLEN(traits))
		LAZYREMOVE(traits, trait_type)
	// Check if we can just default back to species traits.
	if(canonize)
		CanonizeTraits()

/// Removes a trait unless it exists on the species.
/// If it does exist on the species, we reset it to the species' trait level.
/mob/living/proc/RemoveExtrinsicTrait(trait_type)
	var/decl/species/our_species = get_species()
	if(!LAZYACCESS(our_species?.traits, trait_type))
		RemoveTrait(trait_type)
	else if(our_species?.traits[trait_type] != GetTraitLevel(trait_type))
		set_trait(trait_type, our_species?.traits[trait_type])

/// Sets the traits list to null if it's identical to the species list.
/// Returns TRUE if the list was reset and FALSE otherwise.
/mob/living/proc/CanonizeTraits()
	if(!traits) // Already in canonical form.
		return FALSE
	var/decl/species/our_species = get_species()
	if(!our_species) // Doesn't apply without a species.
		return FALSE
	var/list/missing_traits = traits ^ our_species?.traits
	var/list/matched_traits = traits & our_species?.traits
	if(LAZYLEN(missing_traits))
		return FALSE
	for(var/trait in matched_traits) // inside this loop we know our_species exists and has traits
		if(traits[trait] != our_species.traits[trait])
			return FALSE
	traits = null
	return TRUE

/decl/trait
	abstract_type = /decl/trait
	/// String identifier.
	var/name
	/// Flavour text.
	var/description
	/// A list of possible values for this trait. Should either only contain TRAIT_LEVEL_EXISTS or a set of the other TRAIT_LEVEL_* levels
	var/list/levels = list(TRAIT_LEVEL_EXISTS)
	/// Number of points spent or gained by taking this trait
	var/trait_cost = 1
	/// Header for root traits in char prefs.
	var/category
	/// Parent/prerequisite for this trait.
	var/decl/trait/parent
	/// Aspects with this trait as a parent
	var/list/children
	/// Typelist of traits that prevent this one from being taken
	var/list/incompatible_with
	/// Whether or not trait is shown in chargen prefs
	var/available_at_chargen = FALSE
	/// Whether this trait should be available on a map with a given tech leve.
	var/available_at_map_tech = MAP_TECH_LEVEL_ANY
	/// Whether or not a rejuvenation should apply this aspect.
	var/reapply_on_rejuvenation = FALSE
	/// What species can select this trait in chargen?
	var/list/permitted_species
	/// What species cannot select this trait in chargen?
	var/list/blocked_species

/decl/trait/validate()
	. = ..()
	if(!name || !istext(name)) // Empty strings are valid texts
		. += "invalid name [name || "(NULL)"]"
	else
		for(var/decl/trait/trait in decls_repository.get_decls_of_type_unassociated(/decl/trait))
			if(trait != src && lowertext(trait.name) == lowertext(name))
				. += "name '[name]' collides with [trait.type]"

	if(!length(levels))
		. += "invalid (empty) levels list"
	else if (levels.len > 1 && (TRAIT_LEVEL_EXISTS in levels))
		. += "invalid levels list - TRAIT_LEVEL_EXISTS is mutually exclusive with all other levels"

	if(initial(parent) && !istype(parent))
		. += "invalid parent - [parent || "NULL"]"
	for(var/decl/trait/trait as anything in children)
		if(!istype(trait))
			. += "invalid child - [trait || "NULL"]"
		else if(trait.parent != src)
			. += "child [trait || "NULL"] does not have correct parent - expected [src], got [trait.parent || "NULL"]"

/decl/trait/proc/is_available_at_chargen()
	return available_at_chargen && global.using_map.map_tech_level >= available_at_map_tech

/decl/trait/proc/validate_level(level)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)
	return (level in levels)

/decl/trait/proc/build_references()
	SHOULD_CALL_PARENT(TRUE)

	// This is here until there are positive traits to balance out the negative ones;
	// currently the cost calc serves no purpose and looks really silly sitting at -14/5.
	trait_cost = 0
	// End temp set.

	if(ispath(parent))
		parent = GET_DECL(parent)

	if(abstract_type != type && category)
		var/datum/trait_category/trait_category = global.trait_categories[category]
		if(!istype(trait_category))
			trait_category = new(category)
			global.trait_categories[category] = trait_category
		trait_category.items += src
		if(trait_category.hide_from_chargen && is_available_at_chargen())
			trait_category.hide_from_chargen = FALSE
		if(istype(parent))
			LAZYDISTINCTADD(parent.children, src)

/decl/trait/proc/applies_to_organ(var/organ)
	return FALSE

/decl/trait/proc/is_available_to(var/datum/preferences/pref)
	for(var/blacklisted_type in incompatible_with)
		if(blacklisted_type in pref.traits)
			return FALSE
	if(blocked_species && (pref.species in blocked_species))
		return FALSE
	if(permitted_species && !(pref.species in permitted_species))
		return FALSE
	return TRUE

/decl/trait/proc/apply_trait(mob/living/holder)
	return (istype(holder))

// Called by preferences selection for HTML display.
/decl/trait/proc/get_trait_selection_data(var/datum/category_item/player_setup_item/traits/caller, var/list/ticked_traits = list(), var/recurse_level = 0, var/ignore_children_if_unticked = 1, var/ignore_unticked)

	var/ticked = (type in ticked_traits)
	if((ignore_unticked && !ticked) || (caller && !is_available_to(caller.pref)))
		return ""

	var/result = "<tr><td style='max-width:50%;'>"
	if(recurse_level)
		for(var/x = 1 to recurse_level)
			result += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"

	var/incompatible_trait_taken = FALSE
	for(var/trait in incompatible_with)
		if(trait in ticked_traits)
			incompatible_trait_taken = TRUE
			break

	if(istype(caller) && (ticked || caller.get_trait_total() + trait_cost <= get_config_value(/decl/config/num/max_character_traits)) && !incompatible_trait_taken)
		result += "<a href='byond://?src=\ref[caller];toggle_trait=\ref[src]'>[ticked ? "<font color='#E67300'>[name]</font>" : "[name]"] ([trait_cost])</a>"
	else
		result += ticked ? "<font color='#E67300'>[name]</font>" : "[name]"

	result += "</td><td>"
	if(ticked)
		result += "<font size=1><b>[description]</b></font>"
	else
		result += "<font size=1><i>[description]</i></font>"

	result += "</td></tr>"
	if(LAZYLEN(children) && !(ignore_children_if_unticked && !ticked))
		for(var/decl/trait/trait in children)
			result += trait.get_trait_selection_data(caller, ticked_traits, (recurse_level+1), ignore_children_if_unticked)
	return result

/mob/proc/get_trait_data(var/mob/show_to)

	var/list/traits = get_traits()
	if(!LAZYLEN(traits))
		to_chat(show_to, SPAN_WARNING("That mob has no traits."))
		return

	var/trait_cost = 0
	for(var/decl/trait/trait as anything in traits)
		trait_cost += trait.trait_cost

	var/dat = list("<b>[trait_cost]/[get_config_value(/decl/config/num/max_character_traits)] points spent.</b>")
	for(var/trait_category_id in global.trait_categories)
		var/datum/trait_category/trait_category = global.trait_categories[trait_category_id]
		if(!istype(trait_category))
			continue
		var/printed_cat
		for(var/decl/trait/trait as anything in trait_category.items)
			if(trait in traits)
				if(!printed_cat)
					printed_cat = 1
					dat += "<br><b>[trait_category.name]:</b>"
				dat += "<br>[trait.name]: <font size=1><i>[trait.description]</i></font>"
		if(printed_cat)
			dat += "<hr>"

	var/datum/browser/popup = new((show_to || usr), "trait_summary_\ref[src]", "Aspect Summary")
	popup.set_content(jointext(dat, null))
	popup.open()

/mob/verb/show_own_traits()
	set category = "IC"
	set name = "Show Own Traits"
	get_trait_data(src)

/datum/admins/proc/show_traits()
	set category = "Admin"
	set name = "Show Traits"
	if(!check_rights(R_INVESTIGATE))
		return
	var/mob/M = input("Select mob.", "Select mob.") as null|anything in global.living_mob_list_
	if(M)
		M.get_trait_data(usr)
