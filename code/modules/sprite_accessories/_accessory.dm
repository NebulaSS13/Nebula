/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl

	Notice: This all gets automatically compiled in a list in dna2.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.

	!!WARNING!!: changing existing hair information can be VERY hazardous to savefiles,
	to the point where you may completely corrupt a server's savefiles. Please refrain
	from doing this unless you absolutely know what you are doing, and have defined a
	conversion in savefile.dm
*/

/decl/sprite_accessory
	abstract_type = /decl/sprite_accessory
	var/name                                       // The preview name of the accessory
	var/icon                                       // the icon file the accessory is located in
	var/icon_state                                 // the icon_state of the accessory
	var/gender = null                              // Restricted to specific genders. null matches any
	var/list/species_allowed = list(SPECIES_HUMAN) // Restrict some styles to specific root species names
	var/list/subspecies_allowed                    // Restrict some styles to specific species names, irrespective of root species name
	var/bodytypes_allowed = null                   // Restrict some styles to specific bodytypes
	var/bodytypes_denied =  null                   // Restrict some styles to specific bodytypes
	var/do_colouration = 1                         // Whether or not the accessory can be affected by colouration
	var/blend = ICON_ADD
	var/flags = 0

/decl/sprite_accessory/proc/accessory_is_available(var/mob/owner, var/decl/species/species, var/bodytype_flags, var/check_gender)
	if(!isnull(check_gender) && gender && check_gender != gender)
		return FALSE
	if(species)
		var/species_is_permitted = TRUE
		if(species_allowed)
			species_is_permitted = (species.get_root_species_name(owner) in species_allowed)
		if(subspecies_allowed)
			species_is_permitted = (species.name in subspecies_allowed)
		if(!species_is_permitted)
			return FALSE
	if(!isnull(bodytypes_allowed) && !(bodytypes_allowed & bodytype_flags))
		return FALSE
	if(!isnull(bodytypes_denied) && (bodytypes_denied & bodytype_flags))
		return FALSE
	return TRUE
