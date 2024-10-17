/obj/item/chems/drinks/cans
	volume = 40 //just over one and a half cups
	amount_per_transfer_from_this = 5
	atom_flags = 0 //starts closed
	material = /decl/material/solid/metal/aluminium
	abstract_type = /obj/item/chems/drinks/cans

/obj/item/chems/drinks/cans/update_container_desc()
	return

//DRINKS

/obj/item/chems/drinks/cans/cola
	name = "\improper Space Cola"
	desc = "Cola. in space."
	icon_state = "cola"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/cola/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/cola, reagents.maximum_volume)

/obj/item/chems/drinks/cans/waterbottle
	name = "bottled water"
	desc = "Pure drinking water, imported from the Martian poles."
	icon_state = "waterbottle"
	center_of_mass = @'{"x":15,"y":8}'
	material = /decl/material/solid/organic/plastic

/obj/item/chems/drinks/cans/waterbottle/populate_reagents()
	add_to_reagents(/decl/material/liquid/water, reagents.maximum_volume)

/obj/item/chems/drinks/cans/waterbottle/open(mob/user)
	playsound(loc,'sound/effects/bonebreak1.ogg', rand(10,50), 1)
	to_chat(user, SPAN_NOTICE("You twist open \the [src], destroying the safety seal!"))
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER

/obj/item/chems/drinks/cans/space_mountain_wind
	name = "\improper Space Mountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/space_mountain_wind/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/citrussoda, reagents.maximum_volume)

/obj/item/chems/drinks/cans/thirteenloko
	name = "\improper Thirteen Loko"
	desc = "The CMO has advised crew members that consumption of Thirteen Loko may result in seizures, blindness, drunkeness, or even death. Please Drink Responsibly."
	icon_state = "thirteen_loko"
	center_of_mass = @'{"x":16,"y":8}'

/obj/item/chems/drinks/cans/thirteenloko/populate_reagents()
	add_to_reagents(/decl/material/liquid/ethanol/thirteenloko, reagents.maximum_volume)

/obj/item/chems/drinks/cans/dr_gibb
	name = "\improper Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors."
	icon_state = "dr_gibb"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/dr_gibb/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/cherrycola, reagents.maximum_volume)

/obj/item/chems/drinks/cans/starkist
	name = "\improper Star-Kist"
	desc = "Can you taste a bit of tuna...?"
	icon_state = "starkist"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/starkist/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/orangecola, reagents.maximum_volume)

/obj/item/chems/drinks/cans/space_up
	name = "\improper Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/space_up/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/lemonade, reagents.maximum_volume)

/obj/item/chems/drinks/cans/lemon_lime
	name = "\improper Lemon-Lime"
	desc = "You wanted ORANGE. It gave you Lemon Lime."
	icon_state = "lemon-lime"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/lemon_lime/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/lemon_lime, reagents.maximum_volume)

/obj/item/chems/drinks/cans/iced_tea
	name = "\improper Vrisk Serket Iced Tea"
	desc = "That sweet, refreshing southern earthy flavor. That's where it's from, right? South Earth?"
	icon_state = "ice_tea_can"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/iced_tea/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/tea/black, reagents.maximum_volume - 5)
	add_to_reagents(/decl/material/solid/ice,              5)

/obj/item/chems/drinks/cans/grape_juice
	name = "\improper Grapel Juice"
	desc = "500 pages of rules of how to appropriately enter into a combat with this juice!"
	icon_state = "purple_can"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/grape_juice/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/juice/grape, reagents.maximum_volume)

/obj/item/chems/drinks/cans/tonic
	name = "\improper T-Borg's Tonic Water"
	desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."
	icon_state = "tonic"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/tonic/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/tonic, reagents.maximum_volume)

/obj/item/chems/drinks/cans/sodawater
	name = "soda water"
	desc = "A can of soda water. Still water's more refreshing cousin."
	icon_state = "sodawater"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/sodawater/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/sodawater, reagents.maximum_volume)

/obj/item/chems/drinks/cans/beastenergy
	name = "Beast Energy"
	desc = "100% pure energy, and 150% pure liver disease."
	icon_state = "beastenergy"
	center_of_mass = @'{"x":16,"y":6}'

/obj/item/chems/drinks/cans/beastenergy/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/beastenergy, reagents.maximum_volume)

//Items exclusive to the BODA machine on deck 4 and wherever else it pops up. First two are a bit jokey. Second two are genuine article.

/obj/item/chems/drinks/cans/syndicolax
	name = "\improper Red Army Twist!"
	desc = "A taste of what keeps our glorious nation running! Served as Space Commissariat Stahlin prefers it! Luke warm."
	icon_state = "syndi_cola_x"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/syndicolax/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/juice/potato, reagents.maximum_volume)

/obj/item/chems/drinks/cans/artbru
	name = "\improper Arstotzka Bru"
	desc = "Just what any bureaucrat needs to get through the day. Keep stamping those papers!"
	icon_state = "art_bru"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/artbru/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/juice/turnip, reagents.maximum_volume)

/obj/item/chems/drinks/cans/syndicola
	name = "\improper TerraCola"
	desc = "A can of the only soft drink state approved for the benefit of the people. Served at room temperature regardless of ambient temperatures thanks to innovative Terran insulation technology."
	icon_state = "syndi_cola"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/syndicola/populate_reagents()
	add_to_reagents(/decl/material/liquid/water,     reagents.maximum_volume - 5)
	add_to_reagents(/decl/material/solid/metal/iron, 5)

/obj/item/chems/drinks/glass2/square/boda
	name = "boda"
	desc = "A tall glass of refreshing Boda!"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/glass2/square/boda/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/sodawater, reagents.maximum_volume)

/obj/item/chems/drinks/glass2/square/bodaplus
	name = "tri kopeiki sirop boda"
	desc = "A tall glass of even more refreshing Boda! Now with Sok!"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/glass2/square/bodaplus/populate_reagents()
	var/reag = pick(list(
				/decl/material/liquid/drink/citrusseltzer,
				/decl/material/liquid/drink/juice/grape,
				/decl/material/liquid/drink/juice/orange,
				/decl/material/liquid/drink/juice/lemon,
				/decl/material/liquid/drink/juice/lime,
				/decl/material/liquid/drink/juice/apple,
				/decl/material/liquid/drink/juice/pear,
				/decl/material/liquid/drink/juice/banana,
				/decl/material/liquid/drink/juice/berry,
				/decl/material/liquid/drink/juice/watermelon))
	add_to_reagents(/decl/material/liquid/drink/sodawater, reagents.maximum_volume / 2)
	add_to_reagents(reag, reagents.maximum_volume / 2)


//Canned alcohols.

/obj/item/chems/drinks/cans/speer
	name = "\improper Space Beer"
	desc = "Now in a can!"
	icon_state = "beercan"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/speer/populate_reagents()
	add_to_reagents(/decl/material/liquid/ethanol/beer/good, reagents.maximum_volume)

/obj/item/chems/drinks/cans/ale
	name = "\improper Magm-Ale"
	desc = "Now in a can!"
	icon_state = "alecan"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/ale/populate_reagents()
	add_to_reagents(/decl/material/liquid/ethanol/ale, reagents.maximum_volume)
