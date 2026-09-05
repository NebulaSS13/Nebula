/decl/loadout_option/suit/bomber // Override version of bomber jacket selection incorporating map-specific jacket.
	name = "jacket, bomber selection"
	description = "A selection of jackets styled after early aviation gear."
	path = /obj/item/clothing/suit/jacket/bomber
	cost = 2
	uid = "loadout_cynosure_bomber_jacket"

/decl/loadout_option/suit/bomber/Initialize()
	. = ..()
	var/bombertype = list()
	bombertype["bomber jacket"] = /obj/item/clothing/suit/jacket/bomber
	bombertype["bomber jacket, pilot blue"] = /obj/item/clothing/suit/jacket/bomber/pilot
	gear_tweaks += new/datum/gear_tweak/path(bombertype)
