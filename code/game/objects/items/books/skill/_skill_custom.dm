//////////////////////
//Custom Skill Books//
//////////////////////

//custom skill books made by players. Right now it is extremely dodgy and bad and i'm sorry
/obj/item/book/skill/custom
	name = "blank textbook"
	desc = "A somewhat heftier blank book, just ready to filled with knowledge and sold at an unreasonable price."
	custom = TRUE
	author = null
	progress = 0
	icon_state = "tb_white"
	var/skill_option_string = "Skill" //changes to "continue writing content" when the book is in progress
	var/true_author //Used to keep track of who is actually writing the book.
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
	if(IS_PEN(pen))

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
	if(user.get_active_held_item() == pen && CanPhysicallyInteractWith(user,src) && !QDELETED(src) && !QDELETED(pen))
		return TRUE
	else
		to_chat(user,SPAN_DANGER("How can you expect to write anything when you can't physically put pen to paper?"))
		return FALSE

/obj/item/book/skill/custom/proc/edit_title(var/obj/item/pen, var/mob/user)
	var/newtitle = reject_bad_text(sanitize_safe(input(user, "Write a new title:")))
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
	for(var/decl/skill/S in global.using_map.get_available_skills())
		if(user.skill_check(S.type, SKILL_BASIC))
			LAZYADD(skill_choices, S)
	var/decl/skill/skill_choice = input(user, "What subject does your textbook teach?", "Textbook skill selection") as null|anything in skill_choices
	if(!can_write(pen,user) || progress > length(progress_messages))
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
	if(!can_write(pen,user) || progress > length(progress_messages))
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
		progress++
		skill_option_string = "Continue writing content"
		true_author = user.name

/obj/item/book/skill/custom/proc/continue_skill(var/obj/item/pen, var/mob/user)
	if(user.skillset.literacy_charges <= 0)
		to_chat(user, SPAN_WARNING(pick(charge_messages)))
		return
	if(progress > length(progress_messages)) // shouldn't happen but here just in case
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
		progress++
		if(progress > length(progress_messages)) // book is finished! yay!
			user.skillset.literacy_charges -= 1
			skill_option_string = "Cancel"