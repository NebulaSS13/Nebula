// These are basically USB data sticks and may be used to transfer files between devices
/obj/item/stock_parts/computer/hard_drive/portable
	name = "basic data crystal"
	desc = "Small crystal with imprinted photonic circuits that can be used to store data. Its capacity is 16 GQ."
	power_usage = 10
	icon_state = "flashdrive_basic"
	hardware_size = 1
	max_capacity = 16
	origin_tech = "{'programming':1}"
	material = /decl/material/solid/glass

/obj/item/stock_parts/computer/hard_drive/portable/advanced
	name = "advanced data crystal"
	desc = "Small crystal with imprinted high-density photonic circuits that can be used to store data. Its capacity is 64 GQ."
	power_usage = 20
	icon_state = "flashdrive_advanced"
	hardware_size = 1
	max_capacity = 64
	origin_tech = "{'programming':2}"
	material = /decl/material/solid/glass

/obj/item/stock_parts/computer/hard_drive/portable/super
	name = "super data crystal"
	desc = "Small crystal with imprinted ultra-density photonic circuits that can be used to store data. Its capacity is 256 GQ."
	power_usage = 40
	icon_state = "flashdrive_super"
	hardware_size = 1
	max_capacity = 256
	origin_tech = "{'programming':4}"
	material = /decl/material/solid/glass

/obj/item/stock_parts/computer/hard_drive/portable/Initialize()
	. = ..()
	stored_files = list()
	recalculate_size()

// For idiot merchants who wipe the program from their console.
/obj/item/stock_parts/computer/hard_drive/portable/merchant
	name = "merchant_list_1155_CRACKZ_1155_no_keygen_repack"
	desc = "An obviously pirated copy of well-known trading software."

/obj/item/stock_parts/computer/hard_drive/portable/merchant/Initialize()
	. = ..()
	store_file(new/datum/computer_file/program/merchant(src))

// Special disk for antags containing all the evil programs and readme for them
/obj/item/stock_parts/computer/hard_drive/portable/advanced/warez
	var/list/warez = list(
		/datum/computer_file/program/access_decrypter,
		/datum/computer_file/program/camera_monitor/hacked,
		/datum/computer_file/program/revelation,
		/datum/computer_file/program/game
	)

/obj/item/stock_parts/computer/hard_drive/portable/advanced/warez/Initialize()
	. = ..()
	var/list/readme_data = list("\[fontred\]Downloaded from SpaceHaxx1337. Read or die\[/font\]")
	for(var/T in warez)
		var/datum/computer_file/program/P = new T(src)
		readme_data += "_,.-'~'-.,__,.-'~'-.,__,.-'~'-.,"
		readme_data += "\[h3\][P.filedesc]\[/h3\] Filename: \[b\][P.filename]\[/b\]\[br\]"
		readme_data += "[P.extended_desc]"
		store_file(P)
	var/datum/computer_file/data/text/readme = new(src)
	readme.stored_data = jointext(readme_data, "\[br\]")
	readme.filename = "___README___"
	store_file(readme)
	