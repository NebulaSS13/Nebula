/datum/lawset
	var/list/inherent_laws
	var/list/supplied_laws
	var/list/ion_laws
	var/list/zeroth_laws
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

/datum/lawset/proc/add_zeroth_law(var/law_text)
	LAZYADD(zeroth_laws, new /datum/law(law_text, 1))
	if(owner)
		log_law_change("has given [key_name(owner.resolve())] a new zeroth law: '[law_text]'")

/datum/lawset/proc/add_ion_law(var/law_text)
	LAZYADD(ion_laws, new /datum/law(law_text, 1))
	if(owner)
		log_law_change("has given [key_name(owner.resolve())] a new ion law: '[law_text]'")

/datum/lawset/proc/add_inherent_law(var/law_text, var/law_priority)
	LAZYADD(inherent_laws, new /datum/law(law_text, law_priority))
	if(owner)
		log_law_change("has given [key_name(owner.resolve())] a new inherent law: '[law_text]', [law_priority]")
	
/datum/lawset/proc/add_supplied_law(var/law_text, var/law_priority)
	LAZYADD(supplied_laws, new /datum/law(law_text, law_priority))
	if(owner)
		log_law_change("has given [key_name(owner.resolve())] a new supplied law: '[law_text]', [law_priority]")

/datum/lawset/proc/get_all_laws()
	. = list()
	for(var/datum/law/law in (inherent_laws|supplied_laws))
		. += law
	. = sortTim(., /proc/cmp_laws_asc)

/datum/lawset/proc/clear_inherent_laws()
	QDEL_NULL_LIST(inherent_laws)

/datum/lawset/proc/clear_supplied_laws()
	QDEL_NULL_LIST(supplied_laws)

/datum/lawset/proc/clear_ion_laws()
	QDEL_NULL_LIST(ion_laws)

/datum/lawset/proc/clear_zeroth_laws()
	QDEL_NULL_LIST(zeroth_laws)

/datum/lawset/proc/purge_laws(var/clear_zeroth_law)
	clear_inherent_laws()
	if(clear_zeroth_law)
		clear_zeroth_laws()
	reset_laws()

/datum/lawset/proc/reset_laws()
	clear_ion_laws()
	clear_supplied_laws()

/datum/lawset/proc/state_laws(var/mob/stating)

/datum/lawset/proc/manage_laws(var/mob/managing)

/datum/lawset/proc/show_laws(var/mob/showing)
	if(showing == owner?.resolve())
		to_chat(showing, SPAN_NOTICE("<b>You must obey the following laws:"))
	else if(owner)
		to_chat(showing, SPAN_NOTICE("<b>\The [owner.resolve()] must obey the following laws:"))

	for(var/datum/law/law in zeroth_laws)
		to_chat(showing, SPAN_DANGER("<b>0.</b> [law.law_text]"))
	var/list/all_laws = get_all_laws()-zeroth_laws
	for(var/i = 1 to length(all_laws))
		var/datum/law/law = all_laws[i]
		to_chat(showing, "<b>[i].</b> [istype(law) ? law.law_text : law]")

/datum/lawset/proc/has_zeroth_law()
	return length(zeroth_laws)
