/obj/item/food/junk
	icon = 'icons/obj/food/junk/junkfood.dmi'
	abstract_type = /obj/item/food/junk

/obj/item/food/junk/sosjerky
	name = "emergency meat jerky"
	icon_state = "sosjerky"
	desc = "For when you desperately want meat and you don't care what kind. Has the same texture as old leather boots."
	trash = /obj/item/trash/sosjerky
	filling_color = "#631212"
	center_of_mass = @'{"x":15,"y":9}'
	bitesize = 2
	material = /decl/material/solid/organic/meat

/obj/item/food/junk/sosjerky/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 4)

/obj/item/food/junk/no_raisin
	name = "raisins"
	icon_state = "4no_raisins"
	desc = "Pouring water on these will not turn them back into grapes, unfortunately."
	trash = /obj/item/trash/raisins
	filling_color = "#343834"
	center_of_mass = @'{"x":15,"y":4}'
	nutriment_desc = list("raisins" = 6)
	nutriment_amt = 6

/obj/item/food/junk/spacetwinkie
	name = "eclair"
	icon_state = "space_twinkie"
	desc = "So full of preservatives, it's guaranteed to survive longer then you will."
	filling_color = "#ffe591"
	center_of_mass = @'{"x":15,"y":11}'
	bitesize = 2

/obj/item/food/junk/spacetwinkie/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/sugar, 4)

/obj/item/food/junk/cheesiehonkers
	name = "cheese puffs"
	icon_state = "cheesie_honkers"
	desc = "Bite sized cheese flavoured snacks that will leave your fingers coated in cheese dust."
	trash = /obj/item/trash/cheesie
	filling_color = "#ffa305"
	center_of_mass = @'{"x":15,"y":9}'
	nutriment_desc = list("cheese" = 5, "chips" = 2)
	nutriment_amt = 4
	bitesize = 2

/obj/item/food/junk/syndicake
	name = "subversive cakes"
	icon_state = "syndi_cakes"
	desc = "Made using extremely unethical labour, ingredients and marketing methods."
	filling_color = "#ff5d05"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("sweetness" = 3, "cake" = 1)
	nutriment_amt = 4
	trash = /obj/item/trash/syndi_cakes
	bitesize = 3

/obj/item/food/junk/syndicake/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/regenerator, 5)

//terran delights

/obj/item/food/junk/pistachios
	name = "pistachios"
	icon_state = "pistachios"
	desc = "Pistachios. There is absolutely nothing remarkable about these."
	trash = /obj/item/trash/pistachios
	filling_color = "#825d26"
	center_of_mass = @'{"x":15,"y":9}'
	nutriment_desc = list("nuts" = 1)
	nutriment_amt = 3
	bitesize = 0.5

/obj/item/food/junk/semki
	name = "sunflower seeds"
	icon_state = "semki"
	desc = "A favorite among birds."
	trash = /obj/item/trash/semki
	filling_color = "#68645d"
	center_of_mass = @'{"x":15,"y":9}'
	nutriment_desc = list("sunflower seeds" = 1)
	nutriment_amt = 6
	bitesize = 0.5

/obj/item/food/junk/squid
	name = "\improper Calamari Crisps"
	icon_state = "squid"
	desc = "Space cepholapod tentacles, carefully removed from the squid then dried into strips of delicious rubbery goodness!"
	trash = /obj/item/trash/squid
	filling_color = "#c0a9d7"
	center_of_mass = @'{"x":15,"y":9}'
	nutriment_desc = list("fish" = 1, "salt" = 1)
	nutriment_amt = 2
	bitesize = 1

/obj/item/food/junk/squid/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat/fish, 4)

/obj/item/food/junk/croutons
	name = "croutons"
	icon_state = "croutons"
	desc = "Fried bread cubes. Good in salad but I guess you can just eat them as is."
	trash = /obj/item/trash/croutons
	filling_color = "#c6b17f"
	center_of_mass = @'{"x":15,"y":9}'
	nutriment_desc = list("bread" = 1, "salt" = 1)
	nutriment_amt = 3
	bitesize = 1
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/food/junk/salo
	name = "salo"
	icon_state = "salo"
	desc = "Pig fat. Salted. Just as good as it sounds."
	trash = /obj/item/trash/salo
	filling_color = "#e0bcbc"
	center_of_mass = @'{"x":15,"y":9}'
	nutriment_desc = list("fat" = 1, "salt" = 1)
	nutriment_amt = 2
	bitesize = 2

/obj/item/food/junk/salo/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 8)

/obj/item/food/junk/driedfish
	name = "vobla"
	icon_state = "driedfish"
	desc = "Dried salted beer snack fish."
	trash = /obj/item/trash/driedfish
	filling_color = "#c8a5bb"
	center_of_mass = @'{"x":15,"y":9}'
	nutriment_desc = list("fish" = 1, "salt" = 1)
	nutriment_amt = 2
	bitesize = 1

