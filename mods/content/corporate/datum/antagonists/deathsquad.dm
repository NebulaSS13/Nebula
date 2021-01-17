/decl/special_role/deathsquad
	name = "Death Commando"
	name_plural = "Death Commandos"
	welcome_text = "You work in the service of corporate Asset Protection, answering directly to the Board of Directors."
	landmark_id = "Commando"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_HAS_NUKE | ANTAG_HAS_LEADER | ANTAG_RANDOM_EXCEPTED
	default_access = list(access_cent_general, access_cent_specops, access_cent_living, access_cent_storage)
	antaghud_indicator = "huddeathsquad"

	hard_cap = 4
	hard_cap_round = 8
	initial_spawn_req = 4
	initial_spawn_target = 6

	faction = "deathsquad"
	default_outfit = /decl/hierarchy/outfit/commando
	id_title = "Asset Protection"
	var/deployed = 0

/decl/special_role/deathsquad/attempt_spawn()
	if(..())
		deployed = 1

/decl/hierarchy/outfit/commando
	name =     "Special Role - Deathsquad Commando"
	uniform =  /obj/item/clothing/under/color/green
	l_pocket = /obj/item/plastique
	shoes =    /obj/item/clothing/shoes/jackboots/swat
	glasses =  /obj/item/clothing/glasses/thermal
	mask =     /obj/item/clothing/mask/gas/swat
	belt =     /obj/item/gun/projectile/revolver
	hands = list(
		/obj/item/gun/energy/laser,
		/obj/item/energy_blade/sword
	)

/decl/hierarchy/outfit/commando/leader
	name =    "Special Role - Deathsquad Leader"
	uniform =  /obj/item/clothing/under/centcom_officer
	l_pocket = /obj/item/pinpointer
	r_pocket = /obj/item/disk/nuclear

/decl/special_role/deathsquad/equip(var/mob/living/carbon/human/player)
	if (player.mind == leader)
		default_outfit = /decl/hierarchy/outfit/commando/leader
	else
		default_outfit = initial(default_outfit)
	. = ..()
	if(.)
		player.implant_loyalty(player)
		create_radio(DTH_FREQ, player)

/decl/special_role/deathsquad/create_id(mob/living/carbon/human/player, equip)
	var/obj/item/card/id/id = ..()
	if(player && id)
		id.access |= get_all_station_access()
		id.icon_state = "centcom"

/decl/special_role/deathsquad/update_antag_mob(var/datum/mind/player)

	..()

	var/syndicate_commando_rank
	if(leader && player == leader)
		syndicate_commando_rank = pick("Corporal", "Sergeant", "Staff Sergeant", "Sergeant 1st Class", "Master Sergeant", "Sergeant Major")
	else
		syndicate_commando_rank = pick("Lieutenant", "Captain", "Major")

	var/syndicate_commando_name = pick(GLOB.last_names)

	var/datum/preferences/A = new() //Randomize appearance for the commando.
	A.randomize_appearance_and_body_for(player.current)

	player.name = "[syndicate_commando_rank] [syndicate_commando_name]"
	player.current.real_name = player.name
	player.current.SetName(player.current.name)

	var/mob/living/carbon/human/H = player.current
	if(istype(H))
		H.gender = pick(MALE, FEMALE)
		H.age = rand(25,45)
		H.dna.ready_dna(H)

	return

/decl/special_role/deathsquad/create_antagonist()
	if(..() && !deployed)
		deployed = 1
