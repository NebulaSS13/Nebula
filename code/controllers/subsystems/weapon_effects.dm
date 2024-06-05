SUBSYSTEM_DEF(weapon_effects)
	name = "Weapon Effects"
	wait = 2 SECONDS
	priority = SS_PRIORITY_WEAPON_EFFECTS
	flags = SS_NO_INIT
	var/list/queued_weapons = list()
	var/list/processing_weapons

/datum/controller/subsystem/weapon_effects/stat_entry()
	..("P:[queued_weapons.len]")

/datum/controller/subsystem/weapon_effects/fire(resumed = 0)
	if(!resumed)
		processing_weapons = queued_weapons.Copy()
	var/obj/item/current_item
	var/i = 0
	while(i < processing_weapons.len)
		i++
		current_item = processing_weapons[i]
		current_item.process_weapon_effects()
		if(MC_TICK_CHECK)
			processing_weapons.Cut(1, i+1)
			return
