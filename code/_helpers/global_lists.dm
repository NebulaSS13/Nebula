//Since it didn't really belong in any other category, I'm putting this here
//This is for procs to replace all the goddamn 'in world's that are chilling around the code

var/global/list/cable_list = list()					//Index for all cables, so that powernets don't have to look through the entire world all the time
var/global/list/landmarks_list = list()				//list of all landmarks created
var/global/list/side_effects = list()				//list of all medical sideeffects types by thier names |BS12
var/list/mannequins_

// Uplinks
var/list/obj/item/uplink/world_uplinks = list()

//Preferences stuff
//Hairstyles
GLOBAL_LIST_EMPTY(hair_styles_list)        //stores /datum/sprite_accessory/hair indexed by name
GLOBAL_LIST_EMPTY(facial_hair_styles_list) //stores /datum/sprite_accessory/facial_hair indexed by name

var/global/list/skin_styles_female_list = list()		//unused
GLOBAL_LIST_EMPTY(body_marking_styles_list)		//stores /datum/sprite_accessory/marking indexed by name

GLOBAL_DATUM_INIT(underwear, /datum/category_collection/underwear, new())

// Visual nets
var/list/datum/visualnet/visual_nets = list()
var/datum/visualnet/camera/cameranet = new()

// Runes
var/global/list/rune_list = new()
var/global/list/endgame_exits = list()
var/global/list/endgame_safespawns = list()

var/global/list/syndicate_access = list(access_maint_tunnels, access_syndicate, access_external_airlocks)

// Strings which corraspond to bodypart covering flags, useful for outputting what something covers.
var/global/list/string_part_flags = list(
	"head" =       SLOT_HEAD,
	"face" =       SLOT_FACE,
	"eyes" =       SLOT_EYES,
	"ears" =       SLOT_EARS,
	"upper body" = SLOT_UPPER_BODY,
	"lower body" = SLOT_LOWER_BODY,
	"legs" =       SLOT_LEGS,
	"feet" =       SLOT_FEET,
	"arms" =       SLOT_ARMS,
	"hands" =      SLOT_HANDS
)

// Strings which corraspond to slot flags, useful for outputting what slot something is.
var/global/list/string_slot_flags = list(
	"back" =     SLOT_BACK,
	"face" =     SLOT_FACE,
	"waist" =    SLOT_LOWER_BODY,
	"ID slot" =  SLOT_ID,
	"ears" =     SLOT_EARS,
	"eyes" =     SLOT_EYES,
	"hands" =    SLOT_HANDS,
	"head" =     SLOT_HEAD,
	"feet" =     SLOT_FEET,
	"exo slot" = SLOT_OVER_BODY,
	"body" =     SLOT_UPPER_BODY,
	"uniform" =  SLOT_TIE,
	"holster" =  SLOT_HOLSTER
)

//////////////////////////
/////Initial Building/////
//////////////////////////

/proc/get_mannequin(var/ckey)
	if(!mannequins_)
		mannequins_ = new()
	. = mannequins_[ckey]
	if(!.)
		. = new/mob/living/carbon/human/dummy/mannequin()
		mannequins_[ckey] = .

/hook/global_init/proc/makeDatumRefLists()
	var/list/paths

	//Hair - Initialise all /datum/sprite_accessory/hair into an list indexed by hair-style name
	paths = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
	for(var/path in paths)
		var/datum/sprite_accessory/hair/H = new path()
		GLOB.hair_styles_list[H.name] = H

	//Facial Hair - Initialise all /datum/sprite_accessory/facial_hair into an list indexed by facialhair-style name
	paths = typesof(/datum/sprite_accessory/facial_hair) - /datum/sprite_accessory/facial_hair
	for(var/path in paths)
		var/datum/sprite_accessory/facial_hair/H = new path()
		GLOB.facial_hair_styles_list[H.name] = H

	//Body markings - Initialise all /datum/sprite_accessory/marking into an list indexed by marking name
	paths = typesof(/datum/sprite_accessory/marking) - /datum/sprite_accessory/marking
	for(var/path in paths)
		var/datum/sprite_accessory/marking/M = new path()
		GLOB.body_marking_styles_list[M.name] = M

	return 1

// This is all placeholder procs for an eventual PR to change them to use decls.
var/list/all_species = list()
var/list/playable_species = list() // A list of ALL playable species, whitelisted, latejoin or otherwise.
/proc/build_species_lists()
	global.all_species.Cut()
	global.playable_species.Cut()
	var/list/species_decls = decls_repository.get_decls_of_subtype(/decl/species)
	for(var/species_type in species_decls)
		var/decl/species/species = species_decls[species_type]
		if(species.name)
			global.all_species[species.name] = species
			if(!(species.spawn_flags & SPECIES_IS_RESTRICTED))
				global.playable_species += species.name
	if(GLOB.using_map.default_species)
		global.playable_species |= GLOB.using_map.default_species

/proc/get_species_by_key(var/species_key)
	build_species_lists()
	. = global.all_species[species_key]
/proc/get_all_species()
	build_species_lists()
	. = global.all_species
/proc/get_playable_species()
	build_species_lists()
	. = global.playable_species
