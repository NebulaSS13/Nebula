/datum/species/mantid

	name =                   SPECIES_MANTID_ALATE
	name_plural =            "Kharmaan Alates"
	show_ssd =               "quiescent"

	description = "When human surveyors finally arrived at the outer reaches of explored space, they hoped to find \
	new frontiers and new planets to exploit. They were largely not expecting to have entire expeditions lost \
	amid reports of highly advanced, astonishingly violent mantid-cephlapodean sentients with particle cannons."

	icobase =                 'mods/ascent/icons/species/body/alate/body.dmi'
	deform =                  'mods/ascent/icons/species/body/alate/body.dmi'
	damage_overlays =         'mods/ascent/icons/species/body/alate/damage_mask.dmi'
	blood_mask =              'mods/ascent/icons/species/body/alate/blood_mask.dmi'
	organs_icon =             'mods/ascent/icons/species/body/organs.dmi'
	bodytype = BODYTYPE_MANTID_SMALL

	blood_color =             "#660066"
	flesh_color =             "#009999"
	hud_type =                /datum/hud_data/mantid
	move_trail =              /obj/effect/decal/cleanable/blood/tracks/snake

	speech_chance = 100
	speech_sounds = list(
		'mods/ascent/sounds/ascent1.ogg',
		'mods/ascent/sounds/ascent2.ogg',
		'mods/ascent/sounds/ascent3.ogg',
		'mods/ascent/sounds/ascent4.ogg',
		'mods/ascent/sounds/ascent5.ogg',
		'mods/ascent/sounds/ascent6.ogg'
	)

	siemens_coefficient =   0.2 // Crystalline body.
	oxy_mod =               0.8 // Don't need as much breathable gas as humans.
	toxins_mod =            0.8 // Not as biologically fragile as meatboys.
	radiation_mod =         0.5 // Not as biologically fragile as meatboys.
	flash_mod =               2 // Highly photosensitive.

	min_age =                 1
	max_age =                20
	slowdown =               -1
	rarity_value =            3
	gluttonous =              2
	siemens_coefficient =     0
	body_temperature =        null

	breath_type =             MAT_METHYL_BROMIDE
	exhale_type =             MAT_METHANE
	poison_types =            list(MAT_PHORON)

	reagent_tag =             IS_MANTID
	genders =                 list(MALE)

	appearance_flags =        0
	species_flags =           SPECIES_FLAG_NO_SCAN  | SPECIES_FLAG_NO_SLIP        | SPECIES_FLAG_NO_MINOR_CUT
	spawn_flags =             SPECIES_IS_RESTRICTED

	heat_discomfort_strings = list(
		"You feel brittle and overheated.",
		"Your overheated carapace flexes uneasily.",
		"Overheated ichor trickles from your eyes."
		)
	cold_discomfort_strings = list(
		"Frost forms along your carapace.",
		"You hear a faint crackle of ice as you shift your freezing body.",
		"Your movements become sluggish under the weight of the chilly conditions."
		)
	unarmed_attacks = list(
		/decl/natural_attack/claws/strong/gloves,
		/decl/natural_attack/bite/sharp
	)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/insectoid),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/insectoid/mantid),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/insectoid),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/insectoid),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/insectoid),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/insectoid),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/insectoid),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/insectoid),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/insectoid),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/insectoid),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/insectoid)
	)

	has_organ = list(
		BP_HEART =             /obj/item/organ/internal/heart/insectoid,
		BP_STOMACH =           /obj/item/organ/internal/stomach/insectoid,
		BP_LUNGS =             /obj/item/organ/internal/lungs/insectoid,
		BP_LIVER =             /obj/item/organ/internal/liver/insectoid,
		BP_KIDNEYS =           /obj/item/organ/internal/kidneys/insectoid,
		BP_BRAIN =             /obj/item/organ/internal/brain/insectoid,
		BP_EYES =              /obj/item/organ/internal/eyes/insectoid,
		BP_SYSTEM_CONTROLLER = /obj/item/organ/internal/controller
	)

	force_cultural_info = list(
		TAG_CULTURE =   CULTURE_ASCENT,
		TAG_HOMEWORLD = HOME_SYSTEM_KHARMAANI,
		TAG_FACTION =   FACTION_ASCENT_ALATE,
		TAG_RELIGION =  RELIGION_KHARMAANI
	)

	descriptors = list(
		/datum/mob_descriptor/height = -1,
		/datum/mob_descriptor/body_length = -2
		)

	pain_emotes_with_pain_level = list(
			list(/decl/emote/visible/ascent_shine, /decl/emote/visible/ascent_dazzle) = 80,
			list(/decl/emote/visible/ascent_glimmer, /decl/emote/visible/ascent_pulse) = 50,
			list(/decl/emote/visible/ascent_flicker, /decl/emote/visible/ascent_glint) = 20,
		)

