/decl/bodytype/golem
	name =              "humanoid"
	bodytype_category = BODYTYPE_HUMANOID
	icon_base =         'icons/mob/human_races/species/golem/body.dmi'
	husk_icon =         'icons/mob/human_races/species/golem/husk.dmi'

/decl/species/golem
	name = SPECIES_GOLEM
	name_plural = "Golems"

	available_bodytypes = list(/decl/bodytype/golem)

	unarmed_attacks = list(/decl/natural_attack/stomp, /decl/natural_attack/kick, /decl/natural_attack/punch)
	species_flags = SPECIES_FLAG_NO_PAIN | SPECIES_FLAG_NO_SCAN | SPECIES_FLAG_NO_POISON | SPECIES_FLAG_CRYSTALLINE
	spawn_flags = SPECIES_IS_RESTRICTED
	siemens_coefficient = 0

	meat_type = null
	bone_material = null
	skin_material = null

	breath_type = null
	poison_types = null

	blood_types = list(/decl/blood_type/coolant)

	flesh_color = "#137e8f"

	cold_level_1 = SYNTH_COLD_LEVEL_1
	cold_level_2 = SYNTH_COLD_LEVEL_2
	cold_level_3 = SYNTH_COLD_LEVEL_3

	heat_level_1 = SYNTH_HEAT_LEVEL_1
	heat_level_2 = SYNTH_HEAT_LEVEL_2
	heat_level_3 = SYNTH_HEAT_LEVEL_3

	has_organ = list(
		BP_BRAIN = /obj/item/organ/internal/brain/golem
	)

	death_message = "becomes completely motionless..."
	available_pronouns = list(/decl/pronouns/neuter)

	force_cultural_info = list(
		TAG_CULTURE =   /decl/cultural_info/culture/hidden/cultist,
		TAG_HOMEWORLD = /decl/cultural_info/location/stateless,
		TAG_FACTION =   /decl/cultural_info/faction/other
	)

	traits = list(/decl/trait/metabolically_inert = TRAIT_LEVEL_EXISTS)

/decl/species/golem/handle_post_spawn(var/mob/living/carbon/human/H)
	if(H.mind)
		H.mind.reset()
		H.mind.assigned_role = "Golem"
		H.mind.assigned_special_role = "Golem"
	H.real_name = "golem ([rand(1, 1000)])"
	H.SetName(H.real_name)
	H.status_flags |= NO_ANTAG
	..()
