/obj/structure/noticeboard
	name                   = "notice board"
	desc                   = "A board for pinning important notices upon."
	icon                   = 'icons/obj/structures/noticeboard.dmi'
	icon_state             = "nboard"
	density                = FALSE
	anchored               = TRUE
	layer                  = ABOVE_WINDOW_LAYER
	tool_interaction_flags = TOOL_INTERACTION_DECONSTRUCT
	obj_flags              = OBJ_FLAG_MOVES_UNSUPPORTED
	directional_offset     = "{'SOUTH':{'y':32}, 'EAST':{'x':-32}, 'WEST':{'x':32}}"
	material               = /decl/material/solid/wood
	var/tmp/max_notices    = 5
	var/list/notices

/obj/structure/noticeboard/Initialize(ml, _mat, _reinf_mat)
	set_extension(src, /datum/extension/base_icon_state, icon_state)
	. = ..()

	// Grab any mapped notices.
	if(ml)
		for(var/obj/item/paper/note in get_turf(src))
			add_paper(note, skip_icon_update = TRUE)
			if(LAZYLEN(notices) >= max_notices)
				break

	// Automatically place noticeboards that aren't mapped to specific positions.
	if(default_pixel_x == 0 && default_pixel_y == 0)
		var/turf/here = get_turf(src)
		for(var/checkdir in global.cardinal)
			var/turf/T = get_step(here, checkdir)
			if(T && T.density)
				set_dir(global.reverse_dir[checkdir])
				break

	update_icon()

/obj/structure/noticeboard/Destroy()
	QDEL_NULL_LIST(notices)
	return ..()

/obj/structure/noticeboard/proc/add_paper(var/atom/movable/paper, var/skip_icon_update)
	if(istype(paper))
		LAZYDISTINCTADD(notices, paper)
		paper.forceMove(src)
		if(!skip_icon_update)
			update_icon()

/obj/structure/noticeboard/proc/remove_paper(var/atom/movable/paper, var/skip_icon_update)
	if(istype(paper) && paper.loc == src)
		paper.dropInto(loc)
		LAZYREMOVE(notices, paper)
		if(!skip_icon_update)
			update_icon()

/obj/structure/noticeboard/dump_contents()
	for(var/thing in notices)
		remove_paper(thing, skip_icon_update = TRUE)
	return ..()

/obj/structure/noticeboard/on_update_icon()
	. = ..()
	var/datum/extension/base_icon_state/bis = get_extension(src, /datum/extension/base_icon_state)
	var/nb_notices = LAZYLEN(notices)
	icon_state = "[bis.base_icon_state][nb_notices > 0? "0[nb_notices]" : ""]"

/obj/structure/noticeboard/attackby(var/obj/item/thing, var/mob/user)
	if(!istype(thing, /obj/item/paper/sticky) && (istype(thing, /obj/item/paper) || istype(thing, /obj/item/photo)))
		if(jobban_isbanned(user, "Graffiti"))
			to_chat(user, SPAN_WARNING("You are banned from leaving persistent information across rounds."))
		else if(LAZYLEN(notices) < max_notices && user.try_unequip(thing, src))
			add_fingerprint(user)
			add_paper(thing)
			to_chat(user, SPAN_NOTICE("You pin \the [thing] to \the [src]."))
		else
			to_chat(user, SPAN_WARNING("You hesitate, certain \the [thing] will not be seen among the many others already attached to \the [src]."))
		return TRUE
	return ..()

/obj/structure/noticeboard/attack_ai(var/mob/user)
	interact(user)
	return TRUE

/obj/structure/noticeboard/attack_hand(var/mob/user)
	if(user.a_intent == I_HURT)
		return ..()
	interact(user)
	return TRUE

/obj/structure/noticeboard/examine(mob/user, distance, infix, suffix)
	. = ..()
	interact(user)

/obj/structure/noticeboard/interact(mob/user)
	var/list/dat = list("<table>")
	for(var/thing in notices)
		LAZYADD(dat, "<tr><td>[thing]</td><td>")
		if(istype(thing, /obj/item/paper))
			LAZYADD(dat, "<a href='?src=\ref[src];read=\ref[thing]'>Read</a><a href='?src=\ref[src];write=\ref[thing]'>Write</a>")
		else if(istype(thing, /obj/item/photo))
			LAZYADD(dat, "<a href='?src=\ref[src];look=\ref[thing]'>Look</a>")
		LAZYADD(dat, "<a href='?src=\ref[src];remove=\ref[thing]'>Remove</a></td></tr>")

	var/datum/browser/popup = new(user, "noticeboard-\ref[src]", "Noticeboard")
	popup.set_content(jointext(dat, null))
	popup.open()

