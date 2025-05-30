/// A merchant who sells devices, odds and ends, and some basic medical supplies.
/// Like most other retail-themed merchants, their prices are set in stone and they don't buy anything.
/datum/merchant/drugstore
	name_background = /decl/background_detail/heritage/human
	origin = "Drugstore"
	possible_origins = list(
		"Buy 'n Save",
		"Drug Carnival",
		"C&B",
		"Fentles",
		"Dr. Goods",
		"Beevees",
		"McGillicuddy's"
	)
	supply_potential = list(/decl/merchant_potential_commodities/drugstore)
	supply_price_modifiers = list(/decl/merchant_price_modifier/percentage = 1.2)
	speech = /decl/merchant_speech/drugstore
	refuse_haggling = TRUE


/decl/merchant_potential_commodities/drugstore
	type_instructions = list(
		/obj/item/flashlight						= MERCHANT_INCLUDE_ALL,
		/obj/item/kit/paint							= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/aicard							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/binoculars						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/cable_painter						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/flash								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/paint_sprayer						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/multitool							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/lightreplacer						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/megaphone							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/paicard							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/scanner/health					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/scanner/breath					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/scanner/gas						= MERCHANT_INCLUDE_ALL,
		/obj/item/scanner/spectrometer				= MERCHANT_INCLUDE_ALL,
		/obj/item/scanner/reagent					= MERCHANT_INCLUDE_ALL,
		/obj/item/scanner/xenobio					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/suit_cooling_unit					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/t_scanner							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/taperecorder						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/batterer							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/synthesized_instrument/violin 	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/hailer							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/uv_light							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/organ/internal/brain_interface	= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/robotanalyzer						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/chems/toner_cartridge				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/camera_film						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/camera							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/destTagger						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gps								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/measuring_tape					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/ano_scanner						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/core_sampler						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/depth_scanner						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/pinpointer/radio					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stack/medical						= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/stack/medical/ointment/crafted	= MERCHANT_EXCLUDE_ALL,
		/obj/item/stack/medical/bandage/crafted		= MERCHANT_EXCLUDE_ALL,
		/obj/item/stack/medical/splint/crafted		= MERCHANT_EXCLUDE_ALL,
		/obj/item/stack/medical/splint/improvised	= MERCHANT_EXCLUDE_ALL,
	)

/decl/merchant_speech/drugstore
	hailed = "Hello, hello! Bits and bobs and everything in between, I hope you find what you're looking for!"
	hailed_by_synth = "Ah! Hello, robot. We only sell things that, ah.... people can hold in their hands, unfortunately. \
	You are still allowed to buy, though!"
	denied_hail = "Oh no. I don't want to deal with YOU."
	trade_complete = "Thank you! Now remember, there isn't any return policy here, so be careful with that!"
	forbidden_offer = "Hm. Well that would be illegal, so no."
	goods_not_accepted = "I'm sorry, I only sell goods."
	not_enough_value = "Gotta pay more than that to get that!"
	how_much = "Well... I bought it for a lot, but I'll give it to you for "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+"."
	compliment_failure = "Uh... did you say something?"
	compliment_success = "Mhm! I can agree to that!"
	insult_high_opinion = "Wow, where was that coming from?"
	insult_low_opinion = "Don't make me blacklist your connection."
	bribe_failure = "Well, as much as I'd love to say 'yes', you realize I operate on a station, correct?"
	staying_put = "You realize I operate on a station, correct?"
	no_haggling = "Prices are non-negotiable."