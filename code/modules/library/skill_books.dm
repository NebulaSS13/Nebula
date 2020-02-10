#define RANDOM_BOOK_TITLE(skill_name) pick(list("\"[skill_name] for Idiots\"", \
										"\"How To Learn [skill_name] and Not Get Laughed At\"", \
										"\"Teaching Yourself [skill_name]: Volume [rand(1,100)]\"", \
										"\"Getting the Hands-Off Experience You Need with [skill_name]\"", \
										"\"Master [skill_name] in [rand(100,999)] easy steps!\"", \
										"\"[skill_name] Just Like Mum\"", \
										"\"How To [skill_name] Good Enough For Your Father\"", \
										"\"How To Win Your Dad's Approval With [skill_name]\"", \
										"\"Make a Living with [skill_name] Like Your Old Man Always Wanted You To\"", \
										"\"[skill_name]: Secret Techniques\"", \
										"\"The Dos, Don'ts and Oh Gods Please Nos of [skill_name]\"", \
										"\"The Death Of [skill_name]\"", \
										"\"Everything You Never Wanted To Know About [skill_name] But Have Been Reluctantly Forced To Find Out\"", \
										"\"[skill_name] For The Busy Yinglet\"", \
										"\"Learning [skill_name] In A Hurry Because You Lied On Your Resume\"", \
										"\"Help! My Life Suddenly Depends On [skill_name]\"", \
										"\"What The Fuck is [capitalize(ADD_ARTICLE(capitalize(skill_name)))]?\"", \
										"\"Starting [capitalize(ADD_ARTICLE(capitalize(skill_name)))] Business By Yourself\"", \
										"\"Even a Scav Can Learn [skill_name]!\"", \
										"\"How To Impress Your Matriarch with [skill_name]\"", \
										"\"How To Become A Patriarch of [skill_name]\"", \
										"\"Everything The Government Doesn't Want You To Know About [skill_name]\"", \
										"\"[skill_name] For Younglets\"", \
										"\"[skill_name]: Volume [rand(1,100)]\"", \
										"\"Understanding [skill_name]: [rand(1,100)]\th Edition\"", \
										"\"Dealing With Ungrateful Customers Dissatisfied With Your Perfectly Acceptable [skill_name] Services\""))

/*
Skill books that increase your skills while you activate and hold them
*/

/obj/item/book/skill
	name = "default textbook" // requires default names for tradershop, cant rely in Initialize for names
	desc = "A blank textbook. (Notify admin)"
	author = "The Oracle of Bakersroof"
	icon_state = "book2"
	force = 4
	w_class = ITEM_SIZE_HUGE //Skill books are THICC with knowledge. Just to stop people carrying around a library in a box
	unique = 1

	var/decl/hierarchy/skill/skill // e.g. SKILL_LITERACY
	var/skill_req //The level the user needs in the skill to benefit from the book, e.g. SKILL_PROF
	var/reading = FALSE //Tto check if the book is actively being used
	var/custom = FALSE //To bypass init stuff, for player made textbooks and weird books
	var/ez_read = FALSE //Set to TRUE if you can read it without basic literacy skills

	var/skill_name = "missing skill name"

/obj/item/book/skill/Initialize()
	. = ..()
	if(!custom && skill && skill_req)// custom books should already have all they need
		skill_name = initial(skill.name)
		title = RANDOM_BOOK_TITLE(capitalize(initial(skill.name)))
		switch(skill_req) // check what skill_req the book has
			if(1) // none > basic
				name = "beginner [skill_name] textbook"
				desc = "A copy of [title] by [author]. The only reason this book is so big is because all the words are printed very large! Presumably so you, an idiot, can read it."
			if(2) // basic > adept
				name = "intermediate [skill_name] textbook"
				desc = "A copy of [title] by [author]. Dry and long, but not unmanageable. Basic knowledge is required to understand the concepts written."
			if(3) // adept > expert
				name = "advanced [skill_name] textbook"
				desc = "A copy of [title] by [author]. Those not already trained in the subject will have a hard time reading this. Try not to drop it either, it will put a hole in the floor."
			if(4) //expert > prof
				name = "theoretical [skill_name] textbook"
				desc = "A copy of [title] by [author]. Significant experience in the subject is required to read this incredibly information dense block of paper. Sadly, does not come in audio form."
	if(!skill || !skill_req)//That's a bad book, so just grab ANY child to replace it.
		if(subtypesof(src.type))
			var/new_book = pick(subtypesof(src.type))
			new new_book(src.loc)
			qdel_self()

