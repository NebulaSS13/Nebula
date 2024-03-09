/datum/map
	var/list/_available_skills

// Broken into a proc to allow maps to override the general skillset.
/datum/map/proc/get_available_skill_types()
	. = list()
	for(var/skill_type in decls_repository.get_decls_of_type(/decl/hierarchy/skill))
		. += skill_type

/datum/map/proc/build_available_skills()
	_available_skills = list()
	for(var/skill_type in get_available_skill_types())
		var/decl/hierarchy/skill/skill = GET_DECL(skill_type)
		if(INSTANCE_IS_ABSTRACT(skill))
			for(var/decl/hierarchy/skill/child in skill.children)
				_available_skills |= child.get_descendants()
		else
			_available_skills |= skill

/datum/map/proc/get_available_skills()
	if(!_available_skills)
		build_available_skills()
	return _available_skills
