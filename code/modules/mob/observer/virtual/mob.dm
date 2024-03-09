/mob/observer/virtual/mob
	host_type = /mob

/mob/observer/virtual/mob/Initialize(mapload, var/mob/host)
	. = ..()

	events_repository.register(/decl/observ/sight_set, host, src, TYPE_PROC_REF(/mob/observer/virtual/mob, sync_sight))
	events_repository.register(/decl/observ/see_invisible_set, host, src, TYPE_PROC_REF(/mob/observer/virtual/mob, sync_sight))
	events_repository.register(/decl/observ/see_in_dark_set, host, src, TYPE_PROC_REF(/mob/observer/virtual/mob, sync_sight))

	sync_sight(host)

/mob/observer/virtual/mob/Destroy()
	events_repository.unregister(/decl/observ/sight_set, host, src, TYPE_PROC_REF(/mob/observer/virtual/mob, sync_sight))
	events_repository.unregister(/decl/observ/see_invisible_set, host, src, TYPE_PROC_REF(/mob/observer/virtual/mob, sync_sight))
	events_repository.unregister(/decl/observ/see_in_dark_set, host, src, TYPE_PROC_REF(/mob/observer/virtual/mob, sync_sight))
	. = ..()

/mob/observer/virtual/mob/proc/sync_sight(var/mob/mob_host)
	sight = mob_host.sight
	see_invisible = mob_host.see_invisible
	see_in_dark = mob_host.see_in_dark
