// I really don't like having miscellaneous 'collection of definitions' files floating around in the codebase.
// I've already found a lot of the lists that used to be here a new forever home (or taken them out back and shot them),
// but hopefully we can do the same for the rest eventually.
// Either find a better spot for them that's related to their uses/function/etc., or delete them.

// Strings which correspond to bodypart covering flags, useful for outputting what something covers.
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

// TODO: These should probably be able to be generated automatically from inventory slot subtype definitions, maybe?
/// Strings which correspond to slot flags, useful for outputting what slot something is.
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

// Used to avoid constantly generating new lists during movement.
var/global/list/all_maniple_limbs   = list(
	(ORGAN_CATEGORY_MANIPLE)
)
var/global/list/all_stance_limbs   = list(
	(ORGAN_CATEGORY_STANCE),
	(ORGAN_CATEGORY_STANCE_ROOT)
)
var/global/list/child_stance_limbs = list(
	(ORGAN_CATEGORY_STANCE)
)

// TODO: Replace keybinding datums with keybinding decls to make this unnecessary.
var/global/list/hotkey_keybinding_list_by_key = list() // Replace this with just looping over all keybinding decls (as below) in a 'reset hotkeys' proc.
var/global/list/keybindings_by_name = list() // Replace this with just decl lookups.
/proc/makeDatumRefLists()
	// Keybindings
	for(var/KB in subtypesof(/datum/keybinding))
		var/datum/keybinding/keybinding = KB
		if(TYPE_IS_ABSTRACT(keybinding))
			continue
		ASSERT(keybinding.name)
		var/datum/keybinding/instance = new keybinding
		global.keybindings_by_name[instance.name] = instance
		if(length(instance.hotkey_keys))
			for(var/bound_key in instance.hotkey_keys)
				global.hotkey_keybinding_list_by_key[bound_key] += list(instance.name)

/proc/get_playable_species()
	var/static/list/_playable_species // A list of ALL playable species, whitelisted, latejoin or otherwise. (read: non-restricted)
	if(!_playable_species)
		_playable_species = list()
		for(var/decl/species/species in decls_repository.get_decls_of_subtype_unassociated(/decl/species))
			if(species.spawn_flags & SPECIES_IS_RESTRICTED)
				continue
			_playable_species += species.uid
	return _playable_species
