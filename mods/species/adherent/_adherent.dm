#define SPECIES_ADHERENT  "Adherent"
#define BODYTYPE_ADHERENT "Adherent Body"
#define LANGUAGE_ADHERENT "Protocol"

#define BP_FLOAT        "floatation disc"
#define BP_JETS         "maneuvering jets"
#define BP_COOLING_FINS "cooling fins"

/decl/modpack/adherent
	name = "Adherent"

/mob/living/carbon/human/Process_Spacemove()
	. = ..()
	if(!. && inertia_dir)
		// This is horrible but short of spawning a jetpack inside the organ than locating
		// it, I don't really see another viable approach short of a total jetpack refactor.
		for(var/obj/item/organ/internal/powered/jets/jet in internal_organs)
			if(!jet.is_broken() && jet.active)
				inertia_dir = 0
				return 1
		// End 'eugh'

/mob/living/carbon/human/adherent/Initialize(mapload)
	..(mapload, SPECIES_ADHERENT)
