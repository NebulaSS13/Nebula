/decl/hierarchy/supply_pack/galley
	name = "Galley"

/decl/hierarchy/supply_pack/galley/food
	name = "General - Kitchen supplies"
	contains = list(/obj/item/chems/condiment/flour = 6,
					/obj/item/chems/drinks/milk = 4,
					/obj/item/chems/drinks/soymilk = 2,
					/obj/item/storage/fancy/egg_box = 2,
					/obj/item/chems/food/tofu = 4,
					/obj/item/chems/food/meat = 4,
					/obj/item/chems/condiment/enzyme = 1
					)
	containertype = /obj/structure/closet/crate/freezer
	containername = "kitchen supplies crate"

/decl/hierarchy/supply_pack/galley/beef
	name = "Perishables - Beef"
	contains = list(/obj/item/chems/food/meat/beef = 6)
	containertype = /obj/structure/closet/crate/freezer
	containername = "cow meat crate"

/decl/hierarchy/supply_pack/galley/goat
	name = "Perishables - Goat meat"
	contains = list(/obj/item/chems/food/meat/goat = 6)
	containertype = /obj/structure/closet/crate/freezer
	containername = "goat meat crate"

/decl/hierarchy/supply_pack/galley/chicken
	name = "Perishables - Poultry"
	contains = list(/obj/item/chems/food/meat/chicken = 6)
	containertype = /obj/structure/closet/crate/freezer
	containername = "chicken meat crate"

/decl/hierarchy/supply_pack/galley/seafood
	name = "Perishables - Seafood"
	contains = list(
		/obj/item/chems/food/fish = 3,
		/obj/item/chems/food/fish/shark = 3,
		/obj/item/chems/food/fish/octopus = 3,
		/obj/item/mollusc/clam = 3
		)
	containertype = /obj/structure/closet/crate/freezer
	containername = "seafood crate"

/decl/hierarchy/supply_pack/galley/eggs
	name = "Perishables - Eggs"
	contains = list(/obj/item/storage/fancy/egg_box = 2)
	containertype = /obj/structure/closet/crate/freezer
	containername = "egg crate"

/decl/hierarchy/supply_pack/galley/milk
	name = "Perishables - Milk"
	contains = list(/obj/item/chems/drinks/milk = 3)
	containertype = /obj/structure/closet/crate/freezer
	containername = "milk crate"

/decl/hierarchy/supply_pack/galley/pizza
	num_contained = 5
	name = "Emergency - Surprise pack of five pizzas"
	contains = list(/obj/item/pizzabox/margherita,
					/obj/item/pizzabox/mushroom,
					/obj/item/pizzabox/meat,
					/obj/item/pizzabox/vegetable)
	containertype = /obj/structure/closet/crate/freezer
	containername = "pizza crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/galley/rations
	num_contained = 6
	name = "Emergency - MREs"
	contains = list(/obj/item/storage/mre,
					/obj/item/storage/mre/menu2,
					/obj/item/storage/mre/menu3,
					/obj/item/storage/mre/menu4,
					/obj/item/storage/mre/menu5,
					/obj/item/storage/mre/menu6,
					/obj/item/storage/mre/menu7,
					/obj/item/storage/mre/menu8,
					/obj/item/storage/mre/menu9,
					/obj/item/storage/mre/menu10)
	containertype = /obj/structure/closet/crate/freezer
	containername = "emergency rations"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/galley/party
	name = "Bar - Party equipment"
	contains = list(
			/obj/item/storage/box/mixedglasses = 2,
			/obj/item/storage/box/glasses/square,
			/obj/item/chems/drinks/shaker,
			/obj/item/chems/drinks/flask/barflask,
			/obj/item/chems/drinks/bottle/patron,
			/obj/item/chems/drinks/bottle/goldschlager,
			/obj/item/chems/drinks/bottle/agedwhiskey,
			/obj/item/storage/fancy/cigarettes/dromedaryco,
			/obj/random/lipstick,
			/obj/item/chems/drinks/bottle/small/ale = 2,
			/obj/item/chems/drinks/bottle/small/beer = 4,
			/obj/item/storage/box/glowsticks = 2)
	containername = "party equipment crate"

// TODO; Add more premium drinks at a later date. Could be useful for diplomatic events or fancy parties.
/decl/hierarchy/supply_pack/galley/premiumalcohol
	name = "Bar - Premium drinks"
	contains = list(
		/obj/item/chems/drinks/bottle/premiumwine =  3,
		/obj/item/chems/drinks/bottle/premiumvodka = 3,
		/obj/item/chems/drinks/bottle/whiskey =      3
	)
	containertype = /obj/structure/closet/crate/freezer
	containername = "premium drinks crate"

/decl/hierarchy/supply_pack/galley/barsupplies
	name = "Bar - Bar supplies"
	contains = list(
			/obj/item/storage/box/glasses/cocktail,
			/obj/item/storage/box/glasses/rocks,
			/obj/item/storage/box/glasses/square,
			/obj/item/storage/box/glasses/pint,
			/obj/item/storage/box/glasses/wine,
			/obj/item/storage/box/glasses/shake,
			/obj/item/storage/box/glasses/shot,
			/obj/item/storage/box/glasses/mug,
			/obj/item/chems/drinks/shaker,
			/obj/item/storage/box/glass_extras/straws,
			/obj/item/storage/box/glass_extras/sticks
			)
	containername = "bar supplies crate"

/decl/hierarchy/supply_pack/galley/beer_dispenser
	name = "Equipment - Booze dispenser"
	contains = list(
			/obj/machinery/chemical_dispenser/bar_alc{anchored = 0}
		)
	containertype = /obj/structure/largecrate
	containername = "booze dispenser crate"

/decl/hierarchy/supply_pack/galley/soda_dispenser
	name = "Equipment - Soda dispenser"
	contains = list(
			/obj/machinery/chemical_dispenser/bar_soft{anchored = 0}
		)
	containertype = /obj/structure/largecrate
	containername = "soda dispenser crate"
