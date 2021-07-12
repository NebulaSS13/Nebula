var/global/church_name = null
/proc/church_name()
	if (church_name)
		return church_name

	var/name = ""

	name += pick("Holy", "United", "First", "Second", "Last")

	if (prob(20))
		name += " Space"

	name += " " + pick("Church", "Cathedral", "Body", "Worshippers", "Movement", "Witnesses")
	name += " of [religion_name()]"

	return name

var/global/command_name
/proc/command_name()
	if (global.command_name)
		return global.command_name
	global.command_name = "[global.using_map.boss_name]"
	return global.command_name

/proc/change_command_name(var/name)
	global.command_name = name
	return global.command_name

var/global/religion_name = null
/proc/religion_name()
	if (religion_name)
		return religion_name

	var/name = ""

	name += pick("bee", "science", "edu", "captain", "assistant", "monkey", "alien", "space", "unit", "sprocket", "gadget", "bomb", "revolution", "beyond", "station", "goon", "robot", "ivor", "hobnob")
	name += pick("ism", "ia", "ology", "istism", "ites", "ick", "ian", "ity")

	return capitalize(name)

/proc/system_name()
	return global.using_map.system_name ? global.using_map.system_name : generate_system_name()

/proc/generate_system_name()
	return "[pick("Gilese","GSC", "Luyten", "GJ", "HD")][prob(10) ? " Eridani" : ""] [rand(100,999)]"

/proc/generate_planet_name()
	return "[capitalize(pick(global.last_names))]-[pick(global.greek_letters)]"

/proc/generate_planet_type()
	return pick("terrestial planet", "ice planet", "dwarf planet", "desert planet", "ocean planet", "lava planet", "gas giant", "forest planet")

/proc/station_name()
	if(!global.using_map)
		return config.server_name
	if (global.using_map.station_name)
		return global.using_map.station_name

	var/random = rand(1,5)
	var/name = ""

	//Rare: Pre-Prefix
	if(prob(10))
		name = pick(global.station_prefixes)
		global.using_map.station_name = name + " "

	var/holiday_prefix = length(global.current_holiday?.station_prefixes) && pick(global.current_holiday.station_prefixes)
	if(holiday_prefix)
		name = holiday_prefix
		global.using_map.station_name = "[global.using_map.station_name][holiday_prefix] "

	// Suffix
	name = pick(global.station_suffixes)
	global.using_map.station_name += name + " "

	var/holiday_suffix = length(global.current_holiday?.station_suffixes) && pick(global.current_holiday.station_suffixes)
	if(holiday_suffix)
		global.using_map.station_name += holiday_suffix
	else
		// ID Number
		switch(random)
			if(1)
				global.using_map.station_name += "[rand(1, 99)]"
			if(2)
				global.using_map.station_name += pick(global.greek_letters)
			if(3)
				global.using_map.station_name += "\Roman[rand(1,99)]"
			if(4)
				global.using_map.station_name += pick(global.phonetic_alphabet)
			if(5)
				global.using_map.station_name += pick(global.numbers_as_words)

	if (config && config.server_name)
		world.name = "[config.server_name]: [name]"
	else
		world.name = global.using_map.station_name

	return global.using_map.station_name

/proc/world_name(var/name)
	global.using_map.station_name = name

	if (config && config.server_name)
		world.name = "[config.server_name]: [name]"
	else
		world.name = name

	return name

var/global/syndicate_name = null
/proc/syndicate_name()
	if (syndicate_name)
		return syndicate_name

	var/name = ""

	// Prefix
	name += pick("Clandestine", "Prima", "Blue", "Zero-G", "Max", "Blasto", "Waffle", "North", "Omni", "Newton", "Cyber", "Bonk", "Gene", "Gib")

	// Suffix
	if (prob(80))
		name += " "

		// Full
		if (prob(60))
			name += pick("Syndicate", "Consortium", "Collective", "Corporation", "Group", "Holdings", "Biotech", "Industries", "Systems", "Products", "Chemicals", "Enterprises", "Family", "Creations", "International", "Intergalactic", "Interplanetary", "Foundation", "Positronics", "Hive")
		// Broken
		else
			name += pick("Syndi", "Corp", "Bio", "System", "Prod", "Chem", "Inter", "Hive")
			name += pick("", "-")
			name += pick("Tech", "Sun", "Co", "Tek", "X", "Inc", "Code")
	// Small
	else
		name += pick("-", "*", "")
		name += pick("Tech", "Sun", "Co", "Tek", "X", "Inc", "Gen", "Star", "Dyne", "Code", "Hive")

	syndicate_name = name
	return name


