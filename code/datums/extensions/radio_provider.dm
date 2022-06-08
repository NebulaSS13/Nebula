/datum/extension/radio_provider
	base_type = /datum/extension/radio_provider
	expected_type = /atom/movable
	var/list/atom/movable/registered_radios

/datum/extension/radio_provider/Destroy()
	LAZYCLEARLIST(registered_radios)
	. = ..()

/datum/extension/radio_provider/proc/register_radio(atom/movable/to_register)
	LAZYDISTINCTADD(registered_radios, to_register)

/datum/extension/radio_provider/proc/unregister_radio(atom/movable/to_unregister)
	LAZYREMOVE(registered_radios, to_unregister)

/datum/extension/radio_provider/proc/GetRadios(message_mode)
	for(var/atom/movable/registered_radio in registered_radios)
		LAZYDISTINCTADD(., registered_radio.GetRadios(message_mode))

/datum/extension/radio_provider/proc/GetRadio(message_mode)
	return LAZYACCESS(GetRadios(message_mode), 1)

/atom/movable/proc/GetRadios(message_mode)
	var/datum/extension/radio_provider/radio_provider = get_extension(src, /datum/extension/radio_provider)
	if(istype(radio_provider))
		return radio_provider.GetRadios(message_mode)

/atom/movable/proc/GetRadio(message_mode)
	return LAZYACCESS(GetRadios(message_mode), 1)