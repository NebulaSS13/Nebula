/obj/item/chems/food/sosjerky
	name = "emergency meat jerky"
	icon_state = "sosjerky"
	desc = "For when you desperately want meat and you don't care what kind. Has the same texture as old leather boots."
	trash = /obj/item/trash/sosjerky
	filling_color = "#631212"
	center_of_mass = @"{'x':15,'y':9}"
	bitesize = 2
	material = /decl/material/solid/meat

/obj/item/chems/food/sosjerky/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 4)

/obj/item/chems/food/no_raisin
	name = "raisins"
	icon_state = "4no_raisins"
	desc = "Pouring water on these will not turn them back into grapes, unfortunately."
	trash = /obj/item/trash/raisins
	filling_color = "#343834"
	center_of_mass = @"{'x':15,'y':4}"
	nutriment_desc = list("raisins" = 6)
	nutriment_amt = 6

/obj/item/chems/food/spacetwinkie
	name = "eclair"
	icon_state = "space_twinkie"
	desc = "So full of preservatives, it's guaranteed to survive longer then you will."
	filling_color = "#ffe591"
	center_of_mass = @"{'x':15,'y':11}"
	bitesize = 2

/obj/item/chems/food/spacetwinkie/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sugar, 4)

/obj/item/chems/food/cheesiehonkers
	name = "cheese puffs"
	icon_state = "cheesie_honkers"
	desc = "Bite sized cheese flavoured snacks that will leave your fingers coated in cheese dust."
	trash = /obj/item/trash/cheesie
	filling_color = "#ffa305"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("cheese" = 5, "chips" = 2)
	nutriment_amt = 4
	bitesize = 2

/obj/item/chems/food/syndicake
	name = "subversive cakes"
	icon_state = "syndi_cakes"
	desc = "Made using extremely unethical labour, ingredients and marketing methods."
	filling_color = "#ff5d05"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("sweetness" = 3, "cake" = 1)
	nutriment_amt = 4
	trash = /obj/item/trash/syndi_cakes
	bitesize = 3

/obj/item/chems/food/syndicake/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/regenerator, 5)

//terran delights

/obj/item/chems/food/pistachios
	name = "pistachios"
	icon_state = "pistachios"
	desc = "Pistachios. There is absolutely nothing remarkable about these."
	trash = /obj/item/trash/pistachios
	filling_color = "#825d26"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("nuts" = 1)
	nutriment_amt = 3
	bitesize = 0.5

/obj/item/chems/food/semki
	name = "sunflower seeds"
	icon_state = "semki"
	desc = "A favorite among birds."
	trash = /obj/item/trash/semki
	filling_color = "#68645d"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("sunflower seeds" = 1)
	nutriment_amt = 6
	bitesize = 0.5

/obj/item/chems/food/squid
	name = "\improper Calamari Crisps"
	icon_state = "squid"
	desc = "Space cepholapod tentacles, carefully removed from the squid then dried into strips of delicious rubbery goodness!"
	trash = /obj/item/trash/squid
	filling_color = "#c0a9d7"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("fish" = 1, "salt" = 1)
	nutriment_amt = 2
	bitesize = 1

/obj/item/chems/food/squid/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 4)

/obj/item/chems/food/croutons
	name = "croutons"
	icon_state = "croutons"
	desc = "Fried bread cubes. Good in salad but I guess you can just eat them as is."
	trash = /obj/item/trash/croutons
	filling_color = "#c6b17f"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("bread" = 1, "salt" = 1)
	nutriment_amt = 3
	bitesize = 1
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/salo
	name = "salo"
	icon_state = "salo"
	desc = "Pig fat. Salted. Just as good as it sounds."
	trash = /obj/item/trash/salo
	filling_color = "#e0bcbc"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("fat" = 1, "salt" = 1)
	nutriment_amt = 2
	bitesize = 2

/obj/item/chems/food/salo/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 8)

/obj/item/chems/food/driedfish
	name = "vobla"
	icon_state = "driedfish"
	desc = "Dried salted beer snack fish."
	trash = /obj/item/trash/driedfish
	filling_color = "#c8a5bb"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("fish" = 1, "salt" = 1)
	nutriment_amt = 2
	bitesize = 1

/obj/item/chems/food/driedfish/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 4)

/obj/item/chems/food/liquidfood
	name = "\improper LiquidFood MRE"
	desc = "A prepackaged grey slurry for all of the essential nutrients a soldier requires to survive. No expiration date is visible..."
	icon_state = "liquidfood"
	trash = /obj/item/trash/liquidfood
	filling_color = "#a8a8a8"
	center_of_mass = @"{'x':16,'y':15}"
	nutriment_desc = list("chalk" = 6)
	nutriment_amt = 20
	bitesize = 4