/obj/structure/noticeboard/OnTopic(var/mob/user, var/list/href_list)

	if(href_list["read"])
		var/obj/item/paper/P = locate(href_list["read"])
		if(P && P.loc == src)
			P.interact(user)
		. = TOPIC_HANDLED

	if(href_list["look"])
		var/obj/item/photo/P = locate(href_list["look"])
		if(P && P.loc == src)
			P.interact(user)
		. = TOPIC_HANDLED

	if(href_list["remove"])
		remove_paper(locate(href_list["remove"]))
		add_fingerprint(user)
		. = TOPIC_REFRESH

	if(href_list["write"])
		var/obj/item/P = locate(href_list["write"])
		if(!P)
			return
		var/obj/item/pen = locate() in user.get_held_items()
		if(IS_PEN(pen))
			add_fingerprint(user)
			P.attackby(pen, user)
		else
			to_chat(user, SPAN_WARNING("You need a pen to write on \the [P]."))
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		interact(user)

/obj/structure/noticeboard/anomaly
	icon_state = "nboard05"

/obj/structure/noticeboard/anomaly/Initialize()
	. = ..()
	var/obj/item/paper/P = new(src, null,
		"<br>We keep test dummies in pens here for a reason, so standard procedure should be to activate newfound alien artifacts and place the two in close proximity. Promising items I might even approve monkey testing on.",
		"Memo RE: proper analysis procedure")
	P.apply_custom_stamp(overlay_image('icons/obj/bureaucracy.dmi', icon_state = "paper_stamped_rd", flags = RESET_COLOR), "Research Department")
	add_paper(P, skip_icon_update = TRUE)

	P = new(src, null,
		"Corasang,<br>the hands-on approach to gathering our samples may very well be slow at times, but it's safer than allowing the blundering miners to roll willy-nilly over our dig sites in their mechs, destroying everything in the process. And don't forget the excavation tools on your way out there!<br>- R.W",
		"Memo RE: materials gathering")
	P.apply_custom_stamp(overlay_image('icons/obj/bureaucracy.dmi', icon_state = "paper_stamped_rd", flags = RESET_COLOR), "Research Department")
	add_paper(P, skip_icon_update = TRUE)

	P = new(src, null,
		"Darion-<br><br>I don't care what his rank is, our business is that of science and knowledge - questions of moral application do not come into this. Sure, so there are those who would employ the energy-wave particles my modified device has managed to abscond for their own personal gain, but I can hardly see the practical benefits of some of these artifacts our benefactors left behind. Ward--",
		"Memo RE: ethical quandaries")
	P.apply_custom_stamp(overlay_image('icons/obj/bureaucracy.dmi', icon_state = "paper_stamped_rd", flags = RESET_COLOR), "Research Department")
	add_paper(P, skip_icon_update = TRUE)

	P = new(src, null,
		"how many times do i have to tell you people, these xeno-arch samples are del-i-cate, and should be handled so! careful application of a focussed, concentrated heat or some corrosive liquids should clear away the extraneous carbon matter, while application of an energy beam will most decidedly destroy it entirely - like someone did to the chemical dispenser! W, <b>the one who signs your paychecks</b>",
		"READ ME! Before you people destroy any more samples")
	P.apply_custom_stamp(overlay_image('icons/obj/bureaucracy.dmi', icon_state = "paper_stamped_rd", flags = RESET_COLOR), "Research Department")
	add_paper(P, skip_icon_update = TRUE)

	P = new(src, null,
		"Do you people think the anomaly suits are cheap to come by? I'm about a hair trigger away from instituting a log book for the damn things. Only wear them if you're going out for a dig, and for god's sake don't go tramping around in them unless you're field testing something, R",
		"Reminder regarding the anomalous material suits")
	P.apply_custom_stamp(overlay_image('icons/obj/bureaucracy.dmi', icon_state = "paper_stamped_rd", flags = RESET_COLOR), "Research Department")
	add_paper(P)
