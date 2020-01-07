/datum/map/tradeship
	allowed_jobs = list(
		/datum/job/captain,
		/datum/job/chief_engineer,
		/datum/job/doctor,
		/datum/job/rd,
		/datum/job/hop, 
		/datum/job/cyborg, 
		/datum/job/assistant, 
		/datum/job/engineer,
		/datum/job/doctor/junior,
		/datum/job/scientist
	)
	species_to_job_whitelist = list(
		/datum/species/yinglet = list(
			/datum/job/assistant,
			/datum/job/engineer,
			/datum/job/cyborg,
			/datum/job/doctor/junior,
			/datum/job/scientist
		),
		/datum/species/yinglet/southern = list(
			/datum/job/assistant,
			/datum/job/engineer,
			/datum/job/cyborg,
			/datum/job/doctor/junior,
			/datum/job/scientist
		)
	)

/datum/job/captain
	supervisors = "your profit margin, your conscience, and the Trademaster"
	outfit_type = /decl/hierarchy/outfit/job/tradeship/captain
	min_skill = list(   SKILL_WEAPONS = SKILL_ADEPT,
	                    SKILL_SCIENCE     = SKILL_ADEPT,
	                    SKILL_PILOT       = SKILL_ADEPT)
	max_skill = list(   SKILL_PILOT       = SKILL_MAX,
	                    SKILL_WEAPONS     = SKILL_MAX)
	skill_points = 30

/datum/job/captain/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(H.client)
		H.client.verbs += /client/proc/tradehouse_rename_ship
		H.client.verbs += /client/proc/tradehouse_rename_company

/client/proc/tradehouse_rename_ship()
	set name = "Rename Tradeship"
	set category = "Captain's Powers"

	var/ship = sanitize(input(src, "What is your ship called? Don't add the vessel prefix, 'Tradeship' will be attached automatically.", "Ship Name", GLOB.using_map.station_short), MAX_NAME_LEN)
	if(!ship)
		return
	GLOB.using_map.station_short = ship
	GLOB.using_map.station_name = "Tradeship [ship]"
	var/obj/effect/overmap/visitable/ship/tradeship/B = locate() in world
	if(B)
		B.SetName(GLOB.using_map.station_name)
	command_announcement.Announce("Attention all hands on [GLOB.using_map.station_name]! Thank you for your attention.", "Ship re-Christened")
	verbs -= /client/proc/tradehouse_rename_ship

/client/proc/tradehouse_rename_company()
	set name = "Rename Tradehouse"
	set category = "Captain's Powers"
	var/company = sanitize(input(src, "What should your enterprise be called?", "Company name", GLOB.using_map.company_name), MAX_NAME_LEN)
	if(!company)
		return
	var/company_s = sanitize(input(src, "What's the short name for it?", "Company name", GLOB.using_map.company_short), MAX_NAME_LEN)
	if(company != GLOB.using_map.company_name)
		if (company)
			GLOB.using_map.company_name = company
		if(company_s)
			GLOB.using_map.company_short = company_s
		command_announcement.Announce("Congratulations to all members of [capitalize(GLOB.using_map.company_name)] on the new name. Their rebranding has changed the [GLOB.using_map.company_short] market value by [0.01*rand(-10,10)]%.", "Tradehouse Name Change")
	verbs -= /client/proc/tradehouse_rename_company

/datum/job/captain/get_access()
	return get_all_station_access()

/datum/job/chief_engineer
	title = "Head Engineer"
	supervisors = "the Captain"
	department_flag = ENG
	outfit_type = /decl/hierarchy/outfit/job/tradeship/chief_engineer
	min_skill = list(   SKILL_BUREAUCRACY  = SKILL_BASIC,
	                    SKILL_COMPUTER     = SKILL_ADEPT,
	                    SKILL_EVA          = SKILL_ADEPT,
	                    SKILL_CONSTRUCTION = SKILL_ADEPT,
	                    SKILL_ELECTRICAL   = SKILL_ADEPT,
	                    SKILL_ATMOS        = SKILL_ADEPT,
	                    SKILL_ENGINES      = SKILL_EXPERT)

	max_skill = list(   SKILL_CONSTRUCTION = SKILL_MAX,
	                    SKILL_ELECTRICAL   = SKILL_MAX,
	                    SKILL_ATMOS        = SKILL_MAX,
	                    SKILL_ENGINES      = SKILL_MAX)
	skill_points = 30
	alt_titles = list()

/datum/job/doctor
	title = "Head Doctor"
	supervisors = "the Captain and your own ethics"
	outfit_type = /decl/hierarchy/outfit/job/tradeship/doc
	alt_titles = list(
		"Surgeon")
	total_positions = 1
	spawn_positions = 1
	hud_icon = "hudmedicaldoctor"
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_BASIC,
	                    SKILL_MEDICAL     = SKILL_EXPERT,
	                    SKILL_ANATOMY     = SKILL_EXPERT,
	                    SKILL_CHEMISTRY   = SKILL_BASIC)

	max_skill = list(   SKILL_MEDICAL     = SKILL_MAX,
	                    SKILL_ANATOMY     = SKILL_MAX,
	                    SKILL_CHEMISTRY   = SKILL_MAX)
	skill_points = 28

