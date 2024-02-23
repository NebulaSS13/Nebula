/datum/extension/storage/slide_projector
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = BASE_STORAGE_CAPACITY(ITEM_SIZE_SMALL)
	use_sound = 'sound/effects/storage/toolbox.ogg'

/datum/extension/storage/slide_projector/remove_from_storage(obj/item/W, atom/new_location, var/NoUpdate = 0)
	. = ..()
	var/obj/item/slide_projector/projector = holder
	if(. && istype(projector) && W == projector.current_slide)
		var/list/contents = get_contents()
		projector.set_slide(length(contents) ? contents[1] : null)

/datum/extension/storage/slide_projector/handle_item_insertion(var/obj/item/W, var/prevent_warning = 0, var/NoUpdate = 0)
	. = ..()
	var/obj/item/slide_projector/projector = holder
	if(. && istype(projector) && !projector.current_slide)
		projector.set_slide(W)
