/// Buys and sells various kinds of animals and animal accessories.
/datum/merchant/transient/pet_shop
	name = "Pet Shop Owner"
	name_background = /decl/background_detail/heritage/human
	origin = "Pet Shop"
	possible_origins = list(
		"Paws-Out",
		"Pets-R-Smart",
		"Tentacle Companions",
		"Xeno-Pets and Assorted Goods",
		"Barks and Drools"
	)
	accepts_goods_as_payment = TRUE
	speech = /decl/merchant_speech/xeno_shop/pet_shop
	supply_potential = list(
		/decl/merchant_potential_commodities/pet_shop_supply,
		/decl/merchant_potential_commodities/pet_shop_animals
	)
	demand_potential = list(/decl/merchant_potential_commodities/pet_shop_animals)
	refuse_haggling = TRUE


/decl/merchant_potential_commodities/pet_shop_supply
	type_instructions = list(
		/obj/item/dociler								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/structure/dogbed							= MERCHANT_INCLUDE_THIS_TYPE
	)

/decl/merchant_potential_commodities/pet_shop_animals
	type_instructions = list(
		/mob/living/simple_animal/corgi					= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/passive/cat			= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/crab					= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/lizard				= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/passive/mouse			= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/mushroom				= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/tindalos				= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/tomato				= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/cow					= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/chick					= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/fowl/chicken			= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/fowl/duck				= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/yithian				= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/hostile/beast/diyaab	= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/hostile/bear			= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/hostile/beast/shantak = MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/hostile/parrot		= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/hostile/beast/samak	= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/hostile/goat			= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/hostile/carp			= MERCHANT_INCLUDE_THIS_TYPE
	)
	extra_requirements = list(/decl/merchant_commodity_requirement/mobs/is_alive = TRUE)


/decl/merchant_speech/xeno_shop/pet_shop
	hailed = "Welcome to my xeno-pet shop! Here you will find many wonderful companions. Some a bit more... \
	aggressive than others. But companions none the less. I also buy pets, or trade them."
	denied_hail = "I no longer wish to speak to you."
	how_much = "This is a fine specimen. I believe it will cost you "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+"."
	compliment_failure = "That was almost charming."
	insult_high_opinion = "I ask you to stop. We can be peaceful. I know we can."
	insult_low_opinion = "My interactions with you are becoming less than fruitful."
	bribe_failure = "I'm not going to do that. I have places to be."
	bribe_success = "Hm. It'll be good for the animals, so sure."
	leaving_soon = "I'll be here for another "+MERCHANT_TOKEN_TIME+" minutes. I have places to be."