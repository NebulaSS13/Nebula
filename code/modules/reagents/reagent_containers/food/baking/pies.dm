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
	visible_message(SPAN_DANGER("\The [src] splats."), SPAN_DANGER("You hear a splat."))
	qdel(src)

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

/obj/item/food/sliceable/pumpkinpie
	name = "pumpkin pie"
	desc = "A delicious treat for the autumn months."
	icon = 'icons/obj/food/baked/cakes/pumpkin.dmi'
	slice_path = /obj/item/food/slice/pumpkinpie
	slice_num = 5
	filling_color = "#f5b951"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("pie" = 5, "cream" = 5, "pumpkin" = 5)
	nutriment_amt = 15

/obj/item/food/slice/pumpkinpie
	name = "pumpkin pie slice"
	desc = "A slice of pumpkin pie, with whipped cream on top. Perfection."
	icon = 'icons/obj/food/baked/cakes/slices/pumpkin.dmi'
	plate = /obj/item/plate
	filling_color = "#f5b951"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":12}'
	whole_path = /obj/item/food/sliceable/pumpkinpie

/obj/item/food/slice/pumpkinpie/filled
	filled = TRUE