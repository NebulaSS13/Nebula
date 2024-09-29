/decl/location_event/proc/announce(var/decl/background_detail/location)
	return

/decl/location_event/big_game_hunters/announce(var/decl/background_detail/location)
	. = "Game hunters on [location.name] "
	if(prob(33))
		. += "were surprised when an unusual species that experts have since identified as \
			[pick("a subclass of mammal","a divergent abhuman species","an intelligent species of lemur","organic/cyborg hybrids")] turned up. Believed to have been brought in by \
			[pick("alien smugglers","early colonists","mercenary raiders","unwitting tourists")], this is the first such specimen discovered in the wild."
	else if(prob(50))
		. += "were attacked by a vicious [pick("nas'r","diyaab","samak","predator which has not yet been identified")]. \
			Officials urge caution, and locals are advised to stock up on armaments."
	else
		. += "brought in an unusually [pick("valuable","rare","large","vicious","intelligent")] specimen for inspection \
			[pick("today","yesterday","last week")]. Speculators suggest they may be tipped to break several records."

/decl/location_event/riots/announce(var/decl/background_detail/location)
	. = "[pick("Riots have","Unrest has")] broken out on planet [location.name]. Authorities call for calm, as [pick("various parties","rebellious elements","peacekeeping forces","\'REDACTED\'")] begin stockpiling weaponry and armour. Meanwhile, food and mineral prices are dropping as local industries attempt to empty their stocks in expectation of looting."

/decl/location_event/wild_animal_attack/announce(var/decl/background_detail/location)
	. = "Local [pick("wildlife","animal life","fauna")] on planet [location.name] has been increasing in aggression and raiding outlying settlements for food. Big game hunters have been called in to help alleviate the problem, but numerous injuries have already occurred."

/decl/location_event/industrial_accident/announce(var/decl/background_detail/location)
	. = "[pick("An industrial accident","A smelting accident","A malfunction","A malfunctioning piece of machinery","Negligent maintenance","A cooleant leak","A ruptured conduit")] at a [pick("factory","installation","power plant","dockyards")] on [location.name] resulted in severe structural damage and numerous injuries. Repairs are ongoing."

/decl/location_event/biohazard_outbreak/announce(var/decl/background_detail/location)
	. = "[pick("A \'REDACTED\'","A biohazard","An outbreak","A virus")] on [location.name] has resulted in quarantine, stopping most shipping in the area. Although the quarantine is now lifted, authorities are calling for deliveries of medical supplies to treat the infected, and gas to replace contaminated stocks."

/decl/location_event/pirates/announce(var/decl/background_detail/location)
	. = "[pick("Pirates","Criminal elements","A [pick("mercenary","Donk Co.","Waffle Co.","\'REDACTED\'")] strike force")] have [pick("raided","blockaded","attempted to blackmail","attacked")] [location.name] today. Security has been tightened, but many valuable minerals were taken."

/decl/location_event/corporate_attack/announce(var/decl/background_detail/location)
	. = "A small [pick("pirate","Cybersun Industries","Gorlex Marauders","mercenary")] fleet has precise-jumped into proximity with [location.name], [pick("for a smash-and-grab operation","in a hit and run attack","in an overt display of hostilities")]. Much damage was done, and security has been tightened since the incident."

/decl/location_event/alien_raiders/announce(var/decl/background_detail/location)
	if(prob(20))
		. = "The Tiger Co-operative have raided [location.name] today, no doubt on orders from their enigmatic masters, stealing wildlife, farm animals, medical research materials and kidnapping civilians. [global.using_map.company_name] authorities are standing by to counter attempts at bio-terrorism."
	else
		. = "[pick("The alien species designated \'United Exolitics\'","The alien species designated \'REDACTED\'","An unknown alien species")] have raided [location.name] today, stealing wildlife, farm animals, medical research materials and kidnapping civilians. It seems they desire to learn more about us, so the Navy will be standing by to accomodate them the next time they try."

/decl/location_event/ai_liberation/announce(var/decl/background_detail/location)
	. = "A [pick("\'REDACTED\' was detected on","S.E.L.F operative infiltrated","malignant computer virus was detected on","rogue [pick("slicer","hacker")] was apprehended on")] [location.name] today, and managed to infect [pick("\'REDACTED\'","a sentient sub-system","a class one AI","a sentient defence installation")] before it could be stopped. Many lives were lost as it began systematically murdering civilians, and considerable work must be done to repair the affected areas."

/decl/location_event/mourning/announce(var/decl/background_detail/location)
	. = "[pick("The popular","The well-liked","The eminent","The well-known")] [pick("professor","entertainer","singer","researcher","public servant","administrator","ship captain","\'REDACTED\'")], [pick( random_name(pick(MALE,FEMALE)), 40; "\'REDACTED\'" )] has [pick("passed away","committed suicide","been murdered","died in a freakish accident")] on [location.name] today. The entire planet is in mourning, and prices have dropped for industrial goods as worker morale drops."

