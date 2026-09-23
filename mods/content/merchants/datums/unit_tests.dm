#define BASE_TEST_PRICE 1000

/obj/test_product
	abstract_type = /obj/test_product

/obj/test_product/get_base_value()
	return BASE_TEST_PRICE

/obj/test_product/one
	name = "1000-series widget"

/obj/test_product/two
	name = "2000-series widget"


/datum/merchant/test
	abstract_type = /datum/merchant/test
	name = "Test Merchant"
	supply_price_modifiers = list()
	supply_strategy = /decl/merchant_inventory_strategy/offer_everything
	demand_price_modifiers = list()
	demand_strategy = /decl/merchant_inventory_strategy/offer_everything
	price_variance = 1.0

/datum/merchant/test/same_products
	supply_potential = list(/decl/merchant_potential_commodities/test/one)
	demand_potential = list(/decl/merchant_potential_commodities/test/one)

/datum/merchant/test/distinct_products
	supply_potential = list(/decl/merchant_potential_commodities/test/one)
	demand_potential = list(/decl/merchant_potential_commodities/test/two)


/decl/merchant_potential_commodities/test
	abstract_type = /decl/merchant_potential_commodities/test

/decl/merchant_potential_commodities/test/one
	type_instructions = list(/obj/test_product/one = MERCHANT_INCLUDE_THIS_TYPE)

/decl/merchant_potential_commodities/test/two
	type_instructions = list(/obj/test_product/two = MERCHANT_INCLUDE_THIS_TYPE)

/datum/unit_test/merchant
	abstract_type = /datum/unit_test/merchant
	var/datum/merchant/my_merchant = /datum/merchant/test/distinct_products
	var/mob/fake_user = /mob

/datum/unit_test/merchant/setup_test()
	. = ..()
	my_merchant = new my_merchant()
	fake_user = new fake_user()


/datum/unit_test/merchant/disposition_price_change
	name = "MERCHANTS: Merchants shall modify prices according to disposition"

/datum/unit_test/merchant/disposition_price_change/start_test()
	my_merchant.demand_price_modifiers = list(/decl/merchant_price_modifier/disposition = 2.0)
	my_merchant.supply_price_modifiers = list(/decl/merchant_price_modifier/disposition = 0.5)
	my_merchant.set_disposition(/datum/merchant::MAX_DISPOSITION_THRESHOLD, fake_user)

	var/selling_price = my_merchant.get_item_value(/obj/test_product/one, /datum/merchant::TRANSACTION_SELLING, fake_user)
	var/buying_price = my_merchant.get_item_value(/obj/test_product/two, /datum/merchant::TRANSACTION_BUYING, fake_user)
	var/failures = 0

	if(buying_price <= BASE_TEST_PRICE)
		fail("Buying price did not increase with higher disposition. It was [buying_price], but it should've been greater than [BASE_TEST_PRICE].")
		failures++
	if(selling_price >= BASE_TEST_PRICE)
		fail("Selling price did not decrease with higher disposition. It was [selling_price], but it should've been less than [BASE_TEST_PRICE].")
		failures++

	my_merchant.set_disposition(-my_merchant.get_disposition(fake_user), fake_user)

	selling_price = my_merchant.get_item_value(/obj/test_product/one, /datum/merchant::TRANSACTION_SELLING, fake_user)
	buying_price = my_merchant.get_item_value(/obj/test_product/two, /datum/merchant::TRANSACTION_BUYING, fake_user)

	if(buying_price >= BASE_TEST_PRICE)
		fail("Buying price did not decrease with lower disposition. It was [buying_price], but it should've been less than [BASE_TEST_PRICE].")
		failures++
	if(selling_price <= BASE_TEST_PRICE)
		fail("Selling price did not increase with lower disposition. It was [selling_price], but it should've been greater than [BASE_TEST_PRICE].")
		failures++

	if(!failures)
		pass("Prices were modified based on disposition correctly.")
	return TRUE


/datum/unit_test/merchant/prevent_haggle_exploit
	name = "MERCHANTS: Merchants shall not allow haggling to be exploited"
	my_merchant = /datum/merchant/test/same_products

/datum/unit_test/merchant/prevent_haggle_exploit/start_test()
	my_merchant.haggling_refusal_threshold = initial(my_merchant.haggling_refusal_threshold) // Undo the randomization, to avoid a 1% chance of the tests passing anyways when they shouldn't.

	var/selling_price = my_merchant.get_item_value(/obj/test_product/one, /datum/merchant::TRANSACTION_SELLING, fake_user)
	var/selling_haggle_limit = my_merchant.calculate_haggle_limit(/obj/test_product/one, /datum/merchant::TRANSACTION_SELLING, fake_user)
	var/buying_price = my_merchant.get_item_value(/obj/test_product/one, /datum/merchant::TRANSACTION_BUYING, fake_user)
	var/buying_haggle_limit = my_merchant.calculate_haggle_limit(/obj/test_product/one, /datum/merchant::TRANSACTION_BUYING, fake_user)
	var/failures = 0

	if(buying_haggle_limit > selling_price)
		fail("Merchants could be haggled to buy over their selling price. Buying haggle limit was [buying_haggle_limit]. Selling price was [selling_price].")
		failures++
	if(selling_haggle_limit > buying_price)
		fail("Merchants could be haggled to sell over their buying price. Selling haggle limit was [selling_haggle_limit]. Buying price was [buying_price].")
		failures++
	if(!failures)
		pass("Haggling exploit was prevented.")
	return TRUE


