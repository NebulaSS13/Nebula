SUBSYSTEM_DEF(item_effects)
	name = "Weapon Effects"
	wait = 2 SECONDS
	priority = SS_PRIORITY_ITEM_EFFECTS
	flags = SS_NO_INIT
	var/list/queued_items = list()
	var/list/processing_items

/datum/controller/subsystem/item_effects/stat_entry()
	..("P:[queued_items.len]")

/datum/controller/subsystem/item_effects/fire(resumed = 0)
	if(!resumed)
		processing_items = queued_items.Copy()
	var/obj/item/current_item
	var/i = 0
	while(i < processing_items.len)
		i++
		current_item = processing_items[i]
		current_item.process_item_effects()
		if(MC_TICK_CHECK)
			processing_items.Cut(1, i+1)
			return