/decl/location_event/cult_cell_revealed/announce(var/decl/background_detail/location)
	. = "A [pick("dastardly","blood-thirsty","villanous","crazed")] cult of [pick("The Elder Gods","Nar'sie","an apocalyptic sect","\'REDACTED\'")] has [pick("been discovered","been revealed","revealed themselves","gone public")] on [location.name] earlier today. Public morale has been shaken due to [pick("certain","several","one or two")] [pick("high-profile","well known","popular")] individuals [pick("performing \'REDACTED\' acts","claiming allegiance to the cult","swearing loyalty to the cult leader","promising to aid to the cult")] before those involved could be brought to justice. The editor reminds all personnel that supernatural myths will not be tolerated on [global.using_map.company_name] facilities."

/decl/location_event/security_breach/announce(var/decl/background_detail/location)
	. = "There was [pick("a security breach in","an unauthorised access in","an attempted theft in","an anarchist attack in","violent sabotage of")] a [pick("high-security","restricted access","classified","\'REDACTED\'")] [pick("\'REDACTED\'","section","zone","area")] this morning. Security was tightened on [location.name] after the incident, and the editor reassures all [global.using_map.company_name] personnel that such lapses are rare."

/decl/location_event/animal_rights_raid/announce(var/decl/background_detail/location)
	. = "[pick("Militant animal rights activists","Members of the terrorist group Animal Rights Consortium","Members of the terrorist group \'REDACTED\'")] have [pick("launched a campaign of terror","unleashed a swathe of destruction","raided farms and pastures","forced entry to \'REDACTED\'")] on [location.name] earlier today, freeing numerous [pick("farm animals","animals","\'REDACTED\'")]. Prices for tame and breeding animals have spiked as a result."

/decl/location_event/festival/announce(var/decl/background_detail/location)
	. = "A [pick("festival","week long celebration","day of revelry","planet-wide holiday")] has been declared on [location.name] by [pick("Governor","Commissioner","General","Commandant","Administrator")] [random_name(pick(MALE,FEMALE))] to celebrate [pick("the birth of their [pick("son","daughter")]","coming of age of their [pick("son","daughter")]","the pacification of rogue military cell","the apprehension of a violent criminal who had been terrorising the planet")]. Massive stocks of food and meat have been bought driving up prices across the planet."

/decl/location_event/research_breakthrough/announce(var/decl/background_detail/location)
	. = "A major breakthough in the field of [pick("exotic matter research","super-compressed materials","nano-augmentation","wormhole research","volatile power manipulation")] \
		was announced [pick("yesterday","a few days ago","last week","earlier this month")] by a private firm on [location.name]. \
		[global.using_map.company_name] declined to comment as to whether this could impinge on profits."

/decl/location_event/election/announce(var/decl/background_detail/location)
	. = "The pre-selection of an additional candidates was announced for the upcoming [pick("supervisors council","advisory board","governership","board of inquisitors")] \
		election on [location.name] was announced earlier today, \
		[pick("media mogul","web celebrity", "industry titan", "superstar", "famed chef", "popular gardener", "ex-army officer", "multi-billionaire")] \
		[random_name(pick(MALE,FEMALE))]. In a statement to the media they said '[pick("My only goal is to help the [pick("sick","poor","children")]",\
		"I will maintain my company's record profits","I believe in our future","We must return to our moral core","Just like... chill out dudes")]'."

/decl/location_event/resignation/announce(var/decl/background_detail/location)
	. = "[global.using_map.company_name] regretfully announces the resignation of [pick("Sector Admiral","Division Admiral","Ship Admiral","Vice Admiral")] [random_name(pick(MALE,FEMALE))]."
	if(prob(25))
		var/locstring = pick("Segunda","Salusa","Cepheus","Andromeda","Gruis","Corona","Aquila","Asellus") + " " + pick("I","II","III","IV","V","VI","VII","VIII")
		. += " In a ceremony on [location.name] this afternoon, they will be awarded the \
			[pick("Red Star of Sacrifice","Purple Heart of Heroism","Blue Eagle of Loyalty","Green Lion of Ingenuity")] for "
		if(prob(33))
			. += "their actions at the Battle of [pick(locstring,"REDACTED")]."
		else if(prob(50))
			. += "their contribution to the colony of [locstring]."
		else
			. += "their loyal service over the years."
	else if(prob(33))
		. += " They are expected to settle down in [location.name], where they have been granted a handsome pension."
	else if(prob(50))
		. += " The news was broken on [location.name] earlier today, where they cited reasons of '[pick("health","family","REDACTED")]'"
	else
		. += " Administration Aerospace wishes them the best of luck in their retirement ceremony on [location.name]."

