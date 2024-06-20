/proc/possess(obj/O as obj)
	set name = "Possess Obj"
	set category = "Object"

	if(istype(O,/obj/effect/singularity))
		if(get_config_value(/decl/config/toggle/forbid_singulo_possession))
			to_chat(usr, "It is forbidden to possess singularities.")
			return

	log_and_message_admins("has possessed [O]")

	if(!usr.control_object) //If you're not already possessing something...
		usr.name_archive = usr.real_name

	usr.forceMove(O)
	usr.real_name = O.name
	usr.SetName(O.name)
	usr.client.eye = O
	usr.control_object = O
	usr.ReplaceMovementHandler(/datum/movement_handler/mob/admin_possess)
	SSstatistics.add_field_details("admin_verb","PO") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/release(obj/O)
	set name = "Release Obj"
	set category = "Object"

	if(usr.control_object && usr.name_archive) //if you have a name archived and if you are actually relassing an object
		usr.RemoveMovementHandler(/datum/movement_handler/mob/admin_possess)
		usr.real_name = usr.name_archive
		usr.SetName(usr.real_name)
		if(ishuman(usr))
			var/mob/living/human/H = usr
			H.SetName(H.get_visible_name())

	usr.forceMove(O.loc) // Appear where the object you were controlling is -- TLE
	usr.client.eye = usr
	usr.control_object = null
	SSstatistics.add_field_details("admin_verb","RO") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
