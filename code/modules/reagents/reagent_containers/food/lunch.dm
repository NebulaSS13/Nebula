var/global/list/lunchables_lunches_ = list(
									/obj/item/food/sandwich,
									/obj/item/food/slice/meatbread/filled,
									/obj/item/food/slice/tofubread/filled,
									/obj/item/food/slice/creamcheesebread/filled,
									/obj/item/food/slice/pizza/margherita/filled,
									/obj/item/food/slice/pizza/meat/filled,
									/obj/item/food/slice/pizza/mushroom/filled,
									/obj/item/food/slice/pizza/vegetable/filled,
									/obj/item/food/tastybread,
									/obj/item/food/liquidfood,
									/obj/item/food/jellysandwich/cherry,
									/obj/item/food/tossedsalad
								  )

var/global/list/lunchables_snacks_ = list(
									/obj/item/food/donut/jelly,
									/obj/item/food/muffin,
									/obj/item/food/popcorn,
									/obj/item/food/sosjerky,
									/obj/item/food/no_raisin,
									/obj/item/food/spacetwinkie,
									/obj/item/food/cheesiehonkers,
									/obj/item/food/poppypretzel,
									/obj/item/food/processed_grown/sticks/carrot,
									/obj/item/food/candiedapple,
									/obj/item/food/applepie,
									/obj/item/food/cherrypie,
									/obj/item/food/plumphelmetbiscuit,
									/obj/item/food/appletart,
									/obj/item/food/slice/carrotcake/filled,
									/obj/item/food/slice/cheesecake/filled,
									/obj/item/food/slice/plaincake/filled,
									/obj/item/food/slice/orangecake/filled,
									/obj/item/food/slice/limecake/filled,
									/obj/item/food/slice/lemoncake/filled,
									/obj/item/food/slice/chocolatecake/filled,
									/obj/item/food/slice/birthdaycake/filled,
									/obj/item/food/watermelonslice,
									/obj/item/food/slice/applecake/filled,
									/obj/item/food/slice/pumpkinpie/filled
								   )

var/global/list/lunchables_drinks_ = list(
									/obj/item/chems/drinks/cans/cola,
									/obj/item/chems/drinks/cans/waterbottle,
									/obj/item/chems/drinks/cans/space_mountain_wind,
									/obj/item/chems/drinks/cans/dr_gibb,
									/obj/item/chems/drinks/cans/starkist,
									/obj/item/chems/drinks/cans/space_up,
									/obj/item/chems/drinks/cans/lemon_lime,
									/obj/item/chems/drinks/cans/iced_tea,
									/obj/item/chems/drinks/cans/grape_juice,
									/obj/item/chems/drinks/cans/tonic,
									/obj/item/chems/drinks/cans/sodawater
								   )

// This default list is a bit different, it contains items we don't want
var/global/list/lunchables_drink_reagents_ = list(
											/decl/material/liquid/drink/dry_ramen,
											/decl/material/liquid/drink/hell_ramen,
											/decl/material/liquid/drink/hot_ramen,
											/decl/material/liquid/drink/mutagencola,
											/decl/material/liquid/drink/syrup,
											/decl/material/liquid/drink/syrup/mint,
											/decl/material/liquid/drink/syrup/chocolate,
											/decl/material/liquid/drink/syrup/caramel,
											/decl/material/liquid/drink/syrup/vanilla
										)

// This default list is a bit different, it contains items we don't want
var/global/list/lunchables_ethanol_reagents_ = list(
												/decl/material/liquid/ethanol/coffee,
												/decl/material/liquid/ethanol/hooch,
												/decl/material/liquid/ethanol/thirteenloko,
												/decl/material/liquid/ethanol/pwine
											)

/proc/lunchables_lunches()
	if(!(lunchables_lunches_[lunchables_lunches_[1]]))
		lunchables_lunches_ = init_lunchable_list(lunchables_lunches_)
	return lunchables_lunches_

/proc/lunchables_snacks()
	if(!(lunchables_snacks_[lunchables_snacks_[1]]))
		lunchables_snacks_ = init_lunchable_list(lunchables_snacks_)
	return lunchables_snacks_

/proc/lunchables_drinks()
	if(!(lunchables_drinks_[lunchables_drinks_[1]]))
		lunchables_drinks_ = init_lunchable_list(lunchables_drinks_)
	return lunchables_drinks_

/proc/lunchables_drink_reagents()
	if(!(lunchables_drink_reagents_[lunchables_drink_reagents_[1]]))
		lunchables_drink_reagents_ = init_lunchable_reagent_list(lunchables_drink_reagents_, /decl/material/liquid/drink)
	return lunchables_drink_reagents_

/proc/lunchables_ethanol_reagents()
	if(!(lunchables_ethanol_reagents_[lunchables_ethanol_reagents_[1]]))
		lunchables_ethanol_reagents_ = init_lunchable_reagent_list(lunchables_ethanol_reagents_, /decl/material/liquid/ethanol)
	return lunchables_ethanol_reagents_

/proc/init_lunchable_list(var/list/lunches)
	. = list()
	for(var/lunch in lunches)
		var/obj/O = lunch
		.[initial(O.name)] = lunch
	return sortTim(., /proc/cmp_text_asc)

/proc/init_lunchable_reagent_list(var/list/banned_reagents, var/reagent_types)
	. = list()
	for(var/reagent_type in subtypesof(reagent_types))
		if(reagent_type in banned_reagents)
			continue
		var/decl/material/reagent = reagent_type
		.[initial(reagent.name)] = reagent_type
	return sortTim(., /proc/cmp_text_asc)
