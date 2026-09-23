/obj/machinery/computer/modular/preset/merchant
	default_software = list(
		/datum/computer_file/program/merchant,
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor
	)

// Incase playable merchants wipe the program from their console.
// Intended as a failsafe to prevent the inability to interact with merchants if the software becomes lost.
// Generally unneeded if it's freely available to the normal crew via download.
/obj/item/stock_parts/computer/hard_drive/portable/merchant
	name = "merchant_list_1155_CRACKZ_1155_no_keygen_repack"
	desc = "An obviously pirated copy of well-known trading software."

/obj/item/stock_parts/computer/hard_drive/portable/merchant/Initialize()
	. = ..()
	store_file(new/datum/computer_file/program/merchant(src))