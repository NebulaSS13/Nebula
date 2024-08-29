/*
Skill books that increase your skills while you activate and hold them
*/

/obj/item/book/skill
	name = "textbook" // requires default names for tradershop, cant rely on Initialize for names
	desc = "A blank textbook. (Notify admin)"
	author = "The Oracle of Bakersroof"
	icon_state = "book2"
	_base_attack_force = 4
	w_class = ITEM_SIZE_LARGE            // Skill books are THICC with knowledge. Up one level from regular books to prevent library-in-a-bag silliness.
	unique = TRUE
	material = /decl/material/solid/organic/plastic
	matter = list(/decl/material/solid/organic/wood = MATTER_AMOUNT_REINFORCEMENT)
	abstract_type = /obj/item/book/skill

	var/decl/skill/skill       // e.g. SKILL_LITERACY
	var/skill_req = SKILL_NONE           // The level the user needs in the skill to benefit from the book, e.g. SKILL_PROF
	var/weakref/reading                  // To check if the book is actively being used
	var/custom = FALSE                   // To bypass init stuff, for player made textbooks and weird books. If true must have details manually set
	var/ez_read = FALSE                  // Set to TRUE if you can read it without basic literacy skills

	var/skill_name = "missing skill name"
	var/progress = INFINITY // used to track the progress of making a custom book. defaults as finished so, you know, you can read the damn thing

	var/static/list/skill_name_patterns = list(
		"$SKILL_NAME$ for Idiots",
		"How To Learn $SKILL_NAME$ and Not Get Laughed At",
		"Teaching Yourself $SKILL_NAME$: Volume $RAND$",
		"Getting the Hands-Off Experience You Need with $SKILL_NAME$",
		"Master $SKILL_NAME$ in $RAND$ easy steps!",
		"$SKILL_NAME$ Just Like Mum",
		"How To $SKILL_NAME$ Good Enough For Your Father",
		"How To Win Your Dad's Approval With $SKILL_NAME$",
		"Make a Living with $SKILL_NAME$ Like Your Old Man Always Wanted You To",
		"$SKILL_NAME$: Secret Techniques",
		"The Dos, Don'ts and Oh Gods Please Nos of $SKILL_NAME$",
		"The Death Of $SKILL_NAME$",
		"Everything You Never Wanted To Know About $SKILL_NAME$ But Have Been Reluctantly Forced To Find Out",
		"$SKILL_NAME$ For The Busy Professional",
		"Learning $SKILL_NAME$ In A Hurry Because You Lied On Your Resume",
		"Help! My Life Suddenly Depends On $SKILL_NAME$",
		"What The Fuck is $ARTICLE_SKILL_NAME$?",
		"Starting $ARTICLE_SKILL_NAME$ Business By Yourself",
		"Even You Can Learn $SKILL_NAME$!",
		"How To Impress Your Parents with $SKILL_NAME$",
		"How To Become A Master of $SKILL_NAME$",
		"Everything The Government Doesn't Want You To Know About $SKILL_NAME$",
		"$SKILL_NAME$ For Kids!",
		"$SKILL_NAME$: Volume $RAND$",
		"Understanding $SKILL_NAME$: $RAND_TH$ Edition",
		"Dealing With Ungrateful Customers Dissatisfied With Your Perfectly Acceptable $SKILL_NAME$ Services",
		"Really big book of $SKILL_NAME$"
	)

	// Lists used when producing custom skillbooks.
	var/static/list/failure_messages = list(
		"Your hand slips and you accidentally rip your pen through several pages, ruining your hard work!",
		"Your pen slips, dragging a haphazard line across both open pages! Now you need to do those again!"
	)
	/// Messages are in order of progress.
	var/static/list/progress_messages = list(
		"Still quite a few blank pages left.",
		"Feels like you're near halfway done.",
		"You've made good progress.",
		"Just needs a few finishing touches.",
		"And then finish it. Done!"
	)
	var/static/list/charge_messages = list(
		"Your mind instantly recoils at the idea of having to write another textbook. No thank you!",
		"You are far too mentally exhausted to write another textbook. Maybe another day.",
		"Your hand aches in response to the very idea of more textbook writing."
	)

