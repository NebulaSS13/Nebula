var/global/list/med_hud_users = list()          // List of all entities using a medical HUD.
var/global/list/sec_hud_users = list()          // List of all entities using a security HUD.
var/global/list/jani_hud_users = list()
var/global/list/hud_icon_reference = list()
var/global/list/listening_objects = list() // List of objects that need to be able to hear, used to avoid recursive searching through contents.
var/global/list/global_mutations = list() // List of hidden mutation things.
var/global/list/reg_dna = list()
var/global/list/global_map = list()

// Announcer intercom, because too much stuff creates an intercom for one message then hard del()s it. Also headset, for things that should be affected by comms outages.
GLOBAL_GETTER(announcer, /obj/item/radio/announcer, new)
GLOBAL_GETTER(headset, /obj/item/radio/announcer/subspace, new)

var/global/host = null //only here until check @ code\modules\ghosttrap\trap.dm:112 is fixed
var/global/datum/sun/sun = new
var/global/datum/universal_state/universe = new

var/global/list/vowels =             list("a","e","i","o","u")
var/global/list/alphabet_no_vowels = list("b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","z")
var/global/list/full_alphabet =      list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")

var/global/list/meteor_list = list()
