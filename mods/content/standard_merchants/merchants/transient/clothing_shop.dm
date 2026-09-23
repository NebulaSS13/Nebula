/// Sells various kinds of clothes.
/// This one in particula rsells shirts, pants, dresses, and jumpsuits.
/datum/merchant/transient/clothing_shop
	name = "Clothing Store Employee"
	origin = "Clothing Store"
	possible_origins = list(
		"Space Eagle",
		"Banana Democracy",
		"Forever 22",
		"Textiles Factory Warehouse Outlet",
		"Blocks Brothers"
	)
	speech = /decl/merchant_speech/clothing_shop
	supply_potential = list(/decl/merchant_potential_commodities/clothing_shop)
	refuse_haggling = TRUE

// This is very manual and somewhat tedious but it will also prevent future issues with weird stuff like quantum mechanic clothes,
// or other future new content creeping into the merchants' product lines, and then becoming accessible to players.
// It also attempts to avoid pieces of clothing that share the same name, as otherwise players can't distinguish between them.
/decl/merchant_potential_commodities/clothing_shop
	type_instructions = list(
		/obj/item/clothing/dress						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/dress/gown					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/dress/green					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/dress/orange					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/dress/pink					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/dress/purple					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/dress/white					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/dress/yellow					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/dress/sun					= MERCHANT_INCLUDE_ALL,
		/obj/item/clothing/dress/short					= MERCHANT_INCLUDE_ALL,
		/obj/item/clothing/dress/maxi					= MERCHANT_INCLUDE_ALL,
		/obj/item/clothing/jumpsuit						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/jumpsuit/black				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/jumpsuit/blackjumpshorts		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/jumpsuit/blue				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/jumpsuit/brown				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/jumpsuit/green				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/jumpsuit/grey				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/jumpsuit/lightblue			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/jumpsuit/lightpurple			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/jumpsuit/orange				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/jumpsuit/pink				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/jumpsuit/rainbow				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/jumpsuit/red					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/jumpsuit/skirt				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/jumpsuit/skirt/short			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/jumpsuit/white				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/jumpsuit/yellow				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/baggy					= MERCHANT_INCLUDE_ALL,
		/obj/item/clothing/pants/casual					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/casual/blackjeans		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/casual/classicjeans	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/casual/greyjeans		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/casual/mustangjeans	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/casual/track			= MERCHANT_INCLUDE_ALL,
		/obj/item/clothing/pants/casual/youngfolksjeans	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/formal					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/formal/black			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/formal/gray			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/formal/khaki			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/formal/red				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/formal/tan				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/pj						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/pj/blue				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/shorts					= MERCHANT_INCLUDE_ALL,
		/obj/item/clothing/pants/slacks					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/slacks/black			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/slacks/blue			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/slacks/navy			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/slacks/purple			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/slacks/red				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/slacks/tan				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/pants/slacks/white			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shirt/blouse					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shirt/button					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shirt/button/blue			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shirt/button/tan				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shirt/flannel/red			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shirt/hawaii/random			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shirt/pj						= MERCHANT_INCLUDE_ALL,
		/obj/item/clothing/shirt/polo					= MERCHANT_INCLUDE_ALL,
		/obj/item/clothing/shirt/sweater				= MERCHANT_INCLUDE_ALL,
		/obj/item/clothing/shirt/tee					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/gentlecoat				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/hooded_cloak			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/jacket/black			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/jacket/blazer			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/jacket/blue				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/jacket/bomber			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/jacket/brown			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/jacket/burgundy			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/jacket/charcoal			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/jacket/checkered		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/jacket/hoodie			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/jacket/hoodie/black		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/jacket/leather			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/jacket/navy				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/jacket/purple			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/jacket/tan				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/jacket/vest/black		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/jacket/waistcoat/black	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/jacket/winter			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/leathercoat				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/poncho					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/poncho/blue				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/poncho/green			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/poncho/purple			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/poncho/red				= MERCHANT_INCLUDE_THIS_TYPE
	)

/// This merchant sells exclusively shoes.
/datum/merchant/transient/clothing_shop/shoes
	possible_origins = list(
		"Foot Safe",
		"Paysmall",
		"Popular Footwear",
		"Grimbly's Shoes",
		"Right Steps"
	)
	supply_potential = list(/decl/merchant_potential_commodities/shoe_shop)


