/obj/item/clothing/gloves/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/neoavians/icons/clothing/gloves.dmi')

/obj/item/clothing/accessory/cloak/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/neoavians/icons/clothing/cloak.dmi')

/obj/item/clothing/under/avian_smock
	name = "smock"
	desc = "A loose-fitting smock favoured by neo-avians."
	icon = 'mods/species/neoavians/icons/clothing/smock.dmi'
	icon_state = ICON_STATE_WORLD
	bodytype_restricted = list(BODYTYPE_AVIAN)

/obj/item/clothing/under/avian_smock/worker
	name = "worker's smock"
	icon = 'mods/species/neoavians/icons/clothing/smock_grey.dmi'

/obj/item/clothing/under/avian_smock/rainbow
	name = "rainbow smock"
	desc = "A brightly coloured, loose-fitting smock - the height of neo-avian fashion."
	icon = 'mods/species/neoavians/icons/clothing/smock_rainbow.dmi'

/obj/item/clothing/under/avian_smock/security
	name = "armoured smock"
	desc = "A bright red smock with light armour insets, worn by neo-avian security personnel."
	icon = 'mods/species/neoavians/icons/clothing/smock_red.dmi'

/obj/item/clothing/under/avian_smock/engineering
	name = "hazard smock"
	desc = "A high-visibility yellow smock with orange highlights light armour insets, worn by neo-avian engineering personnel."
	icon = 'mods/species/neoavians/icons/clothing/smock_yellow.dmi'

/decl/loadout_option/uniform/avian
	whitelisted = list(SPECIES_AVIAN)

/decl/loadout_option/uniform/avian/smock
	name = "plain smock (Neo-Avian)"
	path = /obj/item/clothing/under/avian_smock
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/avian/smock_worker
	name = "worker's smock (Neo-Avian)"
	path = /obj/item/clothing/under/avian_smock/worker

/decl/loadout_option/uniform/avian/smock_rainbow
	name = "rainbow smock (Neo-Avian)"
	path = /obj/item/clothing/under/avian_smock/rainbow

/decl/loadout_option/uniform/avian/smock_security
	name = "armoured smock (Neo-Avian)"
	path = /obj/item/clothing/under/avian_smock/security

/decl/loadout_option/uniform/avian/smock_engineering
	name = "hazard smock (Neo-Avian)"
	path = /obj/item/clothing/under/avian_smock/engineering
