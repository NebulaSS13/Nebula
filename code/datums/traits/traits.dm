/mob/living
	var/list/traits

/mob/living/proc/HasTrait(trait_type, trait_level = TRAIT_LEVEL_EXISTS)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	return (trait_type in traits) && (!trait_level || traits[trait_type] >= trait_level)

/mob/living/proc/GetTraitLevel(trait_type)
	SHOULD_NOT_SLEEP(TRUE)
	var/traits = GetTraits()
	if(!traits)
		return null
	return traits[trait_type]

/mob/living/proc/GetTraits()
	SHOULD_NOT_SLEEP(TRUE)
	RETURN_TYPE(/list)
	var/decl/species/our_species = get_species()
	return traits || our_species?.traits

/mob/living/proc/SetTrait(trait_type, trait_level)
	SHOULD_NOT_SLEEP(TRUE)
	var/decl/species/our_species = get_species()
	var/decl/trait/T = GET_DECL(trait_type)
	if(!T.validate_level(trait_level))
		return FALSE

	if(our_species && !traits) // If species traits haven't been setup before, check if we need to do so now
		var/species_level = our_species.traits[trait_type]
		if(species_level == trait_level) // Matched the default species trait level, ignore
			return TRUE
		traits = our_species.traits.Copy() // The setup is to simply copy the species list of traits

	LAZYSET(traits, trait_type, trait_level)
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
		SetTrait(trait_type, our_species?.traits[trait_type])

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
	var/name
	var/description
	var/list/levels = list(TRAIT_LEVEL_EXISTS) // Should either only contain TRAIT_LEVEL_EXISTS or a set of the other TRAIT_LEVEL_* levels

/decl/trait/validate()
	. = ..()
	if(!name || !istext(name)) // Empty strings are valid texts
		. += "invalid name [name || "(NULL)"]"
	if(!length(levels))
		. += "invalid (empty) levels list"
	else if (levels.len > 1 && (TRAIT_LEVEL_EXISTS in levels))
		. += "invalid levels list - TRAIT_LEVEL_EXISTS is mutually exclusive with all other levels"

/decl/trait/proc/validate_level(level)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)

	return (level in levels)
