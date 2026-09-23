// Debug/Admin verbs to manipulate the merchant system, for testing or fun. `Debug verbs` must be toggled on to access these.
// Requires `R_DEBUG` permissions.

/// Prints a list of all trade hubs instances, and all of their merchant instances, along with links to open VV for a specific instance of either.
/datum/admins/proc/list_merchants()
	set category = "Debug"
	set name = "List Merchants"
	set desc = "Lists all the current merchants."

	if(!check_rights(R_DEBUG))
		return

	for(var/a in SStrade.trade_hubs)
		var/datum/trade_hub/hub = a
		to_chat(src, "<b>[hub.name]</b> ([hub.type]) <a href='byond://?_src_=vars;Vars=\ref[hub]'>\ref[hub]</a>")
		for(var/b in hub.merchants)
			var/datum/merchant/merchant = b
			to_chat(src, " - [merchant.name] ([merchant.type]) <a href='byond://?_src_=vars;Vars=\ref[merchant]'>\ref[merchant]</a>")

/// Instantiates a singleton trade hub.
/datum/admins/proc/add_singleton_trade_hub()
	set category = "Debug"
	set name = "Add Singleton Trade Hub"
	set desc = "Adds a new singleton trade hub that can be accessed anywhere."

	if(!check_rights(R_DEBUG))
		return

	var/hub_type = input(src, "Choose a type to add.") as null|anything in get_non_abstract_types(/datum/trade_hub/singleton)
	if(hub_type)
		new hub_type() // Will get added automatically to SSTrade.
		log_and_message_admins("has created a new singleton trade hub ([hub_type]).")

/// Instantiates an overmap trade hub, on the tile that the admin ghost is floating over when used.
/datum/admins/proc/add_overmap_trade_hub()
	set category = "Debug"
	set name = "Add Overmap Trade Hub"
	set desc = "Adds a new trade hub on an overmap tile."

	if(!check_rights(R_DEBUG))
		return

	var/turf/T = get_turf(usr)
	var/datum/overmap/overmap = null
	overmap = global.overmaps_by_z["[T.z]"]
	if(!overmap)
		to_chat(usr, SPAN_WARNING("You need to be on an overmap Z-level to place down a trade hub."))
		return

	if(T.x > overmap.map_size_x || T.y > overmap.map_size_y) // This might need to be changed into a 'is within bounds' proc if overmaps ever stop being a single rectangle.
		to_chat(usr, SPAN_WARNING("You need to be within the bounds of the overmap to place down a trade hub."))
		return

	var/hub_type = input(src, "Choose a type to add.") as null|anything in get_non_abstract_types(/obj/effect/overmap/trade_hub)
	if(hub_type)
		new hub_type(T)
		log_and_message_admins("has created a new overmap trade hub ([hub_type]) at [T.x], [T.y], [T.z].")

/// Deletes a trade hub, and all of their merchants contained inside.
/datum/admins/proc/remove_trade_hub()
	set category = "Debug"
	set name = "Remove Trade Hub"
	set desc = "Deletes a trade hub."

	if(!check_rights(R_DEBUG))
		return

	var/datum/trade_hub/hub = input(src, "Select a trade hub.", "Add Trade") as null|anything in SStrade.trade_hubs
	if(!hub || !(hub in SStrade.trade_hubs))
		return

	log_and_message_admins("has deleted trade hub '[hub.name]' ([hub.type]).")
	qdel(hub)

/// Instantiates a merchant inside of a specific trade hub.
/datum/admins/proc/add_merchant()
	set category = "Debug"
	set name = "Add Merchant"
	set desc = "Adds a merchant to a trade hub."

	if(!check_rights(R_DEBUG))
		return

	var/datum/trade_hub/hub = input(src, "Select a trade hub.", "Add Trade") as null|anything in SStrade.trade_hubs
	if(!hub || !(hub in SStrade.trade_hubs))
		return

	var/merchant_type = input(src, "Choose a type to add.") as null|anything in get_non_abstract_types(/datum/merchant)
	if(merchant_type && (hub in SStrade.trade_hubs) && !(merchant_type in hub.merchant_types_in_use))
		hub.add_merchant(merchant_type)
		log_and_message_admins("has created a new merchant ([merchant_type]) at trade hub [hub.name] ([hub.type]).")

/// Deletes a merchant from a specific trade hub.
/datum/admins/proc/remove_merchant()
	set category = "Debug"
	set name = "Remove Merchant"
	set desc = "Deletes a merchant from a trade hub."

	if(!check_rights(R_DEBUG))
		return

	var/datum/trade_hub/hub = input(src, "Select a trade hub.", "Add Trade") as null|anything in SStrade.trade_hubs
	if(!hub || !(hub in SStrade.trade_hubs))
		return

	var/datum/merchant/merchant = input(src, "Choose a trader to remove.") as null|anything in hub.merchants
	if(merchant && (merchant in hub.merchants))
		log_and_message_admins("has deleted merchant '[merchant.name]' ([merchant.type]) from trade hub [hub.name] ([hub.type]).")
		qdel(merchant)
