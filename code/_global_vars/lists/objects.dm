var/list/med_hud_users = list()          // List of all entities using a medical HUD.
var/list/sec_hud_users = list()          // List of all entities using a security HUD.
var/list/jani_hud_users = list()
var/list/hud_icon_reference = list()

var/list/listening_objects = list() // List of objects that need to be able to hear, used to avoid recursive searching through contents.

var/list/global_mutations = list() // List of hidden mutation things.

var/list/reg_dna = list()

var/list/global_map = list()

// Announcer intercom, because too much stuff creates an intercom for one message then hard del()s it. Also headset, for things that should be affected by comms outages.
GLOBAL_DATUM_INIT(global_announcer, /obj/item/radio/announcer, new)
GLOBAL_DATUM_INIT(global_headset, /obj/item/radio/announcer/subspace, new)

var/host = null //only here until check @ code\modules\ghosttrap\trap.dm:112 is fixed
GLOBAL_DATUM_INIT(sun, /datum/sun, new)
GLOBAL_DATUM_INIT(universe, /datum/universal_state, new)

GLOBAL_LIST_INIT(vowels, list("a","e","i","o","u"))
GLOBAL_LIST_INIT(alphabet_no_vowels, list("b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","z"))
GLOBAL_LIST_INIT(full_alphabet, list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"))

var/list/meteor_list = list()

var/list/is_currently_exploding = list()
