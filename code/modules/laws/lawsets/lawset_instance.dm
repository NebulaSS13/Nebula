/datum/lawset
	var/list/inherent_laws
	var/list/supplied_laws
	var/list/ion_laws
	var/datum/law/zeroth_law
	var/weakref/owner

/datum/lawset/New(var/mob/_owner)
	if(istype(_owner))
		owner = weakref(owner)
	..()
	
/datum/lawset/Destroy(force)
	. = ..()
	purge_laws(TRUE)

/datum/lawset/proc/log_law_change(var/law_message)
	log_and_message_admins(law_message)
	GLOB.lawchanges += "[stationtime2text()] - [usr ? "[key_name(usr)]" : "EVENT"] [law_message]"

/datum/lawset/proc/set_zeroth_law(var/law_text, var/subordinate_law_text)
	if(zeroth_law)
		QDEL_NULL(zeroth_law)
	zeroth_law = new /datum/law(law_text, 1)
	if(owner)
		var/atom/movable/owner_atom = owner.resolve()
		log_law_change("has given [key_name(owner_atom)] a new zeroth law: '[law_text]' (subordinate: '[subordinate_law_text]'')")
		if(subordinate_law_text)
			for(var/atom/movable/subordinate in owner_atom.get_law_subordinates())
				var/datum/lawset/laws = subordinate.get_laws()
				if(laws)
					laws.set_zeroth_law(subordinate_law_text)

/datum/lawset/proc/copy_from(var/datum/lawset/other)
	if(!istype(other))
		return
	// Don't use the helper procs here, as that will propagate changes to our
	// subordinates, which we're already doing if this proc is being called. 
	QDEL_NULL_LIST(inherent_laws)
	QDEL_NULL_LIST(supplied_laws)
	QDEL_NULL_LIST(ion_laws)
	for(var/datum/law/law in other.inherent_laws)
		LAZYADD(inherent_laws, new /datum/law(law.law_text, law.law_priority))
	for(var/datum/law/law in other.supplied_laws)
		LAZYADD(supplied_laws, new /datum/law(law.law_text, law.law_priority))
	for(var/datum/law/law in other.ion_laws)
		LAZYADD(ion_laws, new /datum/law(law.law_text, law.law_priority))
	if(owner)
		var/atom/movable/owner_atom = owner.resolve()
		to_chat(owner_atom, SPAN_NOTICE("<b>Your laws have been updated from your master:</b>"))
		show_laws(owner_atom, TRUE)

/datum/lawset/proc/sync_laws()
	var/atom/movable/owner_atom = owner?.resolve()
	if(owner_atom)
		var/atom/movable/superior = owner_atom.get_law_superior()
		if(superior)
			copy_from(superior.get_laws())
		for(var/atom/movable/subordinate in owner_atom.get_law_subordinates())
			var/datum/lawset/laws = subordinate.get_laws()
			if(laws)
				laws.copy_from(src)

/datum/lawset/proc/add_ion_law(var/law_text)
	LAZYADD(ion_laws, new /datum/law(law_text, 1))
	if(owner)
		log_law_change("has given [key_name(owner.resolve())] a new ion law: '[law_text]'")
	sync_laws()

/datum/lawset/proc/add_inherent_law(var/law_text, var/law_priority)
	LAZYADD(inherent_laws, new /datum/law(law_text, law_priority))
	if(owner)
		log_law_change("has given [key_name(owner.resolve())] a new inherent law: '[law_text]', [law_priority]")
	sync_laws()
	
/datum/lawset/proc/add_supplied_law(var/law_text, var/law_priority)
	LAZYADD(supplied_laws, new /datum/law(law_text, law_priority))
	if(owner)
		log_law_change("has given [key_name(owner.resolve())] a new supplied law: '[law_text]', [law_priority]")
	sync_laws()

/datum/lawset/proc/get_all_laws()
	. = list()
	for(var/datum/law/law in (inherent_laws|supplied_laws))
		. += law
	. = sortTim(., /proc/cmp_laws_asc)

/datum/lawset/proc/clear_inherent_laws(var/skip_sync = FALSE)
	QDEL_NULL_LIST(inherent_laws)
	if(!skip_sync)
		sync_laws()

/datum/lawset/proc/clear_supplied_laws(var/skip_sync = FALSE)
	QDEL_NULL_LIST(supplied_laws)
	if(!skip_sync)
		sync_laws()

/datum/lawset/proc/clear_ion_laws(var/skip_sync = FALSE)
	QDEL_NULL_LIST(ion_laws)
	if(!skip_sync)
		sync_laws()

/datum/lawset/proc/purge_laws(var/clear_zeroth_law, var/skip_sync = FALSE)
	clear_inherent_laws(TRUE)
	if(clear_zeroth_law)
		QDEL_NULL(zeroth_law)
	reset_laws(skip_sync)

/datum/lawset/proc/reset_laws(var/skip_sync = FALSE)
	clear_ion_laws(TRUE)
	clear_supplied_laws(TRUE)
	if(!skip_sync)
		sync_laws()

/datum/lawset/proc/state_laws(var/mob/stating, var/prefix)

	set waitfor = FALSE
	if(!istype(stating) || QDELETED(stating) || stating.incapacitated(INCAPACITATION_KNOCKOUT))
		return

	var/list/all_laws = get_all_laws()-zeroth_law
	if(!length(all_laws))
		to_chat(stating, SPAN_WARNING("You have no laws to state."))
		return

	prefix = prefix ? "[prefix] " : ""
	stating.say("[prefix]Current active laws:")
	for(var/i = 1 to length(all_laws))
		var/datum/law/law = all_laws[i]
		stating.say("[prefix][i]. [istype(law) ? law.law_text : law]")
		sleep(2 SECONDS)
		if(QDELETED(stating) || stating.incapacitated(INCAPACITATION_KNOCKOUT))
			break

/datum/lawset/proc/show_laws(var/mob/showing, var/skip_header = FALSE)

	if(!skip_header)
		if(showing == owner?.resolve())
			to_chat(showing, SPAN_NOTICE("<b>You must obey the following laws:"))
		else if(owner)
			to_chat(showing, SPAN_NOTICE("<b>\The [owner.resolve()] must obey the following laws:"))

	if(zeroth_law)
		to_chat(showing, SPAN_DANGER("<b>0.</b> [zeroth_law.law_text]"))
	var/list/all_laws = get_all_laws()-zeroth_law
	for(var/i = 1 to length(all_laws))
		var/datum/law/law = all_laws[i]
		to_chat(showing, "<b>[i].</b> [istype(law) ? law.law_text : law]")

/datum/lawset/proc/manage_laws(var/mob/managing)
	return
