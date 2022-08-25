/datum/appearance_descriptor/age/serpentid
	chargen_min_index = 3
	chargen_max_index = 6
	standalone_value_descriptors = list(
		"a larva" =         1,
		"a nymph" =         2,
		"a juvenile" =      3,
		"an adolescent" =   5,
		"a young adult" =  12,
		"a full adult" =   30,
		"senescent" =      45
	)

/decl/species/serpentid
	name = SPECIES_SERPENTID
	name_plural = "Serpentids"
	spawn_flags = SPECIES_IS_RESTRICTED

	base_color =      "#336600"
	base_eye_color =  "#3f0505"
	preview_outfit = null

	blood_types = list(/decl/blood_type/hemolymph)

	has_organ = list(
		BP_BRAIN =             /obj/item/organ/internal/brain/insectoid/serpentid,
		BP_EYES =              /obj/item/organ/internal/eyes/insectoid/serpentid,
		BP_TRACH =             /obj/item/organ/internal/lungs/insectoid/serpentid,
		BP_HEART =             /obj/item/organ/internal/heart/open,
		BP_LIVER =             /obj/item/organ/internal/liver/insectoid/serpentid,
		BP_STOMACH =           /obj/item/organ/internal/stomach/insectoid,
		BP_SYSTEM_CONTROLLER = /obj/item/organ/internal/controller
	)

	has_limbs = list(
		BP_CHEST =        list("path" = /obj/item/organ/external/chest/insectoid/serpentid),
		BP_GROIN =        list("path" = /obj/item/organ/external/groin/insectoid/serpentid),
		BP_HEAD =         list("path" = /obj/item/organ/external/head/insectoid/serpentid),
		BP_L_ARM =        list("path" = /obj/item/organ/external/arm/insectoid),
		BP_L_HAND =       list("path" = /obj/item/organ/external/hand/insectoid),
		BP_L_HAND_UPPER = list("path" = /obj/item/organ/external/hand/insectoid/upper),
		BP_R_ARM =        list("path" = /obj/item/organ/external/arm/right/insectoid),
		BP_R_HAND =       list("path" = /obj/item/organ/external/hand/right/insectoid),
		BP_R_HAND_UPPER = list("path" = /obj/item/organ/external/hand/right/insectoid/upper),
		BP_R_LEG =        list("path" = /obj/item/organ/external/leg/right/insectoid),
		BP_L_LEG =        list("path" = /obj/item/organ/external/leg/insectoid),
		BP_L_FOOT =       list("path" = /obj/item/organ/external/foot/insectoid),
		BP_R_FOOT =       list("path" = /obj/item/organ/external/foot/right/insectoid)
		)

	limb_mapping = list(
		BP_L_HAND = list(BP_L_HAND, BP_L_HAND_UPPER),
		BP_R_HAND = list(BP_R_HAND, BP_R_HAND_UPPER)
	)

	hidden_from_codex = TRUE
	silent_steps = TRUE
	age_descriptor = /datum/appearance_descriptor/age/serpentid
	skin_material = /decl/material/solid/skin/insect
	bone_material = null
	speech_sounds = list('sound/voice/bug.ogg')
	speech_chance = 2
	warning_low_pressure = 50
	hazard_low_pressure = -1
	body_temperature = null
	flesh_color = "#525252"
	blood_oxy = 0

	available_bodytypes = list(
		/decl/bodytype/serpentid,
		/decl/bodytype/serpentid/green
	)

	darksight_range = 8
	slowdown = -0.5
	rarity_value = 4
	hud_type = /datum/hud_data/serpentid
	total_health = 200
	brute_mod = 0.9
	burn_mod =  1.35

	natural_armour_values = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = 0.5*ARMOR_RAD_MINOR
		)
	gluttonous = GLUT_SMALLER
	mob_size = MOB_SIZE_LARGE
	strength = STR_HIGH
	breath_pressure = 25
	blood_volume = 840
	spawns_with_stack = 0
	heat_level_1 = 410 //Default 360 - Higher is better
	heat_level_2 = 440 //Default 400
	heat_level_3 = 800 //Default 1000
	species_flags = SPECIES_FLAG_NO_SLIP | SPECIES_FLAG_NO_BLOCK | SPECIES_FLAG_NO_MINOR_CUT | SPECIES_FLAG_NEED_DIRECT_ABSORB
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_SKIN_TONE_NORMAL
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	bump_flag = HEAVY
	push_flags = ALLMOBS
	swap_flags = ALLMOBS
	breathing_organ = BP_TRACH
	move_trail = /obj/effect/decal/cleanable/blood/tracks/snake

	unarmed_attacks = list(/decl/natural_attack/serpentid)
	appearance_descriptors = list(
		/datum/appearance_descriptor/height =      1.75,
		/datum/appearance_descriptor/body_length = 1
		)
	pain_emotes_with_pain_level = list(
			list(/decl/emote/audible/bug_hiss) = 40
	)
	var/list/skin_overlays = list()

