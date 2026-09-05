#define LANGUAGE_TAJARAN       "Siik'maas"
#define BODYTYPE_TAJARAN       "felinoid body"

/decl/modpack/tajaran
	name = "Tajaran Species"
	tabloid_headlines = list(
		"TAJARANS: CUTE AND CUDDLY, OR INFILTRATING THE GOVERNMENT? FIND OUT MORE INSIDE"
	)

/decl/modpack/tajaran/pre_initialize()
	..()
	SSmodpacks.default_submap_whitelisted_species |= /decl/species/tajaran::uid

/mob/living/human/tajaran/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	. = ..(species_uid = /decl/species/tajaran::uid)

/obj/item
	var/_tajaran_onmob_icon

/obj/item/setup_sprite_sheets()
	. = ..()
	if(_tajaran_onmob_icon)
		LAZYSET(sprite_sheets, BODYTYPE_TAJARAN, _tajaran_onmob_icon)

/obj/item/remains/tajaran
	desc = "They look like Tajaran remains. They're surprisingly small."
	icon_state = "remainstajaran"
	icon = 'mods/species/tajaran/icons/remains.dmi'

/obj/item/bone/skull/tajaran
	desc = "A skull. Judging by the shape and size, you'd guess that it might be Tajaran."
	icon_state = "tajskull"

/obj/random/humanoidremains/Initialize()
	. = ..()
	remains[/obj/item/remains/tajaran] = 25
