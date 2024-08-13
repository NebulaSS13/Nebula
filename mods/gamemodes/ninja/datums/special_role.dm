/decl/special_role/ninja
	name = "Ninja"
	name_plural = "Ninja"
	landmark_id = "ninjastart"
	welcome_text = "<span class='info'>You are an elite mercenary assassin of the Spider Clan. You have a variety of abilities at your disposal, thanks to your nano-enhanced cyber armor.</span>"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_RANDSPAWN | ANTAG_VOTABLE | ANTAG_SET_APPEARANCE
	antaghud_indicator = "hudninja"
	initial_spawn_req = 1
	initial_spawn_target = 1
	hard_cap = 1
	hard_cap_round = 3
	min_player_age = 18
	default_access = list(access_ninja)
	faction = "ninja"
	base_to_load = "Ninja Base"
	default_outfit = /decl/outfit/ninja
	id_title = "Infiltrator"
	rig_type = /obj/item/rig/light/ninja
	var/list/ninja_titles
	var/list/ninja_names

/decl/special_role/ninja/Initialize()
	ninja_titles = file2list("config/names/ninjatitle.txt")
	ninja_names = file2list("config/names/ninjaname.txt")
	return ..()

/decl/special_role/ninja/attempt_random_spawn()
	if(get_config_value(/decl/config/toggle/ninjas_allowed))
		..()

/decl/special_role/ninja/create_objectives(var/datum/mind/ninja)

	if(!..())
		return

	var/objective_list = list(1,2,3,4,5)
	for(var/i=rand(2,4),i>0,i--)
		switch(pick(objective_list))
			if(1)//Kill
				var/datum/objective/assassinate/ninja_objective = new
				ninja_objective.owner = ninja
				ninja_objective.target = ninja_objective.find_target()
				if(ninja_objective.target != "Free Objective")
					ninja.objectives += ninja_objective
				else
					i++
				objective_list -= 1 // No more than one kill objective
			if(2)//Steal
				var/datum/objective/steal/ninja_objective = new
				ninja_objective.owner = ninja
				ninja_objective.target = ninja_objective.find_target()
				ninja.objectives += ninja_objective
			if(3)//Protect
				var/datum/objective/protect/ninja_objective = new
				ninja_objective.owner = ninja
				ninja_objective.target = ninja_objective.find_target()
				if(ninja_objective.target != "Free Objective")
					ninja.objectives += ninja_objective
				else
					i++
					objective_list -= 3
			if(4)//Download
				var/datum/objective/download/ninja_objective = new
				ninja_objective.owner = ninja
				ninja_objective.gen_amount_goal()
				ninja.objectives += ninja_objective
				objective_list -= 4
			if(5)//Harm
				var/datum/objective/harm/ninja_objective = new
				ninja_objective.owner = ninja
				ninja_objective.target = ninja_objective.find_target()
				if(ninja_objective.target != "Free Objective")
					ninja.objectives += ninja_objective
				else
					i++
					objective_list -= 5

	var/datum/objective/survive/ninja_objective = new
	ninja_objective.owner = ninja
	ninja.objectives += ninja_objective

/decl/special_role/ninja/greet(var/datum/mind/player)

	if(!..())
		return 0
	var/directive = generate_ninja_directive("heel")
	player.StoreMemory("<B>Directive:</B> <span class='danger'>[directive]</span><br>", /decl/memory_options/system)
	to_chat(player, "<b>Remember your directive:</b> [directive].")

/decl/special_role/ninja/update_antag_mob(var/datum/mind/player)
	..()
	var/mob/living/human/H = player.current
	if(istype(H))
		H.real_name = "[pick(ninja_titles)] [pick(ninja_names)]"
		H.SetName(H.real_name)
	player.name = H.name

/decl/outfit/ninja
	name =    "Special Role - Ninja"
	l_ear =   /obj/item/radio/headset
	uniform = /obj/item/clothing/jumpsuit/black
	belt =    /obj/item/flashlight
	hands =   list(/obj/item/modular_computer/pda/ninja)
	id_type = /obj/item/card/id/syndicate

/decl/special_role/ninja/equip_role(var/mob/living/human/player)
	. = ..()
	if(.)
		var/decl/uplink_source/pda/uplink_source = GET_DECL(/decl/uplink_source/pda)
		uplink_source.setup_uplink_source(player, 0)

/decl/special_role/ninja/proc/generate_ninja_directive(side)
	var/directive = "[side=="face"?"[global.using_map.company_name]":"A criminal syndicate"] is your employer. "//Let them know which side they're on.
	switch(rand(1,18))
		if(1)
			directive += "The Spider Clan must not be linked to this operation. Remain hidden and covert when possible."
		if(2)
			directive += "[global.using_map.station_name] is financed by an enemy of the Spider Clan. Cause as much structural damage as desired."
		if(3)
			directive += "A wealthy animal rights activist has made a request we cannot refuse. Prioritize saving animal lives whenever possible."
		if(4)
			directive += "The Spider Clan absolutely cannot be linked to this operation. Eliminate witnesses at your discretion."
		if(5)
			directive += "We are currently negotiating with [global.using_map.company_name] [global.using_map.boss_name]. Prioritize saving human lives over ending them."
		if(6)
			directive += "We are engaged in a legal dispute over [global.using_map.station_name]. If a laywer is present on board, force their cooperation in the matter."
		if(7)
			directive += "A financial backer has made an offer we cannot refuse. Implicate criminal involvement in the operation."
		if(8)
			directive += "Let no one question the mercy of the Spider Clan. Ensure the safety of all non-essential personnel you encounter."
		if(9)
			directive += "A free agent has proposed a lucrative business deal. Implicate [global.using_map.company_name] involvement in the operation."
		if(10)
			directive += "Our reputation is on the line. Harm as few civilians and innocents as possible."
		if(11)
			directive += "Our honor is on the line. Utilize only honorable tactics when dealing with opponents."
		if(12)
			directive += "We are currently negotiating with a mercenary leader. Disguise assassinations as suicide or other natural causes."
		if(13)
			directive += "Some disgruntled [global.using_map.company_name] employees have been supportive of our operations. Be wary of any mistreatment by command staff."
		if(14)
			directive += "The Spider Clan has recently been accused of religious insensitivity. Attempt to speak with the Chaplain and prove these accusations false."
		if(15)
			directive += "The Spider Clan has been bargaining with a competing prosthetics manufacturer. Try to shine [global.using_map.company_name] prosthetics in a bad light."
		if(16)
			directive += "The Spider Clan has recently begun recruiting outsiders. Consider suitable candidates and assess their behavior amongst the crew."
		if(17)
			directive += "A cyborg liberation group has expressed interest in our serves. Prove the Spider Clan merciful towards law-bound synthetics."
		else
			directive += "There are no special supplemental instructions at this time."
	return directive