/datum/species/mantid/handle_sleeping(var/mob/living/carbon/human/H)
	return

/datum/species/mantid/get_blood_name()
	return "hemolymph"

/datum/species/mantid/post_organ_rejuvenate(var/obj/item/organ/org, var/mob/living/carbon/human/H)
	org.status |= ORGAN_CRYSTAL

/datum/species/mantid/equip_survival_gear(var/mob/living/carbon/human/H, var/extendedtank = 1)
	return

/datum/species/mantid/gyne

	name =                    SPECIES_MANTID_GYNE
	name_plural =             "Kharmaan Gynes"

	genders =                 list(FEMALE)
	icobase =                 'mods/ascent/icons/species/body/gyne/body.dmi'
	deform =                  'mods/ascent/icons/species/body/gyne/body.dmi'
	icon_template =           'mods/ascent/icons/species/body/gyne/template.dmi'
	damage_overlays =         'mods/ascent/icons/species/body/gyne/damage_mask.dmi'
	blood_mask =              'mods/ascent/icons/species/body/gyne/blood_mask.dmi'
	bodytype = BODYTYPE_MANTID_LARGE

	gluttonous =              3
	slowdown =                2
	rarity_value =           10
	min_age =                 5
	max_age =               500
	blood_volume =         1200
	spawns_with_stack =       0

	pixel_offset_x =        -4
	antaghud_offset_y =      18
	antaghud_offset_x =      4

	bump_flag =               HEAVY
	push_flags =              ALLMOBS
	swap_flags =              ALLMOBS

	override_limb_types = list(
		BP_HEAD = /obj/item/organ/external/head/insectoid/mantid,
		BP_GROIN = /obj/item/organ/external/groin/insectoid/mantid/gyne
	)

	descriptors = list(
		/datum/mob_descriptor/height = 5,
		/datum/mob_descriptor/body_length = 2
	)

	force_cultural_info = list(
		TAG_CULTURE =   CULTURE_ASCENT,
		TAG_HOMEWORLD = HOME_SYSTEM_KHARMAANI,
		TAG_FACTION =   FACTION_ASCENT_GYNE,
		TAG_RELIGION =  RELIGION_KHARMAANI
	)

/datum/species/mantid/gyne/New()
	equip_adjust = list(
		slot_l_hand_str = list(
			"[NORTH]" = list("x" = -4, "y" = 12),
			"[EAST]" = list("x" =  -4, "y" = 12),
			"[SOUTH]" = list("x" = -4, "y" = 12),
			"[WEST]" = list("x" =  -4, "y" = 12)
		)
	)
	..()

