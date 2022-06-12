//returns 1 if this mob has sufficient access to use this object
/atom/movable/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(src.check_access(null))
		return TRUE
	if(!istype(M))
		return FALSE
	return check_access_list(M.GetAccess())

/atom/movable/proc/GetAccess(var/union = FALSE)
	. = list()
	if(union)
		for(var/atom/movable/id in GetIdCards())
			. |= id.GetAccess()
		return .
	var/atom/movable/id = GetIdCard()
	if(id)
		. = id.GetAccess()

/atom/movable/proc/GetIdCard()
	var/list/cards = GetIdCards()
	return LAZYACCESS(cards, LAZYLEN(cards))

/atom/movable/proc/GetIdCards()
	var/datum/extension/access_provider/our_provider = get_extension(src, /datum/extension/access_provider)
	if(our_provider)
		LAZYDISTINCTADD(., our_provider.GetIdCards())

/atom/movable/proc/check_access(atom/movable/A)
	return check_access_list(A ? A.GetAccess() : list())

/atom/movable/proc/check_access_list(list/L)
	var/list/R = get_req_access()

	if(!R)
		R = list()
	if(!istype(L, /list))
		return FALSE

	if(maint_all_access)
		L = L.Copy()
		L |= access_maint_tunnels

	return has_access(R, L)

/proc/has_access(list/req_access, list/accesses)
	for(var/req in req_access)
		if(islist(req))
			var/found = FALSE
			for(var/req_one in req)
				if(req_one in accesses)
					found = TRUE
					break
			if(!found)
				return FALSE
		else if(!(req in accesses)) //doesn't have this access
			return FALSE
	return TRUE

// Used for retrieving required access information, if available
/atom/movable/proc/get_req_access()
	return null

/obj/get_req_access()
	return req_access?.Copy()

/proc/get_centcom_access(job)
	switch(job)
		if("VIP Guest")
			return list(access_cent_general)
		if("Custodian")
			return list(access_cent_general, access_cent_living, access_cent_storage)
		if("Thunderdome Overseer")
			return list(access_cent_general, access_cent_thunder)
		if("Intel Officer")
			return list(access_cent_general, access_cent_living)
		if("Medical Officer")
			return list(access_cent_general, access_cent_living, access_cent_medical)
		if("Death Commando")
			return list(access_cent_general, access_cent_specops, access_cent_living, access_cent_storage)
		if("Research Officer")
			return list(access_cent_general, access_cent_specops, access_cent_medical, access_cent_teleporter, access_cent_storage)
		if("BlackOps Commander")
			return list(access_cent_general, access_cent_thunder, access_cent_specops, access_cent_living, access_cent_storage, access_cent_creed)
		if("Supreme Commander")
			return get_all_centcom_access()

var/global/list/datum/access/priv_all_access_datums
/proc/get_all_access_datums()
	if(!priv_all_access_datums)
		priv_all_access_datums = init_subtypes(/datum/access)
		priv_all_access_datums = dd_sortedObjectList(priv_all_access_datums)

	return priv_all_access_datums.Copy()

var/global/list/datum/access/priv_all_access_datums_id
/proc/get_all_access_datums_by_id()
	if(!priv_all_access_datums_id)
		priv_all_access_datums_id = list()
		for(var/datum/access/A in get_all_access_datums())
			priv_all_access_datums_id["[A.id]"] = A

	return priv_all_access_datums_id.Copy()

var/global/list/datum/access/priv_all_access_datums_region
/proc/get_all_access_datums_by_region()
	if(!priv_all_access_datums_region)
		priv_all_access_datums_region = list()
		for(var/datum/access/A in get_all_access_datums())
			if(!priv_all_access_datums_region[A.region])
				priv_all_access_datums_region[A.region] = list()
			priv_all_access_datums_region[A.region] += A

	return priv_all_access_datums_region.Copy()

/proc/get_access_ids(var/access_types = ACCESS_TYPE_ALL)
	var/list/L = new()
	for(var/datum/access/A in get_all_access_datums())
		if(A.access_type & access_types)
			L += A.id
	return L

var/global/list/priv_all_access
/proc/get_all_accesses()
	if(!priv_all_access)
		priv_all_access = get_access_ids()

	return priv_all_access?.Copy()

var/global/list/priv_station_access
/proc/get_all_station_access()
	if(!priv_station_access)
		priv_station_access = get_access_ids(ACCESS_TYPE_STATION)

	return priv_station_access.Copy()

var/global/list/priv_centcom_access
/proc/get_all_centcom_access()
	if(!priv_centcom_access)
		priv_centcom_access = get_access_ids(ACCESS_TYPE_CENTCOM)

	return priv_centcom_access.Copy()

