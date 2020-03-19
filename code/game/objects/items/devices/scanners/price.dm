/obj/item/scanner/price
	name = "price scanner"
	desc = "Using an up-to-date database of various costs and prices, this device estimates the market price of an item up to 0.001% accuracy."
	icon_state = "price_scanner"
	origin_tech = "{'" + TECH_MATERIAL + "':6,'" + TECH_MAGNET + "':4}"
	scan_sound = 'sound/effects/checkout.ogg'

/obj/item/scanner/price/is_valid_scan_target(atom/movable/target)
	return istype(target) && target.get_combined_monetary_worth() > 0

/obj/item/scanner/price/scan(atom/movable/target, mob/user)
	scan_title = "Price estimations"
	var/data = "\The [target]: [target.get_combined_monetary_worth()] [GLOB.using_map.local_currency_name]"
	if(!scan_data)
		scan_data = data
	else
		scan_data += "<br>[data]"
	user.show_message(data)