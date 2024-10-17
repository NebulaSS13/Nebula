/////////////////
// Baked Goods //
/////////////////

/obj/item/food/muffin
	name = "muffin"
	desc = "A delicious and spongy little cake."
	icon = 'icons/obj/food/baked/muffin.dmi'
	filling_color = "#e0cf9b"
	center_of_mass = @'{"x":17,"y":4}'
	nutriment_desc = list("sweetness" = 3, "muffin" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/food/bananapie
	name = "banana cream pie"
	desc = "Just like back home, on clown planet! HONK!"
	icon = 'icons/obj/food/baked/pies/pie.dmi'
	plate = /obj/item/plate
	filling_color = "#fbffb8"
	center_of_mass = @'{"x":16,"y":13}'
	nutriment_desc = list("pie" = 3, "cream" = 2)
	nutriment_amt = 4
	bitesize = 3

/obj/item/food/bananapie/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/banana_cream, 5)

/obj/item/food/bananapie/throw_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/pie_smudge(src.loc)
	src.visible_message("<span class='danger'>\The [src.name] splats.</span>","<span class='danger'>You hear a splat.</span>")
	qdel(src)

/obj/item/food/berryclafoutis
	name = "berry clafoutis"
	desc = "No black birds, this is a good sign."
	icon = 'icons/obj/food/baked/pies/berry.dmi'
	plate = /obj/item/plate
	center_of_mass = @'{"x":16,"y":13}'
	nutriment_desc = list("sweetness" = 2, "pie" = 3)
	nutriment_amt = 4
	bitesize = 3

/obj/item/food/berryclafoutis/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/drink/juice/berry, 5)

/obj/item/food/waffles
	name = "waffles"
	desc = "Mmm, waffles."
	icon = 'icons/obj/food/baked/waffles/plain.dmi'
	trash = /obj/item/trash/waffles
	filling_color = "#e6deb5"
	center_of_mass = @'{"x":15,"y":11}'
	nutriment_desc = list("waffle" = 8)
	nutriment_amt = 8
	bitesize = 2

/obj/item/food/rofflewaffles
	name = "waffles(?)"
	desc = "There's something funny about these waffles."
	icon = 'icons/obj/food/baked/waffles/blue.dmi'
	trash = /obj/item/trash/waffles
	filling_color = "#ff00f7"
	center_of_mass = @'{"x":15,"y":11}'
	nutriment_desc = list("waffle" = 7, "sweetness" = 1)
	nutriment_amt = 8
	bitesize = 4

/obj/item/food/rofflewaffles/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/psychotropics, 8)

/obj/item/food/pancakes
	name = "pancakes"
	desc = "Pancakes without blueberries, still delicious."
	icon = 'icons/obj/food/fried/pancakes.dmi'
	plate = /obj/item/plate
	center_of_mass = @'{"x":15,"y":11}'
	nutriment_desc = list("pancake" = 8)
	nutriment_amt = 8
	bitesize = 2

/obj/item/food/pancakesblu
	name = "blueberry pancakes"
	desc = "Pancakes with blueberries, delicious."
	icon = 'icons/obj/food/fried/pancakes.dmi'
	plate = /obj/item/plate
	center_of_mass = @'{"x":15,"y":11}'
	nutriment_desc = list("pancake" = 8)
	nutriment_amt = 8
	bitesize = 2

/obj/item/food/eggplantparm
	name = "eggplant parmigiana"
	desc = "The only good recipe for eggplant."
	icon = 'icons/obj/food/baked/eggplant_parmigiana.dmi'
	plate = /obj/item/plate
	filling_color = "#4d2f5e"
	center_of_mass = @'{"x":16,"y":11}'
	nutriment_desc = list("cheese" = 3, "eggplant" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/food/soylentgreen
	name = "\improper Soylent Green"
	desc = "Not made of people. Honest."//Totally people.
	icon = 'icons/obj/food/baked/waffles/green.dmi'
	trash = /obj/item/trash/waffles
	filling_color = "#b8e6b5"
	center_of_mass = @'{"x":15,"y":11}'
	bitesize = 2

/obj/item/food/soylentgreen/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 10)

/obj/item/food/soylenviridians
	name = "\improper Soylen Virdians"
	desc = "Not made of people. Honest."//Actually honest for once.
	icon = 'icons/obj/food/baked/waffles/blue.dmi'
	trash = /obj/item/trash/waffles
	filling_color = "#e6fa61"
	center_of_mass = @'{"x":15,"y":11}'
	nutriment_desc = list("some sort of protein" = 10)//seasoned vERY well.
	nutriment_amt = 10
	bitesize = 2