/decl/species/serpentid/can_overcome_gravity(var/mob/living/carbon/human/H)
	var/datum/gas_mixture/mixture = H.loc.return_air()

	if(mixture)
		var/pressure = mixture.return_pressure()
		if(pressure > 50)
			var/turf/below = GetBelow(H)
			var/turf/T = H.loc
			if(!T.CanZPass(H, DOWN) || !below.CanZPass(H, DOWN))
				return TRUE

	return FALSE

/decl/species/serpentid/handle_environment_special(var/mob/living/carbon/human/H)
	if(!H.on_fire && H.fire_stacks < 2)
		H.fire_stacks += 0.2
	return

/decl/species/serpentid/can_fall(var/mob/living/carbon/human/H)
	var/datum/gas_mixture/mixture = H.loc.return_air()
	var/turf/T = GetBelow(H.loc)
	for(var/obj/O in T)
		if(istype(O, /obj/structure/stairs))
			return TRUE
	if(mixture)
		var/pressure = mixture.return_pressure()
		if(pressure > 80)
			return FALSE
	return TRUE

/decl/species/serpentid/handle_fall_special(var/mob/living/carbon/human/H, var/turf/landing)

	var/datum/gas_mixture/mixture = H.loc.return_air()
	var/turf/T = GetBelow(H.loc)
	for(var/obj/O in T)
		if(istype(O, /obj/structure/stairs))
			return FALSE

	if(mixture)
		var/pressure = mixture.return_pressure()
		if(pressure > 50)
			if(istype(landing) && landing.is_open())
				H.visible_message("\The [H] descends from the deck above through \the [landing]!", "Your wings slow your descent.")
			else
				H.visible_message("\The [H] buzzes down from \the [landing], wings slowing their descent!", "You land on \the [landing], folding your wings.")

			return TRUE

	return FALSE

/decl/species/serpentid/can_shred(var/mob/living/carbon/human/H, var/ignore_intent, var/ignore_antag)
	if(!H.get_equipped_item(slot_handcuffed_str) || H.buckled)
		return ..(H, ignore_intent, TRUE)
	else
		return 0

/decl/species/serpentid/handle_movement_delay_special(var/mob/living/carbon/human/H)
	var/tally = 0

	H.remove_cloaking_source(src)

	var/obj/item/organ/internal/B = H.get_organ(BP_BRAIN)
	if(istype(B,/obj/item/organ/internal/brain/insectoid/serpentid))
		var/obj/item/organ/internal/brain/insectoid/serpentid/N = B
		tally += N.lowblood_tally * 2
	return tally

