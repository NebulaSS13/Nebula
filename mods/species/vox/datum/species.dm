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
	base_external_prosthetics_model = /decl/bodytype/prosthetic/vox/crap

	default_emotes = list(
		/decl/emote/audible/vox_shriek
	)

	inherent_verbs = list(
		/mob/living/human/proc/toggle_vox_pressure_seal
	)

	unarmed_attacks = list(
		/decl/natural_attack/stomp,
		/decl/natural_attack/kick,
		/decl/natural_attack/claws/strong/gloves,
		/decl/natural_attack/punch,
		/decl/natural_attack/bite/strong
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

	scream_verb_1p = "shriek"
	scream_verb_3p = "shrieks"

	hidden_from_codex = FALSE

	taste_sensitivity = TASTE_DULL
	speech_sounds = list('sound/voice/shriek1.ogg')
	speech_chance = 20

	preview_outfit = /decl/outfit/vox_raider

	gluttonous = GLUT_TINY|GLUT_ITEM_NORMAL
	stomach_capacity = 12

	breath_type = /decl/material/gas/nitrogen
	poison_types = list(/decl/material/gas/oxygen = TRUE)
	shock_vulnerability = 0.2

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED

	blood_types = list(/decl/blood_type/vox)
	flesh_color = "#808d11"

	maneuvers = list(/decl/maneuver/leap/grab)
	standing_jump_range = 5

	available_pronouns = list(
		/decl/pronouns/neuter,
		/decl/pronouns/neuter/person,
		/decl/pronouns,
		/decl/pronouns/male,
		/decl/pronouns/female
	)
	// Add when clothing is available: /decl/bodytype/vox/stanchion
	available_bodytypes = list(
		/decl/bodytype/vox,
		/decl/bodytype/vox/servitor,
		/decl/bodytype/vox/servitor/alchemist,
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

/decl/species/vox/equip_survival_gear(var/mob/living/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vox(H), slot_wear_mask_str)
	var/obj/item/backpack/backpack = H.get_equipped_item(slot_back_str)
	if(istype(backpack))
		H.equip_to_slot_or_del(new /obj/item/box/vox(backpack), slot_in_backpack_str)
		var/obj/item/tank/nitrogen/tank = new(H)
		H.equip_to_slot_or_del(tank, BP_R_HAND)
		if(tank)
			H.set_internals(tank)
	else
		H.equip_to_slot_or_del(new /obj/item/tank/nitrogen(H), slot_back_str)
		H.equip_to_slot_or_del(new /obj/item/box/vox(H), BP_R_HAND)
		H.set_internals(backpack)

// Ideally this would all be on bodytype, but pressure is handled per-mob currently.
var/global/list/vox_current_pressure_toggle = list()

/decl/species/vox/disfigure_msg(var/mob/living/human/H)
	var/decl/pronouns/G = H.get_pronouns()
	return SPAN_DANGER("[G.His] beak-segments are cracked and chipped beyond recognition!\n")

/decl/species/vox/skills_from_age(age)
	. = 8

/decl/species/vox/handle_death(var/mob/living/human/H)
	..()
	var/obj/item/organ/internal/voxstack/stack = H.get_organ(BP_STACK, /obj/item/organ/internal/voxstack)
	if (stack)
		stack.do_backup()

/decl/emote/audible/vox_shriek
	key = "shriek"
	emote_message_3p = "$USER$ SHRIEKS!"
	emote_sound = 'mods/species/vox/sounds/shriek1.ogg'

/decl/species/vox/get_warning_low_pressure(var/mob/living/human/H)
	if(H && global.vox_current_pressure_toggle["\ref[H]"])
		return 50
	return ..()

/decl/species/vox/get_hazard_low_pressure(var/mob/living/human/H)
	if(H && global.vox_current_pressure_toggle["\ref[H]"])
		return 0
	return ..()

/mob/living/human/proc/toggle_vox_pressure_seal()
	set name = "Toggle Vox Pressure Seal"
	set category = "Abilities"
	set src = usr

	if(!istype(species, /decl/species/vox))
		verbs -= /mob/living/human/proc/toggle_vox_pressure_seal
		return

	if(incapacitated(INCAPACITATION_KNOCKOUT))
		to_chat(src, SPAN_WARNING("You are in no state to do that."))
		return

	var/decl/pronouns/G = get_pronouns()
	visible_message(SPAN_NOTICE("\The [src] begins flexing and realigning [G.his] scaling..."))
	if(!do_after(src, 2 SECONDS, src, FALSE))
		visible_message(
			SPAN_NOTICE("\The [src] ceases adjusting [G.his] scaling."),
			self_message = SPAN_WARNING("You must remain still to seal or unseal your scaling."))
		return

	if(incapacitated(INCAPACITATION_KNOCKOUT))
		to_chat(src, SPAN_WARNING("You are in no state to do that."))
		return

	// TODO: maybe add cold and heat thresholds to this.
	var/my_ref = "\ref[src]"
	if((global.vox_current_pressure_toggle[my_ref] = !global.vox_current_pressure_toggle[my_ref]))
		visible_message(
			SPAN_NOTICE("\The [src]'s scaling flattens and smooths out."),
			self_message = SPAN_NOTICE("You flatten your scaling and inflate internal bladders, protecting yourself against low pressure at the cost of dexterity.")
		)
	else
		visible_message(
			SPAN_NOTICE("\The [src]'s scaling bristles roughly."),
			self_message = SPAN_NOTICE("You bristle your scaling and deflate your internal bladders, restoring mobility but leaving yourself vulnerable to low pressure.")
		)
