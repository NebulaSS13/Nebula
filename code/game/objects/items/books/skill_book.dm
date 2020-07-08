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
										"\"[skill_name] For The Busy Professional\"", \
										"\"Learning [skill_name] In A Hurry Because You Lied On Your Resume\"", \
										"\"Help! My Life Suddenly Depends On [skill_name]\"", \
										"\"What The Fuck is [capitalize(ADD_ARTICLE(capitalize(skill_name)))]?\"", \
										"\"Starting [capitalize(ADD_ARTICLE(capitalize(skill_name)))] Business By Yourself\"", \
										"\"Even You Can Learn [skill_name]!\"", \
										"\"How To Impress Your Matriarch with [skill_name]\"", \
										"\"How To Become A Patriarch of [skill_name]\"", \
										"\"Everything The Government Doesn't Want You To Know About [skill_name]\"", \
										"\"[skill_name] For Younglets\"", \
										"\"[skill_name]: Volume [rand(1,100)]\"", \
										"\"Understanding [skill_name]: [rand(1,100)]\th Edition\"", \
										"\"Dealing With Ungrateful Customers Dissatisfied With Your Perfectly Acceptable [skill_name] Services\"", \
										"\"Really big book of [skill_name]\""))
#define SKILLBOOK_PROG_NONE 0
#define SKILLBOOK_PROG_FINISH 6

/*
Skill books that increase your skills while you activate and hold them
*/

/obj/item/book/skill
	name = "default textbook" // requires default names for tradershop, cant rely on Initialize for names
	desc = "A blank textbook. (Notify admin)"
	author = "The Oracle of Bakersroof"
	icon_state = "book2"
	force = 4
	w_class = ITEM_SIZE_LARGE //Skill books are THICC with knowledge. Up one level from regular books to prevent library-in-a-bag silliness.
	unique = 1
	material = /decl/material/solid/plastic
	matter = list(/decl/material/solid/wood = MATTER_AMOUNT_REINFORCEMENT)

	var/decl/hierarchy/skill/skill // e.g. SKILL_LITERACY
	var/skill_req //The level the user needs in the skill to benefit from the book, e.g. SKILL_PROF
	var/reading = FALSE //Tto check if the book is actively being used
	var/custom = FALSE //To bypass init stuff, for player made textbooks and weird books. If true must have details manually set
	var/ez_read = FALSE //Set to TRUE if you can read it without basic literacy skills

	var/skill_name = "missing skill name"
	var/progress = SKILLBOOK_PROG_FINISH // used to track the progress of making a custom book. defaults as finished so, you know, you can read the damn thing

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
	if((!skill || !skill_req) && !custom)//That's a bad book, so just grab ANY child to replace it. Custom books are fine though they can be bad if they want.
		if(subtypesof(src.type))
			var/new_book = pick(subtypesof(src.type))
			new new_book(src.loc)
			qdel_self()

/datum/skill_buff/skill_book
	limit = 1 // you can only read one book at a time nerd, therefore you can only get one buff at a time

/obj/item/book/skill/attack_self(mob/user)
	if(!skill || (custom && progress == SKILLBOOK_PROG_NONE))
		to_chat(user, SPAN_WARNING("The textbook is blank!"))
		return
	if(custom && progress < SKILLBOOK_PROG_FINISH)
		to_chat(user, SPAN_WARNING("The textbook is unfinished! You can't learn from it in this state!"))
		return
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
	name = "alphabet book"
	icon_state = "tb_literacy"
	author = "Dorothy Mulch"
	skill_req = SKILL_NONE
	custom = TRUE
	w_class = ITEM_SIZE_NORMAL // A little bit smaller c:
	ez_read = TRUE

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
	title = "\improper WetSkrell magazine"
	icon_state = "bookMagazine"
	custom = TRUE
	author = "Unknown"
	desc = "Sure, it includes highly detailed information on extremely advanced engine and power generator systems... but why is it written in marker on a tentacle porn magazine?"
	w_class = ITEM_SIZE_NORMAL


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
//Custom Skill Books//
//////////////////////