/obj/item/chems/food/liquidfood/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/solid/metal/iron, 3)

/obj/item/chems/food/meatcube
	name = "cubed meat"
	desc = "Fried, salted lean meat compressed into a cube. Not very appetizing."
	icon_state = "meatcube"
	filling_color = "#7a3d11"
	center_of_mass = @"{'x':16,'y':16}"
	bitesize = 3
	material = /decl/material/solid/meat

/obj/item/chems/food/meatcube/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 15)

/obj/item/chems/food/tastybread
	name = "bread tube"
	desc = "Bread in a tube. Chewy... and surprisingly tasty."
	icon_state = "tastybread"
	trash = /obj/item/trash/tastybread
	filling_color = "#a66829"
	center_of_mass = @"{'x':17,'y':16}"
	nutriment_desc = list("bread" = 2, "sweetness" = 3)
	nutriment_amt = 6
	nutriment_type = /decl/material/liquid/nutriment/bread
	bitesize = 2

/obj/item/chems/food/candy
	name = "candy"
	desc = "Nougat, love it or hate it."
	icon_state = "candy"
	trash = /obj/item/trash/candy
	filling_color = "#7d5f46"
	center_of_mass = @"{'x':15,'y':15}"
	nutriment_amt = 1
	nutriment_desc = list("candy" = 1)
	bitesize = 2

/obj/item/chems/food/candy/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sugar, 3)

/obj/item/chems/food/candy/proteinbar
	name = "protein bar"
	desc = "MuscleLopin brand protein bars, guaranteed to get you soSO strong!"
	icon_state = "proteinbar"
	trash = /obj/item/trash/candy/proteinbar
	bitesize = 6

/obj/item/chems/food/candy/proteinbar/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment, 9)
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 4)
	reagents.add_reagent(/decl/material/liquid/nutriment/sugar, 4)

/obj/item/chems/food/candy/donor
	name = "donor candy"
	desc = "A little treat for blood donors."
	trash = /obj/item/trash/candy
	nutriment_desc = list("candy" = 10)
	bitesize = 5

/obj/item/chems/food/candy/donor/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment, 10)
	reagents.add_reagent(/decl/material/liquid/nutriment/sugar, 3)

/obj/item/chems/food/candy_corn
	name = "candy corn"
	desc = "It's a handful of candy corn. Not actually candied corn."
	icon_state = "candy_corn"
	filling_color = "#fffcb0"
	center_of_mass = @"{'x':14,'y':10}"
	nutriment_amt = 4
	nutriment_desc = list("candy corn" = 4)
	bitesize = 2

/obj/item/chems/food/candy_corn/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment, 4)
	reagents.add_reagent(/decl/material/liquid/nutriment/sugar, 2)

/obj/item/chems/food/chips
	name = "chips"
	desc = "It is impossible to open the packet without rustling it loudly."
	icon_state = "chips"
	trash = /obj/item/trash/chips
	filling_color = "#e8c31e"
	center_of_mass = @"{'x':15,'y':15}"
	nutriment_amt = 3
	nutriment_desc = list("salt" = 1, "chips" = 2)
	bitesize = 1
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/cookie
	name = "cookie"
	desc = "COOKIE!!!"
	icon_state = "cookie"
	filling_color = "#dbc94f"
	center_of_mass = @"{'x':17,'y':18}"
	nutriment_amt = 5
	nutriment_desc = list("sweetness" = 3, "cookie" = 2)
	w_class = ITEM_SIZE_TINY
	bitesize = 1
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/chocolatebar
	name = "chocolate bar"
	desc = "Such sweet, fattening food."
	icon_state = "chocolatebar"
	filling_color = "#7d5f46"
	center_of_mass = @"{'x':15,'y':15}"
	nutriment_amt = 2
	nutriment_desc = list("chocolate" = 5)
	bitesize = 2

/obj/item/chems/food/chocolatebar/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sugar, 2)
	reagents.add_reagent(/decl/material/liquid/nutriment/coco, 2)

/obj/item/chems/food/chocolateegg
	name = "chocolate egg"
	desc = "Such sweet, fattening food."
	icon_state = "chocolateegg"
	filling_color = "#7d5f46"
	center_of_mass = @"{'x':16,'y':13}"
	nutriment_amt = 3
	nutriment_desc = list("chocolate" = 5)
	bitesize = 2

/obj/item/chems/food/chocolateegg/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sugar, 2)
	reagents.add_reagent(/decl/material/liquid/nutriment/coco, 2)

