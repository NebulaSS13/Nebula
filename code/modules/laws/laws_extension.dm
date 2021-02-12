/datum/extension/laws
	base_type = /datum/extension/laws
	expected_type = /atom/movable
	flags = EXTENSION_FLAG_IMMEDIATE

	var/datum/lawset/lawset
	var/list/stating_laws
	var/list/additional_law_channels

/datum/extension/laws/New()
	..()
	LAZYSET(additional_law_channels, "Nearby Listeners", "")
	LAZYSET(additional_law_channels, "Common Frequency", ";")

/datum/extension/laws/proc/get_law_stating_channels()
	. = additional_law_channels

/datum/extension/laws/proc/set_laws(var/new_lawset)
	lawset = new_lawset
	show_laws(holder)

/datum/extension/laws/proc/validate_lawset()
	if(!istype(lawset))
		if(istype(lawset, /datum))
			qdel(lawset)
		lawset = new(holder)
	lawset.owner = weakref(holder)

/datum/extension/laws/proc/show_laws(var/atom/showing)
	validate_lawset()
	lawset.show_laws(showing)

/datum/extension/laws/proc/state_laws(var/atom/stating, var/use_channel)
	validate_lawset()
	var/list/state_law_channels = get_law_stating_channels()
	lawset.state_laws(stating, LAZYACCESS(state_law_channels, use_channel) || get_radio_key_from_channel(use_channel))

/datum/extension/laws/proc/manage_laws(var/atom/managing)
	validate_lawset()
	lawset.manage_laws(managing)

/datum/extension/laws/proc/sync_laws()
	validate_lawset()
	lawset.sync_laws()
