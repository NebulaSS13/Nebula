/decl/loadout_option/accessory/insignia
	name = "religious insignia"
	path = /obj/item/clothing/insignia
	cost = 1
	allowed_roles = list(/datum/job/chaplain)
	uid = "gear_accessory_insignia"

/decl/loadout_option/accessory/insignia/Initialize()
	. = ..()
	var/insignia = list()
	insignia["chaplain insignia (christianity)"] = /obj/item/clothing/insignia/christian
	insignia["chaplain insignia (judaism)"]      = /obj/item/clothing/insignia/judaism
	insignia["chaplain insignia (islam)"]        = /obj/item/clothing/insignia/islam
	insignia["chaplain insignia (buddhism)"]     = /obj/item/clothing/insignia/buddhism
	insignia["chaplain insignia (hinduism)"]     = /obj/item/clothing/insignia/hinduism
	insignia["chaplain insignia (sikhism)"]      = /obj/item/clothing/insignia/sikhism
	insignia["chaplain insignia (baha'i faith)"] = /obj/item/clothing/insignia/bahaifaith
	insignia["chaplain insignia (jainism)"]      = /obj/item/clothing/insignia/jainism
	insignia["chaplain insignia (taoism)"]       = /obj/item/clothing/insignia/taoism
	gear_tweaks += new/datum/gear_tweak/path(insignia)
