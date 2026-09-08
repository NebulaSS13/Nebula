#define BODYTYPE_VOX        "reptoavian body"
#define BODYTYPE_VOX_LARGE  "large reptoavian body"
// Internal organs
#define BP_HINDTONGUE       "hindtongue"
#define BP_VOXSTACK            "vox stack"
// Bodytype equip flags
#define BODY_EQUIP_FLAG_VOX BITFLAG(8)

/decl/modpack/vox
	name = "Vox Content"
	dreams = list("a red stool", "a vox raider")
	credits_crew_names = list("THE VOX")
	credits_topics = list("VOX RITUAL DUELS", "NECK MARKINGS", "ANCIENT SUPERCOMPUTERS")

/datum/follow_holder/voxstack
	sort_order = 14
	followed_type = /obj/item/organ/internal/voxstack

/datum/follow_holder/voxstack/show_entry()
	var/obj/item/organ/internal/voxstack/S = followed_instance
	return ..() && !S.owner
