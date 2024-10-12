#define LANGUAGE_TAJARA "Siik"
#define LANGUAGE_AKHANI "Akhani"
#define BODYTYPE_FELINE "feline body"
#define BODY_EQUIP_FLAG_FELINE BITFLAG(7)

/obj/item/clothing/setup_equip_flags()
	. = ..()
	if(bodytype_equip_flags & BODY_EQUIP_FLAG_EXCLUDE)
		bodytype_equip_flags |= BODY_EQUIP_FLAG_FELINE

/mob/living/human/tajaran/Initialize(mapload, species_name, datum/mob_snapshot/supplied_appearance)
	. = ..(species_name = SPECIES_TAJARA)
