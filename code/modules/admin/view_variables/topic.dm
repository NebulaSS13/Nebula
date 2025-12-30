/client/proc/view_var_Topic(href, href_list, hsrc)
	//This should all be moved over to datum/admins/Topic() or something ~Carn
	if( (usr.client != src) || !src.holder )
		return
	if(href_list["Vars"])
		debug_variables(locate(href_list["Vars"]))

	//~CARN: for renaming mobs (updates their name, real_name, mind.name, their ID/PDA and datacore records).
	else if(href_list["rename"])
		if(!check_rights(R_VAREDIT))	return

		var/mob/victim = locate(href_list["rename"])
		if(!istype(victim))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		var/new_name = sanitize(input(usr,"What would you like to name this mob?","Input a name",victim.real_name) as text|null, MAX_NAME_LEN)
		if(!new_name || !victim)	return

		message_admins("Admin [key_name_admin(usr)] renamed [key_name_admin(victim)] to [new_name].")
		victim.fully_replace_character_name(new_name)
		href_list["datumrefresh"] = href_list["rename"]

	else if(href_list["dressup"])
		if(!check_rights(R_VAREDIT))	return

		var/mob/living/human/victim = locate(href_list["dressup"])
		if(!istype(victim))
			to_chat(usr, "This can only be used on instances of type /mob/living/human")
			return
		var/decl/outfit/outfit = input("Select outfit.", "Select equipment.") as null|anything in decls_repository.get_decls_of_subtype_unassociated(/decl/outfit)
		if(!outfit)
			return

		dressup_human(victim, outfit, TRUE)

	else if(href_list["varnameedit"] && href_list["datumedit"])
		if(!check_rights(R_VAREDIT))	return

		var/datum_to_edit = locate(href_list["datumedit"])
		if(!istype(datum_to_edit, /datum) && !istype(datum_to_edit, /client))
			to_chat(usr, "This can only be used on instances of types /client or /datum")
			return

		modify_variables(datum_to_edit, href_list["varnameedit"], 1)

	else if(href_list["varnamechange"] && href_list["datumchange"])
		if(!check_rights(R_VAREDIT))	return

		var/datum_to_edit = locate(href_list["datumchange"])
		if(!istype(datum_to_edit,/datum) && !istype(datum_to_edit,/client))
			to_chat(usr, "This can only be used on instances of types /client or /datum")
			return

		modify_variables(datum_to_edit, href_list["varnamechange"], 0)

	else if(href_list["varnamemass"] && href_list["datummass"])
		if(!check_rights(R_VAREDIT))	return

		var/atom/atom_to_edit = locate(href_list["datummass"])
		if(!isatom(atom_to_edit))
			to_chat(usr, "This can only be used on instances of type /atom")
			return

		cmd_mass_modify_object_variables(atom_to_edit, href_list["varnamemass"])

	else if(href_list["datumwatch"] && href_list["varnamewatch"])
		var/datum/datum_to_edit = locate(href_list["datumwatch"])
		if(datum_to_edit)
			if(!watched_variables[datum_to_edit])
				watched_variables[datum_to_edit] = list()
			watched_variables[datum_to_edit] |= href_list["varnamewatch"]
			watched_variables()

			if(!watched_variables_window.is_processing)
				START_PROCESSING(SSprocessing, watched_variables_window)

	else if(href_list["datumunwatch"] && href_list["varnameunwatch"])
		var/datum/datum_to_edit = locate(href_list["datumunwatch"])
		if(datum_to_edit && watched_variables[datum_to_edit])
			watched_variables[datum_to_edit] -= href_list["varnameunwatch"]
			var/list/datums_watched_vars = watched_variables[datum_to_edit]
			if(!datums_watched_vars.len)
				watched_variables -= datum_to_edit
		if(!watched_variables.len && watched_variables_window.is_processing)
			STOP_PROCESSING(SSprocessing, watched_variables_window)

	else if(href_list["mob_player_panel"])
		if(!check_rights(0))	return

		var/mob/victim = locate(href_list["mob_player_panel"])
		if(!istype(victim))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		src.holder.show_player_panel(victim)
		href_list["datumrefresh"] = href_list["mob_player_panel"]

	else if(href_list["godmode"])
		if(!check_rights(R_REJUVENATE))	return

		var/mob/victim = locate(href_list["godmode"])
		if(!istype(victim))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		src.cmd_admin_godmode(victim)
		href_list["datumrefresh"] = href_list["godmode"]

	else if(href_list["gib"])
		if(!check_rights(0))	return

		var/mob/victim = locate(href_list["gib"])
		if(!istype(victim))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		src.cmd_admin_gib(victim)

	else if(href_list["drop_everything"])
		if(!check_rights(R_DEBUG|R_ADMIN))	return

		var/mob/victim = locate(href_list["drop_everything"])
		if(!istype(victim))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		if(usr.client)
			usr.client.cmd_admin_drop_everything(victim)

	else if(href_list["direct_control"])
		if(!check_rights(0))	return

		var/mob/victim = locate(href_list["direct_control"])
		if(!istype(victim))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		if(usr.client)
			usr.client.cmd_assume_direct_control(victim)

	else if(href_list["delthis"])
		if(!check_rights(R_DEBUG|R_SERVER))	return

		var/obj/object = locate(href_list["delthis"])
		if(!isobj(object))
			to_chat(usr, "This can only be used on instances of type /obj")
			return
		cmd_admin_delete(object)

	else if(href_list["delall"])
		if(!check_rights(R_DEBUG|R_SERVER))	return

		var/obj/object = locate(href_list["delall"])
		if(!isobj(object))
			to_chat(usr, "This can only be used on instances of type /obj")
			return

		var/action_type = alert("Strict type ([object.type]) or type and all subtypes?",,"Strict type","Type and subtypes","Cancel")
		if(action_type == "Cancel" || !action_type)
			return

		if(alert("Are you really sure you want to delete all objects of type [object.type]?",,"Yes","No") != "Yes")
			return

		if(alert("Second confirmation required. Delete?",,"Yes","No") != "Yes")
			return

		var/type_to_delete = object.type
		switch(action_type)
			if("Strict type")
				var/count = 0
				for(var/obj/deleted_object in world)
					if(deleted_object.type == type_to_delete)
						count++
						qdel(deleted_object)
				if(!count)
					to_chat(usr, "No objects of this type exist")
					return
				log_admin("[key_name(usr)] deleted all objects of type [type_to_delete] ([count] objects deleted)")
				message_admins("<span class='notice'>[key_name(usr)] deleted all objects of type [type_to_delete] ([count] objects deleted)</span>")
			if("Type and subtypes")
				var/count = 0
				for(var/obj/deleted_object in world)
					if(istype(deleted_object, type_to_delete))
						count++
						qdel(deleted_object)
				if(!count)
					to_chat(usr, "No objects of this type exist")
					return
				log_admin("[key_name(usr)] deleted all objects of type or subtype of [type_to_delete] ([count] objects deleted)")
				message_admins("<span class='notice'>[key_name(usr)] deleted all objects of type or subtype of [type_to_delete] ([count] objects deleted)</span>")

	else if(href_list["explode"])
		if(!check_rights(R_DEBUG|R_FUN))	return

		var/atom/atom_to_explode = locate(href_list["explode"])
		if(!isobj(atom_to_explode) && !ismob(atom_to_explode) && !isturf(atom_to_explode))
			to_chat(usr, "This can only be done to instances of type /obj, /mob and /turf")
			return

		src.cmd_admin_explosion(atom_to_explode)
		href_list["datumrefresh"] = href_list["explode"]

	else if(href_list["emp"])
		if(!check_rights(R_DEBUG|R_FUN))	return

		var/atom/atom_to_emp = locate(href_list["emp"])
		if(!isobj(atom_to_emp) && !ismob(atom_to_emp) && !isturf(atom_to_emp))
			to_chat(usr, "This can only be done to instances of type /obj, /mob and /turf")
			return

		src.cmd_admin_emp(atom_to_emp)
		href_list["datumrefresh"] = href_list["emp"]

	else if(href_list["mark_object"])
		if(!check_rights(0))	return

		var/datum/datum_to_mark = locate(href_list["mark_object"])
		if(!istype(datum_to_mark))
			to_chat(usr, "This can only be done to instances of type /datum")
			return

		src.holder.marked_datum_weak = weakref(datum_to_mark)
		href_list["datumrefresh"] = href_list["mark_object"]

	else if(href_list["rotatedatum"])
		if(!check_rights(0))	return

		var/atom/atom_to_rotate = locate(href_list["rotatedatum"])
		if(!isatom(atom_to_rotate))
			to_chat(usr, "This can only be done to instances of type /atom")
			return

		switch(href_list["rotatedir"])
			if("right")	atom_to_rotate.set_dir(turn(atom_to_rotate.dir, -45))
			if("left")	atom_to_rotate.set_dir(turn(atom_to_rotate.dir, 45))
		href_list["datumrefresh"] = href_list["rotatedatum"]

	else if(href_list["makemonkey"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/human/victim = locate(href_list["makemonkey"])
		if(!istype(victim))
			to_chat(usr, "This can only be done to instances of type /mob/living/human")
			return

		if(alert("Confirm mob type change?",,"Transform","Cancel") != "Transform")	return
		if(!victim)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		holder.Topic(href, list("monkeyone"=href_list["makemonkey"]))

	else if(href_list["makerobot"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/human/victim = locate(href_list["makerobot"])
		if(!istype(victim))
			to_chat(usr, "This can only be done to instances of type /mob/living/human")
			return

		if(alert("Confirm mob type change?",,"Transform","Cancel") != "Transform")	return
		if(!victim)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		holder.Topic(href, list("makerobot"=href_list["makerobot"]))

	else if(href_list["makeai"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/human/victim = locate(href_list["makeai"])
		if(!istype(victim))
			to_chat(usr, "This can only be done to instances of type /mob/living/human")
			return

		if(alert("Confirm mob type change?",,"Transform","Cancel") != "Transform")	return
		if(!victim)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		holder.Topic(href, list("makeai"=href_list["makeai"]))

	else if(href_list["addailment"])

		var/mob/living/human/victim = locate(href_list["addailment"])
		if(!istype(victim))
			to_chat(usr, "This can only be done to instances of type /mob/living/human")
			return
		var/obj/item/organ/limb = input("Select a limb to add the ailment to.", "Add Ailment") as null|anything in victim.get_organs()
		if(QDELETED(victim) || QDELETED(limb) || limb.owner != victim)
			return
		var/list/possible_ailments = list()
		for(var/atype in subtypesof(/datum/ailment))
			var/datum/ailment/ailment = get_ailment_reference(atype) // will not get abstract ailments
			if(ailment && ailment.can_apply_to(limb))
				possible_ailments |= ailment

		var/datum/ailment/ailment = input("Select an ailment type to add.", "Add Ailment") as null|anything in possible_ailments
		if(!istype(ailment))
			return
		if(!QDELETED(victim) && !QDELETED(limb) && limb.owner == victim && limb.add_ailment(ailment))
			to_chat(usr, SPAN_NOTICE("Added [ailment] to \the [victim]."))
		else
			to_chat(usr, SPAN_WARNING("Failed to add [ailment] to \the [victim]."))
		return

	else if(href_list["remailment"])

		var/mob/living/human/victim = locate(href_list["remailment"])
		if(!istype(victim))
			to_chat(usr, "This can only be done to instances of type /mob/living/human")
			return
		var/list/all_ailments = list()
		for(var/obj/item/organ/limb in victim.get_organs())
			for(var/datum/ailment/ailment in limb.ailments)
				all_ailments["[ailment.name] - [limb.name]"] = ailment

		var/datum/ailment/ailment = input("Which ailment do you wish to remove?", "Removing Ailment") as null|anything in all_ailments
		if(!ailment)
			return
		ailment = all_ailments[ailment]
		if(istype(ailment) && ailment.organ && ailment.organ.owner == victim && ailment.organ.remove_ailment(ailment))
			to_chat(usr, SPAN_NOTICE("Removed [ailment] from \the [victim]."))
		else
			to_chat(usr, SPAN_WARNING("Failed to remove [ailment] from \the [victim]."))
		return

	else if(href_list["setspecies"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/human/victim = locate(href_list["setspecies"])
		if(!istype(victim))
			to_chat(usr, SPAN_WARNING("This can only be done to instances of type /mob/living/human"))
			return

		var/decl/species/new_species = input("Please choose a new species.","Species",null) as null|anything in decls_repository.get_decls_of_subtype_unassociated(/decl/species)

		if(!victim)
			to_chat(usr, SPAN_WARNING("Mob doesn't exist anymore"))
			return

		if(!new_species)
			return

		if(victim.change_species(new_species.uid))
			to_chat(usr, SPAN_NOTICE("Set species of \the [victim] to [victim.species]."))
		else
			to_chat(usr, SPAN_WARNING("Failed! Something went wrong."))

	else if(href_list["setbodytype"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/human/victim = locate(href_list["setbodytype"])
		if(!istype(victim))
			to_chat(usr, SPAN_WARNING("This can only be done to instances of type /mob/living/human"))
			return

		var/new_bodytype = input("Please choose a new bodytype.","Bodytype",null) as null|anything in victim.species.available_bodytypes

		if(!new_bodytype)
			return

		if(!victim)
			to_chat(usr, SPAN_WARNING("Mob doesn't exist anymore"))
			return

		if(!(new_bodytype in victim.species.available_bodytypes))
			to_chat(usr, SPAN_WARNING("Bodytype is no longer available to the mob species."))

		if(victim.set_bodytype(new_bodytype))
			to_chat(usr, SPAN_NOTICE("Set bodytype of [victim] to [victim.get_bodytype()]."))
		else
			to_chat(usr, SPAN_WARNING("Failed! Something went wrong."))

	else if(href_list["addlanguage"])
		if(!check_rights(R_SPAWN))	return

		var/mob/victim = locate(href_list["addlanguage"])
		if(!istype(victim))
			to_chat(usr, "This can only be done to instances of type /mob")
			return

		var/list/language_types = decls_repository.get_decls_of_subtype(/decl/language)
		var/new_language = input("Please choose a language to add.","Language",null) as null|anything in language_types

		if(!new_language)
			return

		if(!victim)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(victim.add_language(new_language))
			to_chat(usr, "Added [new_language] to [victim].")
		else
			to_chat(usr, "Mob already knows that language.")

	else if(href_list["remlanguage"])
		if(!check_rights(R_SPAWN))	return

		var/mob/victim = locate(href_list["remlanguage"])
		if(!istype(victim))
			to_chat(usr, "This can only be done to instances of type /mob")
			return

		if(!victim.languages.len)
			to_chat(usr, "This mob knows no languages.")
			return

		var/decl/language/rem_language = input("Please choose a language to remove.","Language",null) as null|anything in victim.languages

		if(!rem_language)
			return

		if(!victim)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(victim.remove_language(rem_language.type))
			to_chat(usr, "Removed [rem_language] from [victim].")
		else
			to_chat(usr, "Mob doesn't know that language.")

	else if(href_list["addverb"])
		if(!check_rights(R_DEBUG))      return

		var/mob/living/victim = locate(href_list["addverb"])

		if(!istype(victim))
			to_chat(usr, "This can only be done to instances of type /mob/living")
			return
		var/list/possibleverbs = list()
		possibleverbs += "Cancel" 								// One for the top...
		possibleverbs += typesof(/mob/proc, /mob/verb, /mob/living/proc, /mob/living/verb)
		if(ishuman(victim))
			possibleverbs += typesof(/mob/living/human/verb, /mob/living/human/proc)
		else if(isrobot(victim))
			possibleverbs += typesof(/mob/living/silicon/proc, /mob/living/silicon/robot/proc, /mob/living/silicon/robot/verb)
		else if(isAI(victim))
			possibleverbs += typesof(/mob/living/silicon/proc, /mob/living/silicon/ai/proc, /mob/living/silicon/ai/verb)
		possibleverbs -= victim.verbs
		possibleverbs += "Cancel" 								// ...And one for the bottom

		var/verb = input("Select a verb!", "Verbs",null) as null|anything in possibleverbs
		if(!victim)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		if(!verb || verb == "Cancel")
			return
		else
			victim.verbs += verb

	else if(href_list["remverb"])
		if(!check_rights(R_DEBUG))      return

		var/mob/victim = locate(href_list["remverb"])

		if(!istype(victim))
			to_chat(usr, "This can only be done to instances of type /mob")
			return
		var/verb = input("Please choose a verb to remove.","Verbs",null) as null|anything in victim.verbs
		if(!victim)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		if(!verb)
			return
		else
			victim.verbs -= verb

	else if(href_list["addorgan"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/victim = locate(href_list["addorgan"])
		if(!istype(victim))
			to_chat(usr, "This can only be done to instances of type /mob/living")
			return

		if(!length(victim.get_external_organs())) // quick and dirty check for organs; should always be >0 for humanlike mobs.
			to_chat(usr, "This can only be done to mobs that implement organs!")
			return

		var/obj/item/organ/new_organ = input("Please choose an organ to add.","Organ",null) as null|anything in subtypesof(/obj/item/organ)
		if(!new_organ) return

		if(!victim)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(locate(new_organ) in victim.get_internal_organs())
			to_chat(usr, "Mob already has that organ.")
			return

		var/obj/item/organ/target_organ = victim.get_organ(initial(new_organ.parent_organ))
		if(!target_organ)
			to_chat(usr, "Mob doesn't have \a [target_organ] to install that in.")
			return
		var/obj/item/organ/organ_instance = new new_organ(victim)
		victim.add_organ(organ_instance, target_organ)


	else if(href_list["remorgan"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/victim = locate(href_list["remorgan"])
		if(!istype(victim))
			to_chat(usr, "This can only be done to instances of type /mob/living")
			return

		if(!length(victim.get_external_organs())) // quick and dirty check for organs; should always be >0 for humanlike mobs.
			to_chat(usr, "This can only be done to mobs that implement organs!")
			return

		var/obj/item/organ/rem_organ = input("Please choose an organ to remove.","Organ",null) as null|anything in victim.get_internal_organs()

		if(!victim)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(!(locate(rem_organ) in victim.get_internal_organs()))
			to_chat(usr, "Mob does not have that organ.")
			return

		to_chat(usr, "Removed [rem_organ] from [victim].")
		victim.remove_organ(rem_organ)
		if(!QDELETED(rem_organ))
			qdel(rem_organ)

	else if(href_list["fix_nano"])
		if(!check_rights(R_DEBUG)) return

		var/mob/victim = locate(href_list["fix_nano"])

		if(!istype(victim) || !victim.client)
			to_chat(usr, "This can only be done on mobs with clients")
			return

		SSnano.close_uis(victim)
		victim.client.cache.Cut()
		var/datum/asset/assets = get_asset_datum(/datum/asset/nanoui)
		assets.send(victim)

		to_chat(usr, "Resource files sent")
		to_chat(victim, "Your NanoUI Resource files have been refreshed")

		log_admin("[key_name(usr)] resent the NanoUI resource files to [key_name(victim)] ")

	else if(href_list["updateicon"])
		if(!check_rights(0))
			return
		var/mob/victim = locate(href_list["updateicon"])
		if(!ismob(victim))
			to_chat(usr, "This can only be done to instances of type /mob")
			return
		victim.update_icon()

	else if(href_list["refreshoverlays"])
		if(!check_rights(0))
			return
		var/mob/living/human/victim = locate(href_list["refreshoverlays"])
		if(!istype(victim))
			to_chat(usr, "This can only be done to instances of type /mob/living/human")
			return
		victim.try_refresh_visible_overlays()

	else if(href_list["adjustDamage"] && href_list["mobToDamage"])
		if(!check_rights(R_DEBUG|R_ADMIN|R_FUN))	return

		var/mob/living/victim = locate(href_list["mobToDamage"])
		if(!istype(victim)) return

		var/Text = href_list["adjustDamage"]

		var/amount =  input("Deal how much damage to mob? (Negative values here heal)","Adjust [Text]loss",0) as num

		if(!victim)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(istext(Text))
			victim.take_damage(amount, Text)
		else
			to_chat(usr, "You caused an error. DEBUG: Text:[Text] Mob:[victim]")
			return

		if(amount != 0)
			log_admin("[key_name(usr)] dealt [amount] amount of [Text] damage to [victim]")
			message_admins("<span class='notice'>[key_name(usr)] dealt [amount] amount of [Text] damage to [victim]</span>")
			href_list["datumrefresh"] = href_list["mobToDamage"]

	else if(href_list["call_proc"])
		var/datum/proc_callee = locate(href_list["call_proc"])
		if(istype(proc_callee) || istype(proc_callee, /client)) // can call on clients too, not just datums
			callproc_targetpicked(1, proc_callee)

	else if(href_list["addstressor"])
		if(!check_rights(R_DEBUG))
			return
		var/mob/living/victim = locate(href_list["addstressor"])
		if(!istype(victim))
			return
		var/static/list/_all_stressors
		if(!_all_stressors)
			_all_stressors = SSmanaged_instances.get_category(/datum/stressor)
		var/datum/stressor/stressor = input("Select a stressor to add or refresh.", "Add Stressor") as null|anything in _all_stressors
		if(!stressor)
			return
		var/duration = clamp(input("Enter a duration ([STRESSOR_DURATION_INDEFINITE] for permanent).", "Add Stressor") as num|null, STRESSOR_DURATION_INDEFINITE, INFINITY)
		if(duration && victim.add_stressor(stressor, duration))
			log_and_message_admins("added [stressor] to \the [victim] for duration [duration].")

	else if(href_list["removestressor"])
		if(!check_rights(R_DEBUG))
			return
		var/mob/living/victim = locate(href_list["removestressor"])
		if(!istype(victim))
			return
		if(!length(victim.stressors))
			to_chat(usr, "Nothing to remove.")
			return
		var/datum/stressor/stressor = input("Select a stressor to remove.", "Remove Stressor") as null|anything in victim.stressors
		if(victim.remove_stressor(stressor))
			log_and_message_admins("removed [stressor] from \the [victim].")

	else if(href_list["setstatuscond"])
		if(!check_rights(R_DEBUG))
			return
		var/mob/living/victim = locate(href_list["setstatuscond"])
		if(!istype(victim))
			return
		var/list/all_status_conditions = decls_repository.get_decls_of_subtype(/decl/status_condition)
		var/list/select_from_conditions = list()
		for(var/status_cond in all_status_conditions)
			select_from_conditions += all_status_conditions[status_cond]
		var/decl/status_condition/selected_condition = input("Select a status condition to set.", "Set Status Condition") as null|anything in select_from_conditions
		if(!selected_condition || QDELETED(victim) || !check_rights(R_DEBUG))
			return
		var/amt = input("Enter an amount to set the condition to.", "Set Status Condition") as num|null
		if(isnull(amt) || QDELETED(victim) || !check_rights(R_DEBUG))
			return
		if(amt < 0)
			amt += GET_STATUS(victim, selected_condition.type)
		victim.set_status_condition(selected_condition.type, amt)
		log_and_message_admins("set [selected_condition.name] to [amt] on \the [victim].")

	else if(href_list["setmaterial"])
		if(!check_rights(R_DEBUG))	return

		var/obj/item/item = locate(href_list["setmaterial"])
		if(!istype(item))
			to_chat(usr, "This can only be done to instances of type /obj/item")
			return

		var/decl/material/new_material = input("Please choose a new material.","Materials",null) as null|anything in decls_repository.get_decls_of_subtype_unassociated(/decl/material)
		if(!istype(new_material))
			return
		if(QDELETED(item))
			to_chat(usr, "Item doesn't exist anymore")
			return
		item.set_material(new_material.type)
		to_chat(usr, "Set material of [item] to [item.get_material()].")

	else if(href_list["give_ability"])
		var/mob/target = locate(href_list["give_ability"])
		if(!istype(target) || QDELETED(target))
			to_chat(usr, "Mob no longer exists.")
		else
			var/list/abilities = decls_repository.get_decls_of_type_unassociated(/decl/ability)
			abilities = abilities.Copy()
			abilities -= target.get_all_abilities()
			var/decl/ability/ability = input(usr, "Which ability do you wish to grant?", "Give Ability") as null|anything in abilities
			if(istype(ability) && !QDELETED(usr) && !QDELETED(target))
				if(target.add_ability(ability.type))
					log_and_message_admins("has given [ability] to [key_name(target)].")
				else
					to_chat(usr, SPAN_WARNING("Failed to give [ability] to [target]!"))

	else if(href_list["remove_ability"])
		var/mob/target = locate(href_list["remove_ability"])
		if(!istype(target) || QDELETED(target))
			to_chat(usr, "Mob no longer exists.")
		else
			var/decl/ability/ability = input(usr, "Which ability do you wish to remove?", "Remove Ability") as null|anything in target.get_all_abilities()
			if(istype(ability) && !QDELETED(usr) && !QDELETED(target))
				if(target.remove_ability(ability.type))
					log_and_message_admins("has removed [ability] from [key_name(target)].")
				else
					to_chat(usr, SPAN_WARNING("Failed to remove [ability] from [target]!"))

	else if (href_list["add_mob_modifier"])
		var/mob/living/target = locate(href_list["add_mob_modifier"])
		if(!istype(target) || QDELETED(target))
			to_chat(usr, SPAN_WARNING("Only /mob/living mobs can have mob modifiers."))
		else
			var/list/modifiers = list()
			for(var/decl/mob_modifier/modifier in decls_repository.get_decls_of_type_unassociated(/decl/mob_modifier))
				if(modifier.can_be_admin_granted)
					modifiers += modifier
			// Evil pyramid due to apparently not being able to return early in this Topic()
			var/decl/mob_modifier/modifier = input(usr, "Which modifier do you wish to give?", "Add Mob Modifier") as null|anything in modifiers
			if(istype(modifier) && !QDELETED(target))
				var/duration = input(usr, "How long do you wish this modifier to last, in seconds? Enter -1 for a permanent modifier.", "Add Mob Modifier") as num|null
				if(!isnull(duration))
					if(duration != MOB_MODIFIER_INDEFINITE)
						duration = max(0, duration SECONDS)
					if(duration != 0 && !QDELETED(target))
						if(target.add_mob_modifier(modifier, duration, source = target))
							to_chat(usr, SPAN_NOTICE("Added [modifier] to [target] for [duration] second\s."))
						else
							to_chat(usr, SPAN_WARNING("Failed to add [modifier] to [target]."))

	else if (href_list["remove_mob_modifier"])
		var/mob/living/target = locate(href_list["remove_mob_modifier"])
		if(!istype(target) && !QDELETED(target))
			to_chat(usr, SPAN_WARNING("Only /mob/living mobs can have mob modifiers."))
		else
			var/list/modifiers = list()
			for(var/decl/mob_modifier/modifier in target._mob_modifiers)
				if(modifier.can_be_admin_granted)
					modifiers += modifier
			var/decl/mob_modifier/modifier = input(usr, "Which modifier do you wish to remove?", "Remove Mob Modifier") as null|anything in modifiers
			if(istype(modifier))
				if(target.remove_mob_modifier(modifier, source = target))
					to_chat(usr, SPAN_NOTICE("Removed [modifier] from [target]."))
				else
					to_chat(usr, SPAN_WARNING("Failed to remove [modifier] from [target]."))

	if(href_list["datumrefresh"])
		var/datum/datum_to_refresh = locate(href_list["datumrefresh"])
		if(istype(datum_to_refresh, /datum) || istype(datum_to_refresh, /client))
			debug_variables_inner(datum_to_refresh, filter = href_list["filter"])

	return