/datum/job/doctor/junior
	title = "Junior Doctor"
	supervisors = "the Head Doctor and the Captain"
	total_positions = 2
	spawn_positions = 2
	alt_titles = list()

/datum/job/hop
	title = "First Mate"
	supervisors = "the Captain"
	outfit_type = /decl/hierarchy/outfit/job/tradeship/mate
	hud_icon = "hudheadofpersonnel"
	min_skill = list(   SKILL_WEAPONS     = SKILL_BASIC,
	                    SKILL_FINANCE     = SKILL_EXPERT,
	                    SKILL_BUREAUCRACY = SKILL_ADEPT,
	                    SKILL_PILOT       = SKILL_ADEPT)

	max_skill = list(   SKILL_PILOT       = SKILL_MAX,
	                    SKILL_FINANCE     = SKILL_MAX,
	                    SKILL_BUREAUCRACY = SKILL_ADEPT)
	skill_points = 30
	alt_titles = list()

/datum/job/assistant
	title = "Deck Hand"
	supervisors = "literally everyone, you bottom feeder"
	outfit_type = /decl/hierarchy/outfit/job/tradeship/hand
	alt_titles = list(
		"Cook" = /decl/hierarchy/outfit/job/tradeship/hand/cook,
		"Cargo Hand",
		"Passenger")
	hud_icon = "hudcargotechnician"

/datum/job/engineer
	title = "Junior Engineer"
	supervisors = "the Head Engineer"
	total_positions = 2
	spawn_positions = 2
	hud_icon = "hudengineer"
	min_skill = list(   SKILL_COMPUTER     = SKILL_BASIC,
	                    SKILL_EVA          = SKILL_BASIC,
	                    SKILL_CONSTRUCTION = SKILL_ADEPT,
	                    SKILL_ELECTRICAL   = SKILL_BASIC,
	                    SKILL_ATMOS        = SKILL_BASIC,
	                    SKILL_ENGINES      = SKILL_BASIC)

	max_skill = list(   SKILL_CONSTRUCTION = SKILL_MAX,
	                    SKILL_ELECTRICAL   = SKILL_MAX,
	                    SKILL_ATMOS        = SKILL_MAX,
	                    SKILL_ENGINES      = SKILL_MAX)
	skill_points = 20
	alt_titles = list()

/datum/job/cyborg
	supervisors = "your laws and the Captain"
	outfit_type = /decl/hierarchy/outfit/job/tradeship/hand/engine
	total_positions = 1
	spawn_positions = 1
	alt_titles = list()

/datum/job/rd
	title = "Head Researcher"
	supervisors = "the Captain"
	spawn_positions = 1
	total_positions = 1
	alt_titles = list()
	outfit_type = /decl/hierarchy/outfit/job/tradeship/hand/researcher

/datum/job/scientist
	title = "Junior Researcher"
	supervisors = "the Head Researcher and the Captain"
	spawn_positions = 1
	total_positions = 2
	alt_titles = list()
	outfit_type = /decl/hierarchy/outfit/job/tradeship/hand/researcher/junior

//TODO
/*


/datum/job/yinglet
	title = "Enclave Scav"
	spawn_positions = 2
	total_positions = 4
	hud_icon = "hudying"
	supervisors = "the Matriarch and the Patriarches"
	var/requires_species = SPECIES_YINGLET
	var/requires_gender = MALE

/datum/job/yinglet/some_check
	check requires_species
	check requires_gender

/datum/job/yinglet/patriarch
	title = "Enclave Patriarch"
	hud_icon = "hudyingpatriarch"
	spawn_positions = 1
	total_positions = 2
	supervisors = "the Matriarch"

/datum/job/yinglet/lady
	title = "Enclave Lady"
	hud_icon = "hudyinglady"
	spawn_positions = 1
	total_positions = 3
	requires_gender = FEMALE

/datum/job/yinglet/lady/matriarch
	title = "Enclave Matriarch"
	hud_icon = "hudyingmatriarch"
	spawn_positions = 1
	total_positions = 1
*/


// OUTFITS
#define TRADESHIP_OUTFIT_JOB_NAME(job_name) ("Tradeship - Job - " + job_name)

/decl/hierarchy/outfit/job/tradeship
	hierarchy_type = /decl/hierarchy/outfit/job/tradeship
	pda_type = /obj/item/modular_computer/pda
	pda_slot = slot_l_store
	suit = /obj/item/clothing/suit/storage/toggle/redcoat
	l_ear = null
	r_ear = null
	var/yinglet_suit_fallback = /obj/item/clothing/suit/storage/toggle/redcoat/yinglet

