/decl/appearance_handler
	var/priority = 15
	var/list/appearance_sources = list()

/decl/appearance_handler/proc/AddAltAppearance(var/source, var/list/images, var/list/viewers = list())
	if(source in appearance_sources)
		return FALSE
	appearance_sources[source] = new/datum/appearance_data(images, viewers, priority)
	events_repository.register(/decl/observ/destroyed, source, src, /decl/appearance_handler/proc/RemoveAltAppearance)

/decl/appearance_handler/proc/RemoveAltAppearance(var/source)
	var/datum/appearance_data/ad = appearance_sources[source]
	if(ad)
		events_repository.unregister(/decl/observ/destroyed, source, src)
		appearance_sources -= source
		qdel(ad)

/decl/appearance_handler/proc/DisplayAltAppearanceTo(var/source, var/viewer)
	var/datum/appearance_data/ad = appearance_sources[source]
	if(ad)
		ad.AddViewer(viewer)

/decl/appearance_handler/proc/DisplayAllAltAppearancesTo(var/viewer)
	for(var/entry in appearance_sources)
		DisplayAltAppearanceTo(entry, viewer)

/decl/appearance_handler/proc/HideAltAppearanceFrom(source, viewer)
	var/datum/appearance_data/ad = appearance_sources[source]
	if(ad)
		ad.RemoveViewer(viewer)

/decl/appearance_handler/proc/HideAllAltAppearancesFrom(viewer)
	for(var/entry in appearance_sources)
		HideAltAppearanceFrom(entry, viewer)
