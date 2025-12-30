// All variables here use double quotes to able load information on every startup.

var/global/list/ai_names =           file2list("config/names/ai.txt")

var/global/list/verbs =              file2list("config/names/verbs.txt")
var/global/list/adjectives =         file2list("config/names/adjectives.txt")

var/global/list/abstract_slot_names = list(
	slot_in_backpack_str = "In Backpack"
)
