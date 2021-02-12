
/*
/decl/lawset

	var/selectable = 0
	var/shackles = 0
	var/datum/law/zero/zeroth_law
	var/datum/law/zero/zeroth_law_borg
	var/list/inherent_laws = list()
	var/list/supplied_laws = list()
	var/list/ion_laws = list()
	var/list/sorted_laws = list()

	var/state_zeroth = 0
	var/list/state_ion = list()
	var/list/state_inherent = list()
	var/list/state_supplied = list()

/decl/lawset/New()
	..()
	sort_laws()

/* General ai_law functions */
/decl/lawset/proc/all_laws()
	sort_laws()
	return sorted_laws

/decl/lawset/proc/laws_to_state()
	sort_laws()
	var/list/statements = new()
	for(var/datum/law/law in sorted_laws)
		if(get_state_law(law))
			statements += law
	return statements

/decl/lawset/proc/sync(var/mob/living/silicon/S, var/full_sync = 1)
	// Add directly to laws to avoid log-spam
	S.sync_zeroth(zeroth_law, zeroth_law_borg)

	if(full_sync || ion_laws.len)
		S.laws.clear_ion_laws()
	if(full_sync || inherent_laws.len)
		S.laws.clear_inherent_laws()
	if(full_sync || supplied_laws.len)
		S.laws.clear_supplied_laws()

	for (var/datum/law/law in ion_laws)
		S.laws.add_ion_law(law.law)
	for (var/datum/law/law in inherent_laws)
		S.laws.add_inherent_law(law.law)
	for (var/datum/law/law in supplied_laws)
		if(law)
			S.laws.add_supplied_law(law.index, law.law)

/decl/lawset/proc/set_zeroth_law(var/law, var/law_borg)
	if(!law)
		return

	zeroth_law = new(law)
	if(law_borg) //Making it possible for slaved borgs to see a different law 0 than their AI. --NEO
		zeroth_law_borg = new(law_borg)
	else
		zeroth_law_borg = null
	sorted_laws.Cut()

/decl/lawset/proc/add_ion_law(var/law)
	if(!law)
		return

	for(var/datum/law/AL in ion_laws)
		if(AL.law == law)
			return

	var/new_law = new/datum/law/ion(law)
	ion_laws += new_law
	if(state_ion.len < ion_laws.len)
		state_ion += 1

	sorted_laws.Cut()

/decl/lawset/proc/add_inherent_law(var/law)
	if(!law)
		return

	for(var/datum/law/AL in inherent_laws)
		if(AL.law == law)
			return

	var/new_law = new/datum/law/inherent(law)
	inherent_laws += new_law
	if(state_inherent.len < inherent_laws.len)
		state_inherent += 1

	sorted_laws.Cut()

/decl/lawset/proc/add_supplied_law(var/number, var/law)
	if(!law)
		return

	if(supplied_laws.len >= number)
		var/datum/law/existing_law = supplied_laws[number]
		if(existing_law && existing_law.law == law)
			return

	if(supplied_laws.len >= number && supplied_laws[number])
		delete_law(supplied_laws[number])

	while (src.supplied_laws.len < number)
		src.supplied_laws += ""
		if(state_supplied.len < supplied_laws.len)
			state_supplied += 1

	var/new_law = new/datum/law/supplied(law, number)
	supplied_laws[number] = new_law
	if(state_supplied.len < supplied_laws.len)
		state_supplied += 1

	sorted_laws.Cut()

/****************
*	Remove Laws	*
*****************/
/decl/lawset/proc/delete_law(var/datum/law/law)
	if(istype(law))
		law.delete_law(src)


/decl/lawset/proc/internal_delete_law(var/list/laws, var/list/state, var/list/law)
	var/index = laws.Find(law)
	if(index)
		laws -= law
		for(index, index < state.len, index++)
			state[index] = state[index+1]
	sorted_laws.Cut()

/****************
*	Clear Laws	*
****************/
/decl/lawset/proc/clear_zeroth_laws()
	zeroth_law = null
	zeroth_law_borg = null

