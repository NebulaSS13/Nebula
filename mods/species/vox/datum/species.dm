/datum/appearance_descriptor/age/vox
	chargen_min_index = 3
	chargen_max_index = 6
	standalone_value_descriptors = list(
		"freshly spawned" =  1,
		"a larva" =          2,
		"a juvenile" =       5,
		"an adolescent" =    8,
		"an adult" =        12,
		"senescent" =       50,
		"withered" =        65
	)

/decl/blood_type/vox
	name = "vox ichor"
	antigen_category = "vox"
	splatter_name = "ichor"
	splatter_desc = "A smear of thin, sticky alien ichor."
	splatter_colour = "#2299fc"
	transfusion_fail_reagent = /decl/material/gas/ammonia

/decl/species/vox
	name = SPECIES_VOX
	name_plural = SPECIES_VOX
	base_prosthetics_model = /decl/prosthetics_manufacturer/vox/crap

	vital_organs = list(
		BP_STACK,
		BP_BRAIN
	)

	default_emotes = list(
		/decl/emote/audible/vox_shriek
	)

	unarmed_attacks = list(
		/decl/natural_attack/stomp,
		/decl/natural_attack/kick,
		/decl/natural_attack/claws/strong/gloves,
		/decl/natural_attack/punch,
		/decl/natural_attack/bite/strong
	)

	default_h_style = /decl/sprite_accessory/hair/vox/short

	base_hair_color = "#160900"
	base_eye_color = "#d60093"
	base_color = "#526d29"
	base_markings = list(
		/decl/sprite_accessory/marking/vox/beak =   "#bc7d3e",
		/decl/sprite_accessory/marking/vox/scutes = "#bc7d3e",
		/decl/sprite_accessory/marking/vox/crest =  "#bc7d3e",
		/decl/sprite_accessory/marking/vox/claws =  "#a0a654"
	)

	rarity_value = 4

	description = {"The Vox are the broken remnants of a once-proud race, now reduced to little more
	than scavenging vermin who prey on isolated stations, ships or planets to keep their own ancient
	arkships alive. They are four to five feet tall, reptillian, beaked, tailed and quilled; human
	crews often refer to them as 'shitbirds' for their violent and offensive nature, as well as their
	horrible smell.
	<br/><br/>
	Most humans will never meet a Vox raider, instead learning of this insular species through dealing
	with their traders and merchants; those that do rarely enjoy the experience."}

	codex_description = {"The Vox are a hostile, deeply untrustworthy species from the edges of human
	space. They prey on isolated stations, ships or settlements without any apparent logic or reason,
	and tend to refuse communications or negotiations except when their backs are to the wall or they
	are in dire need of resources. They are four to five feet tall, reptillian, beaked, tailed and
	quilled."}

	hidden_from_codex = FALSE

	taste_sensitivity = TASTE_DULL
	speech_sounds = list('sound/voice/shriek1.ogg')
	speech_chance = 20

	warning_low_pressure = 50
	hazard_low_pressure = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = -1

	age_descriptor = /datum/appearance_descriptor/age/vox

	preview_outfit = /decl/hierarchy/outfit/vox_raider

	gluttonous = GLUT_TINY|GLUT_ITEM_NORMAL
	stomach_capacity = 12

	breath_type = /decl/material/gas/nitrogen
	poison_types = list(/decl/material/gas/oxygen = TRUE)
	siemens_coefficient = 0.2

	species_flags = SPECIES_FLAG_NO_SCAN
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = HAS_EYE_COLOR | HAS_HAIR_COLOR | HAS_SKIN_COLOR

	blood_types = list(/decl/blood_type/vox)
	flesh_color = "#808d11"

	maneuvers = list(/decl/maneuver/leap/grab)
	standing_jump_range = 5

	override_limb_types = list(
		BP_GROIN = /obj/item/organ/external/groin/vox,
		BP_TAIL = /obj/item/organ/external/tail/vox
	)

	has_organ = list(
		BP_STOMACH =    /obj/item/organ/internal/stomach/vox,
		BP_HEART =      /obj/item/organ/internal/heart/vox,
		BP_LUNGS =      /obj/item/organ/internal/lungs/vox,
		BP_LIVER =      /obj/item/organ/internal/liver/vox,
		BP_KIDNEYS =    /obj/item/organ/internal/kidneys/vox,
		BP_BRAIN =      /obj/item/organ/internal/brain,
		BP_EYES =       /obj/item/organ/internal/eyes/vox,
		BP_STACK =      /obj/item/organ/internal/voxstack,
		BP_HINDTONGUE = /obj/item/organ/internal/hindtongue
	)

	available_pronouns = list(
		/decl/pronouns/neuter,
		/decl/pronouns/neuter/person
	)
	available_bodytypes = list(/decl/bodytype/vox)

	appearance_descriptors = list(
		/datum/appearance_descriptor/height =       0.75,
		/datum/appearance_descriptor/build =        1.25,
		/datum/appearance_descriptor/vox_markings = 1
	)

	available_cultural_info = list(
		TAG_CULTURE =   list(
			/decl/cultural_info/culture/vox,
			/decl/cultural_info/culture/vox/salvager,
			/decl/cultural_info/culture/vox/raider
		),
		TAG_HOMEWORLD = list(
			/decl/cultural_info/location/vox,
			/decl/cultural_info/location/vox/shroud,
			/decl/cultural_info/location/vox/ship
		),
		TAG_FACTION = list(
			/decl/cultural_info/faction/vox,
			/decl/cultural_info/faction/vox/raider,
			/decl/cultural_info/faction/vox/apex
		),
		TAG_RELIGION =  list(
			/decl/cultural_info/religion/vox
		)
	)

	exertion_effect_chance = 10
	exertion_hydration_scale = 1
	exertion_charge_scale = 1
	exertion_reagent_scale = 1
	exertion_reagent_path = /decl/material/liquid/lactate
	exertion_emotes_biological = list(
		/decl/emote/exertion/biological,
		/decl/emote/exertion/biological/breath,
		/decl/emote/exertion/biological/pant
	)
	exertion_emotes_synthetic = list(
		/decl/emote/exertion/synthetic,
		/decl/emote/exertion/synthetic/creak
	)

/decl/species/vox/equip_survival_gear(var/mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vox(H), slot_wear_mask_str)
	var/obj/item/storage/backpack/backpack = H.get_equipped_item(slot_back_str)
	if(istype(backpack))
		H.equip_to_slot_or_del(new /obj/item/storage/box/vox(backpack), slot_in_backpack_str)
		var/obj/item/tank/nitrogen/tank = new(H)
		H.equip_to_slot_or_del(tank, BP_R_HAND)
		if(tank)
			H.set_internals(tank)
	else
		H.equip_to_slot_or_del(new /obj/item/tank/nitrogen(H), slot_back_str)
		H.equip_to_slot_or_del(new /obj/item/storage/box/vox(H), BP_R_HAND)
		H.set_internals(backpack)

/decl/species/vox/disfigure_msg(var/mob/living/carbon/human/H)
	var/decl/pronouns/G = H.get_pronouns()
	return SPAN_DANGER("[G.His] beak-segments are cracked and chipped beyond recognition!\n")

/decl/species/vox/skills_from_age(age)
	. = 8

/decl/species/vox/handle_death(var/mob/living/carbon/human/H)
	..()
	var/obj/item/organ/internal/voxstack/stack = H.get_organ(BP_STACK, /obj/item/organ/internal/voxstack)
	if (stack)
		stack.do_backup()

/decl/emote/audible/vox_shriek
	key ="shriek"
	emote_message_3p = "USER SHRIEKS!"
	emote_sound = 'mods/species/vox/sounds/shriek1.ogg'
