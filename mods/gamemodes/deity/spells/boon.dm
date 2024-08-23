/decl/ability/proc/set_connected_god(mob/living/subject, mob/living/deity/god)
	var/list/metadata = subject.get_ability_metadata(type)
	metadata["connected_god"] = god