//custom skill books made by players. Right now it is extremely dodgy and bad and i'm sorry
/obj/item/book/skill/custom
	name = "blank textbook"
	desc = "A somewhat heftier blank book, just ready to filled with knowledge and sold at an unreasonable price."
	custom = TRUE
	author = null
	progress = SKILLBOOK_PROG_NONE
	icon_state = "tb_white"
	var/skill_option_string = "Skill" //changes to "continue writing content" when the book is in progress
	var/true_author //Used to keep track of who is actually writing the book.
	var/list/failure_messages = list("Your hand slips and you accidentally rip your pen through several pages, ruining your hard work!","Your pen slips, dragging a haphazard line across both open pages! Now you need to do those again!")
	var/list/progress_messages = list("Still quite a few blank pages left.","Feels like you're near halfway done.","You've made good progress.","Just needs a few finishing touches.","And then finish it. Done!") // Messages are in order of progress.
	var/list/charge_messages = list("Your mind instantly recoils at the idea of having to write another textbook. No thank you!","You are far too mentally exhausted to write another textbook. Maybe another day.","Your hand aches in response to the very idea of more textbook writing.")
	var/writing_time = 15 SECONDS // time it takes to write a segment of the book. This happens 6 times total

//these all show up in the book fabricator
/obj/item/book/skill/custom/circle
	icon_state = "tb_white_circle"
/obj/item/book/skill/custom/star
	icon_state = "tb_white_star"
/obj/item/book/skill/custom/hourglass
	icon_state = "tb_white_hourglass"
/obj/item/book/skill/custom/cracked
	icon_state = "tb_white_cracked"
/obj/item/book/skill/custom/gun
	icon_state = "tb_white_gun"
/obj/item/book/skill/custom/wrench
	icon_state = "tb_white_wrench"
/obj/item/book/skill/custom/glass
	icon_state = "tb_white_glass"

/obj/item/book/skill/custom/cross
	icon_state = "tb_white_cross"
/obj/item/book/skill/custom/text
	icon_state = "tb_white_text"
/obj/item/book/skill/custom/download
	icon_state = "tb_white_download"
/obj/item/book/skill/custom/uparrow
	icon_state = "tb_white_uparrow"
/obj/item/book/skill/custom/percent
	icon_state = "tb_white_percent"
/obj/item/book/skill/custom/flask
	icon_state = "tb_white_flask"
/obj/item/book/skill/custom/detective
	icon_state = "tb_white_detective"
/obj/item/book/skill/custom/device
	icon_state = "tb_white_device"
/obj/item/book/skill/custom/smile
	icon_state = "tb_white_smile"
/obj/item/book/skill/custom/exclamation
	icon_state = "tb_white_exclamation"
/obj/item/book/skill/custom/question
	icon_state = "tb_white_question"

/obj/item/book/skill/custom/attackby(obj/item/pen, mob/user)
	if(istype(pen, /obj/item/pen))

		if(!user.skill_check(SKILL_LITERACY, SKILL_BASIC))
			to_chat(user, SPAN_WARNING("You can't even read, yet you want to write a whole educational textbook?"))
			return
		if(!user.skill_check(SKILL_LITERACY, SKILL_PROF))
			to_chat(user, SPAN_WARNING("You have no clue as to how to write an entire textbook in a way that is actually useful. Maybe a regular book would be better?"))
			return
		var/state_check = skill_option_string // the state skill_option_string is in just before opening the input
		var/choice = input(user, "What would you like to change?","Textbook editing") as null|anything in list("Title", "Author", skill_option_string)
		if(!can_write(pen,user))
			return

		switch(choice)
			if("Title")
				edit_title(pen, user)

			if("Skill")
				if(state_check != "Skill") // make sure someone hasn't already started the book while we were staring at menus woops
					to_chat(user, SPAN_WARNING("The skill has already been selected and the writing started."))
					return
				edit_skill(pen, user)

			if("Continue writing content")
				if(state_check != "Continue writing content")
					return
				continue_skill(pen, user)

			if("Author")
				edit_author(pen, user)

			else
				return

		if(skill && title && author) // we have everything we need so lets set a good description
			desc = "A handwritten textbook titled [title], by [author]. Looks like it teaches [skill_name]."
		return
	..()

/obj/item/book/skill/custom/proc/can_write(var/obj/item/pen, var/mob/user)
	if(user.get_active_hand() == pen && CanPhysicallyInteractWith(user,src) && !QDELETED(src) && !QDELETED(pen))
		return TRUE
	else
		to_chat(user,SPAN_DANGER("How can you expect to write anything when you can't physically put pen to paper?"))
		return FALSE

