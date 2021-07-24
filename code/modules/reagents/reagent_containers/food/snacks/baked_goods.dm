/////////////////
// Baked Goods //
/////////////////

/obj/item/chems/food/muffin
	name = "muffin"
	desc = "A delicious and spongy little cake."
	icon_state = "muffin"
	filling_color = "#e0cf9b"
	center_of_mass = @"{'x':17,'y':4}"
	nutriment_desc = list("sweetness" = 3, "muffin" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/chems/food/bananapie
	name = "banana cream pie"
	desc = "Just like back home, on clown planet! HONK!"
	icon_state = "pie"
	trash = /obj/item/trash/plate
	filling_color = "#fbffb8"
	center_of_mass = @"{'x':16,'y':13}"
	nutriment_desc = list("pie" = 3, "cream" = 2)
	nutriment_amt = 4
	bitesize = 3

/obj/item/chems/food/pie/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/banana_cream,5)

/obj/item/chems/food/pie/throw_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/pie_smudge(src.loc)
	src.visible_message("<span class='danger'>\The [src.name] splats.</span>","<span class='danger'>You hear a splat.</span>")
	qdel(src)

/obj/item/chems/food/berryclafoutis
	name = "berry clafoutis"
	desc = "No black birds, this is a good sign."
	icon_state = "berryclafoutis"
	trash = /obj/item/trash/plate
	center_of_mass = @"{'x':16,'y':13}"
	nutriment_desc = list("sweetness" = 2, "pie" = 3)
	nutriment_amt = 4
	bitesize = 3

/obj/item/chems/food/berryclafoutis/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/drink/juice/berry, 5)

/obj/item/chems/food/waffles
	name = "waffles"
	desc = "Mmm, waffles."
	icon_state = "waffles"
	trash = /obj/item/trash/waffles
	filling_color = "#e6deb5"
	center_of_mass = @"{'x':15,'y':11}"
	nutriment_desc = list("waffle" = 8)
	nutriment_amt = 8
	bitesize = 2

/obj/item/chems/food/rofflewaffles
	name = "waffles(?)"
	desc = "There's something funny about these waffles."
	icon_state = "rofflewaffles"
	trash = /obj/item/trash/waffles
	filling_color = "#ff00f7"
	center_of_mass = @"{'x':15,'y':11}"
	nutriment_desc = list("waffle" = 7, "sweetness" = 1)
	nutriment_amt = 8
	bitesize = 4

/obj/item/chems/food/rofflewaffles/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/psychotropics, 8)

/obj/item/chems/food/pancakes
	name = "pancakes"
	desc = "Pancakes without blueberries, still delicious."
	icon_state = "pancakes"
	trash = /obj/item/trash/plate
	center_of_mass = @"{'x':15,'y':11}"
	nutriment_desc = list("pancake" = 8)
	nutriment_amt = 8
	bitesize = 2

/obj/item/chems/food/pancakesblu
	name = "blueberry pancakes"
	desc = "Pancakes with blueberries, delicious."
	icon_state = "pancakes"
	trash = /obj/item/trash/plate
	center_of_mass = @"{'x':15,'y':11}"
	nutriment_desc = list("pancake" = 8)
	nutriment_amt = 8
	bitesize = 2

/obj/item/chems/food/eggplantparm
	name = "eggplant parmigiana"
	desc = "The only good recipe for eggplant."
	icon_state = "eggplantparm"
	trash = /obj/item/trash/plate
	filling_color = "#4d2f5e"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("cheese" = 3, "eggplant" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/chems/food/soylentgreen
	name = "\improper Soylent Green"
	desc = "Not made of people. Honest."//Totally people.
	icon_state = "soylent_green"
	trash = /obj/item/trash/waffles
	filling_color = "#b8e6b5"
	center_of_mass = @"{'x':15,'y':11}"
	bitesize = 2

/obj/item/chems/food/soylentgreen/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 10)