/obj/item/food/junk/driedfish/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat/fish, 4)

/obj/item/food/junk/liquidfood
	name = "\improper LiquidFood MRE"
	desc = "A prepackaged grey slurry for all of the essential nutrients a soldier requires to survive. No expiration date is visible..."
	icon_state = "liquidfood"
	trash = /obj/item/trash/liquidfood
	filling_color = "#a8a8a8"
	center_of_mass = @'{"x":16,"y":15}'
	nutriment_desc = list("chalk" = 6)
	nutriment_amt = 20
	bitesize = 4

/obj/item/food/junk/liquidfood/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/metal/iron, 3)

/obj/item/food/junk/meatcube
	name = "cubed meat"
	desc = "Fried, salted lean meat compressed into a cube. Not very appetizing."
	icon_state = "meatcube"
	filling_color = "#7a3d11"
	center_of_mass = @'{"x":16,"y":16}'
	bitesize = 3
	material = /decl/material/solid/organic/meat

/obj/item/food/junk/meatcube/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 15)

/obj/item/food/junk/tastybread
	name = "bread tube"
	desc = "Bread in a tube. Chewy... and surprisingly tasty."
	icon_state = "tastybread"
	trash = /obj/item/trash/tastybread
	filling_color = "#a66829"
	center_of_mass = @'{"x":17,"y":16}'
	nutriment_desc = list("bread" = 2, "sweetness" = 3)
	nutriment_amt = 6
	nutriment_type = /decl/material/liquid/nutriment/bread
	bitesize = 2

/obj/item/food/junk/candy
	name = "candy"
	desc = "Nougat, love it or hate it."
	icon_state = "candy"
	trash = /obj/item/trash/candy
	filling_color = "#7d5f46"
	center_of_mass = @'{"x":15,"y":15}'
	nutriment_amt = 1
	nutriment_desc = list("candy" = 1)
	bitesize = 2

/obj/item/food/junk/candy/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/sugar, 3)

/obj/item/food/junk/candy/proteinbar
	name = "protein bar"
	desc = "MuscleLopin brand protein bars, guaranteed to get you soSO strong!"
	icon_state = "proteinbar"
	trash = /obj/item/trash/candy/proteinbar
	bitesize = 6

/obj/item/food/junk/candy/proteinbar/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment,         9)
	add_to_reagents(/decl/material/solid/organic/meat, 4)
	add_to_reagents(/decl/material/liquid/nutriment/sugar,   4)

/obj/item/food/junk/candy/donor
	name = "donor candy"
	desc = "A little treat for blood donors."
	trash = /obj/item/trash/candy
	nutriment_desc = list("candy" = 10)
	bitesize = 5

/obj/item/food/junk/candy/donor/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment,      10)
	add_to_reagents(/decl/material/liquid/nutriment/sugar, 3)

/obj/item/food/junk/candy_corn
	name = "candy corn"
	desc = "It's a handful of candy corn. Not actually candied corn."
	icon_state = "candy_corn"
	filling_color = "#fffcb0"
	center_of_mass = @'{"x":14,"y":10}'
	nutriment_amt = 4
	nutriment_desc = list("candy corn" = 4)
	bitesize = 2

/obj/item/food/junk/candy_corn/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment,       4)
	add_to_reagents(/decl/material/liquid/nutriment/sugar, 2)

/obj/item/food/junk/chips
	name = "chips"
	desc = "It is impossible to open the packet without rustling it loudly."
	icon_state = "chips"
	trash = /obj/item/trash/chips
	filling_color = "#e8c31e"
	center_of_mass = @'{"x":15,"y":15}'
	nutriment_amt = 3
	nutriment_desc = list("salt" = 1, "chips" = 2)
	bitesize = 1
	nutriment_type = /decl/material/liquid/nutriment/bread

//Sol Vendor
/obj/item/food/junk/lunacake
	name = "moon cake"
	icon_state = "lunacake_wrapped"
	desc = "Now with 20% less lawsuit enabling regolith!"
	trash = /obj/item/trash/cakewrap
	filling_color = "#ffffff"
	center_of_mass = @'{"x":15,"y":9}'
	nutriment_desc = list("sweet" = 4, "vanilla" = 1)
	nutriment_amt = 5
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/food/junk/lunacake/mochicake
	name = "mochi"
	icon_state = "mochicake_wrapped"
	desc = "A type of rice cake with an extremely soft, glutinous texture."
	trash = /obj/item/trash/mochicakewrap
	nutriment_desc = list("sweet" = 4, "rice" = 1)

