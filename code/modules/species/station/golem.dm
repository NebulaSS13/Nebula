/decl/bodytype/crystalline/golem
	name =              "humanoid"
	bodytype_category = BODYTYPE_HUMANOID
	icon_base =         'icons/mob/human_races/species/golem/body.dmi'
	husk_icon =         'icons/mob/human_races/species/golem/husk.dmi'
	body_flags =        BODY_FLAG_NO_DNA | BODY_FLAG_NO_PAIN | BODY_FLAG_NO_DEFIB | BODY_FLAG_NO_STASIS
	has_organ = list(
		BP_BRAIN = /obj/item/organ/internal/brain/golem
	)
	uid = "bodytype_crystalline_golem"

/decl/species/golem
	name = SPECIES_GOLEM
	name_plural = "Golems"

	available_bodytypes = list(/decl/bodytype/crystalline/golem)

	unarmed_attacks = list(/decl/natural_attack/stomp, /decl/natural_attack/kick, /decl/natural_attack/punch)
	species_flags = SPECIES_FLAG_NO_POISON
	spawn_flags = SPECIES_IS_RESTRICTED
	shock_vulnerability = 0

	butchery_data = /decl/butchery_data/crystal

	breath_type = null
	poison_types = null

	blood_types = list(/decl/blood_type/coolant)

	flesh_color = "#137e8f"

	death_message = "becomes completely motionless..."
	available_pronouns = list(/decl/pronouns/neuter)

	force_cultural_info = list(
		TAG_CULTURE =   /decl/cultural_info/culture/hidden/cultist,
		TAG_HOMEWORLD = /decl/cultural_info/location/stateless,
		TAG_FACTION =   /decl/cultural_info/faction/other
	)

	traits = list(/decl/trait/metabolically_inert = TRAIT_LEVEL_EXISTS)

/decl/species/golem/handle_post_spawn(var/mob/living/human/H)
	if(H.mind)
		H.mind.reset()
		H.mind.assigned_role = "Golem"
		H.mind.assigned_special_role = "Golem"
	H.real_name = "golem ([rand(1, 1000)])"
	H.SetName(H.real_name)
	H.status_flags |= NO_ANTAG
	..()
