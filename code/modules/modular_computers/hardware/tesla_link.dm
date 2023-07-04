/obj/item/stock_parts/computer/tesla_link
	name = "tesla link"
	desc = "An advanced tesla link that wirelessly recharges connected device from nearby area power controller."
	critical = FALSE
	icon_state = "teslalink"
	w_class = ITEM_SIZE_TINY
	origin_tech = "{'programming':2,'powerstorage':3,'engineering':2}"
	material = /decl/material/solid/metal/steel

	var/passive_charging_rate = 250			// W