/obj/item/chems/food/donut
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut1"
	filling_color = "#d9c386"
	var/overlay_state = "box-donut1"
	center_of_mass = @"{'x':13,'y':16}"
	nutriment_desc = list("sweetness", "donut")
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/donut/normal
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut1"
	nutriment_amt = 3
	bitesize = 3
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/donut/normal/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 1)

	if(prob(30))
		src.icon_state = "donut2"
		src.overlay_state = "box-donut2"
		src.SetName("frosted donut")
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 2)
	center_of_mass = @"{'x':19,'y':16}"

/obj/item/chems/food/donut/chaos
	name = "chaos donut"
	desc = "Like life, it never quite tastes the same."
	icon_state = "donut1"
	filling_color = "#ed11e6"
	nutriment_amt = 2
	bitesize = 10
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/donut/chaos/proc/get_random_fillings()
	. = list(
		/decl/material/liquid/nutriment,
		/decl/material/liquid/capsaicin,
		/decl/material/liquid/frostoil,
		/decl/material/liquid/nutriment/sprinkles,
		/decl/material/gas/chlorine,
		/decl/material/liquid/nutriment/coco,
		/decl/material/liquid/nutriment/banana_cream,
		/decl/material/liquid/nutriment/cherryjelly,
		/decl/material/liquid/fuel,
		/decl/material/liquid/regenerator
	)

/obj/item/chems/food/donut/chaos/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 1)
	reagents.add_reagent(pick(get_random_fillings()), 3)
	if(prob(30))
		src.icon_state = "donut2"
		src.overlay_state = "box-donut2"
		src.SetName("frosted chaos donut")
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 2)

/obj/item/chems/food/donut/jelly
	name = "jelly donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ed1169"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_amt = 3
	bitesize = 5
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/donut/jelly/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 1)
	reagents.add_reagent(/decl/material/liquid/nutriment/cherryjelly, 5)
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.SetName("frosted jelly donut")
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 2)

/obj/item/chems/food/donut/cherryjelly
	name = "jelly donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ed1169"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_amt = 3
	bitesize = 5

/obj/item/chems/food/donut/cherryjelly/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 1)
	reagents.add_reagent(/decl/material/liquid/nutriment/cherryjelly, 5)
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.SetName("frosted jelly donut")
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 2)

//Sol Vendor

/obj/item/chems/food/lunacake
	name = "moon cake"
	icon_state = "lunacake_wrapped"
	desc = "Now with 20% less lawsuit enabling regolith!"
	trash = /obj/item/trash/cakewrap
	filling_color = "#ffffff"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("sweet" = 4, "vanilla" = 1)
	nutriment_amt = 5
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/lunacake/mochicake
	name = "mochi"
	icon_state = "mochicake_wrapped"
	desc = "A type of rice cake with an extremely soft, glutinous texture."
	trash = /obj/item/trash/mochicakewrap
	nutriment_desc = list("sweet" = 4, "rice" = 1)