/datum/hud_data/mantid
	gear = list(
		"i_clothing" =   list("loc" = ui_iclothing, "name" = "Uniform",      "slot" = slot_w_uniform, "state" = "center", "toggle" = 1),
		"o_clothing" =   list("loc" = ui_oclothing, "name" = "Suit",         "slot" = slot_wear_suit, "state" = "suit",   "toggle" = 1),
		"mask" =         list("loc" = ui_mask,      "name" = "Mask",         "slot" = slot_wear_mask, "state" = "mask",   "toggle" = 1),
		"gloves" =       list("loc" = ui_gloves,    "name" = "Gloves",       "slot" = slot_gloves,    "state" = "gloves", "toggle" = 1),
		"eyes" =         list("loc" = ui_glasses,   "name" = "Glasses",      "slot" = slot_glasses,   "state" = "glasses","toggle" = 1),
		"l_ear" =        list("loc" = ui_l_ear,     "name" = "Left Ear",     "slot" = slot_l_ear,     "state" = "ears",   "toggle" = 1),
		"r_ear" =        list("loc" = ui_r_ear,     "name" = "Right Ear",    "slot" = slot_r_ear,     "state" = "ears",   "toggle" = 1),
		"head" =         list("loc" = ui_head,      "name" = "Hat",          "slot" = slot_head,      "state" = "hair",   "toggle" = 1),
		"shoes" =        list("loc" = ui_shoes,     "name" = "Shoes",        "slot" = slot_shoes,     "state" = "shoes",  "toggle" = 1),
		"suit storage" = list("loc" = ui_sstore1,   "name" = "Suit Storage", "slot" = slot_s_store,   "state" = "suitstore"),
		"back" =         list("loc" = ui_back,      "name" = "Back",         "slot" = slot_back,      "state" = "back"),
		"id" =           list("loc" = ui_id,        "name" = "ID",           "slot" = slot_wear_id,   "state" = "id"),
		"storage1" =     list("loc" = ui_storage1,  "name" = "Left Pocket",  "slot" = slot_l_store,   "state" = "pocket"),
		"storage2" =     list("loc" = ui_storage2,  "name" = "Right Pocket", "slot" = slot_r_store,   "state" = "pocket"),
		"belt" =         list("loc" = ui_belt,      "name" = "Belt",         "slot" = slot_belt,      "state" = "belt")
		)

/datum/species/serpentid
	name = SPECIES_SERPENTID
	name_plural = "Serpentids"
	spawn_flags = SPECIES_IS_RESTRICTED
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
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/insectoid/serpentid),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/insectoid/serpentid),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/insectoid/serpentid),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/insectoid),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/insectoid),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/insectoid),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/insectoid),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/insectoid),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/insectoid),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/insectoid),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/insectoid)
		)
	force_cultural_info = list(
		TAG_CULTURE =   CULTURE_ASCENT,
		TAG_HOMEWORLD = HOME_SYSTEM_KHARMAANI,
		TAG_FACTION =   FACTION_ASCENT_SERPENTID,
		TAG_RELIGION =  RELIGION_KHARMAANI
	)
	hidden_from_codex = TRUE
	silent_steps = TRUE
	antaghud_offset_y = 8
	min_age = 8
	max_age = 40
	skin_material = MAT_SKIN_CHITIN
	bone_material = null
	speech_sounds = list('sound/voice/bug.ogg')
	speech_chance = 2
	warning_low_pressure = 50
	hazard_low_pressure = -1
	body_temperature = null
	blood_color = "#525252"
	flesh_color = "#525252"
	blood_oxy = 0
	reagent_tag = IS_SERPENTID
	icon_template = 'icons/mob/human_races/species/template_tall.dmi'
	icobase = 'mods/ascent/icons/species/body/serpentid/body.dmi'
	deform = 'mods/ascent/icons/species/body/serpentid/body.dmi'
	preview_icon = 'mods/ascent/icons/species/body/serpentid/preview.dmi'
	blood_mask = 'mods/ascent/icons/species/body/serpentid/blood_mask.dmi'
	limb_blend = ICON_MULTIPLY
	darksight_range = 8
	darksight_tint = DARKTINT_GOOD
	slowdown = -0.5
	rarity_value = 4
	hud_type = /datum/hud_data/serpentid
	total_health = 200
	brute_mod = 0.9
	burn_mod =  1.35
	bodytype = BODYTYPE_SNAKE
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
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_SKIN_TONE_NORMAL | HAS_BASE_SKIN_COLOURS
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	bump_flag = HEAVY
	push_flags = ALLMOBS
	swap_flags = ALLMOBS
	breathing_organ = BP_TRACH
	move_trail = /obj/effect/decal/cleanable/blood/tracks/snake
	base_skin_colours = list(
		"Grey"   = "",
		"Green"  = "_green"
	)
	unarmed_attacks = list(/decl/natural_attack/serpentid)
	descriptors = list(
		/datum/mob_descriptor/height = 3,
		/datum/mob_descriptor/body_length = 0
		)
	pain_emotes_with_pain_level = list(
			list(/decl/emote/audible/bug_hiss) = 40
	)

