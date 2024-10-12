/obj/item/clothing/ears/skrell
	name = "skrell tentacle wear"
	desc = "Some stuff worn by skrell to adorn their head tentacles."

/obj/item/clothing/ears/skrell/mob_can_equip(mob/user, slot, disable_warning = FALSE, force = FALSE, ignore_equipped = FALSE)
	. = ..()
	if(. && user?.get_species_name() != SPECIES_SKRELL)
		return FALSE

/obj/item/clothing/ears/skrell/band
	name = "headtail bands"
	desc = "Metallic bands worn by skrell to adorn their head tails."
	icon = 'mods/species/skrell/icons/clothing/ears/band.dmi'
	drop_sound = 'mods/species/skrell/sound/drop/accessory.ogg'
	pickup_sound = 'mods/species/skrell/sound/pickup/accessory.ogg'

/obj/item/clothing/ears/skrell/band/chains
	name = "very short headtail chains"
	desc = "A delicate chain worn by skrell to decorate their headtails."
	icon = 'mods/species/skrell/icons/clothing/ears/chains_very_short.dmi'

/obj/item/clothing/ears/skrell/band/chains/short
	name = "short headtail chains"
	icon = 'mods/species/skrell/icons/clothing/ears/chains_short.dmi'

/obj/item/clothing/ears/skrell/band/chains/long
	name = "long headtail chains"
	icon = 'mods/species/skrell/icons/clothing/ears/chains_long.dmi'

/obj/item/clothing/ears/skrell/band/chains/very_long
	name = "very long headtail chains"
	icon = 'mods/species/skrell/icons/clothing/ears/chains_very_long.dmi'

/obj/item/clothing/ears/skrell/cloth
	name = "short headtail cloth"
	desc = "A cloth shawl worn by skrell draped around their head tails."
	icon = 'mods/species/skrell/icons/clothing/ears/cloth_short.dmi'

/obj/item/clothing/ears/skrell/cloth/long
	name = "long headtail cloth"
	icon = 'mods/species/skrell/icons/clothing/ears/cloth_long.dmi'

/decl/loadout_option/ears/skrell
	name = "skrell headtail accessory selection"
	category = /decl/loadout_category/ears
	whitelisted = list(SPECIES_SKRELL)
	path = /obj/item/clothing/ears/skrell
	loadout_flags = GEAR_HAS_COLOR_SELECTION | GEAR_HAS_SUBTYPE_SELECTION
	uid = "gear_accessory_skrell"