/datum/skill_buff/skill_book
	limit = 1 // you can only read one book at a time nerd, therefore you can only get one buff at a time

/obj/item/book/skill/attack_self(mob/user)
	if(!ez_read &&!user.skill_check(SKILL_LITERACY, SKILL_BASIC))
		to_chat(user, SPAN_WARNING(pick("Haha, you know you can't read. Good joke. Put [title] back.","You open up [title], but there aren't any pictures, so you close it again.","You don't know how to read! What good is this [name] to you?!")))
		return

	if(reading) //Close book, get rid of buffs
		src.unlearn(user)
		to_chat(user, SPAN_NOTICE("You close the [name]. That's enough learning for now."))
		reading = FALSE
		return

	if(user.too_many_buffs(/datum/skill_buff/skill_book))
		to_chat(user, SPAN_WARNING("You can't read two books at once!"))
		return

	if(!user.skill_check(skill, skill_req))
		to_chat(user, SPAN_WARNING("[title] is too advanced for you! Try something easier, perhaps the \"For Idiots\" edition?"))
		return
	if(user.get_skill_value(skill) > skill_req)
		to_chat(user, SPAN_WARNING("You already know everything [title] has to teach you!"))
		return

	to_chat(user, SPAN_NOTICE("You open up the [name] and start reading..."))
	if(user.do_skilled(4 SECONDS, SKILL_LITERACY, src, 0.75))
		var/list/buff = list()
		buff[skill] = 1
		user.buff_skill(buff, buff_type = /datum/skill_buff/skill_book)
		reading = TRUE
		to_chat(user, SPAN_NOTICE("You find the information you need! Better keep the page open to reference it."))
	else
		to_chat(user, SPAN_DANGER("Your perusal of the [name] was interrupted!"))
		return

// buff removal
/obj/item/book/skill/proc/unlearn(var/mob/user)
	var/list/F = user.fetch_buffs_of_type(/datum/skill_buff/skill_book, 0)
	for(var/datum/skill_buff/skill_book/S in F)
		S.remove()

// Remove buffs when book goes away
/obj/item/book/skill/dropped(mob/user)
	if(reading)
		to_chat(user, SPAN_DANGER("You lose the page you were on! You can't cross-reference using the [name] like this!"))
		var/mob/M = user
		if(istype(M) && M.fetch_buffs_of_type(/datum/skill_buff/skill_book, 0))
			src.unlearn(user)
		reading = FALSE
	. = ..()
/obj/item/book/skill/Destroy()
	var/mob/M = loc
	if(istype(M) && M.fetch_buffs_of_type(/datum/skill_buff/skill_book, 0))
		src.unlearn(M)
	. = ..()

/obj/item/book/skill/get_codex_value()
	return "textbook"

////////////////////////////////
//THIS IS WHERE THE BOOKS LIVE//
////////////////////////////////

/* 
ORGANIZATIONAL 
*/
/obj/item/book/skill/organizational

//literacy
/obj/item/book/skill/organizational/literacy
	skill = SKILL_LITERACY

/obj/item/book/skill/organizational/literacy/basic
	name = "younglet's alphabet book"
	icon_state = "tb_literacy"
	author = "Matriarch Ivalini"
	skill_req = SKILL_NONE
	custom = TRUE
	w_class = ITEM_SIZE_LARGE // A little bit smaller c:
	ez_read = TRUE

/obj/item/book/skill/organizational/literacy/basic/Initialize()
	. = ..()
	title = pick("Younglet's First Human Letterz", "The Curious, Funny, Tasty Snaprat", "The Hungry Hungry Quilldog")
	desc = "A copy of [title] by [author]. It's a thick book, mostly because the pages are made of cardboard. Looks like it's designed to teach juvenile yinglets basic literacy."

//finance
/obj/item/book/skill/organizational/finance
	skill = SKILL_FINANCE
	author = "Cadence Bennett"
	icon_state = "tb_finance"

