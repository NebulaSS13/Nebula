// Would be nice to use can_unequip_item() but it doesn't have a target param.
/mob/living/silicon/robot/try_unequip(obj/item/I, atom/target, play_dropsound)
	if(!module || (target != module && (I in module.equipment)))
		return FALSE
	return ..()

/mob/living/silicon/robot/drop_from_inventory(obj/item/dropping_item, atom/target, play_dropsound)
	if(module && (dropping_item in module.equipment) && target != module)
		return FALSE
	. = ..()
	if(!QDELETED(dropping_item) && module?.storage && (dropping_item in module.equipment))
		module.storage.handle_item_insertion(src, dropping_item)

// Always try to redirect drops into our module.
/mob/living/silicon/robot/drop_item(var/atom/Target)
	Target = module
	return ..()

// Overriding default drop arg.
/mob/living/silicon/robot/drop_held_items(drop_loc = module)
	return ..()
