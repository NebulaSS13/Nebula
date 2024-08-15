#define HAND_LABELER_MODE_ADD    0 //Add a new label if possible
#define HAND_LABELER_MODE_REM    1 //Remove the last label
#define HAND_LABELER_MODE_REMALL 2 //Remove all labels
//Mode names
#define HAND_LABELER_SAFETY_TOGGLE    "Safety"
#define HAND_LABELER_MODE_ADD_NAME    "Label"
#define HAND_LABELER_MODE_REM_NAME    "Remove one"
#define HAND_LABELER_MODE_REMALL_NAME "Remove all"

#define LABEL_MATERIAL_COST 120 //units of matter a single label is worth

//////////////////////////////////////////////////////
// Hand Labeler
//////////////////////////////////////////////////////
/obj/item/hand_labeler
	name            = "hand labeler"
	icon            = 'icons/obj/items/hand_labeler.dmi'
	icon_state      = ICON_STATE_WORLD
	material        = /decl/material/solid/organic/plastic
	w_class         = ITEM_SIZE_SMALL
	item_flags      = ITEM_FLAG_NO_BLUDGEON
	matter          = list(
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT, //These things always got some metal parts
	)
	var/label                                  //What the labeler will label its target with
	var/labels_left      = 30
	var/tmp/max_labels   = 30                    //Maximum amount of label charges
	var/safety           = TRUE                  //Whether the safety is on or off. Set to FALSE to allow labeler to interact with things
	var/mode             = HAND_LABELER_MODE_ADD //What operation the labeler is set to do

/obj/item/hand_labeler/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(distance < 1)
		to_chat(user, safety? "Safety is on." : SPAN_WARNING("Safety is off!"))
		var/modename
		switch(mode)
			if(HAND_LABELER_MODE_ADD)
				modename = HAND_LABELER_MODE_ADD_NAME
			if(HAND_LABELER_MODE_REM)
				modename = HAND_LABELER_MODE_REM_NAME
			if(HAND_LABELER_MODE_REMALL)
				modename = HAND_LABELER_MODE_REMALL_NAME
		to_chat(user, "It's set to '[SPAN_ITALIC(modename)]' mode.")
		to_chat(user, "It has [get_labels_left()]/[max_labels] label(s).")
		if(length(label))
			to_chat(user, "Its label text reads '[SPAN_ITALIC(label)]'.")
	else
		to_chat(user, SPAN_NOTICE("You're too far away to tell much more."))

/obj/item/hand_labeler/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	return FALSE

/obj/item/hand_labeler/afterattack(atom/movable/A, mob/user, proximity)
	if(safety || !proximity || !istype(A) || A == loc)
		return

	switch(mode)
		if(HAND_LABELER_MODE_ADD)
			if(!get_labels_left())
				to_chat(user, SPAN_WARNING("No labels left."))
				return
			if(!length(label))
				to_chat(user, SPAN_WARNING("No label text set."))
				return
			if(A.attach_label(user, src, label))
				rem_paper_labels(1)

		if(HAND_LABELER_MODE_REM, HAND_LABELER_MODE_REMALL)
			var/datum/extension/labels/L = get_extension(A, /datum/extension/labels)
			if(!LAZYLEN(L?.labels))
				to_chat(user, SPAN_WARNING("\The [A] is not labeled!"))
				return

			var/nb_removed
			var/removed    = L.labels[L.labels.len]
			if(mode == HAND_LABELER_MODE_REMALL)
				L.RemoveAllLabels()
				nb_removed = length(L.labels)
			else
				L.RemoveLabel(user, L.labels[L.labels.len])
				nb_removed = 1

			user.visible_message(
				SPAN_NOTICE("[user] removes [nb_removed > 1? "some labels" : "a label"] from \the [A]."),
				SPAN_NOTICE("You remove [nb_removed > 1? "[nb_removed] labels" : "the '[removed]' label"] from \the [A].")
			)
			playsound(loc, 'sound/items/poster_ripped.ogg', 50, TRUE)

	//Update stuff
	A.queue_icon_update() //Ask them to update their icons if possible
	update_icon()

