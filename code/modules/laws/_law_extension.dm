/datum/extension/laws
	base_type = /datum/extension/laws
	expected_type = /atom/movable
	flags = EXTENSION_FLAG_IMMEDIATE
	var/datum/lawset/lawset

/datum/extension/laws/proc/set_laws(var/new_lawset)
	lawset = new_lawset
	show_laws()

/datum/extension/laws/proc/validate_lawset()
	if(!istype(lawset))
		if(istype(lawset, /datum))
			qdel(lawset)
		lawset = new(holder)

/datum/extension/laws/proc/show_laws(var/atom/showing)
	validate_lawset()
	lawset.show_laws(showing)

/datum/extension/laws/proc/state_laws(var/atom/stating)
	validate_lawset()
	lawset.state_laws(stating)

/datum/extension/laws/proc/manage_laws(var/atom/managing)
	validate_lawset()
	lawset.manage_laws(managing)
