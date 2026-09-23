/// A trading outpost managed by a fairly sophisticated artificial intelligence. They ask for a wide range of random things, and sell products within their particular focus.
/// Like other AI-themed merchants, they are highly skilled in trade and are likely to have an advantage in negotiations.
/// They will also not play favorites, and will not consider disposition as a factor in pricing.
/// They also essentially have infinite patience and won't care about most things that might offend merchants made out of flesh.
/datum/merchant/trading_beacon
	name = "AI"
	origin = "Trading Beacon"
	name_background = /decl/background_detail/heritage/synthetic // This just results in a human name, but if that ever changes, the merchant will change with it.
	merchant_languages = list(
		/decl/language/human/common,
		/decl/language/machine,
		/decl/language/binary
	)
	skill_level = SKILL_PROF
	refuse_anonymous_comms = TRUE
	accepts_goods_as_payment = TRUE
	speech = /decl/merchant_speech/ai
	positive_disposition_multiplier = 0
	negative_disposition_multiplier = 0
	supply_price_modifiers = list(
		/decl/merchant_price_modifier/percentage = 1.2,
		/decl/merchant_price_modifier/legacy_skill_disparity/supply = 1.2
	)
	supply_potential = list(/decl/merchant_potential_commodities/trading_beacon_supply)
	demand_potential = list(/decl/merchant_potential_commodities/trading_beacon_demand)

/datum/merchant/trading_beacon/New()
	. = ..()
	origin = "[origin] #[rand(100,999)]"


/decl/merchant_potential_commodities/trading_beacon_supply
	type_instructions = list(
		/obj/item/bag									= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/backpack								= MERCHANT_INCLUDE_ALL,
		/obj/item/backpack/cultpack						= MERCHANT_EXCLUDE_ALL,
		/obj/item/backpack/holding						= MERCHANT_EXCLUDE_ALL,
		/obj/item/backpack/chameleon					= MERCHANT_EXCLUDE_ALL,
		/obj/item/backpack/satchel/grey/withwallet		= MERCHANT_EXCLUDE_ALL,
		/obj/item/backpack/satchel/syndie_kit			= MERCHANT_EXCLUDE_ALL,
		/obj/item/backpack/dufflebag/syndie				= MERCHANT_EXCLUDE_ALL,
		/obj/item/backpack/dufflebag/syndie_kit			= MERCHANT_EXCLUDE_ALL,
		/obj/item/belt/champion							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/briefcase								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/box/fancy								= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/laundry_basket						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/secure_storage/briefcase				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/plant_satchel							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/ore_satchel							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/toolbox								= MERCHANT_INCLUDE_ALL,
		/obj/item/wallet								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/photo_album							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/glasses						= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/clothing/glasses/hud					= MERCHANT_EXCLUDE_ALL,
		/obj/item/clothing/glasses/blindfold/tape		= MERCHANT_EXCLUDE_ALL,
		/obj/item/clothing/glasses/chameleon			= MERCHANT_EXCLUDE_ALL,
		/obj/item/clothing/glasses/sunglasses/quantum	= MERCHANT_EXCLUDE_ALL
	)

// The old version of this merchant could ask to buy almost any subtype of `/obj/item`.
// This was terrible and often resulted in wanting to buy unobtainable, misleading, or nonsensical things like projectiles, "arcane energy",
// and very specific away mission mapspawn papers that still had the name 'sheet of paper'.
// Instead this is intended to be a Curated List of Junk(tm), so the merchant still appears to ask for a bunch of random stuff, but still be possible for players to actually sell them things.
/decl/merchant_potential_commodities/trading_beacon_demand
	type_instructions = list(
		/obj/item/aicard										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/aiModule/reset								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/bonegel										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/bonesetter									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/cautery										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/retractor										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/scalpel										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/scalpel/laser									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/surgicaldrill									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/sutures										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/circular_saw									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/cell/crap										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/cell											= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/cell/high										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/cell/super									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/cell/device/standard							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/gloves/insulated 					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/welding							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/magboots						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/inflatable									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/inflatable/door								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/flashlight									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/flashlight/maglight							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/flashlight/pen								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/duct_tape										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/tool/drill									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/lightreplacer									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/geiger										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/megaphone										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/rcd											= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/rcd_ammo										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/rpd											= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/apc					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/air_alarm			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/autolathe			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/arcade				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/smes					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/recycler				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/microwave			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/jukebox				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/circuit_imprinter	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/matter_bin						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/manipulator						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/capacitor							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/micro_laser						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/scanning_module					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/multitool										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/screwdriver									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/wrench										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/crowbar										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/wirecutters									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/fuelled_tool/welding							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/handcuffs										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/hailer										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/scanner/gas									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/scanner/health								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/scanner/mining								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/scanner/autopsy								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/soap											= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/beartrap										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/mop											= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/plunger										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/toy/blink										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/toy/eightball									= MERCHANT_INCLUDE_THIS_TYPE
	)


