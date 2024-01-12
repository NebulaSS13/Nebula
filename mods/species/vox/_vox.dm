#define SPECIES_VOX        "Vox"
#define BODYTYPE_VOX       "reptoavian body"
#define BODYTYPE_VOX_LARGE "large reptoavian body"
#define BP_HINDTONGUE      "hindtongue"
#define BODY_FLAG_VOX      BITFLAG(8)

/decl/modpack/vox
	name = "Vox Content"
	dreams = list("a red stool", "a vox raider")
	credits_crew_names = list("THE VOX")
	credits_topics = list("VOX RITUAL DUELS", "NECK MARKINGS", "ANCIENT SUPERCOMPUTERS")

/mob/living/carbon/human/vox/Initialize(mapload, species_name, datum/dna/new_dna, decl/bodytype/new_bodytype)
	set_hairstyle(/decl/sprite_accessory/hair/vox/short, skip_update = TRUE)
	set_hair_colour(COLOR_BEASTY_BROWN, skip_update = TRUE)
	species_name = SPECIES_VOX
	. = ..()

/datum/follow_holder/voxstack
	sort_order = 14
	followed_type = /obj/item/organ/internal/voxstack

/datum/follow_holder/voxstack/show_entry()
	var/obj/item/organ/internal/voxstack/S = followed_instance
	return ..() && !S.owner