/obj/item/book/skill/Initialize()

	. = ..()

	global.events_repository.register(/decl/observ/moved, src, src, PROC_REF(check_buff))

	if(!custom && skill && skill_req)// custom books should already have all they need

		skill_name = initial(skill.name)

		var/title_name = capitalize(skill_name)
		title = replacetext(pick(skill_name_patterns), "$SKILL_NAME$", title_name)
		title = replacetext(title, "$RAND$", rand(1,100))
		title = replacetext(title, "$RAND_TH$", "[rand(1,100)]\th")
		title = replacetext(title, "$ARTICLE_SKILL_NAME$", capitalize(ADD_ARTICLE(title_name)))
		title = "\"[title]\""

		switch(skill_req) // check what skill_req the book has
			if(SKILL_NONE) // none > basic
				name = "beginner [skill_name] textbook"
				desc = "A copy of [title] by [author]. The only reason this book is so big is because all the words are printed very large! Presumably so you, an idiot, can read it."
			if(SKILL_BASIC) // basic > adept
				name = "intermediate [skill_name] textbook"
				desc = "A copy of [title] by [author]. Dry and long, but not unmanageable. Basic knowledge is required to understand the concepts written."
			if(SKILL_ADEPT) // adept > expert
				name = "advanced [skill_name] textbook"
				desc = "A copy of [title] by [author]. Those not already trained in the subject will have a hard time reading this. Try not to drop it either, it will put a hole in the floor."
			if(SKILL_EXPERT to SKILL_MAX) //expert > prof
				name = "theoretical [skill_name] textbook"
				desc = "A copy of [title] by [author]. Significant experience in the subject is required to read this incredibly information dense block of paper. Sadly, does not come in audio form."

	if((!skill || !skill_req) && !custom)//That's a bad book, so just grab ANY child to replace it. Custom books are fine though they can be bad if they want.
		if(subtypesof(src.type))
			var/new_book = pick(subtypesof(src.type))
			new new_book(src.loc)
			qdel_self()

/datum/skill_buff/skill_book
	limit = 1 // you can only read one book at a time nerd, therefore you can only get one buff at a time

/obj/item/book/skill/get_single_monetary_worth()
	. = max(..(), 200) + (100 * skill_req)

/obj/item/book/skill/proc/check_can_read(mob/user)
	if(QDELETED(user))
		return FALSE
	var/effective_title = length(title) ? title : "the textbook"
	if(!CanPhysicallyInteract(user))
		to_chat(user, SPAN_WARNING("You can't reach [effective_title]!"))
		return FALSE
	if(!skill || (custom && progress == 0))
		to_chat(user, SPAN_WARNING("[capitalize(effective_title)] is blank!"))
		return FALSE
	if(custom && progress <= length(progress_messages))
		to_chat(user, SPAN_WARNING("[capitalize(effective_title)] is unfinished! You can't learn from it in this state!"))
		return FALSE
	if(!ez_read &&!user.skill_check(SKILL_LITERACY, SKILL_BASIC))
		to_chat(user, SPAN_WARNING(pick(list(
			"Haha, you know you can't read. Good joke. Put [effective_title] back.",
			"You open up [effective_title], but there aren't any pictures, so you close it again.",
			"You don't know how to read! What good is [effective_title] to you?!"
		))))
		return FALSE

	if(reading)
		if(reading.resolve() != user)
			to_chat(user, SPAN_WARNING("\The [reading.resolve()] is already reading [effective_title]!"))
		else
			to_chat(user, SPAN_WARNING("You are already reading [effective_title]!"))
		return FALSE

	if(user.too_many_buffs(/datum/skill_buff/skill_book))
		to_chat(user, SPAN_WARNING("You can't read two books at once!"))
		return FALSE

	if(!user.skill_check(skill, skill_req))
		to_chat(user, SPAN_WARNING("[capitalize(title)] is too advanced for you! Try something easier, perhaps the \"For Idiots\" edition?"))
		return FALSE

	if(user.get_skill_value(skill) > skill_req)
		to_chat(user, SPAN_WARNING("You already know everything [effective_title] has to teach you!"))
		return FALSE

	return TRUE