/obj/item/food/meatpie
	name = "meat-pie"
	icon = 'icons/obj/food/baked/pies/meat.dmi'
	desc = "An old barber recipe, very delicious!"
	plate = /obj/item/plate
	filling_color = "#948051"
	center_of_mass = @'{"x":16,"y":13}'
	bitesize = 2

/obj/item/food/meatpie/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 10)

/obj/item/food/tofupie
	name = "tofu-pie"
	icon = 'icons/obj/food/baked/pies/meat.dmi'
	desc = "A delicious tofu pie."
	plate = /obj/item/plate
	filling_color = "#fffee0"
	center_of_mass = @'{"x":16,"y":13}'
	nutriment_desc = list("tofu" = 2, "pie" = 8)
	nutriment_amt = 10
	bitesize = 2

/obj/item/food/amanita_pie
	name = "amanita pie"
	desc = "Sweet and tasty poison pie."
	icon = 'icons/obj/food/baked/pies/amanita.dmi'
	filling_color = "#ffcccc"
	center_of_mass = @'{"x":17,"y":9}'
	nutriment_desc = list("sweetness" = 3, "mushroom" = 3, "pie" = 2)
	nutriment_amt = 5
	bitesize = 3

/obj/item/food/amanita_pie/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/amatoxin,      3)
	add_to_reagents(/decl/material/liquid/psychotropics, 1)

/obj/item/food/plump_pie
	name = "plump pie"
	desc = "I bet you love stuff made out of plump helmets!"
	icon = 'icons/obj/food/baked/pies/plumphelmet.dmi'
	filling_color = "#b8279b"
	center_of_mass = @'{"x":17,"y":9}'
	nutriment_desc = list("heartiness" = 2, "mushroom" = 3, "pie" = 3)
	nutriment_amt = 8
	bitesize = 2

/obj/item/food/plump_pie/populate_reagents()
	. = ..()
	if(prob(10)) //#TODO: have this depend on cook's skill within the recipe handling instead maybe?
		name = "exceptional plump pie"
		desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump pie!"
		add_to_reagents(/decl/material/liquid/regenerator, 5)

/obj/item/food/xemeatpie
	name = "xeno-pie"
	icon = 'icons/obj/food/baked/pies/xeno.dmi'
	desc = "A delicious meatpie. Probably heretical."
	plate = /obj/item/plate
	filling_color = "#43de18"
	center_of_mass = @'{"x":16,"y":13}'
	bitesize = 2

/obj/item/food/xemeatpie/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat/xeno, 10)

/obj/item/food/poppypretzel
	name = "poppy pretzel"
	desc = "It's all twisted up!"
	icon = 'icons/obj/food/baked/pretzel.dmi'
	filling_color = "#916e36"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("poppy seeds" = 2, "pretzel" = 3)
	nutriment_amt = 5
	bitesize = 2

/obj/item/food/applepie
	name = "apple pie"
	desc = "A pie containing sweet sweet love... or apple."
	icon = 'icons/obj/food/baked/pies/apple.dmi'
	filling_color = "#e0edc5"
	center_of_mass = @'{"x":16,"y":13}'
	nutriment_desc = list("sweetness" = 2, "apple" = 2, "pie" = 2)
	nutriment_amt = 4
	bitesize = 3

/obj/item/food/cherrypie
	name = "cherry pie"
	desc = "Taste so good, make a grown man cry."
	icon = 'icons/obj/food/baked/pies/cherry.dmi'
	filling_color = "#ff525a"
	center_of_mass = @'{"x":16,"y":11}'
	nutriment_desc = list("sweetness" = 2, "cherry" = 2, "pie" = 2)
	nutriment_amt = 4
	bitesize = 3

/obj/item/food/fortunecookie
	name = "fortune cookie"
	desc = "A true prophecy in each cookie!"
	icon = 'icons/obj/food/baked/fortune_cookie.dmi'
	filling_color = "#e8e79e"
	center_of_mass = @'{"x":15,"y":14}'
	nutriment_desc = list("fortune cookie" = 2)
	nutriment_amt = 3
	bitesize = 2


/obj/item/food/bun
	name = "bun"
	desc = "A base for any self-respecting burger."
	icon = 'icons/obj/food/baked/bun.dmi'
	icon_state = ICON_STATE_WORLD
	bitesize = 2
	center_of_mass = @'{"x":16,"y":12}'
	nutriment_desc = list("bun" = 4)
	nutriment_amt = 4
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/food/bunbun
	name = "\improper Bun Bun"
	desc = "A small bread monkey fashioned from two burger buns."
	icon = 'icons/obj/food/baked/bunbun.dmi'
	bitesize = 2
	center_of_mass = @'{"x":16,"y":8}'
	nutriment_desc = list("bun" = 8)
	nutriment_amt = 8
	nutriment_type = /decl/material/liquid/nutriment/bread