/obj/item/book/skill/organizational/finance/basic
	skill_req = SKILL_NONE
	name = "beginner finance textbook"

/obj/item/book/skill/organizational/finance/adept
	skill_req = SKILL_BASIC
	name = "intermediate finance textbook"

/obj/item/book/skill/organizational/finance/expert
	skill_req = SKILL_ADEPT
	name = "advanced finance textbook"

/obj/item/book/skill/organizational/finance/prof
	skill_req = SKILL_EXPERT
	name = "theoretical finance textbook"

/* 
GENERAL
*/
/obj/item/book/skill/general

//eva
/obj/item/book/skill/general/eva
	icon_state = "evabook"
	skill = SKILL_EVA
	author = "Big Dark"

/obj/item/book/skill/general/eva/basic
	skill_req = SKILL_NONE
	name = "beginner extra-vehicular activity textbook"

/obj/item/book/skill/general/eva/adept
	skill_req = SKILL_BASIC
	name = "intermediate extra-vehicular activity textbook"

/obj/item/book/skill/general/eva/expert
	skill_req = SKILL_ADEPT
	name = "advanced extra-vehicular activity textbook"

/obj/item/book/skill/general/eva/prof
	skill_req = SKILL_EXPERT
	name = "theoretical extra-vehicular activity textbook"

//mech
/obj/item/book/skill/general/mech
	icon_state = "tb_mech"
	skill = SKILL_MECH
	author = "J.T. Marsh"

/obj/item/book/skill/general/mech/basic
	skill_req = SKILL_NONE
	name = "beginner exosuit operation textbook"

/obj/item/book/skill/general/mech/adept
	skill_req = SKILL_BASIC
	name = "intermediate exosuit operation textbook"

/obj/item/book/skill/general/mech/expert
	skill_req = SKILL_ADEPT
	name = "advanced exosuit operation textbook"

/obj/item/book/skill/general/mech/prof
	skill_req = SKILL_EXPERT
	name = "theoretical exosuit operation textbook"

//piloting
/obj/item/book/skill/general/pilot
	skill = SKILL_PILOT
	author = "Sumi Shimamoto"
	icon_state = "tb_pilot"

/obj/item/book/skill/general/pilot/basic
	skill_req = SKILL_NONE
	name = "beginner piloting textbook"

/obj/item/book/skill/general/pilot/adept
	skill_req = SKILL_BASIC
	name = "intermediate piloting textbook"

/obj/item/book/skill/general/pilot/expert
	skill_req = SKILL_ADEPT
	name = "advanced piloting textbook"

/obj/item/book/skill/general/pilot/prof
	skill_req = SKILL_EXPERT
	name = "theoretical piloting textbook"

//hauling
/obj/item/book/skill/general/hauling
	skill = SKILL_HAULING
	author = "Chiel Brunt"
	icon_state = "tb_hauling"

/obj/item/book/skill/general/hauling/basic
	skill_req = SKILL_NONE
	name = "beginner athletics textbook"

/obj/item/book/skill/general/hauling/adept
	skill_req = SKILL_BASIC
	name = "intermediate athletics textbook"

/obj/item/book/skill/general/hauling/expert
	skill_req = SKILL_ADEPT
	name = "advanced athletics textbook"

/obj/item/book/skill/general/hauling/prof
	skill_req = SKILL_EXPERT
	name = "theoretical athletics textbook"

//computer
/obj/item/book/skill/general/computer
	skill = SKILL_COMPUTER
	author = "Simona Castiglione"
	icon_state = "bookNuclear"

/obj/item/book/skill/general/computer/basic
	skill_req = SKILL_NONE
	name = "beginner information technology textbook"

/obj/item/book/skill/general/computer/adept
	skill_req = SKILL_BASIC
	name = "intermediate information technology textbook"

/obj/item/book/skill/general/computer/expert
	skill_req = SKILL_ADEPT
	name = "advanced information technology textbook"

/obj/item/book/skill/general/computer/prof
	skill_req = SKILL_EXPERT
	name = "theoretical information technology textbook"

/* 
SERVICE
*/
/obj/item/book/skill/service

//botany
/obj/item/book/skill/service/botany
	icon_state = "bookHydroponicsPodPeople"
	skill = SKILL_BOTANY
	author = "Mai Dong Chat"

