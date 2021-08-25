// DRONE ABILITIES
/mob/living/silicon/robot/drone/verb/set_mail_tag()
	set name = "Set Mail Tag"
	set desc = "Tag yourself for delivery through the disposals system."
	set category = "Silicon Commands"

	var/new_tag = input("Select the desired destination.", "Set Mail Tag", null) as null|anything in global.tagger_locations

	if(!new_tag)
		mail_destination = ""
		return

	to_chat(src, "<span class='notice'>You configure your internal beacon, tagging yourself for delivery to '[new_tag]'.</span>")
	mail_destination = new_tag

	//Auto flush if we use this verb inside a disposal chute.
	var/obj/machinery/disposal/D = src.loc
	if(istype(D))
		to_chat(src, "<span class='notice'>\The [D] acknowledges your signal.</span>")
		D.flush_count = D.flush_every_ticks
