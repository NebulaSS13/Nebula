// DRONE ABILITIES
/mob/living/silicon/robot/drone/verb/set_mail_tag()
	set name = "Set Mail Tag"
	set desc = "Tag yourself for delivery through the disposals system."
	set category = "Silicon Commands"

	var/choice = alert(usr, "Enter a custom destination, or pick one from the list?", "", "Custom", "List", "Cancel")
	var/datum/extension/sorting_tag/ST
	var/new_tag

	if(choice == "Custom")
		ST = get_extension(src, /datum/extension/sorting_tag)
		new_tag = input(usr, "Enter custom destination tag:", "Custom Destination", ST?.destination)
	else if(choice == "List")
		new_tag = input("Select the desired destination.", "Set Mail Tag", null) as null|anything in global.tagger_locations
	else
		return

	if(!new_tag)
		remove_extension(src, /datum/extension/sorting_tag)
		return
	ST = get_or_create_extension(src, /datum/extension/sorting_tag)
	ST.destination = new_tag
	to_chat(src, SPAN_NOTICE("You configure your internal beacon, tagging yourself for delivery to '[new_tag]'."))

	//Auto flush if we use this verb inside a disposal chute.
	var/obj/machinery/disposal/D = src.loc
	if(istype(D))
		to_chat(src, SPAN_NOTICE("\The [D] acknowledges your signal."))
		D.flush_count = D.flush_every_ticks