/datum/species/serpentid/New()
	equip_adjust = list(
		slot_head_str =    list("[NORTH]" = list("x" = 0, "y" = 7),  "[EAST]" = list("x" = 0, "y" = 8),  "[SOUTH]" = list("x" = 0, "y" = 8),  "[WEST]" = list("x" = 0, "y" = 8)),
		slot_back_str =    list("[NORTH]" = list("x" = 0, "y" = 7),  "[EAST]" = list("x" = 0, "y" = 8),  "[SOUTH]" = list("x" = 0, "y" = 8),  "[WEST]" = list("x" = 0, "y" = 8)),
		slot_belt_str =    list("[NORTH]" = list("x" = 0, "y" = 0),  "[EAST]" = list("x" = 8, "y" = 0),  "[SOUTH]" = list("x" = 0, "y" = 0),  "[WEST]" = list("x" = -8, "y" = 0)),
		slot_glasses_str = list("[NORTH]" = list("x" = 0, "y" = 10), "[EAST]" = list("x" = 0, "y" = 11), "[SOUTH]" = list("x" = 0, "y" = 11), "[WEST]" = list("x" = 0, "y" = 11))
	)
	..()

/datum/species/serpentid/get_blood_name()
	return "haemolymph"

/datum/species/serpentid/can_overcome_gravity(var/mob/living/carbon/human/H)
	var/datum/gas_mixture/mixture = H.loc.return_air()

	if(mixture)
		var/pressure = mixture.return_pressure()
		if(pressure > 50)
			var/turf/below = GetBelow(H)
			var/turf/T = H.loc
			if(!T.CanZPass(H, DOWN) || !below.CanZPass(H, DOWN))
				return TRUE

	return FALSE

/datum/species/serpentid/handle_environment_special(var/mob/living/carbon/human/H)
	if(!H.on_fire && H.fire_stacks < 2)
		H.fire_stacks += 0.2
	return

/datum/species/serpentid/can_fall(var/mob/living/carbon/human/H)
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

/datum/species/serpentid/handle_fall_special(var/mob/living/carbon/human/H, var/turf/landing)

	var/datum/gas_mixture/mixture = H.loc.return_air()
	var/turf/T = GetBelow(H.loc)
	for(var/obj/O in T)
		if(istype(O, /obj/structure/stairs))
			return FALSE

	if(mixture)
		var/pressure = mixture.return_pressure()
		if(pressure > 50)
			if(istype(landing, /turf/simulated/open))
				H.visible_message("\The [H] descends from the deck above through \the [landing]!", "Your wings slow your descent.")
			else
				H.visible_message("\The [H] buzzes down from \the [landing], wings slowing their descent!", "You land on \the [landing], folding your wings.")

			return TRUE

	return FALSE


/datum/species/serpentid/can_shred(var/mob/living/carbon/human/H, var/ignore_intent, var/ignore_antag)
	if(!H.handcuffed || H.buckled)
		return ..(H, ignore_intent, TRUE)
	else
		return 0