/obj/item/book/skill/verb/read_book()
	set name = "Read Book"
	set category = "Object"
	set src in view(1)
	try_to_read(usr)

/obj/item/book/skill/try_to_read(mob/user)

	if(isobserver(user))
		to_chat(user, SPAN_WARNING("Ghosts can't read! Go away!"))
		return TRUE

	if(isturf(loc))
		user.face_atom(src)

	if(user && user == reading?.resolve())
		//Close book, get rid of buffs
		unlearn(user)
		to_chat(user, SPAN_NOTICE("You close [title]. That's enough learning for now."))
		reading = null
		STOP_PROCESSING(SSprocessing, src)
		return TRUE

	if(!check_can_read(user))
		return FALSE

	to_chat(user, SPAN_NOTICE("You open up [title] and start reading..."))
	if(!user.do_skilled(4 SECONDS, SKILL_LITERACY, src, 0.75))
		to_chat(user, SPAN_DANGER("Your perusal of [title] was interrupted!"))
		return TRUE

	if(!check_can_read(user))
		return TRUE

	var/list/buff = list()
	buff[skill] = 1
	user.buff_skill(buff, buff_type = /datum/skill_buff/skill_book)
	reading = weakref(user)
	to_chat(user, SPAN_NOTICE("You find the information you need! Better keep the page open to reference it."))
	START_PROCESSING(SSprocessing, src)
	return TRUE

// buff removal
/obj/item/book/skill/proc/unlearn(var/mob/user)
	var/list/F = user.fetch_buffs_of_type(/datum/skill_buff/skill_book, 0)
	for(var/datum/skill_buff/skill_book/S in F)
		S.remove()

/obj/item/book/skill/Process()
	if(!reading)
		return PROCESS_KILL
	check_buff()

/obj/item/book/skill/proc/check_buff()
	if(!reading)
		return
	var/mob/R = reading.resolve()
	if(!istype(R) || !CanPhysicallyInteract(R))
		remove_buff()

/obj/item/book/skill/proc/remove_buff()
	var/mob/R = reading?.resolve()
	reading = null
	if(istype(R))
		to_chat(R, SPAN_DANGER("You lose the page you were on! You can't cross-reference using [title] like this!"))
		if(R.fetch_buffs_of_type(/datum/skill_buff/skill_book, 0))
			unlearn(R)
	STOP_PROCESSING(SSprocessing, src)

/obj/item/book/skill/Destroy()
	global.events_repository.unregister(/decl/observ/moved, src, src)
	remove_buff()
	. = ..()






//////////////////////
// SHELF SHELF SHELF//
//////////////////////

/obj/structure/bookcase/skill_books
	name = "textbook bookcase"
	// Contains a list of parent types but doesn't actually DO anything with them. Use a child of this book case
	var/static/list/catalogue = list(
		/obj/item/book/skill/organizational/finance,
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
		/obj/item/book/skill/medical/anatomy
	)

//give me ALL the textbooks
/obj/structure/bookcase/skill_books/all/Initialize()
	. = ..()
	for(var/category in catalogue)
		for(var/real_book in subtypesof(category))
			new real_book(src)

//Bookshelf with some random textbooks
/obj/structure/bookcase/skill_books/random/Initialize()
	. = ..()
	for(var/category in catalogue)
		for(var/real_book in subtypesof(category))
			if(prob(20))
				new real_book(src)
