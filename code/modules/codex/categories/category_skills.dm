/decl/codex_category/skills
	name = "Skills"
	desc = "Certifiable skills."

/decl/codex_category/skills/Populate()
	var/list/available_skill_types = global.using_map.get_available_skill_types()
	for(var/decl/skill/skill in decls_repository.get_decls_of_subtype_unassociated(/decl/skill))
		var/list/skill_info = list()
		if(skill.prerequisites)
			var/list/reqs = list()
			for(var/req in skill.prerequisites)
				var/decl/skill/skill_req = GET_DECL(req)
				reqs += "[skill_req.levels[skill.prerequisites[req]]] [skill_req.name]"
			skill_info += "Prerequisites: [english_list(reqs)]"
		for(var/level in skill.levels)
			skill_info += "<h4>[level]</h4>[skill.levels[level]]"
		var/datum/codex_entry/entry = new(
			_display_name = "[skill.name] (skill)",
			_lore_text = skill.desc,
			_mechanics_text = jointext(skill_info, "<br>"),
		)
		if(!(skill.type in available_skill_types))
			entry.unsearchable = TRUE
		items |= entry.name
	. = ..()