/////////////
// Burgers //
/////////////

/obj/item/chems/food/brainburger
	name = "brainburger"
	desc = "A strange looking burger. It looks almost sentient."
	icon_state = "brainburger"
	filling_color = "#f2b6ea"
	center_of_mass = @"{'x':15,'y':11}"
	bitesize = 2
	material = /decl/material/solid/meat

/obj/item/chems/food/brainburger/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 6)
	reagents.add_reagent(/decl/material/liquid/neuroannealer, 6)

/obj/item/chems/food/ghostburger
	name = "ghost burger"
	desc = "Spooky! It doesn't look very filling."
	icon_state = "ghostburger"
	filling_color = "#fff2ff"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("buns" = 3, "spookiness" = 3)
	nutriment_amt = 2
	bitesize = 2

/obj/item/chems/food/human
	filling_color = "#d63c3c"
	material = /decl/material/solid/meat
	var/hname = ""
	var/job = null

/obj/item/chems/food/human/burger
	name = "-burger"
	desc = "A bloody burger."
	icon_state = "hburger"
	center_of_mass = @"{'x':16,'y':11}"
	bitesize = 2

/obj/item/chems/food/human/burger/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 6)

/obj/item/chems/food/cheeseburger
	name = "cheeseburger"
	desc = "The cheese adds a good flavor."
	icon_state = "cheeseburger"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("cheese" = 2, "bun" = 2)
	nutriment_amt = 2

/obj/item/chems/food/cheeseburger/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 2)

/obj/item/chems/food/meatburger
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon_state = "hburger"
	filling_color = "#d63c3c"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 3
	bitesize = 2

/obj/item/chems/food/meatburger/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 3)

/obj/item/chems/food/plainburger
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "burger"
	filling_color = "#d63c3c"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 3
	bitesize = 2

/obj/item/chems/food/plainburger/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 3)

/obj/item/chems/food/hamburger
	name = "hamburger"
	desc = "The cornerstone of every nutritious breakfast, now with ham!"
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "hamburger"
	filling_color = "#d63c3c"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 3
	bitesize = 2

/obj/item/chems/food/hamburger/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 5)

/obj/item/chems/food/fishburger
	name = "fish sandwich"
	desc = "Almost like a carp is yelling somewhere... Give me back that fillet -o- carp, give me that carp."
	icon_state = "fishburger"
	filling_color = "#ffdefe"
	center_of_mass = @"{'x':16,'y':10}"
	bitesize = 3

/obj/item/chems/food/fishburger/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 6)

/obj/item/chems/food/tofuburger
	name = "tofu burger"
	desc = "What.. is that meat?"
	icon_state = "tofuburger"
	filling_color = "#fffee0"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("bun" = 2, "pseudo-soy meat" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/chems/food/roburger
	name = "roburger"
	desc = "The lettuce is the only organic component. Beep."
	icon_state = "roburger"
	filling_color = COLOR_GRAY80
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("bun" = 2, "metal" = 3)
	nutriment_amt = 2
	bitesize = 2

/obj/item/chems/food/roburger/Initialize()
	. = ..()
	if(prob(5))
		reagents.add_reagent(/decl/material/liquid/nanitefluid, 2)

/obj/item/chems/food/roburgerbig
	name = "roburger"
	desc = "This massive patty looks like poison. Beep."
	icon_state = "roburger"
	filling_color = COLOR_GRAY80
	volume = 100
	center_of_mass = @"{'x':16,'y':11}"
	bitesize = 0.1

/obj/item/chems/food/roburgerbig/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nanitefluid, 100)

/obj/item/chems/food/xenoburger
	name = "xenoburger"
	desc = "Smells caustic. Tastes like heresy."
	icon_state = "xburger"
	filling_color = "#43de18"
	center_of_mass = @"{'x':16,'y':11}"
	bitesize = 2

/obj/item/chems/food/xenoburger/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 8)

/obj/item/chems/food/clownburger
	name = "clown burger"
	desc = "This tastes funny..."
	icon_state = "clownburger"
	filling_color = "#ff00ff"
	center_of_mass = @"{'x':17,'y':12}"
	nutriment_desc = list("bun" = 2, "clown shoe" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/chems/food/mimeburger
	name = "mime burger"
	desc = "Its taste defies language."
	icon_state = "mimeburger"
	filling_color = "#ffffff"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("bun" = 2, "mime paint" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/chems/food/spellburger
	name = "spell burger"
	desc = "This is absolutely magical."
	icon_state = "spellburger"
	filling_color = "#d505ff"
	nutriment_desc = list("magic" = 3, "buns" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/chems/food/bigbiteburger
	name = "big bite burger"
	desc = "Forget the Luna Burger! THIS is the future!"
	icon_state = "bigbiteburger"
	filling_color = "#e3d681"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("buns" = 4)
	nutriment_amt = 4
	bitesize = 3

/obj/item/chems/food/bigbiteburger/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 10)

/obj/item/chems/food/jellyburger
	name = "jelly burger"
	desc = "Culinary delight..?"
	icon_state = "jellyburger"
	filling_color = "#b572ab"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("buns" = 5)
	nutriment_amt = 5
	bitesize = 2

/obj/item/chems/food/jellyburger/cherry/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/cherryjelly, 5)

/obj/item/chems/food/superbiteburger
	name = "super bite burger"
	desc = "This is a mountain of a burger. FOOD!"
	icon_state = "superbiteburger"
	filling_color = "#cca26a"
	center_of_mass = @"{'x':16,'y':3}"
	nutriment_desc = list("buns" = 25)
	nutriment_amt = 25
	bitesize = 10

/obj/item/chems/food/superbiteburger/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 25)

// I am not creating another file just for hot dogs.

/obj/item/chems/food/hotdog
	name = "hotdog"
	desc = "Unrelated to dogs, maybe."
	icon_state = "hotdog"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':17}"
	nutriment_type = /decl/material/liquid/nutriment/bread
	material = /decl/material/solid/meat

/obj/item/chems/food/hotdog/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 6)

/obj/item/chems/food/classichotdog
	name = "classic hotdog"
	desc = "Going literal."
	icon_state = "hotcorgi"
	bitesize = 6
	center_of_mass = @"{'x':16,'y':17}"
	material = /decl/material/solid/meat

/obj/item/chems/food/classichotdog/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 16)