/datum/merchant/trading_beacon/mining
	origin = "Mining Beacon"
	supply_potential = list(/decl/merchant_potential_commodities/mining_beacon_supply)


/decl/merchant_potential_commodities/mining_beacon_supply
	type_instructions = list(
		/obj/item/stack/material/ore								= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/stack/material/pane/mapped/glass					= MERCHANT_INCLUDE_ALL,
		/obj/item/stack/material/pane/mapped/glass/fifty			= MERCHANT_EXCLUDE_ALL,
		/obj/item/stack/material/ingot/mapped/iron					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stack/material/brick/mapped/sandstone				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stack/material/brick/mapped/marble				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stack/material/gemstone/mapped/diamond			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stack/material/puck/mapped/uranium				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stack/material/panel/mapped/plastic				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stack/material/ingot/mapped/gold					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stack/material/ingot/mapped/silver				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stack/material/ingot/mapped/platinum				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stack/material/segment/mapped/mhydrogen			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stack/material/aerogel/mapped/tritium				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stack/material/ingot/mapped/osmium				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stack/material/sheet/mapped/steel					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stack/material/sheet/reinforced/mapped/plasteel	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/machinery/mining_drill									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/structure/drill_brace									= MERCHANT_INCLUDE_THIS_TYPE
	)

/datum/merchant/trading_beacon/manufacturing
	origin = "Manufacturing Beacon"
	supply_potential = list(/decl/merchant_potential_commodities/manufacturing_beacon_supply)


/decl/merchant_potential_commodities/manufacturing_beacon_supply
	type_instructions = list(
		/obj/structure/aicore				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/structure/girder				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/structure/grille				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/structure/mopbucket			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/structure/ore_box				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/structure/coatrack				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/structure/bookcase				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/structure/tank_rack			= MERCHANT_INCLUDE_SUBTYPES,
		/obj/structure/filing_cabinet		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/structure/safe					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/structure/plushie				= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/glass_jar					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/structure/sign					= MERCHANT_INCLUDE_SUBTYPES,
		/obj/structure/sign/double			= MERCHANT_EXCLUDE_ALL,
		/obj/structure/sign/plaque/golden	= MERCHANT_EXCLUDE_ALL,
		/obj/structure/sign/poster			= MERCHANT_EXCLUDE_THIS_TYPE,
		/obj/item/training_dummy			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/training_dummy/syndicate	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/training_dummy/alien		= MERCHANT_INCLUDE_THIS_TYPE
	)


/decl/merchant_speech/ai
	hailed = "Greetings, I am "+MERCHANT_TOKEN_MERCHANT_NAME+", Artificial Intelligence onboard "+MERCHANT_TOKEN_ORIGIN+", \
	tasked with trading goods in return for "+MERCHANT_TOKEN_CURRENCY+" and supplies."
	denied_hail = "We are sorry, your connection has been blacklisted. Have a nice day."
	no_anonymous = "We are sorry, but our laws prohibit trading with anonymous entities. Please return with valid identification."
	trade_complete = "Thank you for your patronage."
	not_enough_value = "I'm sorry, your offer is not worth what you are asking for."
	forbidden_offer = "You have offered a blacklisted item. My laws do not allow me to trade for that."
	how_much = MERCHANT_TOKEN_ITEM+" will cost you roughly "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+", or something of equal worth."
	what_wanted_beginning = "I have logged need for:"
	compliment_failure = "I'm sorry, I am not allowed to let compliments affect the trade."
	compliment_success = "Thank you, but that will not not change our business interactions."
	insult_high_opinion = "I do not understand, are we not on good terms?"
	insult_low_opinion = "I do not understand, are you insulting me?"
	bribe_failure = "You have attempted to give me money to stay, however, I am a station. I do not leave."
	staying_put = "I am a station. I do not leave."