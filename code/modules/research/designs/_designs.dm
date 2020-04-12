/***************************************************************
**						Design Datums						  **
**	All the data for building stuff and tracking reliability. **
***************************************************************/
/*
For the materials datum, it assumes you need reagents unless specified otherwise. To designate a material that isn't a reagent,
you use one of the material IDs below. These are NOT ids in the usual sense (they aren't defined in the object or part of a datum),
they are simply references used as part of a "has materials?" type proc. They all start with a  to denote that they aren't reagents.
The currently supporting non-reagent materials:

Don't add new keyword/IDs if they are made from an existing one (such as rods which are made from metal). Only add raw materials.

Design Guidlines
- When adding new designs, check rdreadme.dm to see what kind of things have already been made and where new stuff is needed.
- A single sheet of anything is 2000 units of material. Materials besides metal/glass require help from other jobs (mining for
other types of metals and chemistry for reagents).

*/
//Note: More then one of these can be added to a design.

/datum/design                   // Datum for object designs, used in construction
	var/name                    // Name of the created object. If null it will be 'guessed' from build_path if possible.
	var/desc                    // Description of the created object. If null it will use group_desc and name where applicable.
	var/build_type              // Flag as to what kind machine the design is built in. See defines.
	var/build_path              // The path of the object that gets created.
	var/time = 10               // How many ticks it requires to build
	var/category                // Primarily used for Mech Fabricators, but can be used for anything.
	var/list/req_tech = list()  // IDs of that techs the object originated from and the minimum level requirements.
	var/list/materials          // List of materials. Format: "id" = amount.
	var/list/chemicals = list() // List of chemicals.

/datum/design/New()
	..()
	// Needs to be handled during New() because R&D network code is a mess.
	// Only accesses initial() on paths so should be more or less safe.
	AssembleDesignInfo()
	// Queue material update.
	SSfabrication.init_rnd_design(src)

//These procs are used in subtypes for assigning names and descriptions dynamically
/datum/design/proc/AssembleDesignInfo()
	AssembleDesignName()
	AssembleDesignDesc()
	ModifyDesignName()

// Grab materials from our build path if not already set.
/datum/design/proc/AssembleDesignMaterials()
	if(build_path && !materials)
		materials = list()
		var/list/build_mats = atom_info_repository.get_matter_for(build_path)
		for(var/mat in build_mats)
			materials[mat] = ceil(build_mats[mat] * FABRICATOR_EXTRA_COST_FACTOR)

//Adjust name, if needed.
/datum/design/proc/ModifyDesignName()
	return

//Get name from build path if posible
/datum/design/proc/AssembleDesignName()
	if(!name && build_path)
		var/atom/movable/A = build_path
		name = initial(A.name)
	if(!name)
		name = "unnamed design"

//Try to make up a nice description if we don't have one
/datum/design/proc/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [name]."

//Returns a new instance of the item for this design
//This is to allow additional initialization to be performed, including possibly additional contructor arguments.
/datum/design/proc/Fabricate(var/newloc, var/fabricator)
	return new build_path(newloc)

/datum/design/item
	build_type = PROTOLATHE

// Testing helper
GLOBAL_LIST_INIT(build_path_to_design_datum_path, populate_design_datum_index())

/proc/populate_design_datum_index()
	. = list()
	for(var/path in typesof(/datum/design))
		var/datum/design/fake_design = path
		if(initial(fake_design.build_path))
			.[initial(fake_design.build_path)] = path
	for(var/path in typesof(/datum/fabricator_recipe))
		var/datum/fabricator_recipe/fake_recipe = path
		if(initial(fake_recipe.path))
			.[initial(fake_recipe.path)] = path