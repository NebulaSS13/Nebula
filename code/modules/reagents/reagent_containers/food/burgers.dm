/////////////
// Burgers //
/////////////

/obj/item/food/brainburger
	name = "brainburger"
	desc = "A strange looking burger. It looks almost sentient."
	icon = 'icons/obj/food/burgers/brainburger.dmi'
	filling_color = "#f2b6ea"
	center_of_mass = @'{"x":15,"y":11}'
	bitesize = 2
	material = /decl/material/solid/organic/meat

/obj/item/food/brainburger/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 6)
	add_to_reagents(/decl/material/liquid/neuroannealer,     6)

/obj/item/food/ghostburger
	name = "ghost burger"
	desc = "Spooky! It doesn't look very filling."
	icon = 'icons/obj/food/burgers/ghostburger.dmi'
	filling_color = "#fff2ff"
	center_of_mass = @'{"x":16,"y":11}'
	nutriment_desc = list("buns" = 3, "spookiness" = 3)
	nutriment_amt = 2
	bitesize = 2

/obj/item/food/cheeseburger
	name = "cheeseburger"
	desc = "The cheese adds a good flavor."
	icon = 'icons/obj/food/burgers/cheeseburger.dmi'
	center_of_mass = @'{"x":16,"y":11}'
	nutriment_desc = list("cheese" = 2, "bun" = 2)
	nutriment_amt = 2

/obj/item/food/cheeseburger/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 2)

/obj/item/food/burger
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon = 'icons/obj/food/burgers/burger.dmi'
	filling_color = "#d63c3c"
	center_of_mass = @'{"x":16,"y":11}'
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 3
	bitesize = 2

/obj/item/food/burger/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 3)

/obj/item/food/hamburger
	name = "hamburger"
	desc = "The cornerstone of every nutritious breakfast, now with ham!"
	icon = 'icons/obj/food/burgers/hamburger.dmi'
	filling_color = "#d63c3c"
	center_of_mass = @'{"x":16,"y":11}'
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 3
	bitesize = 2

/obj/item/food/hamburger/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 5)

/obj/item/food/fishburger
	name = "fish sandwich"
	desc = "Almost like a carp is yelling somewhere... Give me back that fillet -o- carp, give me that carp."
	icon = 'icons/obj/food/burgers/fishburger.dmi'
	filling_color = "#ffdefe"
	center_of_mass = @'{"x":16,"y":10}'
	bitesize = 3

/obj/item/food/fishburger/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 6)

/obj/item/food/tofuburger
	name = "tofu burger"
	desc = "What... is that meat?"
	icon = 'icons/obj/food/burgers/tofuburger.dmi'
	filling_color = "#fffee0"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("bun" = 2, "pseudo-soy meat" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/food/roburger
	name = "roburger"
	desc = "The lettuce is the only organic component. Beep."
	icon = 'icons/obj/food/burgers/roburger.dmi'
	filling_color = COLOR_GRAY80
	center_of_mass = @'{"x":16,"y":11}'
	nutriment_desc = list("bun" = 2, "metal" = 3)
	nutriment_amt = 2
	bitesize = 2

/obj/item/food/roburger/populate_reagents()
	. = ..()
	if(prob(5))
		add_to_reagents(/decl/material/liquid/nanitefluid, 2)

/obj/item/food/roburgerbig
	name = "roburger"
	desc = "This massive patty looks like poison. Beep."
	icon = 'icons/obj/food/burgers/roburger.dmi'
	filling_color = COLOR_GRAY80
	volume = 100
	center_of_mass = @'{"x":16,"y":11}'
	bitesize = 0.1

/obj/item/food/roburgerbig/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nanitefluid, reagents.maximum_volume)

/obj/item/food/xenoburger
	name = "xenoburger"
	desc = "Smells caustic. Tastes like heresy."
	icon = 'icons/obj/food/burgers/xenoburger.dmi'
	filling_color = "#43de18"
	center_of_mass = @'{"x":16,"y":11}'
	bitesize = 2

/obj/item/food/xenoburger/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 8)

/obj/item/food/clownburger
	name = "clown burger"
	desc = "This tastes funny..."
	icon = 'icons/obj/food/burgers/clownburger.dmi'
	filling_color = "#ff00ff"
	center_of_mass = @'{"x":17,"y":12}'
	nutriment_desc = list("bun" = 2, "clown shoe" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/food/mimeburger
	name = "mime burger"
	desc = "Its taste defies language."
	icon = 'icons/obj/food/burgers/mimeburger.dmi'
	filling_color = "#ffffff"
	center_of_mass = @'{"x":16,"y":11}'
	nutriment_desc = list("bun" = 2, "mime paint" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/food/spellburger
	name = "spell burger"
	desc = "This is absolutely magical."
	icon = 'icons/obj/food/burgers/spellburger.dmi'
	filling_color = "#d505ff"
	nutriment_desc = list("magic" = 3, "buns" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/food/bigbiteburger
	name = "big bite burger"
	desc = "Forget the Luna Burger! THIS is the future!"
	icon = 'icons/obj/food/burgers/bigbiteburger.dmi'
	filling_color = "#e3d681"
	center_of_mass = @'{"x":16,"y":11}'
	nutriment_desc = list("buns" = 4)
	nutriment_amt = 4
	bitesize = 3

/obj/item/food/bigbiteburger/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 10)

/obj/item/food/jellyburger
	name = "jelly burger"
	desc = "Culinary delight...?"
	icon = 'icons/obj/food/burgers/jellyburger.dmi'
	filling_color = "#b572ab"
	center_of_mass = @'{"x":16,"y":11}'
	nutriment_desc = list("buns" = 5)
	nutriment_amt = 5
	bitesize = 2

/obj/item/food/jellyburger/cherry/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/cherryjelly, 5)

/obj/item/food/superbiteburger
	name = "super bite burger"
	desc = "This is a mountain of a burger. FOOD!"
	icon = 'icons/obj/food/burgers/superbiteburger.dmi'
	filling_color = "#cca26a"
	center_of_mass = @'{"x":16,"y":3}'
	nutriment_desc = list("buns" = 25)
	nutriment_amt = 25
	bitesize = 10

/obj/item/food/superbiteburger/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 25)

