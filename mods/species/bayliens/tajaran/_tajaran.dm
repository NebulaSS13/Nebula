#define SPECIES_TAJARA  "Tajara"
#define LANGUAGE_TAJARA "Siik'maas"
#define BODYTYPE_FELINE "feline body"
#define BODY_FLAG_FELINE BITFLAG(7)

/obj/item/clothing/Initialize()
	. = ..()
	if(bodytype_equip_flags & BODY_FLAG_EXCLUDE)
		bodytype_equip_flags |= BODY_FLAG_FELINE

/mob/living/carbon/human/tajaran/Initialize(mapload, species_name, datum/dna/new_dna, decl/bodytype/new_bodytype)
	. = ..(mapload, SPECIES_TAJARA, dna, new_bodytype)