/obj/item/book/skill/custom/proc/edit_title(var/obj/item/pen, var/mob/user)
	var/newtitle = reject_bad_text(sanitizeSafe(input(user, "Write a new title:")))
	if(!can_write(pen,user))
		return
	if(!newtitle)
		to_chat(user, "The title is invalid.")
		return
	else
		newtitle = user.handle_writing_literacy(user, newtitle)
		if(newtitle)
			title = newtitle
			SetName(title)

/obj/item/book/skill/custom/proc/edit_author(var/obj/item/pen, var/mob/user)
	var/newauthor = sanitize(input(user, "Write the author's name:"))
	if(!can_write(pen,user))
		return
	if(!newauthor)
		to_chat(user, SPAN_WARNING("The author name is invalid."))
		return
	else
		newauthor = user.handle_writing_literacy(user, newauthor)
		if(newauthor)
			author = newauthor

/obj/item/book/skill/custom/proc/edit_skill(var/obj/item/pen, var/mob/user)
	if(user.skillset.literacy_charges <= 0)
		to_chat(user, SPAN_WARNING(pick(charge_messages)))
		return

	//Choosing the skill
	var/list/skill_choices = list()
	for(var/decl/hierarchy/skill/S in GLOB.skills)
		if(user.skill_check(S.type, SKILL_BASIC))
			LAZYADD(skill_choices, S)
	var/decl/hierarchy/skill/skill_choice = input(user, "What subject does your textbook teach?", "Textbook skill selection") as null|anything in skill_choices
	if(!can_write(pen,user) || progress == SKILLBOOK_PROG_FINISH)
		return
	if(!skill_choice)
		to_chat(user, SPAN_WARNING("Textbook skill selection cancelled."))
		return
	var/newskill = skill_choice.type

	//Choosing the level
	var/list/skill_levels = skill_choice.levels.Copy()
	for(var/SL in skill_levels)
		if(!user.skill_check(newskill, skill_levels.Find(SL)))
			LAZYREMOVE(skill_levels, SL)
		else
			skill_levels[SL] = skill_levels.Find(SL)
	LAZYREMOVE(skill_levels,skill_levels[1])
	var/newskill_level = input(user, "What level of education does it provide?","Textbook skill level") as null|anything in skill_levels
	if(!can_write(pen,user) || progress == SKILLBOOK_PROG_FINISH)
		return
	if(!newskill_level)
		to_chat(user, SPAN_WARNING("Textbook skill level selection cancelled."))
		return
	var/usable_level = skill_levels[newskill_level]
	if(newskill && usable_level)
		if(!do_after(user, writing_time, src))
			to_chat(user, SPAN_DANGER(pick(failure_messages)))
			return
		//everything worked out so now we can put the learnings in the book
		to_chat(user, SPAN_NOTICE("You start writing your book, getting a few pages in."))
		skill = newskill
		skill_name = skill_choice.name
		skill_req = (usable_level - 1)
		desc = "A handwritten textbook on [skill_choice]! Wow!"
		progress += 1
		skill_option_string = "Continue writing content"
		true_author = user.name

/obj/item/book/skill/custom/proc/continue_skill(var/obj/item/pen, var/mob/user)
	if(user.skillset.literacy_charges <= 0)
		to_chat(user, SPAN_WARNING(pick(charge_messages)))
		return
	if(progress >= SKILLBOOK_PROG_FINISH) // shouldn't happen but here just in case
		to_chat(user, SPAN_WARNING("This book is already finished! There's no need to add anything else!"))
		return
	if(true_author != user.name)
		to_chat(user, SPAN_WARNING("This isn't your work and you're not really sure how to continue it."))
		return
	else
		if(!do_after(user, writing_time, src))
			to_chat(user, SPAN_DANGER(pick(failure_messages)))
			return
		to_chat(user, SPAN_NOTICE("You continue writing your book. [progress_messages[progress]]"))
		progress += 1
		if(progress == SKILLBOOK_PROG_FINISH) // book is finished! yay!
			user.skillset.literacy_charges -= 1
			skill_option_string = "Cancel"


//////////////////////
// SHELF SHELF SHELF//
//////////////////////

/obj/structure/bookcase/skill_books
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
/obj/structure/bookcase/skill_books/random

/obj/structure/bookcase/skill_books/random/Initialize()
	. = ..()
	for(var/category in catalogue)
		for(var/real_book in subtypesof(category))
			if(prob(20))
				new real_book(src)

#undef RANDOM_BOOK_TITLE
#undef SKILLBOOK_PROG_NONE
#undef SKILLBOOK_PROG_FINISH