/datum/species/serpentid/handle_movement_delay_special(var/mob/living/carbon/human/H)
	var/tally = 0

	H.remove_cloaking_source(src)

	var/obj/item/organ/internal/B = H.internal_organs_by_name[BP_BRAIN]
	if(istype(B,/obj/item/organ/internal/brain/insectoid/serpentid))
		var/obj/item/organ/internal/brain/insectoid/serpentid/N = B
		tally += N.lowblood_tally * 2
	return tally

/datum/species/serpentid/update_skin(var/mob/living/carbon/human/H)

	if(H.stat)
		H.skin_state = SKIN_NORMAL

	switch(H.skin_state)
		if(SKIN_NORMAL)
			return
		if(SKIN_THREAT)

			var/image_key = "[H.species.get_icon_cache_uid(H)]"

			for(var/organ_tag in H.species.has_limbs)
				var/obj/item/organ/external/part = H.organs_by_name[organ_tag]
				if(isnull(part) || part.is_stump())
					image_key += "0"
					continue
				if(part)
					image_key += "[part.species.get_icon_cache_uid(part.owner)]"
					image_key += "[part.dna.GetUIState(DNA_UI_GENDER)]"
				if(BP_IS_PROSTHETIC(part))
					image_key += "2[part.model ? "-[part.model]": ""]"
				else if(part.status & ORGAN_DEAD)
					image_key += "3"
				else
					image_key += "1"

			var/image/threat_image = skin_overlays[image_key]
			if(!threat_image)
				var/icon/base_icon = icon(H.stand_icon)
				var/icon/I = new('mods/ascent/icons/species/body/serpentid/threat.dmi', "threat")
				base_icon.Blend(COLOR_BLACK, ICON_MULTIPLY)
				base_icon.Blend(I, ICON_ADD)
				threat_image  = image(base_icon)
				skin_overlays[image_key] = threat_image

			return(threat_image)
	return

/datum/species/serpentid/disarm_attackhand(var/mob/living/carbon/human/attacker, var/mob/living/carbon/human/target)
	if(attacker.pulling_punches || target.lying || attacker == target)
		return ..(attacker, target)
	if(world.time < attacker.last_attack + 20)
		to_chat(attacker, "<span class='notice'>You can't attack again so soon.</span>")
		return 0
	attacker.last_attack = world.time
	var/turf/T = get_step(get_turf(target), get_dir(get_turf(attacker), get_turf(target)))
	playsound(target.loc, 'sound/weapons/pushhiss.ogg', 50, 1, -1)
	if(!T.density)
		step(target, get_dir(get_turf(attacker), get_turf(target)))
		target.visible_message("<span class='danger'>[pick("[target] was sent flying backward!", "[target] staggers back from the impact!")]</span>")
	else
		target.turf_collision(T, target.throw_speed / 2)
	if(prob(50))
		target.set_dir(GLOB.reverse_dir[target.dir])

/datum/species/serpentid/get_additional_examine_text(var/mob/living/carbon/human/H)
	var/datum/gender/T = gender_datums[H.get_gender()]
	if(H.pulling_punches)
		return "\n[T.His] manipulation arms are out and [T.he] looks ready to use complex items."
	else
		return "\n<span class='warning'>[T.His] upper arms are raised and [T.he] looks ready to attack!</span>"

/datum/species/serpentid/handle_post_spawn(var/mob/living/carbon/human/H)
	..()
	H.pulling_punches = TRUE

/datum/species/serpentid/get_manual_dexterity(var/mob/living/carbon/human/H)
	. = (H && H.pulling_punches) ? ..() : DEXTERITY_SIMPLE_MACHINES

/datum/species/serpentid/toggle_stance(var/mob/living/carbon/human/H)
	if(H.incapacitated())
		return FALSE
	var/datum/gender/T = gender_datums[H.get_gender()]
	to_chat(H, "<span class='notice'>You begin to adjust the fluids in your arms, dropping everything and getting ready to swap which set you're using.</span>")
	var/hidden = H.is_cloaked()
	if(!hidden) H.visible_message("<span class='warning'>\The [H] shifts [T.his] arms.</span>")
	H.unEquip(H.l_hand)
	H.unEquip(H.r_hand)
	if(do_after(H, 30))
		arm_swap(H)
	else
		to_chat(H, "<span class='notice'>You stop adjusting your arms and don't switch between them.</span>")
	return TRUE