/datum/unit_test/merchant/capped_buy_price_if_selling_same_item_for_cheaper
	name = "MERCHANTS: Merchants shall not buy items for more than their sell price if it could lead to an exploit"
	my_merchant = /datum/merchant/test/same_products

/datum/unit_test/merchant/capped_buy_price_if_selling_same_item_for_cheaper/start_test()
	my_merchant.demand_price_modifiers = list(/decl/merchant_price_modifier/percentage = 2.0)

	var/selling_price = my_merchant.get_item_value(/obj/test_product/one, /datum/merchant::TRANSACTION_SELLING, fake_user)
	var/buying_price = my_merchant.get_item_value(/obj/test_product/one, /datum/merchant::TRANSACTION_BUYING, fake_user)

	if(buying_price > selling_price)
		fail("Merchant could buy items for more than their selling price, enabling an exploit. Buying price was [buying_price], and selling price was [selling_price].")
	else if(buying_price == selling_price)
		pass("Buying price was capped to selling price.")
	else
		fail("Buying price was less than selling price, rendering the test invalid. Buying price was [buying_price], and selling price was [selling_price].")
	return TRUE


/datum/unit_test/merchant/uncapped_buy_price_if_selling_same_item
	name = "MERCHANTS: Merchants shall not cap buying price to selling price if unnecessary"
	my_merchant = /datum/merchant/test/same_products

/datum/unit_test/merchant/uncapped_buy_price_if_selling_same_item/start_test()
	my_merchant.demand_price_modifiers = list(/decl/merchant_price_modifier/percentage = 0.5)

	var/buying_price = my_merchant.get_item_value(/obj/test_product/one, /datum/merchant::TRANSACTION_BUYING, fake_user)
	var/selling_price = my_merchant.get_item_value(/obj/test_product/one, /datum/merchant::TRANSACTION_SELLING, fake_user)

	if(buying_price < selling_price)
		pass("Buying price was unaffected.")
	else
		fail("Buying price was unnecessarily capped. Buying price was [buying_price], and selling price was [selling_price].")
	return TRUE


/datum/unit_test/merchant/dispositon_changes_when_buying_and_selling
	name = "MERCHANTS: Merchants shall gain disposition when buying or selling something"
	my_merchant = /datum/merchant/test/distinct_products

/datum/unit_test/merchant/dispositon_changes_when_buying_and_selling/start_test()
	my_merchant.transaction_disposition_shift(list(/obj/test_product/one), /datum/merchant::TRANSACTION_SELLING, fake_user)
	if(my_merchant.get_disposition(fake_user) <= 0)
		fail("Merchant disposition did not increase after selling a product. It was [my_merchant.get_disposition(fake_user)].")

	my_merchant.set_disposition(0, fake_user)
	my_merchant.transaction_disposition_shift(list(/obj/test_product/two), /datum/merchant::TRANSACTION_BUYING, fake_user)
	if(my_merchant.get_disposition(fake_user) <= 0)
		fail("Merchant disposition did not increase after buying a product. It was [my_merchant.get_disposition(fake_user)].")
	pass("Merchant disposition increased when buying or selling.")
	return TRUE


/datum/unit_test/merchant/no_disposition_change_if_buying_and_selling_same_item_for_same_price
	name = "MERCHANTS: Merchants shall not gain disposition if buying and selling the same item for the same price"
	my_merchant = /datum/merchant/test/same_products

/datum/unit_test/merchant/no_disposition_change_if_buying_and_selling_same_item_for_same_price/start_test()
	my_merchant.transaction_disposition_shift(list(/obj/test_product/one), /datum/merchant::TRANSACTION_SELLING, fake_user)
	my_merchant.transaction_disposition_shift(list(/obj/test_product/one), /datum/merchant::TRANSACTION_BUYING, fake_user)
	if(my_merchant.get_disposition(fake_user) != 0)
		fail("Merchant disposition increased after buying and selling the same item for the same price. The disposition was [my_merchant.get_disposition(fake_user)].")
	else
		pass("Merchant disposition did not increase.")
	return TRUE


/datum/unit_test/merchant/reduced_disposition_change_if_buying_and_selling_same_item_for_different_prices
	name = "MERCHANTS: Merchants shall reduce disposition gain if buying and selling the same item for different prices"
	my_merchant = /datum/merchant/test/same_products

/datum/unit_test/merchant/reduced_disposition_change_if_buying_and_selling_same_item_for_different_prices/start_test()
	my_merchant.transaction_disposition_shift(list(/obj/test_product/one), /datum/merchant::TRANSACTION_SELLING, fake_user)
	my_merchant.transaction_disposition_shift(list(/obj/test_product/one), /datum/merchant::TRANSACTION_BUYING, fake_user)
	var/normal_disposition = my_merchant.get_disposition(fake_user)

	my_merchant.set_disposition(0, fake_user)
	my_merchant.supply_price_modifiers = list(/decl/merchant_price_modifier/percentage = 2.0)
	my_merchant.transaction_disposition_shift(list(/obj/test_product/one), /datum/merchant::TRANSACTION_SELLING, fake_user)
	my_merchant.transaction_disposition_shift(list(/obj/test_product/one), /datum/merchant::TRANSACTION_BUYING, fake_user)

	if(my_merchant.get_disposition(fake_user) == normal_disposition)
		fail("Merchant disposition did not increase after buying and selling the same item for different prices. The disposition was [my_merchant.get_disposition(fake_user)].")
	else
		pass("Merchant disposition increased.")
	return TRUE


#undef BASE_TEST_PRICE