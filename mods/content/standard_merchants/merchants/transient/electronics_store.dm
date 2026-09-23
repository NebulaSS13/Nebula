/// Sells electronic components and some consumer electronics.
/datum/merchant/transient/electronics_store
	name = "Electronics Shop Employee"
	origin = "Electronics Shop"
	possible_origins = list(
		"Best Sale",
		"Overstore",
		"Oldegg",
		"Circuit Citadel",
		"Silicon Village",
		"Positronic Solutions LLC",
		"Sunvolt Inc."
	)
	supply_potential = list(/decl/merchant_potential_commodities/electronics_store)
	speech = /decl/merchant_speech/electronics_store
	refuse_haggling = TRUE


/decl/merchant_potential_commodities/electronics_store
	type_instructions = list(
		/obj/item/stock_parts/computer/hard_drive						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/computer/hard_drive/advanced				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/computer/hard_drive/small					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/computer/hard_drive/micro					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/computer/battery_module					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/computer/battery_module/advanced			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/computer/battery_module/micro				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/computer/battery_module/nano				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/computer/processor_unit					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/computer/processor_unit/small				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/computer/network_card						= MERCHANT_INCLUDE_ALL,
		/obj/item/stock_parts/computer/nano_printer						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/computer/drive_slot						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/computer/card_slot						= MERCHANT_INCLUDE_ALL,
		/obj/item/stock_parts/computer/charge_stick_slot				= MERCHANT_INCLUDE_ALL,
		/obj/item/stock_parts/computer/data_disk_drive					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/computer/lan_port							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/computer/scanner							= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/stock_parts/capacitor									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/capacitor/adv								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/box/parts_pack/capacitor								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/manipulator								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/manipulator/nano							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/box/parts_pack/manipulator							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/matter_bin								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/matter_bin/adv							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/micro_laser								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/micro_laser/high							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/box/parts_pack/laser									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/scanning_module							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/scanning_module/adv						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/subspace/filter							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/box/parts_pack/keyboard								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stack/cable_coil/random								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/toolbox/repairs										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/console_screen							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/keyboard									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/power/apc/buildable						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/arcade						= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/stock_parts/circuitboard/autolathe					= MERCHANT_INCLUDE_ALL,
		/obj/item/stock_parts/circuitboard/batteryrack					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/camera						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/cell_charger					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/recharger					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/recharger/wall				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/microwave					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/dehumidifier					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/fax_machine					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/fridge						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/juicer						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/jukebox						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/modem						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/relay						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/relay/wall_mounted			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/recycler						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/router						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/router/wall_mounted			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/washer						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/cell													= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/cell/crap												= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/cell/high												= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/music_player/boombox									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/taperecorder											= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/magnetic_tape/random									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/camera												= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/camera/tvcamera										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/camera_film											= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/card/data/disk										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/eftpos												= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/flashlight											= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/flashlight/maglight									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gps													= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/lightreplacer											= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/megaphone												= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/multitool												= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/radio/headset											= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/radio/shortwave										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/modular_computer/holotablet							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/modular_computer/holotablet/curved					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/modular_computer/holotablet/round						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/modular_computer/holotablet/side						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/modular_computer/holotablet/wide						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/modular_computer/laptop/preset						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/modular_computer/pda									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/box/PDAs												= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/box/wrist												= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/modular_computer/tablet/preset/custom_loadout/cheap	= MERCHANT_INCLUDE_THIS_TYPE
	)


/decl/merchant_speech/electronics_store
	hailed = "Hello, "+MERCHANT_TOKEN_PLAYER_HONORIFIC+"! Welcome to "+MERCHANT_TOKEN_ORIGIN+", I hope you find what you are looking for."
	denied_hail = "Your call has been disconnected."
	trade_complete = "Thank you for shopping at "+MERCHANT_TOKEN_ORIGIN+", would you like to get the extended warranty as well?"
	forbidden_offer = MERCHANT_TOKEN_PLAYER_HONORIFIC+", this is a /electronics/ store."
	goods_not_accepted = "As much as I'd love to buy that from you, I can't."
	not_enough_value = "Your offer isn't adequate, "+MERCHANT_TOKEN_PLAYER_HONORIFIC+"."
	how_much = "Your total comes out to "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+"."
	compliment_failure = "Hahaha! Yeah... funny..."
	compliment_success = "That's very nice of you!"
	insult_high_opinion = "That was uncalled for, "+MERCHANT_TOKEN_PLAYER_HONORIFIC+". Don't make me get my manager."
	insult_low_opinion = MERCHANT_TOKEN_PLAYER_HONORIFIC+", I am allowed to hang up the phone if you continue, "+MERCHANT_TOKEN_PLAYER_HONORIFIC+"."
	bribe_failure = "Sorry, "+MERCHANT_TOKEN_PLAYER_HONORIFIC+", but I can't really do that."
	bribe_success = "Why not! Glad to be here for a few more minutes."
	leaving_soon = "I can stay for another "+MERCHANT_TOKEN_TIME+" minutes."
