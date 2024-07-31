/decl/species/human
	name = SPECIES_HUMAN
	name_plural = "Humans"
	primitive_form = SPECIES_MONKEY
	unarmed_attacks = list(
		/decl/natural_attack/stomp,
		/decl/natural_attack/kick,
		/decl/natural_attack/punch,
		/decl/natural_attack/bite
	)
	description = "A medium-sized creature prone to great ambition. If you are reading this, you are probably a human."
	hidden_from_codex = FALSE
	spawn_flags = SPECIES_CAN_JOIN
	inherent_verbs = list(/mob/living/human/proc/tie_hair)

	// Add /decl/bodytype/prosthetic/basic_human to this list to allow full-body prosthetics.
	available_bodytypes = list(
		/decl/bodytype/human,
		/decl/bodytype/human/masculine,
		/decl/bodytype/prosthetic/basic_human
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

/decl/species/human/get_root_species_name(var/mob/living/human/H)
	return SPECIES_HUMAN

/decl/species/human/get_ssd(var/mob/living/human/H)
	if(H.stat == CONSCIOUS)
		return "staring blankly, not reacting to your presence"
	return ..()

/decl/species/human/equip_default_fallback_uniform(var/mob/living/human/H)
	if(istype(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/jumpsuit/grey, slot_w_uniform_str)