/obj/item/book/skill/service/botany/basic
	skill_req = SKILL_NONE
	name = "beginner botany textbook"

/obj/item/book/skill/service/botany/adept
	skill_req = SKILL_BASIC
	name = "intermediate botany textbook"

/obj/item/book/skill/service/botany/expert
	skill_req = SKILL_ADEPT
	name = "advanced botany textbook"

/obj/item/book/skill/service/botany/prof
	skill_req = SKILL_EXPERT
	name = "theoretical botany textbook"

//cooking
/obj/item/book/skill/service/cooking
	icon_state = "barbook"
	skill = SKILL_COOKING
	author = "Lavinia Burrows"

/obj/item/book/skill/service/cooking/basic
	skill_req = SKILL_NONE
	name = "beginner cooking textbook"

/obj/item/book/skill/service/cooking/adept
	skill_req = SKILL_BASIC
	name = "intermediate cooking textbook"

/obj/item/book/skill/service/cooking/expert
	skill_req = SKILL_ADEPT
	name = "advanced cooking textbook"

/obj/item/book/skill/service/cooking/prof
	skill_req = SKILL_EXPERT
	name = "theoretical cooking textbook"

/* 
SECURITY
*/
/obj/item/book/skill/security
	icon_state = "bookSpaceLaw"

//combat
/obj/item/book/skill/security/combat
	skill = SKILL_COMBAT
	author = "Autumn Eckhardstein"
	icon_state = "tb_combat"

/obj/item/book/skill/security/combat/basic
	skill_req = SKILL_NONE
	name = "beginner close combat textbook"

/obj/item/book/skill/security/combat/adept
	skill_req = SKILL_BASIC
	name = "intermediate close combat textbook"

/obj/item/book/skill/security/combat/expert
	skill_req = SKILL_ADEPT
	name = "advanced close combat textbook"

/obj/item/book/skill/security/combat/prof
	skill_req = SKILL_EXPERT
	name = "theoretical close combat textbook"

//weapons
/obj/item/book/skill/security/weapons
	skill = SKILL_WEAPONS
	author = "Miho Tatsu"
	icon_state = "tb_weapon"

/obj/item/book/skill/security/weapons/basic
	skill_req = SKILL_NONE
	name = "beginner weapons expertise textbook"

/obj/item/book/skill/security/weapons/adept
	skill_req = SKILL_BASIC
	name = "intermediate weapons expertise textbook"

/obj/item/book/skill/security/weapons/expert
	skill_req = SKILL_ADEPT
	name = "advanced weapons expertise textbook"

/obj/item/book/skill/security/weapons/prof
	skill_req = SKILL_EXPERT
	name = "theoretical weapons expertise textbook"

//forensics
/obj/item/book/skill/security/forensics
	icon_state = "bookDetective"
	skill = SKILL_FORENSICS
	author = "Samuel Vimes"

/obj/item/book/skill/security/forensics/basic
	skill_req = SKILL_NONE
	name = "beginner forensics textbook"

/obj/item/book/skill/security/forensics/adept
	skill_req = SKILL_BASIC
	name = "intermediate forensics textbook"

/obj/item/book/skill/security/forensics/expert
	skill_req = SKILL_ADEPT
	name = "advanced forensics textbook"

/obj/item/book/skill/security/forensics/prof
	skill_req = SKILL_EXPERT
	name = "theoretical forensics textbook"

/* 
ENGINEERING 
*/
/obj/item/book/skill/engineering
	icon_state = "bookEngineering"

//construction
/obj/item/book/skill/engineering/construction/
	author = "Robert Bildar"
	skill = SKILL_CONSTRUCTION

/obj/item/book/skill/engineering/construction/basic
	skill_req = SKILL_NONE
	name = "beginner construction textbook"

/obj/item/book/skill/engineering/construction/adept
	skill_req = SKILL_BASIC
	name = "intermediate construction textbook"

/obj/item/book/skill/engineering/construction/expert
	skill_req = SKILL_ADEPT
	name = "advanced construction textbook"

/obj/item/book/skill/engineering/construction/prof
	skill_req = SKILL_EXPERT
	name = "theoretical construction textbook"