//Traitors and traitor silicons will get these. Revs will not.
var/global/syndicate_code_phrase//Code phrase for traitors.
var/global/syndicate_code_response//Code response for traitors.

	/*
	Should be expanded.
	How this works:
	Instead of "I'm looking for James Smith," the traitor would say "James Smith" as part of a conversation.
	Another traitor may then respond with: "They enjoy running through the void-filled vacuum of the derelict."
	The phrase should then have the words: James Smith.
	The response should then have the words: run, void, and derelict.
	This way assures that the code is suited to the conversation and is unpredicatable.
	Obviously, some people will be better at this than others but in theory, everyone should be able to do it and it only enhances roleplay.
	Can probably be done through "{ }" but I don't really see the practical benefit.
	One example of an earlier system is commented below.
	-N
	*/

/proc/generate_code_phrase()//Proc is used for phrase and response in subsystem init.

	var/code_phrase = ""//What is returned when the proc finishes.
	var/words = pick(//How many words there will be. Minimum of two. 2, 4 and 5 have a lesser chance of being selected. 3 is the most likely.
		50; 2,
		200; 3,
		50; 4,
		25; 5
	)

	var/safety[] = list(1,2,3)//Tells the proc which options to remove later on.
	var/nouns[] = list("love","hate","anger","peace","pride","sympathy","bravery","loyalty","honesty","integrity","compassion","charity","success","courage","deceit","skill","beauty","brilliance","pain","misery","beliefs","dreams","justice","truth","faith","liberty","knowledge","thought","information","culture","trust","dedication","progress","education","hospitality","leisure","trouble","friendships", "relaxation")
	var/drinks[] = list("vodka and tonic","gin fizz","bahama mama","manhattan","black Russian","whiskey soda","long island tea","margarita","Irish coffee"," manly dwarf","Irish cream","doctor's delight","Beepsky Smash","tequila sunrise","brave bull","gargle blaster","bloody mary","whiskey cola","white Russian","vodka martini","martini","Cuba libre","kahlua","vodka","wine","moonshine")
	var/locations[] = length(stationlocs) ? stationlocs : drinks//if null, defaults to drinks instead.

	var/maxwords = words//Extra var to check for duplicates.

	for(words,words>0,words--)//Randomly picks from one of the choices below.

		if(words==1&&(1 in safety)&&(2 in safety))//If there is only one word remaining and choice 1 or 2 have not been selected.
			safety = list(pick(1,2))//Select choice 1 or 2.
		else if(words==1&&maxwords==2)//Else if there is only one word remaining (and there were two originally), and 1 or 2 were chosen,
			safety = list(3)//Default to list 3

		switch(pick(safety))//Chance based on the safety list.
			if(1)//1 and 2 can only be selected once each to prevent more than two specific names/places/etc.
				switch(rand(1,2))//Mainly to add more options later.
					if(1)
						code_phrase += pick(pick(global.first_names_male,global.first_names_female))
						code_phrase += " "
						code_phrase += pick(global.last_names)
					if(2)
						code_phrase += pick(SSjobs.titles_to_datums) //Returns a job.
				safety -= 1
			if(2)
				switch(rand(1,2))//Places or things.
					if(1)
						code_phrase += pick(drinks)
					if(2)
						code_phrase += pick(locations)
				safety -= 2
			if(3)
				switch(rand(1,3))//Nouns, adjectives, verbs. Can be selected more than once.
					if(1)
						code_phrase += pick(nouns)
					if(2)
						code_phrase += pick(global.adjectives)
					if(3)
						code_phrase += pick(global.verbs)
		if(words==1)
			code_phrase += "."
		else
			code_phrase += ", "

	return code_phrase

/proc/get_name(var/atom/A)
	return A.name

/proc/get_name_and_coordinates(var/atom/A)
	return "[A.name] \[[A.x],[A.y],[A.z]\]"