/decl/lawset/proc/clear_ion_laws()
	ion_laws.Cut()
	sorted_laws.Cut()

/decl/lawset/proc/clear_inherent_laws()
	inherent_laws.Cut()
	sorted_laws.Cut()

/decl/lawset/proc/clear_supplied_laws()
	supplied_laws.Cut()
	sorted_laws.Cut()

/********************
*	Stating Laws	*
********************/
/********
*	Get	*
********/
/decl/lawset/proc/get_state_law(var/datum/law/law)
	return law.get_state_law(src)


/decl/lawset/proc/get_state_internal(var/list/laws, var/list/state, var/list/law)
	var/index = laws.Find(law)
	if(index)
		return state[index]
	return 0



/********
*	Set	*
********/
/decl/lawset/proc/set_state_law(var/datum/law/law, var/state)
	law.set_state_law(src, state)


/decl/lawset/proc/set_state_law_internal(var/list/laws, var/list/state, var/list/law, var/do_state)
	var/index = laws.Find(law)
	if(index)
		state[index] = do_state


/datum/law
	var/law = ""
	var/index = 0

/datum/law/New(law, index)
	src.law = law
	src.index = index

/datum/law/proc/get_index()
	return index

/datum/law/ion/get_index()
	return ionnum()

/datum/law/zero/get_index()
	return 0

/mob/living/silicon/proc/sync_zeroth(var/datum/law/zeroth_law, var/datum/law/zeroth_law_borg)
	if (!is_traitor(src))
		if(zeroth_law_borg)
			laws.set_zeroth_law(zeroth_law_borg.law)
		else if(zeroth_law)
			laws.set_zeroth_law(zeroth_law.law)

/mob/living/silicon/ai/sync_zeroth(var/datum/law/zeroth_law, var/datum/law/zeroth_law_borg)
	if(zeroth_law)
		laws.set_zeroth_law(zeroth_law.law, zeroth_law_borg ? zeroth_law_borg.law : null)

/datum/law/proc/delete_law(var/decl/lawset/laws)

/datum/law/zero/delete_law(var/decl/lawset/laws)
	laws.clear_zeroth_laws()

/datum/law/ion/delete_law(var/decl/lawset/laws)
	laws.internal_delete_law(laws.ion_laws, laws.state_ion, src)

/datum/law/inherent/delete_law(var/decl/lawset/laws)
	laws.internal_delete_law(laws.inherent_laws, laws.state_inherent, src)

/datum/law/supplied/delete_law(var/decl/lawset/laws)
	var/index = laws.supplied_laws.Find(src)
	if(index)
		laws.supplied_laws[index] = ""
		laws.state_supplied[index] = 1

/datum/law/proc/get_state_law(var/decl/lawset/laws)

/datum/law/zero/get_state_law(var/decl/lawset/laws)
	if(src == laws.zeroth_law)
		return laws.state_zeroth

/datum/law/ion/get_state_law(var/decl/lawset/laws)
	return laws.get_state_internal(laws.ion_laws, laws.state_ion, src)

/datum/law/inherent/get_state_law(var/decl/lawset/laws)
	return laws.get_state_internal(laws.inherent_laws, laws.state_inherent, src)

/datum/law/supplied/get_state_law(var/decl/lawset/laws)
	return laws.get_state_internal(laws.supplied_laws, laws.state_supplied, src)


/datum/law/proc/set_state_law(var/datum/law/law, var/state)

/datum/law/zero/set_state_law(var/decl/lawset/laws, var/state)
	if(src == laws.zeroth_law)
		laws.state_zeroth = state

/datum/law/ion/set_state_law(var/decl/lawset/laws, var/state)
	laws.set_state_law_internal(laws.ion_laws, laws.state_ion, src, state)

/datum/law/inherent/set_state_law(var/decl/lawset/laws, var/state)
	laws.set_state_law_internal(laws.inherent_laws, laws.state_inherent, src, state)

/datum/law/supplied/set_state_law(var/decl/lawset/laws, var/state)
	laws.set_state_law_internal(laws.supplied_laws, laws.state_supplied, src, state)


*/