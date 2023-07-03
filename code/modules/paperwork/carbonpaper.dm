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
	//Make a new paper that copies our contents
	var/obj/item/paper/original = copy_to(new /obj/item/paper)
	var/obj/item/paper/copy     = original.Clone()
	LAZYSET(copy.metadata, "is_copy", TRUE)
	copy.set_color("#ffccff")

	//Make all stamps on the copy be grayscale
	for(var/image/stamp in copy.applied_stamps)
		stamp.filters += filter(type = "color", color = list(1,0,0, 0,0,0, 0,0,1), space = FILTER_COLOR_HSV)
		stamp.appearance_flags |= RESET_COLOR

	//Silly hack to make all the text grayscale, since nobody is using standard css classes for pens we could override instead. Also, all using deprecated tags as well.
	var/copycontents = copy.info
	copycontents = replacetext(copycontents, "<font face=\"[original.deffont]\" color=", "<font face=\"[original.deffont]\" nocolor=")
	copycontents = replacetext(copycontents, "<font face=\"[original.crayonfont]\" color=", "<font face=\"[original.crayonfont]\" nocolor=")
	copy.set_content("<font color = #101010>[copycontents]</font>", (original.name != initial(original.name))? "Copy - [original.name]" : null)
	original.update_icon()

	qdel(src)
	user.put_in_active_hand(original)
	user.put_in_hands(copy)
	return copy

///Copy our contents to a regular sheet of paper
/obj/item/paper/carbon/proc/copy_to(var/obj/item/paper/other)
	//Don't copy the default name of the carbon paper
	if(name != initial(name))
		other.SetName(name)
	other.fields             = fields
	other.last_modified_ckey = last_modified_ckey
	other.free_space         = free_space
	other.rigged             = rigged
	other.is_crumpled        = is_crumpled
	other.info               = info
	other.stamp_text         = stamp_text
	other.applied_stamps     = LAZYLEN(applied_stamps)? listDeepClone(applied_stamps) : null
	other.metadata           = LAZYLEN(metadata)?       listDeepClone(metadata, TRUE) : null
	other.updateinfolinks()
	return other

/obj/item/paper/carbon/get_alt_interactions(mob/user)
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