/obj/item/hand_labeler/proc/show_action_radial_menu(var/mob/user)
	//#TODO: Cache some of that stuff.
	var/image/btn_power = image('icons/screen/radial.dmi', icon_state = safety? "radial_power" : "radial_power_off")
	btn_power.plane = FLOAT_PLANE
	btn_power.layer = FLOAT_LAYER
	btn_power.name  = "Turn Safety [safety? "Off": "On"]"
	var/image/btn_set_label = new()
	btn_set_label.appearance = src
	btn_set_label.plane = FLOAT_PLANE
	btn_set_label.layer = FLOAT_LAYER
	btn_set_label.name  = "Set Label Text"
	var/image/btn_rem_one = new()
	btn_rem_one.appearance = src
	btn_rem_one.plane = FLOAT_PLANE
	btn_rem_one.layer = FLOAT_LAYER
	btn_rem_one.name  = "Remove One"
	var/image/btn_rem_all = new()
	btn_rem_all.appearance = src
	btn_rem_all.plane = FLOAT_PLANE
	btn_rem_all.layer = FLOAT_LAYER
	btn_rem_all.name  = "Remove All"

	var/list/choices = list(
		HAND_LABELER_SAFETY_TOGGLE    = btn_power,
		HAND_LABELER_MODE_ADD_NAME    = btn_set_label,
		HAND_LABELER_MODE_REM_NAME    = btn_rem_one,
		HAND_LABELER_MODE_REMALL_NAME = btn_rem_all,
	)
	return show_radial_menu(user, user, choices, use_labels = TRUE)

/obj/item/hand_labeler/attack_self(mob/user)
	var/choice = show_action_radial_menu(user)
	switch(choice)
		if(HAND_LABELER_SAFETY_TOGGLE)
			safety = !safety
			playsound(user, 'sound/machines/click.ogg', 30, TRUE)
			to_chat(loc, SPAN_NOTICE("You toggle the safety [safety? "on" : "off"]!"))

		if(HAND_LABELER_MODE_ADD_NAME)
			to_chat(user, SPAN_NOTICE("You switch to labeling mode."))
			var/str = sanitize_safe(input(user,"Label text?", "Set label", label), MAX_LNAME_LEN)
			if(!str || !length(str))
				return
			label = str
			mode = HAND_LABELER_MODE_ADD
			to_chat(user, SPAN_NOTICE("You set the label text to '[str]'."))

		if(HAND_LABELER_MODE_REMALL_NAME, HAND_LABELER_MODE_REM_NAME)
			mode = (choice == HAND_LABELER_MODE_REMALL_NAME)? HAND_LABELER_MODE_REMALL : HAND_LABELER_MODE_REM
			to_chat(user, SPAN_NOTICE("You switch to remove [mode == HAND_LABELER_MODE_REMALL? "all labels" : "one label"] mode."))
			playsound(loc, 'sound/effects/pop.ogg', 10)
			if(prob(5))
				spark_at(src, amount = 2)

	update_icon()
	return TRUE

/obj/item/hand_labeler/attackby(obj/item/W, mob/user)

	//Allow refilling with paper sheets too
	if(istype(W, /obj/item/paper))
		var/obj/item/paper/P = W
		if(!P.is_blank())
			to_chat(user, SPAN_WARNING("\The [P] is not blank. You can't use that for refilling \the [src]."))
			return

		var/incoming_amt = LAZYACCESS(P.matter, /decl/material/solid/organic/paper)
		var/current_amt = LAZYACCESS(matter, /decl/material/solid/organic/paper)
		var/label_added = incoming_amt / LABEL_MATERIAL_COST

		if(incoming_amt < LABEL_MATERIAL_COST)
			to_chat(user, SPAN_WARNING("\The [P] does not contains enough paper."))
			return
		if(((incoming_amt + current_amt) / LABEL_MATERIAL_COST) > max_labels)
			to_chat(user, SPAN_WARNING("There's not enough room in \the [src] for the [label_added] label(s) \the [P] is worth."))
			return
		if(!user.do_skilled(2 SECONDS, SKILL_LITERACY, src) || (QDELETED(W) || QDELETED(src)))
			return

		to_chat(user, SPAN_NOTICE("You slice \the [P] into [label_added] small strips and insert them into \the [src]'s paper feed."))
		add_paper_labels(label_added)
		qdel(W)
		update_icon()
		return TRUE

	//Allow reloading from stacks much faster
	else if(istype(W, /obj/item/stack/material))
		var/obj/item/stack/material/ST = W
		var/decl/material/M = ST.material
		var/max_accepted_labels = max_labels - get_labels_left()
		var/max_accepted_units  = max_accepted_labels * LABEL_MATERIAL_COST
		var/available_units     = ST.get_amount() * SHEET_MATERIAL_AMOUNT
		var/added_labels        = 0

		if(available_units > max_accepted_units)
			//Take only what's needed
			var/needed_sheets  = ceil(max_accepted_units / SHEET_MATERIAL_AMOUNT)
			var/leftover_units = max_accepted_units % SHEET_MATERIAL_AMOUNT
			ST.use(needed_sheets)
			//Drop the extra as shards
			if(leftover_units)
				M.place_cuttings(get_turf(user), leftover_units)
				to_chat(user, SPAN_NOTICE("Some leftover [ST.singular_name] cuttings fall to the ground..."))
			add_paper_labels(max_accepted_labels)
			added_labels = max_accepted_labels
			to_chat(user, SPAN_NOTICE("You use [max_accepted_units/SHEET_MATERIAL_AMOUNT] [ST.plural_name] to refill \the [src] with [added_labels] label(s)."))

		else if(available_units > LABEL_MATERIAL_COST)
			//Take all that's available
			ST.use(ceil(available_units/SHEET_MATERIAL_AMOUNT))
			added_labels = round(available_units / LABEL_MATERIAL_COST)
			add_paper_labels(added_labels)
			to_chat(user, SPAN_NOTICE("You use [ceil(available_units/SHEET_MATERIAL_AMOUNT)] [ST.plural_name] to refill \the [src] with [added_labels] label(s)."))
		else
			//Abort because not enough materials for even a single label
			to_chat(user, SPAN_WARNING("There's not enough [ST.plural_name] in \the [ST] to refil \the [src]!"))
			return

		update_icon()
		return TRUE
	return ..()