/decl/species/serpentid/update_skin(var/mob/living/carbon/human/H)

	if(H.stat)
		H.skin_state = SKIN_NORMAL

	switch(H.skin_state)
		if(SKIN_NORMAL)
			return
		if(SKIN_THREAT)

			var/image_key = "[H.bodytype.get_icon_cache_uid(H)]"

			for(var/organ_tag in H.species.has_limbs)
				var/obj/item/organ/external/part = H.get_organ(organ_tag)
				if(!part)
					image_key += "0"
					continue
				if(part)
					image_key += "[part.bodytype.get_icon_cache_uid(part.owner)]"
				if(BP_IS_PROSTHETIC(part))
					image_key += "2[part.model ? "-[part.model]": ""]"
				else if(part.status & ORGAN_DEAD)
					image_key += "3"
				else
					image_key += "1"

			var/image/threat_image = skin_overlays[image_key]
			if(!threat_image)
				var/icon/base_icon = icon(H.stand_icon)
				var/icon/I = new('mods/species/serpentid/icons/threat.dmi', "threat")
				base_icon.Blend(COLOR_BLACK, ICON_MULTIPLY)
				base_icon.Blend(I, ICON_ADD)
				threat_image  = image(base_icon)
				skin_overlays[image_key] = threat_image

			return(threat_image)


/decl/species/serpentid/disarm_attackhand(var/mob/living/carbon/human/attacker, var/mob/living/carbon/human/target)
	if(attacker.pulling_punches || target.lying || attacker == target)
		return ..(attacker, target)
	if(world.time < attacker.last_attack + 20)
		to_chat(attacker, SPAN_NOTICE("You can't attack again so soon."))
		return 0
	attacker.last_attack = world.time
	var/turf/T = get_step(get_turf(target), get_dir(get_turf(attacker), get_turf(target)))
	playsound(target.loc, 'sound/weapons/pushhiss.ogg', 50, 1, -1)
	if(!T.density)
		step(target, get_dir(get_turf(attacker), get_turf(target)))
		target.visible_message(SPAN_DANGER("[pick("[target] was sent flying backward!", "[target] staggers back from the impact!")]"))
	else
		target.turf_collision(T, target.throw_speed / 2)
	if(prob(50))
		target.set_dir(global.reverse_dir[target.dir])

/decl/species/serpentid/skills_from_age(age)	//Converts an age into a skill point allocation modifier. Can be used to give skill point bonuses/penalities not depending on job.
	switch(age)
		if(0 to 18) 	. = 8
		if(19 to 27) 	. = 2
		if(28 to 40)	. = -2
		else			. = -4

/datum/hud_data/serpentid
	gear = list(
		"i_clothing" =   list("loc" = ui_iclothing, "name" = "Uniform",      "slot" = slot_w_uniform_str, "state" = "center", "toggle" = 1),
		"o_clothing" =   list("loc" = ui_shoes,     "name" = "Suit",         "slot" = slot_wear_suit_str, "state" = "suit",   "toggle" = 1),
		"l_ear" =        list("loc" = ui_oclothing, "name" = "Ear",          "slot" = slot_l_ear_str,     "state" = "ears",   "toggle" = 1),
		"gloves" =       list("loc" = ui_gloves,    "name" = "Gloves",       "slot" = slot_gloves_str,    "state" = "gloves", "toggle" = 1),
		"head" =         list("loc" = ui_mask,      "name" = "Hat",          "slot" = slot_head_str,      "state" = "hair",   "toggle" = 1),
		"eyes" =         list("loc" = ui_glasses,   "name" = "Glasses",      "slot" = slot_glasses_str,   "state" = "glasses","toggle" = 1),
		"suit storage" = list("loc" = ui_sstore1,   "name" = "Suit Storage", "slot" = slot_s_store_str,   "state" = "suitstore"),
		"back" =         list("loc" = ui_back,      "name" = "Back",         "slot" = slot_back_str,      "state" = "back"),
		"id" =           list("loc" = ui_id,        "name" = "ID",           "slot" = slot_wear_id_str,   "state" = "id"),
		"storage1" =     list("loc" = ui_storage1,  "name" = "Left Pocket",  "slot" = slot_l_store_str,   "state" = "pocket"),
		"storage2" =     list("loc" = ui_storage2,  "name" = "Right Pocket", "slot" = slot_r_store_str,   "state" = "pocket"),
		"belt" =         list("loc" = ui_belt,      "name" = "Belt",         "slot" = slot_belt_str,      "state" = "belt")
	)