//electrical
/obj/item/book/skill/engineering/electrical
	skill = SKILL_ELECTRICAL
	author = "Ariana Vanderbalt"

/obj/item/book/skill/engineering/electrical/basic
	skill_req = SKILL_NONE
	name = "beginner electrical engineering textbook"

/obj/item/book/skill/engineering/electrical/adept
	skill_req = SKILL_BASIC
	name = "intermediate electrical engineering textbook"

/obj/item/book/skill/engineering/electrical/expert
	skill_req = SKILL_ADEPT
	name = "advanced electrical engineering textbook"

/obj/item/book/skill/engineering/electrical/prof
	skill_req = SKILL_EXPERT
	name = "theoretical electrical engineering textbook"

//atmos
/obj/item/book/skill/engineering/atmos
	skill = SKILL_ATMOS
	author = "Maria Crash"
	icon_state = "pipingbook"

/obj/item/book/skill/engineering/atmos/basic
	skill_req = SKILL_NONE
	name = "beginner atmospherics textbook"

/obj/item/book/skill/engineering/atmos/adept
	skill_req = SKILL_BASIC
	name = "intermediate atmospherics textbook"

/obj/item/book/skill/engineering/atmos/expert
	skill_req = SKILL_ADEPT
	name = "advanced atmospherics textbook"

/obj/item/book/skill/engineering/atmos/prof
	skill_req = SKILL_EXPERT
	name = "theoretical atmospherics textbook"

//engines
/obj/item/book/skill/engineering/engines
	skill = SKILL_ENGINES
	author = "Gilgamesh Scholz"

/obj/item/book/skill/engineering/engines/basic
	skill_req = SKILL_NONE
	name = "beginner engines textbook"

/obj/item/book/skill/engineering/engines/adept
	skill_req = SKILL_BASIC
	name = "intermediate engines textbook"

/obj/item/book/skill/engineering/engines/expert
	skill_req = SKILL_ADEPT
	name = "advanced engines textbook"

/obj/item/book/skill/engineering/engines/prof
	skill_req = SKILL_EXPERT
	name = "theoretical engines textbook"

/obj/item/book/skill/engineering/engines/prof/magazine
	name = "theoretical engines magazine"
	title = "\"Bad Baxxid\""
	icon_state = "bookMagazine"
	custom = TRUE
	author = "Unknown"
	desc = "Sure, it includes highly detailed information on extremely advanced engine and power generator systems... but why is it written in marker on a tentacle porn magazine?"
	w_class = ITEM_SIZE_LARGE

/* 
RESEARCH
*/
/obj/item/book/skill/research
	icon_state = "analysis"

//devices
/obj/item/book/skill/research/devices
	author = "Nilva Plosinjak"
	skill = SKILL_DEVICES

/obj/item/book/skill/research/devices/basic
	skill_req = SKILL_NONE
	name = "beginner complex devices textbook"

/obj/item/book/skill/research/devices/adept
	skill_req = SKILL_BASIC
	name = "intermediate complex devices textbook"

/obj/item/book/skill/research/devices/expert
	skill_req = SKILL_ADEPT
	name = "advanced complex devices textbook"

/obj/item/book/skill/research/devices/prof
	skill_req = SKILL_EXPERT
	name = "theoretical complex devices textbook"

//science
/obj/item/book/skill/research/science
	author = "Hui Ying Ch'ien"
	skill = SKILL_SCIENCE

/obj/item/book/skill/research/science/basic
	skill_req = SKILL_NONE
	name = "beginner science textbook"

/obj/item/book/skill/research/science/adept
	skill_req = SKILL_BASIC
	name = "intermediate science textbook"

/obj/item/book/skill/research/science/expert
	skill_req = SKILL_ADEPT
	name = "advanced science textbook"

/obj/item/book/skill/research/science/prof
	skill_req = SKILL_EXPERT
	name = "theoretical science textbook"

/*
MEDICAL
*/
/obj/item/book/skill/medical
	icon_state = "bookMedical"

//chemistry
/obj/item/book/skill/medical/chemistry
	icon_state = "chemistry"
	author = "Dr. Shinula Nyekundujicho"
	skill = SKILL_CHEMISTRY