/obj/item/chems/food/lunacake/mooncake
	name = "dark side moon cake"
	icon_state = "mooncake_wrapped"
	desc = "Explore the dark side! May contain trace amounts of reconstituted cocoa."
	trash = /obj/item/trash/mooncakewrap
	filling_color = "#000000"
	nutriment_desc = list("sweet" = 4, "chocolate" = 1)
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/triton
	name = "\improper Tidal Gobs"
	icon_state = "tidegobs"
	desc = "Contains over 9000% of your daily recommended intake of salt."
	trash = /obj/item/trash/tidegobs
	filling_color = "#2556b0"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("salt" = 4, "ocean" = 1, "seagull" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/chems/food/saturn
	name = "snack rings"
	icon_state = "saturno"
	desc = "A day ration of salt, styrofoam and possibly sawdust."
	trash = /obj/item/trash/saturno
	filling_color = "#dca319"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("salt" = 4, "peanut" = 2,  "wood?" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/chems/food/jupiter
	name = "probably gelatin"
	icon_state = "jupiter"
	desc = "Some kind of gel, maybe?"
	trash = /obj/item/trash/jupiter
	filling_color = "#dc1919"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("jelly?" = 5)
	nutriment_amt = 5
	bitesize = 2

/obj/item/chems/food/pluto
	name = "nutrient rods"
	icon_state = "pluto"
	desc = "Baseless tasteless nutrient rods to get you through the day. Now even less rash inducing!"
	trash = /obj/item/trash/pluto
	filling_color = "#ffffff"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("chalk" = 4, "sadness" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/chems/food/mars
	name = "instant potato and eggs"
	icon_state = "mars"
	desc = "A steaming self-heated bowl of sweet eggs and taters!"
	trash = /obj/item/trash/mars
	filling_color = "#d2c63f"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("eggs" = 4, "potato" = 4, "mustard" = 2)
	nutriment_amt = 8
	bitesize = 2

/obj/item/chems/food/venus
	name = "hot cakes"
	icon_state = "venus"
	desc = "Hot takes on hot cakes, a timeless classic now finally fit for human consumption!"
	trash = /obj/item/trash/venus
	filling_color = "#d2c63f"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("heat" = 4, "burning" = 1)
	nutriment_amt = 5
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/venus/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/capsaicin = 5)

/obj/item/chems/food/oort
	name = "\improper Cloud Rocks"
	icon_state = "oort"
	desc = "Pop rocks. The new formula guarantees fewer shrapnel induced oral injuries."
	trash = /obj/item/trash/oort
	filling_color = "#3f7dd2"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("fizz" = 3, "sweet?" = 1, "shrapnel" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/chems/food/oort/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/frostoil = 5)

//weebo vend! So japanese it hurts

/obj/item/chems/food/ricecake
	name = "rice ball"
	icon_state = "ricecake"
	desc = "A snack food made from balled up rice."
	nutriment_desc = list("rice" = 3, "sweet" = 1, "seaweed" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/chems/food/pokey
	name = "chocolate coated biscuit sticks"
	icon_state = "pokeys"
	desc = "A bundle of chocolate coated biscuit sticks. Not as exciting as they seem."
	nutriment_desc = list("chocolate" = 1, "biscuit" = 2, "cardboard" = 2)
	nutriment_amt = 5
	bitesize = 2

/obj/item/chems/food/weebonuts
	name = "spicy nuts"
	icon_state = "weebonuts"
	trash = /obj/item/trash/weebonuts
	desc = "A bag of spicy nuts. Goes well with beer!"
	nutriment_desc = list("nuts" = 4, "spicy!" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/chems/food/weebonuts/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/capsaicin = 1)

/obj/item/chems/food/chocobanana
	name = "choco banana"
	icon_state = "chocobanana"
	trash = /obj/item/trash/stick
	desc = "A chocolate and sprinkles coated banana. On a stick."
	nutriment_desc = list("banana" = 3, "chocolate" = 1, "wax?" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/chems/food/chocobanana/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 10)

/obj/item/chems/food/dango
	name = "dango"
	icon_state = "dango"
	trash = /obj/item/trash/stick
	desc = "Food dyed rice dumplings on a stick."
	nutriment_desc = list("rice" = 4, "topping?" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/chems/food/donkpocket/sinpocket
	name = "\improper Sin-pocket"
	desc = "The food of choice for the veteran. Do <b>NOT</b> overconsume."
	filling_color = "#6d6d00"
	heated_reagents = list(
		/decl/material/liquid/regenerator = 5,
		/decl/material/liquid/amphetamines = 0.75,
		/decl/material/liquid/stimulants = 0.25
	)
	var/has_been_heated = 0 // Unlike the warm var, this checks if the one-time self-heating operation has been used.

/obj/item/chems/food/donkpocket/sinpocket/attack_self(mob/user)
	if(has_been_heated)
		to_chat(user, "<span class='notice'>The heating chemicals have already been spent.</span>")
		return
	has_been_heated = 1
	user.visible_message("<span class='notice'>[user] crushes \the [src] package.</span>", "You crush \the [src] package and feel a comfortable heat build up.")
	addtimer(CALLBACK(src, .proc/heat, weakref(user)), 20 SECONDS)

/obj/item/chems/food/donkpocket/sinpocket/heat(weakref/message_to)
	..()
	if(message_to)
		var/mob/user = message_to.resolve()
		if(user)
			to_chat(user, "You think \the [src] is ready to eat about now.")

/obj/item/chems/food/donkpocket
	name = "\improper Donk-pocket"
	desc = "The food of choice for the seasoned traitor."
	icon_state = "donkpocket"
	filling_color = "#dedeab"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("heartiness" = 1, "dough" = 2)
	nutriment_amt = 2
	var/warm = 0
	var/list/heated_reagents = list(/decl/material/liquid/regenerator = 5)

/obj/item/chems/food/donkpocket/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 2)

/obj/item/chems/food/donkpocket/proc/heat()
	if(warm)
		return
	warm = 1
	for(var/reagent in heated_reagents)
		reagents.add_reagent(reagent, heated_reagents[reagent])
	bitesize = 6
	SetName("warm " + name)
	addtimer(CALLBACK(src, .proc/cool), 7 MINUTES)

/obj/item/chems/food/donkpocket/proc/cool()
	if(!warm)
		return
	warm = 0
	for(var/reagent in heated_reagents)
		reagents.clear_reagent(reagent)
	SetName(initial(name))