/decl/hierarchy/outfit/job/tradeship/equip(mob/living/carbon/human/H, rank, assignment, equip_adjustments)
	. = ..()
	if(. && yinglet_suit_fallback && istype(H) && !H.wear_suit && H.species.get_bodytype(H) == SPECIES_YINGLET)
		H.equip_to_slot_or_del(new yinglet_suit_fallback(H), slot_wear_suit)

/decl/hierarchy/outfit/job/tradeship/captain
	name = TRADESHIP_OUTFIT_JOB_NAME("Captain")
	uniform = /obj/item/clothing/under/casual_pants/classicjeans
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/modular_computer/pda/captain
	r_pocket = /obj/item/device/radio
	id_type = /obj/item/weapon/card/id/gold
	suit = /obj/item/clothing/suit/storage/toggle/redcoat/officer

/decl/hierarchy/outfit/job/tradeship/captain/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/toggleable/hawaii/random/eyegore = new()
		if(uniform.can_attach_accessory(eyegore))
			uniform.attach_accessory(null, eyegore)
		else
			qdel(eyegore)

/decl/hierarchy/outfit/job/tradeship/chief_engineer
	name = TRADESHIP_OUTFIT_JOB_NAME("Head Engineer")
	uniform = /obj/item/clothing/under/rank/chief_engineer
	glasses = /obj/item/clothing/glasses/welding/superior
	suit = /obj/item/clothing/suit/storage/hazardvest
	gloves = /obj/item/clothing/gloves/thick
	shoes = /obj/item/clothing/shoes/workboots
	pda_type = /obj/item/modular_computer/pda/heads/ce
	l_hand = /obj/item/weapon/wrench
	belt = /obj/item/weapon/storage/belt/utility/full
	id_type = /obj/item/weapon/card/id/engineering/head
	r_pocket = /obj/item/device/radio
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL
	suit = /obj/item/clothing/suit/storage/toggle/redcoat/service/officiated

/decl/hierarchy/outfit/job/tradeship/doc
	name = TRADESHIP_OUTFIT_JOB_NAME("Head Doctor")
	uniform = /obj/item/clothing/under/det/black
	shoes = /obj/item/clothing/shoes/laceup
	pda_type = /obj/item/modular_computer/pda/medical
	suit = /obj/item/clothing/suit/storage/toggle/redcoat/service/officiated

/decl/hierarchy/outfit/job/tradeship/doc/junior
	name = TRADESHIP_OUTFIT_JOB_NAME("Junior Doctor")
	suit = /obj/item/clothing/suit/storage/toggle/redcoat/service

/decl/hierarchy/outfit/job/tradeship/mate
	name = TRADESHIP_OUTFIT_JOB_NAME("First Mate")
	uniform = /obj/item/clothing/under/suit_jacket/checkered
	shoes = /obj/item/clothing/shoes/laceup
	glasses = /obj/item/clothing/glasses/sunglasses/big
	pda_type = /obj/item/modular_computer/pda/cargo
	l_hand = /obj/item/weapon/material/clipboard
	suit = /obj/item/clothing/suit/storage/toggle/redcoat/officiated

/decl/hierarchy/outfit/job/tradeship/hand
	name = TRADESHIP_OUTFIT_JOB_NAME("Deck Hand")

/decl/hierarchy/outfit/job/tradeship/hand/pre_equip(mob/living/carbon/human/H)
	..()
	uniform = pick(list(/obj/item/clothing/under/overalls,/obj/item/clothing/under/focal,/obj/item/clothing/under/hazard,/obj/item/clothing/under/rank/cargotech,/obj/item/clothing/under/color/black,/obj/item/clothing/under/color/grey,/obj/item/clothing/under/casual_pants/track, ))

/decl/hierarchy/outfit/job/tradeship/hand/cook
	name = TRADESHIP_OUTFIT_JOB_NAME("Cook")
	head = /obj/item/clothing/head/chefhat
	suit = /obj/item/clothing/suit/storage/toggle/redcoat/service

/decl/hierarchy/outfit/job/tradeship/hand/engine
	name = TRADESHIP_OUTFIT_JOB_NAME("Junior Engineer")
	head = /obj/item/clothing/head/hardhat
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL
	suit = /obj/item/clothing/suit/storage/toggle/redcoat/service

/decl/hierarchy/outfit/job/tradeship/hand/researcher
	name = TRADESHIP_OUTFIT_JOB_NAME("Head Researcher")
	suit = /obj/item/clothing/suit/storage/toggle/redcoat/service/officiated
	shoes = /obj/item/clothing/shoes/laceup
	pda_type = /obj/item/modular_computer/pda/science

/decl/hierarchy/outfit/job/tradeship/hand/researcher/junior
	name = TRADESHIP_OUTFIT_JOB_NAME("Junior Researcher")
	suit = /obj/item/clothing/suit/storage/toggle/redcoat/service