/obj/item/chems/food/soylenviridians
	name = "\improper Soylen Virdians"
	desc = "Not made of people. Honest."//Actually honest for once.
	icon_state = "soylent_yellow"
	trash = /obj/item/trash/waffles
	filling_color = "#e6fa61"
	center_of_mass = @"{'x':15,'y':11}"
	nutriment_desc = list("some sort of protein" = 10)//seasoned vERY well.
	nutriment_amt = 10
	bitesize = 2

/obj/item/chems/food/meatpie
	name = "meat-pie"
	icon_state = "meatpie"
	desc = "An old barber recipe, very delicious!"
	trash = /obj/item/trash/plate
	filling_color = "#948051"
	center_of_mass = @"{'x':16,'y':13}"
	bitesize = 2

/obj/item/chems/food/meatpie/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 10)

/obj/item/chems/food/tofupie
	name = "tofu-pie"
	icon_state = "meatpie"
	desc = "A delicious tofu pie."
	trash = /obj/item/trash/plate
	filling_color = "#fffee0"
	center_of_mass = @"{'x':16,'y':13}"
	nutriment_desc = list("tofu" = 2, "pie" = 8)
	nutriment_amt = 10
	bitesize = 2

/obj/item/chems/food/amanita_pie
	name = "amanita pie"
	desc = "Sweet and tasty poison pie."
	icon_state = "amanita_pie"
	filling_color = "#ffcccc"
	center_of_mass = @"{'x':17,'y':9}"
	nutriment_desc = list("sweetness" = 3, "mushroom" = 3, "pie" = 2)
	nutriment_amt = 5
	bitesize = 3

/obj/item/chems/food/amanita_pie/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/amatoxin, 3)
	reagents.add_reagent(/decl/material/liquid/psychotropics, 1)

/obj/item/chems/food/plump_pie
	name = "plump pie"
	desc = "I bet you love stuff made out of plump helmets!"
	icon_state = "plump_pie"
	filling_color = "#b8279b"
	center_of_mass = @"{'x':17,'y':9}"
	nutriment_desc = list("heartiness" = 2, "mushroom" = 3, "pie" = 3)
	nutriment_amt = 8
	bitesize = 2

/obj/item/chems/food/plump_pie/Initialize()
	. = ..()
	if(prob(10))
		name = "exceptional plump pie"
		desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump pie!"
		reagents.add_reagent(/decl/material/liquid/regenerator, 5)

/obj/item/chems/food/xemeatpie
	name = "xeno-pie"
	icon_state = "xenomeatpie"
	desc = "A delicious meatpie. Probably heretical."
	trash = /obj/item/trash/plate
	filling_color = "#43de18"
	center_of_mass = @"{'x':16,'y':13}"
	bitesize = 2

/obj/item/chems/food/xemeatpie/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 10)

/obj/item/chems/food/poppypretzel
	name = "poppy pretzel"
	desc = "It's all twisted up!"
	icon_state = "poppypretzel"
	bitesize = 2
	filling_color = "#916e36"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("poppy seeds" = 2, "pretzel" = 3)
	nutriment_amt = 5
	bitesize = 2

/obj/item/chems/food/applepie
	name = "apple pie"
	desc = "A pie containing sweet sweet love... or apple."
	icon_state = "applepie"
	filling_color = "#e0edc5"
	center_of_mass = @"{'x':16,'y':13}"
	nutriment_desc = list("sweetness" = 2, "apple" = 2, "pie" = 2)
	nutriment_amt = 4
	bitesize = 3

/obj/item/chems/food/cherrypie
	name = "cherry pie"
	desc = "Taste so good, make a grown man cry."
	icon_state = "cherrypie"
	filling_color = "#ff525a"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("sweetness" = 2, "cherry" = 2, "pie" = 2)
	nutriment_amt = 4
	bitesize = 3

/obj/item/chems/food/fortunecookie
	name = "fortune cookie"
	desc = "A true prophecy in each cookie!"
	icon_state = "fortune_cookie"
	filling_color = "#e8e79e"
	center_of_mass = @"{'x':15,'y':14}"
	nutriment_desc = list("fortune cookie" = 2)
	nutriment_amt = 3
	bitesize = 2