/obj/item/stock_parts/computer/tesla_link
	name = "tesla link"
	desc = "An advanced tesla link that wirelessly recharges connected device from nearby area power controller."
	critical = 0
	enabled = 1
	icon_state = "teslalink"
	hardware_size = 1
	origin_tech = @'{"programming":2,"powerstorage":3,"engineering":2}'
	material = /decl/material/solid/metal/steel

	var/passive_charging_rate = 250			// W