/**Gets the amount of labels we can apply with our current supply of paper. */
/obj/item/hand_labeler/proc/get_labels_left()
	return labels_left

/**Adds a paper label to the labeler if there's room for it. */
/obj/item/hand_labeler/proc/add_paper_labels(var/amount)
	if(get_labels_left() >= max_labels || amount <= 0)
		return FALSE
	labels_left = clamp((labels_left + amount), 0, max_labels)
	update_icon()
	return TRUE

/**Remove a paper label from the labeler if there's any. */
/obj/item/hand_labeler/proc/rem_paper_labels(var/amount)
	if(get_labels_left() <= 0 || amount <= 0)
		return FALSE
	labels_left = clamp((labels_left - amount), 0, max_labels)
	update_icon()
	return TRUE

/obj/item/hand_labeler/dump_contents(atom/forced_loc = loc, mob/user)
	. = ..()
	//Dump label paper left
	if(labels_left > 0)
		var/decl/material/M = GET_DECL(/decl/material/solid/organic/paper)
		var/turf/T          = get_turf(forced_loc)
		var/total_sheets    = round((labels_left * LABEL_MATERIAL_COST) / SHEET_MATERIAL_AMOUNT)
		var/leftovers       = round((labels_left * LABEL_MATERIAL_COST) % SHEET_MATERIAL_AMOUNT)
		M.create_object(T, total_sheets)
		if(leftovers > 0)
			M.place_cuttings(T, leftovers)

////////////////////////////////////////////////////////////
// Attach Label Overrides
////////////////////////////////////////////////////////////
/atom/proc/attach_label(var/mob/user, var/atom/labeler, var/label_text)
	to_chat(user, SPAN_WARNING("The label refuses to stick to \the [src]."))
	return FALSE

/mob/observer/attach_label(mob/user, atom/labeler, label_text)
	to_chat(user, SPAN_DANGER("\The [labeler] passes through \the [src]!"))
	return FALSE

/obj/machinery/portable_atmospherics/hydroponics/attach_label(mob/user, atom/labeler, label_text)
	if(!mechanical)
		to_chat(user, SPAN_WARNING("How are you going to label that?"))
		return
	. = ..()
	update_icon()

/obj/attach_label(mob/user, atom/labeler, label_text)
	if(!simulated)
		return
	var/datum/extension/labels/L = get_or_create_extension(src, /datum/extension/labels)
	return L.AttachLabel(user, label_text)

#undef HAND_LABELER_MODE_ADD
#undef HAND_LABELER_MODE_REM
#undef HAND_LABELER_MODE_REMALL
#undef HAND_LABELER_SAFETY_TOGGLE
#undef HAND_LABELER_MODE_ADD_NAME
#undef HAND_LABELER_MODE_REM_NAME
#undef HAND_LABELER_MODE_REMALL_NAME
#undef LABEL_MATERIAL_COST