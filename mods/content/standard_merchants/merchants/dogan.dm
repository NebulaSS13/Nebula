/// A mysterious trading beacon, presumably managed by a simple algorithm that communicates with pre-recorded phrases that were added by "Mr. Dogan".
/// Because of that, there is no ability to negotiate with the beacon, making the prices set in stone.
/// Most of the products are of very dubious quality.
/datum/merchant/dogan
	name = "Dogan"
	origin = "Dogan's Gun Beacon"
	refuse_haggling = TRUE
	speech = /decl/merchant_speech/dogan
	positive_disposition_multiplier = 0
	negative_disposition_multiplier = 0
	supply_potential = list(/decl/merchant_potential_commodities/dogan)
	supply_price_modifiers = list(/decl/merchant_price_modifier/percentage = 1.2)


/decl/merchant_potential_commodities/dogan
	type_instructions = list(
		/obj/item/gun/projectile/zipgun					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gun/projectile/bolt_action/sniper/ant	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gun/energy/laser/dogan				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gun/projectile/automatic/smg/uzi		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/webbing/holster				= MERCHANT_INCLUDE_ALL
	)


/decl/merchant_speech/dogan
	hailed = "Hello! This is an automatic recording of me, Mr. Dogan! I hope you like the... GUNS... \
	I've got in store for you today."
	denied_hail = "I formally welcome you to... NOT... visit our store!"
	trade_complete = "Thank you for... PURCHASING... that quality... "+MERCHANT_TOKEN_ITEM+"... from me!"
	forbidden_offer = "Thank you for... that quality... ILLEGAL OFFER THAT I WILL REFUSE... from me!"
	goods_not_accepted = "Thank you for... that quality... OFFER THAT ISN'T MONEY THAT I WILL REFUSE... from me!"
	not_enough_value = "Thank you for... that quality... OFFER THAT IS NOT ENOUGH... from me!"
	how_much = "Thank you for... ASKING ME ABOUT MY PRICES... that quality... "+MERCHANT_TOKEN_ITEM+" is \
	worth "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+"... from me!"
	compliment_failure = "Thank you for... that quality... COMPLIMENT... from me!"
	compliment_success = "Thank you for... that quality... COMPLIMENT... from me!"
	insult_high_opinion = "Thank you for... that quality... COMPLIMENT... from me!"
	insult_low_opinion = "Thank you for... that quality... COMPLIMENT... from me!"
	bribe_failure = "Your... BLATANT BRIBERY... is... UNNECESSARY!"
	staying_put = "Thank you for... that quality... USELESS QUESTION... from me!"
	no_haggling = "Your... NEGOTIATION... is... UNNECESSARY!"


/obj/item/gun/projectile/bolt_action/sniper/ant
	name = "anti-material rifle"
	desc = "A portable anti-armour rifle fitted with a scope, the HI PTR-7 Rifle was originally designed to used against armoured \
	exosuits. It is capable of punching through windows and non-reinforced walls with ease. Fires armor piercing 14.5mm shells. \
	This replica however fires pistol rounds."
	ammo_type = /obj/item/ammo_magazine/pistol/small
	caliber = CALIBER_PISTOL_SMALL


/obj/item/gun/energy/laser/dogan
	desc = "This carbine works just as well as a normal carbine. Most of the time."

/obj/item/gun/energy/laser/dogan/consume_next_projectile()
	projectile_type = pick(/obj/item/projectile/beam/midlaser, /obj/item/projectile/beam/lasertag/red, /obj/item/projectile/beam)
	return ..()

