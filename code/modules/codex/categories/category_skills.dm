/decl/codex_category/skills
	name = "Skills"
	desc = "Certifiable skills."

/decl/codex_category/skills/Populate()
	for(var/decl/hierarchy/skill/skill in global.using_map.get_available_skills())
		var/list/skill_info = list()
		if(skill.prerequisites)
			var/list/reqs = list()
			for(var/req in skill.prerequisites)
				var/decl/hierarchy/skill/skill_req = GET_DECL(req)
				reqs += "[skill_req.levels[skill.prerequisites[req]]] [skill_req.name]"
			skill_info += "Prerequisites: [english_list(reqs)]"
		for(var/level in skill.levels)
			skill_info += "<h4>[level]</h4>[skill.levels[level]]"
		var/datum/codex_entry/entry = new(
			_display_name = "[skill.name] (skill)",
			_lore_text = skill.desc,
			_mechanics_text = jointext(skill_info, "<br>"),
		)
		items |= entry.name
	. = ..()