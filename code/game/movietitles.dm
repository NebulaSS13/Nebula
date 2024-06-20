var/global/list/end_titles

/client
	var/list/credits

/client/proc/RollCredits()
	set waitfor = FALSE

	if(get_preference_value(/datum/client_preference/show_credits) != PREF_YES)
		return

	if(!global.end_titles)
		global.end_titles = generate_titles()

	if(mob)
		mob.overlay_fullscreen("fishbed",/obj/screen/fullscreen/fishbed)
		mob.overlay_fullscreen("fadeout",/obj/screen/fullscreen/fadeout)

		if(mob.get_preference_value(/datum/client_preference/play_lobby_music) == PREF_YES)
			sound_to(mob, sound(null, channel = sound_channels.lobby_channel))
			if(global.end_credits_song == null)
				if(global.using_map.credit_sound)
					sound_to(mob, sound(pick(global.using_map.credit_sound), wait = 0, volume = 40, channel = sound_channels.lobby_channel))
			else if(get_preference_value(/datum/client_preference/play_admin_midis) == PREF_YES)
				sound_to(mob, sound(global.end_credits_song, wait = 0, volume = 40, channel = sound_channels.lobby_channel))

	sleep(5 SECONDS)
	verbs += /client/proc/ClearCredits
	for(var/credit in global.end_titles)
		var/obj/screen/credit/credit_obj = new(null, mob)
		LAZYADD(credits, credit_obj)
		credit_obj.maptext = {"<div style="font:'Small Fonts'">[credit]</div>"}
		credit_obj.rollem()
		sleep(CREDIT_SPAWN_SPEED)
	sleep(CREDIT_ROLL_SPEED - CREDIT_SPAWN_SPEED)

	ClearCredits()
	verbs -= /client/proc/ClearCredits

/client/proc/ClearCredits()
	set name = "Stop End Titles"
	set category = "OOC"
	verbs -= /client/proc/ClearCredits
	QDEL_NULL_LIST(credits)
	mob.clear_fullscreen("fishbed")
	mob.clear_fullscreen("fadeout")
	sound_to(mob, sound(null, channel = sound_channels.lobby_channel))

