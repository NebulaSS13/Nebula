/decl/appearance_manager
	var/list/appearances_

/decl/appearance_manager/New()
	..()
	appearances_ = list()

/decl/appearance_manager/proc/get_appearance_handler(var/handler_type)
	var/list/appearance_handlers = decls_repository.get_decls_of_subtype(/decl/appearance_handler)
	return appearance_handlers[handler_type]

/decl/appearance_manager/proc/add_appearance(var/mob/viewer, var/datum/appearance_data/ad)
	var/PriorityQueue/pq = appearances_[viewer]
	if(!pq)
		pq = new/PriorityQueue(/proc/cmp_appearance_data)
		appearances_[viewer] = pq
		events_repository.register(/decl/observ/logged_in, viewer, src, /decl/appearance_manager/proc/apply_appearance_images)
		events_repository.register(/decl/observ/destroyed, viewer, src, /decl/appearance_manager/proc/remove_appearances)
	pq.Enqueue(ad)
	reset_appearance_images(viewer)

/decl/appearance_manager/proc/remove_appearance(var/mob/viewer, var/datum/appearance_data/ad, var/refresh_images)
	var/PriorityQueue/pq = appearances_[viewer]
	pq.Remove(ad)
	if(viewer.client)
		viewer.client.images -= ad.images
	if(!pq.Length())
		events_repository.unregister(/decl/observ/logged_in, viewer, src, /decl/appearance_manager/proc/apply_appearance_images)
		events_repository.register(/decl/observ/destroyed, viewer, src, /decl/appearance_manager/proc/remove_appearances)
		appearances_ -= viewer

/decl/appearance_manager/proc/remove_appearances(var/mob/viewer)
	var/PriorityQueue/pq = appearances_[viewer]
	for(var/entry in pq.L)
		var/datum/appearance_data/ad = entry
		ad.RemoveViewer(viewer, FALSE)
	if(viewer in appearances_)
		appearances_[viewer] -= viewer

/decl/appearance_manager/proc/reset_appearance_images(var/mob/viewer)
	clear_appearance_images(viewer)
	apply_appearance_images(viewer)

/decl/appearance_manager/proc/clear_appearance_images(var/mob/viewer)
	if(!viewer.client)
		return
	var/PriorityQueue/pq = appearances_[viewer]
	if(!pq)
		return
	for(var/entry in pq.L)
		var/datum/appearance_data/ad = entry
		viewer.client.images -= ad.images

/decl/appearance_manager/proc/apply_appearance_images(var/mob/viewer)
	if(!viewer.client)
		return
	var/PriorityQueue/pq = appearances_[viewer]
	if(!pq)
		return
	for(var/entry in pq.L)
		var/datum/appearance_data/ad = entry
		viewer.client.images |= ad.images