/obj/item/food/junk/lunacake/mooncake
	name = "dark side moon cake"
	icon_state = "mooncake_wrapped"
	desc = "Explore the dark side! May contain trace amounts of reconstituted cocoa."
	trash = /obj/item/trash/mooncakewrap
	filling_color = "#000000"
	nutriment_desc = list("sweet" = 4, "chocolate" = 1)
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/food/junk/triton
	name = "\improper Tidal Gobs"
	icon_state = "tidegobs"
	desc = "Contains over 9000% of your daily recommended intake of salt."
	trash = /obj/item/trash/tidegobs
	filling_color = "#2556b0"
	center_of_mass = @'{"x":15,"y":9}'
	nutriment_desc = list("salt" = 4, "ocean" = 1, "seagull" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/food/junk/saturn
	name = "snack rings"
	icon_state = "saturno"
	desc = "A day ration of salt, styrofoam and possibly sawdust."
	trash = /obj/item/trash/saturno
	filling_color = "#dca319"
	center_of_mass = @'{"x":15,"y":9}'
	nutriment_desc = list("salt" = 4, "peanut" = 2,  "wood?" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/food/junk/jupiter
	name = "probably gelatin"
	icon_state = "jupiter"
	desc = "Some kind of gel, maybe?"
	trash = /obj/item/trash/jupiter
	filling_color = "#dc1919"
	center_of_mass = @'{"x":15,"y":9}'
	nutriment_desc = list("jelly?" = 5)
	nutriment_amt = 5
	bitesize = 2

/obj/item/food/junk/pluto
	name = "nutrient rods"
	icon_state = "pluto"
	desc = "Baseless tasteless nutrient rods to get you through the day. Now even less rash inducing!"
	trash = /obj/item/trash/pluto
	filling_color = "#ffffff"
	center_of_mass = @'{"x":15,"y":9}'
	nutriment_desc = list("chalk" = 4, "sadness" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/food/junk/mars
	name = "instant potato and eggs"
	icon_state = "mars"
	desc = "A steaming self-heated bowl of sweet eggs and taters!"
	trash = /obj/item/trash/mars
	filling_color = "#d2c63f"
	center_of_mass = @'{"x":15,"y":9}'
	nutriment_desc = list("eggs" = 4, "potato" = 4, "mustard" = 2)
	nutriment_amt = 8
	bitesize = 2

/obj/item/food/junk/venus
	name = "hot cakes"
	icon_state = "venus"
	desc = "Hot takes on hot cakes, a timeless classic now finally fit for human consumption!"
	trash = /obj/item/trash/venus
	filling_color = "#d2c63f"
	center_of_mass = @'{"x":15,"y":9}'
	nutriment_desc = list("heat" = 4, "burning" = 1)
	nutriment_amt = 5
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/food/junk/venus/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/capsaicin, 5)

/obj/item/food/junk/oort
	name = "\improper Cloud Rocks"
	icon_state = "oort"
	desc = "Pop rocks. The new formula guarantees fewer shrapnel induced oral injuries."
	trash = /obj/item/trash/oort
	filling_color = "#3f7dd2"
	center_of_mass = @'{"x":15,"y":9}'
	nutriment_desc = list("fizz" = 3, "sweet?" = 1, "shrapnel" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/food/junk/oort/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/frostoil, 5)

//weebo vend! So japanese it hurts

/obj/item/food/junk/ricecake
	name = "rice ball"
	icon_state = "ricecake"
	desc = "A snack food made from balled up rice."
	nutriment_desc = list("rice" = 3, "sweet" = 1, "seaweed" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/food/junk/pokey
	name = "chocolate coated biscuit sticks"
	icon_state = "pokeys"
	desc = "A bundle of chocolate coated biscuit sticks. Not as exciting as they seem."
	nutriment_desc = list("chocolate" = 1, "biscuit" = 2, "cardboard" = 2)
	nutriment_amt = 5
	bitesize = 2

/obj/item/food/junk/weebonuts
	name = "spicy nuts"
	icon_state = "weebonuts"
	trash = /obj/item/trash/weebonuts
	desc = "A bag of spicy nuts. Goes well with beer!"
	nutriment_desc = list("nuts" = 4, "spicy!" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/food/junk/weebonuts/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/capsaicin, 1)

/obj/item/food/junk/chocobanana
	name = "choco banana"
	icon_state = "chocobanana"
	trash = /obj/item/trash/stick
	desc = "A chocolate and sprinkles coated banana. On a stick."
	nutriment_desc = list("banana" = 3, "chocolate" = 1, "wax?" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/food/junk/chocobanana/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/sprinkles, 10)

/obj/item/food/junk/dango
	name = "dango"
	icon_state = "dango"
	trash = /obj/item/trash/stick
	desc = "Food dyed rice dumplings on a stick."
	nutriment_desc = list("rice" = 4, "topping?" = 1)
	nutriment_amt = 5
	bitesize = 2
