#define CAT_NORMAL 1
#define CAT_HIDDEN 2  // also used in corresponding wires/vending.dm

/**
 *  Datum used to hold information about a product in a vending machine
 */

/datum/stored_items/vending_products
	/// Display name for the product
	item_name = "generic"
	/// Price to buy one
	var/price = 0
	/// Display color for vending machine listing
	var/display_color = null
	// CAT_HIDDEN for contraband
	var/category = CAT_NORMAL