/obj/item/book/skill/medical/chemistry/basic
	skill_req = SKILL_NONE
	name = "beginner chemistry textbook"

/obj/item/book/skill/medical/chemistry/adept
	skill_req = SKILL_BASIC
	name = "intermediate chemistry textbook"

/obj/item/book/skill/medical/chemistry/expert
	skill_req = SKILL_ADEPT
	name = "advanced chemistry textbook"

/obj/item/book/skill/medical/chemistry/prof
	skill_req = SKILL_EXPERT
	name = "theoretical chemistry textbook"

//medicine
/obj/item/book/skill/medical/medicine
	author = "Dr. Nagarjuna Siddha"
	skill = SKILL_MEDICAL

/obj/item/book/skill/medical/medicine/basic
	skill_req = SKILL_NONE
	name = "beginner medicine textbook"
	title = "\"Instructional Guide on How Rubbing Dirt In Wounds Might Not Be The Right Approach To Stopping Bleeding Anymore\""
	desc = "A copy of \"Instructional Guide on How Rubbing Dirt In Wounds Might Not Be The Right Approach To Stopping Bleeding Anymore\" by Dr. Merrs. Despite the information density of this heavy book, it lacks any and all teachings regarding bedside manner."
	author = "Dr. Merrs"
	custom = TRUE

/obj/item/book/skill/medical/medicine/adept
	skill_req = SKILL_BASIC
	name = "intermediate medicine textbook"

/obj/item/book/skill/medical/medicine/expert
	skill_req = SKILL_ADEPT
	name = "advanced medicine textbook"

/obj/item/book/skill/medical/medicine/prof
	skill_req = SKILL_EXPERT
	name = "theoretical medicine textbook"

//anatomy
/obj/item/book/skill/medical/anatomy
	author = "Dr. Basil Cartwright"
	skill = SKILL_ANATOMY

/obj/item/book/skill/medical/anatomy/basic
	skill_req = SKILL_NONE
	name = "beginner anatomy textbook"

/obj/item/book/skill/medical/anatomy/adept
	skill_req = SKILL_BASIC
	name = "intermediate anatomy textbook"

/obj/item/book/skill/medical/anatomy/expert
	skill_req = SKILL_ADEPT
	name = "advanced anatomy textbook"

/obj/item/book/skill/medical/anatomy/prof
	skill_req = SKILL_EXPERT
	name = "theoretical anatomy textbook"

//////////////////////
// SHELF SHELF SHELF//
//////////////////////

/obj/structure/bookcase/skill_books/
	name = "textbook bookcase"
	// Contains a list of parent types but doesn't actually DO anything with them. Use a child of this book case
	var/list/catalogue = list(/obj/item/book/skill/organizational/finance,
							/obj/item/book/skill/organizational/literacy,
							/obj/item/book/skill/general/eva,
							/obj/item/book/skill/general/mech,
							/obj/item/book/skill/general/pilot,
							/obj/item/book/skill/general/hauling,
							/obj/item/book/skill/general/computer,
							/obj/item/book/skill/service/botany,
							/obj/item/book/skill/service/cooking,
							/obj/item/book/skill/security/combat,
							/obj/item/book/skill/security/weapons,
							/obj/item/book/skill/security/forensics,
							/obj/item/book/skill/engineering/construction,
							/obj/item/book/skill/engineering/electrical,
							/obj/item/book/skill/engineering/atmos,
							/obj/item/book/skill/engineering/engines,
							/obj/item/book/skill/research/devices,
							/obj/item/book/skill/research/science,
							/obj/item/book/skill/medical/chemistry,
							/obj/item/book/skill/medical/medicine,
							/obj/item/book/skill/medical/anatomy)

//give me ALL the textbooks
/obj/structure/bookcase/skill_books/all

/obj/structure/bookcase/skill_books/all/Initialize()
	. = ..()
	for(var/category in catalogue)
		for(var/real_book in subtypesof(category))
			new real_book(src)

//Bookshelf with some random textbooks
/obj/structure/bookcase/skill_books/random/

/obj/structure/bookcase/skill_books/random/Initialize()
	. = ..()
	for(var/category in catalogue)
		for(var/real_book in subtypesof(category))
			if(prob(20))
				new real_book(src)

#undef RANDOM_BOOK_TITLE