/proc/generate_titles()
	var/list/titles = list()
	var/list/cast = list()
	var/list/chunk = list()
	var/chunksize = 0
	titles += "<center><h1>EPISODE [rand(1,1000)]<br>[SSlore.get_end_credits_title()]<h1></h1></h1></center>"

	for(var/mob/living/human/H in global.living_mob_list_|global.dead_mob_list_)
		if(findtext(H.real_name,"(mannequin)"))
			continue
		if(H.isMonkey() && findtext(H.real_name,"[lowertext(H.species.name)]")) //no monki
			continue
		if(H.timeofdeath && H.timeofdeath < 5 MINUTES) //don't mention these losers (prespawned corpses mostly)
			continue
		if(!cast.len && !chunksize)
			chunk += "CAST:"
		var/job = ""
		if(GetAssignment(H) != "Unassigned")
			job = ", [uppertext(GetAssignment(H))]"
		var/used_name = H.real_name
		var/datum/computer_file/report/crew_record/R = get_crewmember_record(H.real_name)
		if(R && R.get_rank())
			var/datum/mil_rank/rank = mil_branches.get_rank(R.get_branch(), R.get_rank())
			if(rank.name_short)
				used_name = "[rank.name_short] [used_name]"
		var/showckey = 0
		if(H.ckey && H.client)
			if(H.client.get_preference_value(/datum/client_preference/show_ckey_credits) == PREF_SHOW)
				showckey = 1
		var/decl/cultural_info/actor_culture = GET_DECL(H.get_cultural_value(TAG_CULTURE))
		if(!actor_culture || !(H.species.spawn_flags & SPECIES_CAN_JOIN) || prob(10))
			actor_culture = GET_DECL(/decl/cultural_info/culture/human)
		if(!showckey)
			if(prob(90))
				chunk += "[actor_culture.get_random_name(H, H.gender)]\t \t \t \t[uppertext(used_name)][job]"
			else
				var/decl/pronouns/G = H.get_pronouns()
				chunk += "[used_name]\t \t \t \t[uppertext(G.him)]SELF"
		else
			chunk += "[uppertext(actor_culture.get_random_name(H, H.gender))] a.k.a. '[uppertext(H.ckey)]'\t \t \t \t[uppertext(used_name)][job]"
		chunksize++
		if(chunksize > 2)
			cast += "<center>[jointext(chunk,"<br>")]</center>"
			chunk.Cut()
			chunksize = 0
	if(chunk.len)
		cast += "<center>[jointext(chunk,"<br>")]</center>"

	titles += cast

	var/list/corpses = list()
	var/list/monkies = list()
	for(var/mob/living/human/H in global.dead_mob_list_)
		if(H.timeofdeath < 5 MINUTES) //no prespawned corpses
			continue
		if(H.isMonkey() && findtext(H.real_name,"[lowertext(H.species.name)]"))
			monkies[H.species.name] += 1
		else if(H.real_name)
			corpses += H.real_name
	for(var/spec in monkies)
		var/decl/species/S = get_species_by_key(spec)
		corpses += "[monkies[spec]] [lowertext(monkies[spec] > 1 ? S.name_plural : S.name)]"
	if(corpses.len)
		titles += "<center>BASED ON REAL EVENTS<br>In memory of [english_list(corpses)].</center>"

	var/list/staff = list("PRODUCTION STAFF:")
	var/list/staffjobs = list("Coffe Fetcher", "Cameraman", "Angry Yeller", "Chair Operator", "Choreographer", "Historical Consultant", "Costume Designer", "Chief Editor", "Executive Assistant")
	var/list/goodboys = list()
	for(var/client/C)
		if(!C.holder)
			continue
		if(C.holder.rights & (R_DEBUG|R_ADMIN))
			var/list/all_cultures = decls_repository.get_decls_of_subtype(/decl/cultural_info/culture)
			var/decl/cultural_info/cult = all_cultures[pick(all_cultures)]
			staff += "[uppertext(pick(staffjobs))] - [cult.get_random_name(pick(MALE, FEMALE))] a.k.a. '[C.key]'"
		else if(C.holder.rights & R_MOD)
			goodboys += "[C.key]"

	titles += "<center>[jointext(staff,"<br>")]</center>"
	if(goodboys.len)
		titles += "<center>STAFF'S GOOD BOYS:<br>[english_list(goodboys)]</center><br>"

	var/disclaimer = "<br>Sponsored by [global.using_map.company_name].<br>All rights reserved.<br>\
					 This motion picture is protected under the copyright laws of the Sol Central Government<br> and other nations throughout the galaxy.<br>\
					 Colony of First Publication: [pick("Mars", "Luna", "Earth", "Venus", "Phobos", "Ceres", "Tiamat", "Ceti Epsilon", "Eos", "Pluto", "Ouere",\
					 "Lordania", "Kingston", "Cinu", "Yuklid V", "Lorriman", "Tersten", "Gaia")].<br>"
	disclaimer += pick("Use for parody prohibited. PROHIBITED.",
					   "All stunts were performed by underpaid interns. Do NOT try at home.",
					   "[global.using_map.company_name] does not endorse behaviour depicted. Attempt at your own risk.",
					   "Any unauthorized exhibition, distribution, or copying of this film or any part thereof (including soundtrack)<br>\
						may result in an ERT being called to storm your home and take it back by force.",
						"The story, all names, characters, and incidents portrayed in this production are fictitious. No identification with actual<br>\
						persons (living or deceased), places, buildings, and products is intended or should be inferred.<br>\
						This film is based on a true story and all individuals depicted are based on real people, despite what we just said.",
						"No person or entity associated	with this film received payment or anything of value, or entered into any agreement, in connection<br>\
						with the depiction of tobacco products, despite the copious amounts	of smoking depicted within.<br>\
						(This disclaimer sponsored by Carcinoma - Carcinogens are our Business!(TM)).",
						"No animals were harmed in the making of this motion picture except for those listed previously as dead. Do not try this at home.")
	titles += "<hr>"
	titles += "<center><span style='font-size:6pt;'>[JOINTEXT(disclaimer)]</span></center>"

	return titles