/decl/merchant_potential_commodities/shoe_shop
	type_instructions = list(
		/obj/item/clothing/shoes/athletic				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/color/black			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/color/blue				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/color/brown			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/color/green			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/color/orange			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/color/purple			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/color/red				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/color/white			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/color/yellow			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/color/hightops			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/color/hightops/black	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/color/hightops/blue	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/color/hightops/brown	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/color/hightops/green	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/color/hightops/orange	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/color/hightops/purple	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/color/hightops/red		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/color/hightops/yellow	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/dress					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/dress/white			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/flats					= MERCHANT_INCLUDE_ALL,
		/obj/item/clothing/shoes/heels					= MERCHANT_INCLUDE_ALL,
		/obj/item/clothing/shoes/jackboots				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/rainbow				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/sandal					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/slippers				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/winterboots			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/workboots				= MERCHANT_INCLUDE_THIS_TYPE
	)

/// This merchant sells hats, gloves, and some accessories (for people, not accessories for hats or gloves).
/datum/merchant/transient/clothing_shop/hats_gloves_accessories
	possible_origins = list(
		"Baldie's Hats and Accessories",
		"The Right Fit",
		"Like a Glove",
		"Space Fashion"
	)
	supply_potential = list(/decl/merchant_potential_commodities/hats_gloves_accessories)


/decl/merchant_potential_commodities/hats_gloves_accessories
	type_instructions = list(
		/obj/item/clothing/neck/necklace/random			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/neck/scarf					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/neck/scarf/christmas			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/neck/tie/black				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/neck/tie/blue				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/neck/tie/blue_clip			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/neck/tie/bow/red				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/neck/tie/bow/ugly			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/neck/tie/brown				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/neck/tie/green				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/neck/tie/horrible			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/neck/tie/navy				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/neck/tie/red					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/neck/tie/long/blue			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/neck/tie/long/red			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/neck/tie/long/yellow			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/gloves/bracelet				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/gloves/ring/silver			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/gloves/ring/gold				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/gloves/ring/bronze			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/gloves/ring/platinum			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/gloves/ring/engagement		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/gloves/black					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/gloves/rainbow				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/gloves/evening				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/bandana/green			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/bandana/orange			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/beanie					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/beaverhat				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/boaterhat				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/bowler					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/feathertrilby			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/fedora					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/flatcap					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/hairflower				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/hairflower/bow			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/headband				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/hijab					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/kippa					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/kitty					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/rastacap				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/santahat				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/soft/black				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/soft/blue				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/soft/green				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/soft/grey				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/soft/orange				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/soft/purple				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/soft/rainbow			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/soft/red				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/soft/yellow				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/taqiyah					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/that					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/turban					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/ushanka					= MERCHANT_INCLUDE_THIS_TYPE
	)


/decl/merchant_speech/clothing_shop
	hailed = "Hello, "+MERCHANT_TOKEN_PLAYER_HONORIFIC+"! Welcome to "+MERCHANT_TOKEN_ORIGIN+"!"
	denied_hail = "We do not trade with rude customers. Consider yourself blacklisted."
	trade_complete = "Thank you for shopping at "+MERCHANT_TOKEN_ORIGIN+". Remember: We cannot accept returns without the original tags!"
	forbidden_offer = "Hm, how about no?"
	goods_not_accepted = "We don't buy, "+MERCHANT_TOKEN_PLAYER_HONORIFIC+". Only sell."
	not_enough_value = "Sorry, "+MERCHANT_TOKEN_ORIGIN+" policy to not accept trades below our marked prices."
	how_much = "Your total comes out to "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+"."
	compliment_failure = "Excuse me?"
	compliment_success = "Aw, you're so nice!"
	insult_high_opinion = MERCHANT_TOKEN_PLAYER_HONORIFIC+"."
	insult_low_opinion = "Wow, I don't have to take this."
	bribe_failure = MERCHANT_TOKEN_ORIGIN+" policy clearly states we cannot stay for more than the designated time."
	bribe_success = "Hm.... sure! We'll have a few minutes of 'engine troubles'."