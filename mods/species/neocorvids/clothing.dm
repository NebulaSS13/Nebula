/obj/item/clothing/gloves/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_CORVID, 'mods/species/neocorvids/icons/clothing/gloves.dmi')

/obj/item/clothing/under/corvid_smock
	name = "smock"
	desc = "A loose-fitting smock favoured by neocorvids."
	icon = 'mods/species/neocorvids/icons/clothing/smock.dmi'
	icon_state = ICON_STATE_WORLD
	bodytype_restricted = list(BODYTYPE_CORVID)

/obj/item/clothing/under/corvid_smock/worker
	name = "worker's smock"
	icon = 'mods/species/neocorvids/icons/clothing/smock_grey.dmi'

/obj/item/clothing/under/corvid_smock/rainbow
	name = "rainbow smock"
	desc = "A brightly coloured, loose-fitting smock - the height of neocorvid fashion."
	icon = 'mods/species/neocorvids/icons/clothing/smock_rainbow.dmi'

/obj/item/clothing/under/corvid_smock/security
	name = "armoured smock"
	desc = "A bright red smock with light armour insets, worn by neocorvid security personnel."
	icon = 'mods/species/neocorvids/icons/clothing/smock_red.dmi'

/obj/item/clothing/under/corvid_smock/engineering
	name = "hazard smock"
	desc = "A high-visibility yellow smock with orange highlights light armour insets, worn by neocorvid engineering personnel."
	icon = 'mods/species/neocorvids/icons/clothing/smock_yellow.dmi'

/datum/gear/suit/corvid
	sort_category = "Xenowear"
	category = /datum/gear/suit/corvid
	whitelisted = list(SPECIES_CORVID)

datum/gear/suit/corvid/smock
	display_name = "plain smock (Neocorvid)"
	path = /obj/item/clothing/under/corvid_smock
	flags = GEAR_HAS_COLOR_SELECTION

datum/gear/suit/corvid/smock_worker
	display_name = "worker's smock (Neocorvid)"
	path = /obj/item/clothing/under/corvid_smock/worker

datum/gear/suit/corvid/smock_rainbow
	display_name = "rainbow smock (Neocorvid)"
	path = /obj/item/clothing/under/corvid_smock/rainbow

datum/gear/suit/corvid/smock_security
	display_name = "armoured smock (Neocorvid)"
	path = /obj/item/clothing/under/corvid_smock/security

datum/gear/suit/corvid/smock_engineering
	display_name = "hazard smock (Neocorvid)"
	path = /obj/item/clothing/under/corvid_smock/engineering
