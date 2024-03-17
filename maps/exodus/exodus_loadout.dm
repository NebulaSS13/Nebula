/decl/loadout_option/accessory/chaplaininsignia
	name = "chaplain insignia"
	path = /obj/item/clothing/jewelry/insignia
	cost = 1
	allowed_roles = list(/datum/job/chaplain)

/decl/loadout_option/accessory/chaplaininsignia/Initialize()
	. = ..()
	var/insignia = list()
	insignia["chaplain insignia (christianity)"] = /obj/item/clothing/jewelry/insignia
	insignia["chaplain insignia (judaism)"] = /obj/item/clothing/jewelry/insignia/judaism
	insignia["chaplain insignia (islam)"] = /obj/item/clothing/jewelry/insignia/islam
	insignia["chaplain insignia (buddhism)"] = /obj/item/clothing/jewelry/insignia/buddhism
	insignia["chaplain insignia (hinduism)"] = /obj/item/clothing/jewelry/insignia/hinduism
	insignia["chaplain insignia (sikhism)"] = /obj/item/clothing/jewelry/insignia/sikhism
	insignia["chaplain insignia (baha'i faith)"] = /obj/item/clothing/jewelry/insignia/bahaifaith
	insignia["chaplain insignia (jainism)"] = /obj/item/clothing/jewelry/insignia/jainism
	insignia["chaplain insignia (taoism)"] = /obj/item/clothing/jewelry/insignia/taoism
	gear_tweaks += new/datum/gear_tweak/path(insignia)
