/decl/loadout_option/storage/brown_vest
	name = "webbing, brown"
	path = /obj/item/clothing/accessory/storage/vest/brown
	cost = 3
	allowed_roles = list(/datum/job/chief_engineer, /datum/job/engineer, /datum/job/roboticist, /datum/job/qm, /datum/job/cargo_tech, /datum/job/mining, /datum/job/janitor)

/decl/loadout_option/storage/black_vest
	name = "webbing, black"
	path = /obj/item/clothing/accessory/storage/vest/black
	cost = 3
	allowed_roles = list(/datum/job/hos, /datum/job/warden, /datum/job/detective, /datum/job/officer)

/decl/loadout_option/storage/white_vest
	name = "webbing, white"
	path = /obj/item/clothing/accessory/storage/vest
	cost = 3
	allowed_roles = list(/datum/job/cmo, /datum/job/doctor)

/decl/loadout_option/storage/brown_drop_pouches
	name = "drop pouches, brown"
	path = /obj/item/clothing/accessory/storage/drop_pouches/brown
	cost = 3
	allowed_roles = list(/datum/job/chief_engineer, /datum/job/engineer, /datum/job/roboticist, /datum/job/qm, /datum/job/cargo_tech, /datum/job/mining, /datum/job/janitor)

/decl/loadout_option/storage/black_drop_pouches
	name = "drop pouches, black"
	path = /obj/item/clothing/accessory/storage/drop_pouches/black
	cost = 3
	allowed_roles = list(/datum/job/hos, /datum/job/warden, /datum/job/detective, /datum/job/officer)

/decl/loadout_option/storage/white_drop_pouches
	name = "drop pouches, white"
	path = /obj/item/clothing/accessory/storage/drop_pouches/white
	cost = 3
	allowed_roles = list(/datum/job/cmo, /datum/job/doctor)

/decl/loadout_option/accessory/armband_hydro
	name = "hydroponics armband"
	path = /obj/item/clothing/accessory/armband/hydro
	allowed_roles = list(/datum/job/rd, /datum/job/scientist, /datum/job/assistant)

/decl/loadout_option/accessory/chaplaininsignia
	name = "chaplain insignia"
	path = /obj/item/clothing/accessory/chaplaininsignia
	cost = 1
	allowed_roles = list(/datum/job/chaplain)

/decl/loadout_option/accessory/chaplaininsignia/Initialize()
	. = ..()
	var/insignia = list()
	insignia["chaplain insignia (christianity)"] = /obj/item/clothing/accessory/chaplaininsignia
	insignia["chaplain insignia (judaism)"] = /obj/item/clothing/accessory/chaplaininsignia/judaism
	insignia["chaplain insignia (islam)"] = /obj/item/clothing/accessory/chaplaininsignia/islam
	insignia["chaplain insignia (buddhism)"] = /obj/item/clothing/accessory/chaplaininsignia/buddhism
	insignia["chaplain insignia (hinduism)"] = /obj/item/clothing/accessory/chaplaininsignia/hinduism
	insignia["chaplain insignia (sikhism)"] = /obj/item/clothing/accessory/chaplaininsignia/sikhism
	insignia["chaplain insignia (baha'i faith)"] = /obj/item/clothing/accessory/chaplaininsignia/bahaifaith
	insignia["chaplain insignia (jainism)"] = /obj/item/clothing/accessory/chaplaininsignia/jainism
	insignia["chaplain insignia (taoism)"] = /obj/item/clothing/accessory/chaplaininsignia/taoism
	gear_tweaks += new/datum/gear_tweak/path(insignia)

/decl/loadout_option/eyes/meson
	name = "Meson Goggles"
	path = /obj/item/clothing/glasses/meson
	allowed_roles = list(/datum/job/chief_engineer, /datum/job/engineer, /datum/job/mining, /datum/job/scientist, /datum/job/rd)

/decl/loadout_option/eyes/meson/prescription
	name = "Meson Goggles, prescription"
	path = /obj/item/clothing/glasses/meson/prescription

/decl/loadout_option/eyes/meson/ipatch
	name = "HUDpatch, Meson"
	path = /obj/item/clothing/glasses/eyepatch/hud/meson
	cost = 2

/decl/loadout_option/eyes/material
	name = "Material Goggles"
	path = /obj/item/clothing/glasses/material
	allowed_roles = list(/datum/job/chief_engineer, /datum/job/engineer, /datum/job/mining)

/decl/loadout_option/eyes/janitor
	name = "JaniHUD"
	path = /obj/item/clothing/glasses/hud/janitor
	cost = 2
	allowed_roles = list(/datum/job/janitor)

/decl/loadout_option/eyes/janitor/prescription
	name = "JaniHUD, prescription"
	path = /obj/item/clothing/glasses/hud/janitor/prescription

/decl/loadout_option/gloves/botany
	name = "gloves, botany"
	path = /obj/item/clothing/gloves/thick/botany
	cost = 3
	allowed_roles = list(/datum/job/rd, /datum/job/scientist, /datum/job/chef, /datum/job/bartender, /datum/job/assistant)

/decl/loadout_option/accessory/armband_emt
	name = "EMT armband"
	path = /obj/item/clothing/accessory/armband/medgreen
	allowed_roles = list(/datum/job/doctor)