/datum/species/serpentid/proc/arm_swap(var/mob/living/carbon/human/H, var/forced)
	H.unEquip(H.l_hand)
	H.unEquip(H.r_hand)
	var/hidden = H.is_cloaked()
	var/datum/gender/T = gender_datums[H.get_gender()]
	H.pulling_punches = !H.pulling_punches
	if(H.pulling_punches)
		if(forced)
			to_chat(H, "<span class='notice'>You can't keep your hunting arms prepared and they drop, forcing you to use your manipulation arms.</span>")
			if(!hidden)
				H.visible_message("<span class='notice'>[H] falters, [T.his] hunting arms failing.</span>")
		else
			to_chat(H, "<span class='notice'>You relax your hunting arms, lowering the pressure and folding them tight to your thorax. \
			You reach out with your manipulation arms, ready to use complex items.</span>")
			if(!hidden)
				H.visible_message("<span class='notice'>[H] seems to relax as [T.he] folds [T.his] massive curved arms to [T.his] thorax and reaches out \
				with [T.his] small handlike limbs.</span>")
	else
		to_chat(H, "<span class='notice'>You pull in your manipulation arms, dropping any items and unfolding your massive hunting arms in preparation of grabbing prey.</span>")
		if(!hidden)
			H.visible_message("<span class='warning'>[H] tenses as [T.he] brings [T.his] smaller arms in close to [T.his] body. [T.His] two massive spiked arms reach \
			out. [T.He] looks ready to attack.</span>")

/datum/species/serpentid/skills_from_age(age)	//Converts an age into a skill point allocation modifier. Can be used to give skill point bonuses/penalities not depending on job.
	switch(age)
		if(0 to 18) 	. = 8
		if(19 to 27) 	. = 2
		if(28 to 40)	. = -2
		else			. = -4

/datum/hud_data/serpentid
	gear = list(
		"i_clothing" =   list("loc" = ui_iclothing, "name" = "Uniform",      "slot" = slot_w_uniform, "state" = "center", "toggle" = 1),
		"o_clothing" =   list("loc" = ui_shoes,     "name" = "Suit",         "slot" = slot_wear_suit, "state" = "suit",   "toggle" = 1),
		"l_ear" =        list("loc" = ui_oclothing, "name" = "Ear",          "slot" = slot_l_ear,     "state" = "ears",   "toggle" = 1),
		"gloves" =       list("loc" = ui_gloves,    "name" = "Gloves",       "slot" = slot_gloves,    "state" = "gloves", "toggle" = 1),
		"head" =         list("loc" = ui_mask,      "name" = "Hat",          "slot" = slot_head,      "state" = "hair",   "toggle" = 1),
		"eyes" =         list("loc" = ui_glasses,   "name" = "Glasses",      "slot" = slot_glasses,   "state" = "glasses","toggle" = 1),
		"suit storage" = list("loc" = ui_sstore1,   "name" = "Suit Storage", "slot" = slot_s_store,   "state" = "suitstore"),
		"back" =         list("loc" = ui_back,      "name" = "Back",         "slot" = slot_back,      "state" = "back"),
		"id" =           list("loc" = ui_id,        "name" = "ID",           "slot" = slot_wear_id,   "state" = "id"),
		"storage1" =     list("loc" = ui_storage1,  "name" = "Left Pocket",  "slot" = slot_l_store,   "state" = "pocket"),
		"storage2" =     list("loc" = ui_storage2,  "name" = "Right Pocket", "slot" = slot_r_store,   "state" = "pocket"),
		"belt" =         list("loc" = ui_belt,      "name" = "Belt",         "slot" = slot_belt,      "state" = "belt")
		)