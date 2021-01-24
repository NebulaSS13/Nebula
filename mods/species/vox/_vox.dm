#define SPECIES_VOX            "Vox"
#define BODYTYPE_VOX           "Reptoavian Body"

#define CULTURE_VOX_ARKSHIP    "Arkship Crew"
#define CULTURE_VOX_SALVAGER   "Salvager Crew"
#define CULTURE_VOX_RAIDER     "Raider Crew"
#define HOME_SYSTEM_VOX_ARK    "Ark-Dweller"
#define HOME_SYSTEM_VOX_SHROUD "Shroud-Dweller"
#define HOME_SYSTEM_VOX_SHIP   "Ship-Dweller"
#define FACTION_VOX_RAIDER     "Raider"
#define FACTION_VOX_CREW       "Ark Labourer"
#define FACTION_VOX_APEX       "Apex Servant"
#define RELIGION_VOX           "Auralis Reverence"

#define BP_HINDTONGUE "hindtongue"

/decl/modpack/vox
	name = "Vox Content"
	dreams = list("a red stool", "a vox raider")
	credits_crew_names = list("THE VOX")
	credits_topics = list("VOX RITUAL DUELS", "NECK MARKINGS", "ANCIENT SUPERCOMPUTERS")

/mob/living/carbon/human/vox/Initialize(mapload, new_species)
	h_style = "Short Vox Quills"
	hair_colour = COLOR_BEASTY_BROWN
	. = ..(mapload, SPECIES_VOX)

/datum/follow_holder/voxstack
	sort_order = 14
	followed_type = /obj/item/organ/internal/voxstack

/datum/follow_holder/voxstack/show_entry()
	var/obj/item/organ/internal/voxstack/S = followed_instance
	return ..() && !S.owner
