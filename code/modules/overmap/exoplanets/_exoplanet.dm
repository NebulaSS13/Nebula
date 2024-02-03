/////////////////////////////////////////////////////////////////////////
// Exoplanet
/////////////////////////////////////////////////////////////////////////

///Helper subtype for exoplanet overmap markers
/obj/effect/overmap/visitable/sector/planetoid/exoplanet
	name         = "exoplanet"
	sector_flags = OVERMAP_SECTOR_KNOWN

/obj/effect/overmap/visitable/sector/planetoid/exoplanet/get_scan_data(mob/user)
	. = ..()
	var/datum/planetoid_data/E = SSmapping.planetoid_data_by_id[planetoid_id]

	if(E.has_flora() && user.skill_check(SKILL_SCIENCE, SKILL_BASIC))
		. += "Xenoflora detected<br>"
	if(E.has_fauna() && user.skill_check(SKILL_SCIENCE, SKILL_BASIC))
		. += "Life traces detected<br>"

	if(LAZYLEN(E.subtemplates) && user.skill_check(SKILL_SCIENCE, SKILL_ADEPT))
		var/poi_num = 0
		for(var/datum/map_template/R in E.subtemplates)
			if(!(R.get_template_tags() & TEMPLATE_TAG_NATURAL))
				poi_num++
		if(poi_num)
			. += "<br>[poi_num] possible artificial structure\s detected.<br>"
