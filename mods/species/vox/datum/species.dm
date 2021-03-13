#define IS_VOX "vox"

/decl/species/vox
	name = SPECIES_VOX
	name_plural = SPECIES_VOX
	icobase =         'mods/species/vox/icons/body/body.dmi'
	deform =          'mods/species/vox/icons/body/body.dmi'
	husk_icon =       'mods/species/vox/icons/body/husk.dmi'
	damage_overlays = 'mods/species/vox/icons/body/damage_overlay.dmi'
	damage_mask =     'mods/species/vox/icons/body/damage_mask.dmi'
	blood_mask =      'mods/species/vox/icons/body/blood_mask.dmi'

	bodytype = BODYTYPE_VOX

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
	rarity_value = 4
	description = "The Vox are the broken remnants of a once-proud race, now reduced to little more than \
	scavenging vermin who prey on isolated stations, ships or planets to keep their own ancient arkships \
	alive. They are four to five feet tall, reptillian, beaked, tailed and quilled; human crews often \
	refer to them as 'shitbirds' for their violent and offensive nature, as well as their horrible \
	smell. \
	<br/><br/> \
	Most humans will never meet a Vox raider, instead learning of this insular species through \
	dealing with their traders and merchants; those that do rarely enjoy the experience."
	codex_description = "The Vox are a hostile, deeply untrustworthy species from the edges of human space. They prey \
	on isolated stations, ships or settlements without any apparent logic or reason, and tend to refuse communications \
	or negotiations except when their backs are to the wall or they are in dire need of resources. They are four to five \
	feet tall, reptillian, beaked, tailed and quilled."
	hidden_from_codex = FALSE

	taste_sensitivity = TASTE_DULL
	speech_sounds = list('sound/voice/shriek1.ogg')
	speech_chance = 20

	warning_low_pressure = 50
	hazard_low_pressure = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = -1
	
	min_age = 1
	max_age = 100
	
	gluttonous = GLUT_TINY|GLUT_ITEM_NORMAL
	stomach_capacity = 12

	breath_type = /decl/material/gas/nitrogen
	poison_types = list(/decl/material/gas/oxygen = TRUE)
	siemens_coefficient = 0.2

	species_flags = SPECIES_FLAG_NO_SCAN
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = HAS_EYE_COLOR | HAS_HAIR_COLOR

	blood_color = "#2299fc"
	flesh_color = "#808d11"

	reagent_tag = IS_VOX
	maneuvers = list(/decl/maneuver/leap/grab)
	standing_jump_range = 5

	override_limb_types = list(
		BP_GROIN = /obj/item/organ/external/groin/vox
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

	genders = list(NEUTER)
	descriptors = list(
		/datum/mob_descriptor/height = -1,
		/datum/mob_descriptor/build = 1,
		/datum/mob_descriptor/vox_markings = 0
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
	exertion_reagent_scale = 5
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

/decl/species/vox/New()
	..()
	equip_adjust = list(
		BP_L_HAND =           list("[NORTH]" = list("x" =  0, "y" = -3), "[EAST]" = list("x" = 0, "y" = -3), "[SOUTH]" = list("x" =  0, "y" = -3),  "[WEST]" = list("x" =  0, "y" = -3)),
		BP_R_HAND =           list("[NORTH]" = list("x" =  0, "y" = -3), "[EAST]" = list("x" = 0, "y" = -3), "[SOUTH]" = list("x" =  0, "y" = -3),  "[WEST]" = list("x" =  0, "y" = -3)),
		slot_head_str =       list("[NORTH]" = list("x" =  0, "y" =  0), "[EAST]" = list("x" = 3, "y" =  0), "[SOUTH]" = list("x" =  0, "y" =  0),  "[WEST]" = list("x" = -3, "y" =  0)),
		slot_wear_mask_str =  list("[NORTH]" = list("x" =  0, "y" =  0), "[EAST]" = list("x" = 4, "y" =  0), "[SOUTH]" = list("x" =  0, "y" =  0),  "[WEST]" = list("x" = -4, "y" =  0)),
		slot_back_str =       list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" =  0, "y" = -2)),
		slot_wear_suit_str =  list("[NORTH]" = list("x" =  0, "y" = -3), "[EAST]" = list("x" = 0, "y" = -3), "[SOUTH]" = list("x" =  0, "y" = -3),  "[WEST]" = list("x" =  0, "y" = -3)),
		slot_w_uniform_str =  list("[NORTH]" = list("x" =  0, "y" = -3), "[EAST]" = list("x" = 0, "y" = -3), "[SOUTH]" = list("x" =  0, "y" = -3),  "[WEST]" = list("x" =  0, "y" = -3)),
		slot_underpants_str = list("[NORTH]" = list("x" =  0, "y" = -3), "[EAST]" = list("x" = 0, "y" = -3), "[SOUTH]" = list("x" =  0, "y" = -3),  "[WEST]" = list("x" =  0, "y" = -3)),
		slot_undershirt_str = list("[NORTH]" = list("x" =  0, "y" = -3), "[EAST]" = list("x" = 0, "y" = -3), "[SOUTH]" = list("x" =  0, "y" = -3),  "[WEST]" = list("x" =  0, "y" = -3))
	)

/decl/species/vox/equip_survival_gear(var/mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vox(H), slot_wear_mask_str)

	if(istype(H.get_equipped_item(slot_back_str), /obj/item/storage/backpack))
		H.equip_to_slot_or_del(new /obj/item/storage/box/vox(H.back), slot_in_backpack_str)
		var/obj/item/tank/nitrogen/tank = new(H)
		H.equip_to_slot_or_del(tank, BP_R_HAND)
		if(tank)
			H.set_internals(tank)
	else
		H.equip_to_slot_or_del(new /obj/item/tank/nitrogen(H), slot_back_str)
		H.equip_to_slot_or_del(new /obj/item/storage/box/vox(H), BP_R_HAND)
		H.set_internals(H.back)

/decl/species/vox/disfigure_msg(var/mob/living/carbon/human/H)
	var/datum/gender/T = gender_datums[H.get_gender()]
	return "<span class='danger'>[T.His] beak-segments are cracked and chipped! [T.He] [T.is] not even recognizable.</span>\n"
	
/decl/species/vox/skills_from_age(age)
	. = 8

/decl/species/vox/handle_death(var/mob/living/carbon/human/H)
	..()
	var/obj/item/organ/internal/voxstack/stack = H.get_organ(BP_STACK)
	if (stack)
		stack.do_backup()

/decl/emote/audible/vox_shriek
	key ="shriek"
	emote_message_3p = "USER SHRIEKS!"
	emote_sound = 'mods/species/vox/sounds/shriek1.ogg'
