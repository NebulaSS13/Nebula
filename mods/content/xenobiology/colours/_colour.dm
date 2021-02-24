/decl/slime_colour
	var/name
	var/min_children = 4
	var/max_children = 4
	var/list/descendants = list()
	var/child_type = /mob/living/slime
	var/baby_icon =      'mods/content/xenobiology/icons/slimes/slime_baby.dmi'
	var/adult_icon =     'mods/content/xenobiology/icons/slimes/slime_adult.dmi'
	var/mood_icon =      'mods/content/xenobiology/icons/slimes/slime_faces.dmi'
	var/extract_icon =   'mods/content/xenobiology/icons/slimes/slime_extract.dmi'
	var/reaction_sound = 'sound/effects/bubbles.ogg'
	var/list/reaction_strings = list()
	var/list/reaction_procs = list(
		/decl/material/liquid/blood =        /decl/slime_colour/proc/try_blood_reaction,
		/decl/material/solid/metal/uranium = /decl/slime_colour/proc/try_uranium_reaction
	)

/decl/slime_colour/proc/handle_reaction(var/datum/reagents/holder)

	. = FALSE
	if(!istype(holder))
		return

	var/obj/item/slime_extract/core = holder.my_atom
	if(!istype(core) || core.Uses <= 0)
		return

	for(var/rtype in holder.reagent_volumes)
		if(holder.reagent_volumes[rtype] < 1)
			continue
		var/call_proc = reaction_procs[rtype]
		if(call_proc && call(src, call_proc)(holder))
			holder.remove_reagent(rtype, holder.reagent_volumes[rtype])
			. = TRUE
			break

	if(. && holder?.my_atom)
		if(reaction_sound)
			playsound(holder.my_atom.loc, reaction_sound, 75, 1)
		if(!QDELETED(core))
			core.Uses--
			if(core.Uses <= 0)
				core.visible_message(SPAN_NOTICE("[html_icon(core)] \The [core]'s power is consumed in the reaction."))
				core.SetName("used slime extract")
				core.desc = "This extract has been used up."

/decl/slime_colour/proc/try_blood_reaction(var/datum/reagents/holder)
	return handle_blood_reaction(holder)
/decl/slime_colour/proc/handle_blood_reaction(var/datum/reagents/holder)
	return FALSE
/decl/slime_colour/proc/try_uranium_reaction(var/datum/reagents/holder)
	return handle_uranium_reaction(holder)
/decl/slime_colour/proc/handle_uranium_reaction(var/datum/reagents/holder)
	return FALSE