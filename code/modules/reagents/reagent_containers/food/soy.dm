/obj/item/food/tofu
	name = "tofu"
	icon = 'icons/obj/food/tofu/tofu.dmi'
	desc = "We all love tofu."
	filling_color = "#fffee0"
	center_of_mass = @'{"x":17,"y":10}'
	nutriment_amt = 3
	nutriment_desc = list("tofu" = 3, "softness" = 3)
	bitesize = 3

/obj/item/food/tofu/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/plant_protein, 6)

/obj/item/food/tofurkey
	name = "\improper Tofurkey"
	desc = "A fake turkey made from tofu."
	icon = 'icons/obj/food/tofu/tofurkey.dmi'
	filling_color = "#fffee0"
	center_of_mass = @'{"x":16,"y":8}'
	nutriment_amt = 12
	nutriment_desc = list("turkey" = 3, "tofu" = 5, "softness" = 4)
	bitesize = 3

/obj/item/food/stewedsoymeat
	name = "stewed soy meat"
	desc = "Even non-vegetarians will LOVE this!"
	icon = 'icons/obj/food/tofu/soymeat.dmi'
	plate = /obj/item/plate
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("soy" = 4, "tomato" = 4)
	nutriment_amt = 8
	bitesize = 2