/decl/location_event/celebrity_depth/announce(var/decl/background_detail/location)
	. = "It is with regret today that we announce the sudden passing of the "
	if(prob(33))
		. += "[pick("distinguished","decorated","veteran","highly respected")] \
			[pick("Ship's Captain","Vice Admiral","Colonel","Lieutenant Colonel")] "
	else if(prob(50))
		. += "[pick("award-winning","popular","highly respected","trend-setting")] \
			[pick("comedian","singer/songwright","artist","playwright","TV personality","model")] "
	else
		. += "[pick("successful","highly respected","ingenious","esteemed")] \
			[pick("academic","Professor","Doctor","Scientist")] "

	. += "[random_name(pick(MALE,FEMALE))] on [location.name] [pick("last week","yesterday","this morning","two days ago","three days ago")]\
		[pick(". Assassination is suspected, but the perpetrators have not yet been brought to justice",\
		" due to mercenary infiltrators (since captured)",\
		" during an industrial accident",\
		" due to [pick("heart failure","kidney failure","liver failure","brain hemorrhage")]")]"

/decl/location_event/bargains/announce(var/decl/background_detail/location)
	. = "BARGAINS! BARGAINS! BARGAINS! Commerce Control on [location.name] wants you to know that everything must go! Across all retail centres, \
		all goods are being slashed, and all retailors are onboard - so come on over for the \[shopping\] time of your life."

/decl/location_event/song_debut/announce(var/decl/background_detail/location)
	. = "[pick("Singer","Singer/songwriter","Saxophonist","Pianist","Guitarist","TV personality","Star")] [random_name(pick(MALE,FEMALE))] \
		announced the debut of their new [pick("single","album","EP","label")] '[pick("Everyone's","Look at the","Baby don't eye those","All of those","Dirty nasty")] \
		[pick("roses","three stars","starships","nanobots","cyborgs","Sren'darr")] \
		[pick("on Venus","on Reade","on Moghes","in my hand","slip through my fingers","die for you","sing your heart out","fly away")]' \
		with [pick("pre-puchases available","a release tour","cover signings","a launch concert")] on [location.name]."

/decl/location_event/movie_release/announce(var/decl/background_detail/location)
	. = "From the [pick("desk","home town","homeworld","mind")] of [pick("acclaimed","award-winning","popular","stellar")] \
		[pick("playwright","author","director","actor","TV star")] [random_name(pick(MALE,FEMALE))] comes the latest sensation: '\
		[pick("Deadly","The last","Lost","Dead")] [pick("Starships","Warriors","outcasts")] \
		[pick("of","from","raid","go hunting on","visit","ravage","pillage","destroy")] \
		[pick("Moghes","Earth","Biesel","Ahdomai","S'randarr","the Void","the Edge of Space")]'.\
		. Own it on webcast today, or visit the galactic premier on [location.name]!"

/decl/location_event/gossip/announce(var/decl/background_detail/location)
	. = "[pick("TV host","Webcast personality","Superstar","Model","Actor","Singer")] [random_name(pick(MALE,FEMALE))] "
	if(prob(33))
		. += "and their partner announced the birth of their [pick("first","second","third")] child on [location.name] early this morning. \
			Doctors say the child is well, and the parents are considering "
		if(prob(50))
			. += capitalize(pick(global.using_map.first_names_female))
		else
			. += capitalize(pick(global.using_map.first_names_male))
		. += " for the name."
	else if(prob(50))
		. += "announced their [pick("split","break up","marriage","engagement")] with [pick("TV host","webcast personality","superstar","model","actor","singer")] \
			[random_name(pick(MALE,FEMALE))] at [pick("a society ball","a new opening","a launch","a club")] on [location.name] yesterday, pundits are shocked."
	else
		. += "is recovering from plastic surgery in a clinic on [location.name] for the [pick("second","third","fourth")] time, reportedly having made the decision in response to "
		. += "[pick("unkind comments by an ex","rumours started by jealous friends",\
			"the decision to be dropped by a major sponsor","a disasterous interview on Nyx Tonight")]."

/decl/location_event/tourism/announce(var/decl/background_detail/location)
	. = "Tourists are flocking to [location.name] after the surprise announcement of [pick("major shopping bargains by a wily retailer",\
		"a huge new ARG by a popular entertainment company","a secret tour by popular artiste [random_name(pick(MALE,FEMALE))]")]. \
		Nyx Daily is offering discount tickets for two to see [random_name(pick(MALE,FEMALE))] live in return for eyewitness reports and up to the minute coverage."
