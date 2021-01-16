#define SPECIES_TAJARA "Tajaran"
#define CULTURE_TAJARA "Tajaran"
#define LANGUAGE_TAJARA "Siik'maas"
#define BODYTYPE_FELINE "Feline Body"

/obj/item/clothing/Initialize()
	. = ..()
	if(length(bodytype_restricted) && !("exclude" in bodytype_restricted))
		bodytype_restricted |= BODYTYPE_FELINE

/decl/modpack/tajaran
	name = "Tajaran"
