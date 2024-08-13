// Submap datum and archetype.
/decl/submap_archetype/liberia
	descriptor = "merchant ship"
	crew_jobs = list(
		/datum/job/submap/merchant
	)

/datum/job/submap/merchant
	title = "Merchant"
	total_positions = 4
	info = "You are free traders who have drifted into unknown distances in search of profit. Travel, trade, make profit!"
	supervisors = "the invisible hand of the market"
	selection_color = "#515151"

	ideal_character_age = 20
	minimal_player_age = 7

	outfit_type = /decl/outfit/job/merchant

	skill_points = 24
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_FINANCE  = SKILL_ADEPT,
		SKILL_PILOT	   = SKILL_BASIC
	)

/datum/job/submap/merchant/equip_job(var/mob/living/human/H, var/alt_title, var/datum/mil_branch/branch, var/datum/mil_rank/grade)
	to_chat(H, "Your connections helped you learn about the words that will help you identify a locals... Particularly interested buyers:")
	to_chat(H, "<b>Code phases</b>: <span class='danger'>[syndicate_code_phrase]</span>")
	to_chat(H, "<b>Responses to phrases</b>: <span class='danger'>[syndicate_code_response]</span>")
	H.StoreMemory("<b>Code phase</b>: [syndicate_code_phrase]", /decl/memory_options/system)
	H.StoreMemory("<b>Responses to phrases</b>: [syndicate_code_response]", /decl/memory_options/system)
	return ..()

// Spawn points.
/obj/abstract/submap_landmark/spawnpoint/liberia
	name = "Merchant"

/decl/outfit/job/merchant
	name = "Job - Merchant - Liberia"
	shoes = /obj/item/clothing/shoes/color/black
	l_ear = /obj/item/radio/headset
	uniform = /obj/item/clothing/pants/casual/camo/outfit_tacticool
	id_slot = slot_wear_id_str
	id_type = /obj/item/card/id/merchant
	pda_slot = slot_r_store_str
	pda_type = /obj/item/modular_computer/pda //cause I like the look
	id_pda_assignment = "Merchant"

/obj/item/card/id/merchant
	name = "identification card"
	desc = "A card issued to Merchants, indicating their right to sell and buy goods."
	access = list(access_merchant)
	color = COLOR_OFF_WHITE
	detail_color = COLOR_BEIGE
