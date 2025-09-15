// Contains Supermatter-related uplink items accessible only to mercenaries.
/datum/uplink_item/item/grenades/supermatter
	name = "1x Supermatter Grenade"
	desc = "This grenade contains a small supermatter shard which will delaminate upon activation and pull in nearby objects, irradiate lifeforms, and eventually explode."
	item_cost = 15
	antag_roles = list(/decl/special_role/mercenary)
	path = /obj/item/grenade/supermatter

/datum/uplink_item/item/grenades/supermatters
	name = "5x Supermatter Grenades"
	desc = "These grenades contain a small supermatter shard which will delaminate upon activation and pull in nearby objects, irradiate lifeforms, and eventually explode."
	item_cost = 60
	antag_roles = list(/decl/special_role/mercenary)
	path = /obj/item/box/supermatters
