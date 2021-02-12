/proc/cmp_laws_asc(var/datum/law/a, var/datum/law/b)
	return a.law_priority - b.law_priority

/datum/law
	var/law_text
	var/law_priority

/datum/law/New(var/_text, var/_priority)
	law_text = _text
	law_priority = _priority
	..()
