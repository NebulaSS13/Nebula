/////////////////////////////////////////////////
// Carbon paper
/////////////////////////////////////////////////
/obj/item/paper/carbon
	name       = "sheets of paper with carbon paper"
	icon_state = "paper_stack"
	item_state = "paper"

/obj/item/paper/carbon/update_contents_overlays()
	if(length(info))
		add_overlay("paper_stack_words")

/obj/item/paper/carbon/proc/remove_copy(var/mob/user)
	var/obj/item/paper/original = Clone()
	var/obj/item/paper/copy     = Clone()
	LAZYSET(copy.metadata, "is_copy", TRUE)
	copy.set_color("#ffccff")

	//Silly hack to make all the text grayscale, since nobody is using standard css classes for pens we could override instead. Also, all using deprecated tags as well.
	var/copycontents = copy.info
	copycontents = replacetext(copycontents, "<font face=\"[original.deffont]\" color=", "<font face=\"[original.deffont]\" nocolor=")
	copycontents = replacetext(copycontents, "<font face=\"[original.crayonfont]\" color=", "<font face=\"[original.crayonfont]\" nocolor=")
	copy.set_content("<font color = #101010>[copycontents]</font>", "Copy - [original.name]")

	qdel(src)
	user.put_in_active_hand(original)
	user.put_in_hands(copy)
	return copy

/obj/item/paint_sprayer/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/carbon_paper_remove)

/////////////////////////////////////////////////
// Carbon Paper Alt Interactions
/////////////////////////////////////////////////
/decl/interaction_handler/carbon_paper_remove
	name = "remove carbon-copy"
	expected_target_type = /obj/item/paper/carbon

/decl/interaction_handler/carbon_paper_remove/invoked(obj/item/paper/carbon/target, mob/user)
	target.remove_copy(user)
