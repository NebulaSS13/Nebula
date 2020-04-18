/obj/item/scanner/price
	name = "price scanner"
	desc = "Using an up-to-date database of various costs and prices, this device estimates the market price of an item up to 0.001% accuracy."
	icon = 'icons/obj/items/device/scanner/price_scanner.dmi'
	icon_state = "price_scanner"
	origin_tech = "{'materials':6,'magnets':4}"
	scan_sound = 'sound/effects/checkout.ogg'
	material = MAT_STEEL
	matter = list(
		MAT_GLASS = MATTER_AMOUNT_REINFORCEMENT,
		MAT_SILVER = MATTER_AMOUNT_TRACE
	)
	var/scanner_currency

/obj/item/scanner/price/Initialize(ml, material_key)
	. = ..()
	if(!ispath(scanner_currency, /decl/currency))
		scanner_currency = GLOB.using_map.default_currency

/obj/item/scanner/price/is_valid_scan_target(atom/movable/target)
	return istype(target) && target.get_combined_monetary_worth() > 0

/obj/item/scanner/price/scan(atom/movable/target, mob/user)
	scan_title = "Price estimations"
	var/decl/currency/cur = decls_repository.get_decl(scanner_currency)
	var/data = "\The [target]: [cur.format_value(target.get_combined_monetary_worth())]"
	if(!scan_data)
		scan_data = data
	else
		scan_data += "<br>[data]"
	user.show_message(data)