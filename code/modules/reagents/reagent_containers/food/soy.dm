/obj/item/food/tofu
	name = "tofu"
	icon_state = "tofu"
	desc = "We all love tofu."
	filling_color = "#fffee0"
	center_of_mass = @'{"x":17,"y":10}'
	nutriment_amt = 3
	nutriment_desc = list("tofu" = 3, "softness" = 3)
	bitesize = 3

/obj/item/food/tofu/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/plant_protein, 6)

/obj/item/food/tofukabob
	name = "tofu-kabob"
	icon_state = "kabob"
	desc = "Vegan meat, on a stick."
	trash = /obj/item/stack/material/rods
	filling_color = "#fffee0"
	center_of_mass = @'{"x":17,"y":15}'
	nutriment_desc = list("tofu" = 3, "metal" = 1)
	nutriment_amt = 8
	bitesize = 2

/obj/item/food/tofurkey
	name = "\improper Tofurkey"
	desc = "A fake turkey made from tofu."
	icon_state = "tofurkey"
	filling_color = "#fffee0"
	center_of_mass = @'{"x":16,"y":8}'
	nutriment_amt = 12
	nutriment_desc = list("turkey" = 3, "tofu" = 5, "softness" = 4)
	bitesize = 3

/obj/item/food/stewedsoymeat
	name = "stewed soy meat"
	desc = "Even non-vegetarians will LOVE this!"
	icon_state = "stewedsoymeat"
	plate = /obj/item/plate
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("soy" = 4, "tomato" = 4)
	nutriment_amt = 8
	bitesize = 2