var/global/list/med_hud_users = list()          // List of all entities using a medical HUD.
var/global/list/sec_hud_users = list()          // List of all entities using a security HUD.
var/global/list/jani_hud_users = list()
var/global/list/hud_icon_reference = list()
var/global/list/listening_objects = list() // List of objects that need to be able to hear, used to avoid recursive searching through contents.
var/global/list/global_mutations = list() // List of hidden mutation things.
var/global/list/reg_dna = list()
var/global/list/global_map = list()

var/global/host = null //only here until check @ code\modules\ghosttrap\trap.dm:112 is fixed
var/global/datum/sun/sun = new
var/global/datum/universal_state/universe = new

/// Vowels.
var/global/list/vowels = list("a","e","i","o","u")
/// Alphabet a-z.
var/global/list/alphabet = list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
/// Alphabet A-Z.
var/global/list/alphabet_capital = list("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")
/// Numbers 0-9.
var/global/list/numbers = list("0","1","2","3","4","5","6","7","8","9")

var/global/list/meteor_list = list()
