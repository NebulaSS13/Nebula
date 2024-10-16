//Since it didn't really belong in any other category, I'm putting this here
//This is for procs to replace all the goddamn 'in world's that are chilling around the code
//Nine years later, we can report we've killed most of them!

var/global/list/cable_list = list()					//Index for all cables, so that powernets don't have to look through the entire world all the time
var/global/list/landmarks_list = list()				//list of all landmarks created
var/global/list/mannequins_

// Uplinks
var/global/list/obj/item/uplink/world_uplinks = list()

//Preferences stuff
var/global/datum/category_collection/underwear/underwear = new()

// Visual nets
var/global/list/datum/visualnet/visual_nets = list()
var/global/datum/visualnet/camera/cameranet = new()

// Strings which corraspond to bodypart covering flags, useful for outputting what something covers.
var/global/list/string_part_flags = list(
	"head" =       SLOT_HEAD,
	"face" =       SLOT_FACE,
	"eyes" =       SLOT_EYES,
	"ears" =       SLOT_EARS,
	"upper body" = SLOT_UPPER_BODY,
	"lower body" = SLOT_LOWER_BODY,
	"tail" =       SLOT_TAIL,
	"legs" =       SLOT_LEGS,
	"feet" =       SLOT_FEET,
	"arms" =       SLOT_ARMS,
	"hands" =      SLOT_HANDS
)

// Strings which corraspond to slot flags, useful for outputting what slot something is.
var/global/list/string_slot_flags = list(
	"back"      = SLOT_BACK,
	"face"      = SLOT_FACE,
	"waist"     = SLOT_LOWER_BODY,
	"tail"      = SLOT_TAIL,
	"ID slot"   = SLOT_ID,
	"ears"      = SLOT_EARS,
	"eyes"      = SLOT_EYES,
	"hands"     = SLOT_HANDS,
	"head"      = SLOT_HEAD,
	"feet"      = SLOT_FEET,
	"exo slot"  = SLOT_OVER_BODY,
	"body"      = SLOT_UPPER_BODY,
	"holster"   = SLOT_HOLSTER
)

//////////////////////////
/////Initial Building/////
//////////////////////////

/proc/get_mannequin(var/ckey)
	if(SSatoms.atom_init_stage < INITIALIZATION_INNEW_REGULAR)
		return
	if(!mannequins_)
		mannequins_ = new()
	. = mannequins_[ckey]
	if(!.)
		. = new /mob/living/human/dummy/mannequin()
		mannequins_[ckey] = .

/hook/global_init/proc/makeDatumRefLists()
	// Keybindings
	for(var/KB in subtypesof(/datum/keybinding))
		var/datum/keybinding/keybinding = KB
		if(!initial(keybinding.name))
			continue
		var/datum/keybinding/instance = new keybinding
		global.keybindings_by_name[instance.name] = instance
		if(length(instance.hotkey_keys))
			for(var/bound_key in instance.hotkey_keys)
				global.hotkey_keybinding_list_by_key[bound_key] += list(instance.name)
	return 1

// This is all placeholder procs for an eventual PR to change them to use decls.
var/global/list/all_species
var/global/list/playable_species // A list of ALL playable species, whitelisted, latejoin or otherwise.
var/global/list/bodytype_species_pairs = list() // A list of bodytypes -> species, used for mainly unit testing.
/proc/build_species_lists()
	if(global.all_species)
		return
	global.all_species      = list()
	global.playable_species = list()
	var/list/species_decls = decls_repository.get_decls_of_subtype(/decl/species)
	for(var/species_type in species_decls)
		var/decl/species/species = species_decls[species_type]
		if(species.name)
			global.all_species[species.name] = species
			for(var/decl/bodytype/bodytype in species.available_bodytypes)
				global.bodytype_species_pairs[bodytype] = species
			if(!(species.spawn_flags & SPECIES_IS_RESTRICTED))
				global.playable_species += species.name
	if(global.using_map.default_species)
		global.playable_species |= global.using_map.default_species

/proc/get_species_by_key(var/species_key)
	build_species_lists()
	. = global.all_species[species_key]
/proc/get_all_species()
	build_species_lists()
	. = global.all_species
/proc/get_playable_species()
	build_species_lists()
	. = global.playable_species
/proc/get_bodytype_species_pairs()
	build_species_lists()
	. = global.bodytype_species_pairs