var/global/list/priv_syndicate_access
/proc/get_all_syndicate_access()
	if(!priv_syndicate_access)
		priv_syndicate_access = get_access_ids(ACCESS_TYPE_SYNDICATE)

	return priv_syndicate_access.Copy()

var/global/list/priv_region_access
/proc/get_region_accesses(var/code)
	if(code == ACCESS_REGION_ALL)
		return get_all_station_access()

	if(!priv_region_access)
		priv_region_access = list()
		for(var/datum/access/A in get_all_access_datums())
			if(!priv_region_access["[A.region]"])
				priv_region_access["[A.region]"] = list()
			priv_region_access["[A.region]"] += A.id

	var/list/region = priv_region_access["[code]"]
	return islist(region) ? region.Copy() : list()

/proc/get_region_accesses_name(var/code)
	switch(code)
		if(ACCESS_REGION_ALL)
			return "All"
		if(ACCESS_REGION_SECURITY) //security
			return "Security"
		if(ACCESS_REGION_MEDBAY) //medbay
			return "Medbay"
		if(ACCESS_REGION_RESEARCH) //research
			return "Research"
		if(ACCESS_REGION_ENGINEERING) //engineering and maintenance
			return "Engineering"
		if(ACCESS_REGION_COMMAND) //command
			return "Command"
		if(ACCESS_REGION_GENERAL) //station general
			return "General"
		if(ACCESS_REGION_SUPPLY) //supply
			return "Supply"
		if(ACCESS_REGION_NT) //nt
			return "Corporate"

/proc/get_access_desc(id)
	var/list/AS = priv_all_access_datums_id || get_all_access_datums_by_id()
	var/datum/access/A = AS["[id]"]

	return A ? A.desc : ""

/proc/get_centcom_access_desc(A)
	return get_access_desc(A)

/proc/get_access_by_id(id)
	var/list/AS = priv_all_access_datums_id || get_all_access_datums_by_id()
	return AS[id]

/proc/get_all_centcom_jobs()
	return list("VIP Guest",
		"Custodian",
		"Thunderdome Overseer",
		"Intel Officer",
		"Medical Officer",
		"Death Commando",
		"Research Officer",
		"BlackOps Commander",
		"Supreme Commander",
		"Emergency Response Team",
		"Emergency Response Team Leader")

/mob/observer/ghost
	var/static/obj/item/card/id/all_access/ghost_all_access

/mob/observer/ghost/GetIdCards()
	. = ..()
	if (!is_admin(src))
		return .

	if (!ghost_all_access)
		ghost_all_access = new()
	LAZYDISTINCTADD(., ghost_all_access)

/mob/living/bot/GetIdCards()
	. = ..()
	if(istype(botcard))
		LAZYDISTINCTADD(., botcard)

// Gets the ID card of a mob, but will not check types in the exceptions list
/mob/living/carbon/human/GetIdCard(exceptions = null)
	return LAZYACCESS(GetIdCards(exceptions), 1)

/mob/living/carbon/human/GetIdCards(exceptions = null)
	. = ..()
	var/list/candidates = get_held_items()
	var/id = get_equipped_item(slot_wear_id_str)
	if(id)
		LAZYDISTINCTADD(candidates, id)
	for(var/atom/movable/candidate in candidates)
		if(!candidate || is_type_in_list(candidate, exceptions))
			continue
		var/list/obj/item/card/id/id_cards = candidate.GetIdCards()
		if(LAZYLEN(id_cards))
			LAZYDISTINCTADD(., id_cards)

/mob/living/carbon/human/GetAccess(var/union = TRUE)
	. = ..(union)

/mob/living/silicon/GetIdCards()
	. = ..()
	if(stat || (ckey && !client))
		return // Unconscious, dead or once possessed but now client-less silicons are not considered to have id access.
	if(istype(idcard))
		LAZYDISTINCTADD(., idcard)

/proc/FindNameFromID(var/mob/M, var/missing_id_name = "Unknown")
	var/obj/item/card/id/C = M.GetIdCard()
	if(C)
		return C.registered_name
	return missing_id_name

/proc/get_all_job_icons() //For all existing HUD icons
	return SSjobs.titles_to_datums + list("Prisoner")

/obj/proc/GetJobName() //Used in secHUD icon generation
	var/obj/item/card/id/I = GetIdCard()

	if(I)
		var/job_icons = get_all_job_icons()
		if(I.assignment	in job_icons) //Check if the job has a hud icon
			return I.assignment
		if(I.rank in job_icons)
			return I.rank

		var/centcom = get_all_centcom_jobs()
		if(I.assignment	in centcom)
			return "Centcom"
		if(I.rank in centcom)
			return "Centcom"
	else
		return

	return "Unknown" //Return unknown if none of the above apply

/proc/get_access_region_by_id(id)
	var/datum/access/AD = get_access_by_id(id)
	return AD.region