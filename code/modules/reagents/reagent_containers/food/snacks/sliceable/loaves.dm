/obj/item/chems/food/snacks/sliceable/meatbread
	name = "meatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman."
	icon_state = "meatbread"
	slice_path = /obj/item/chems/food/snacks/slice/meatbread
	slices_num = 5
	filling_color = "#ff7575"
	center_of_mass = @"{'x':19,'y':9}"
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 10
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/sliceable/meatbread/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 20)

/obj/item/chems/food/snacks/slice/meatbread
	name = "meatbread slice"
	desc = "A slice of delicious meatbread."
	icon_state = "meatbreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#ff7575"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':13}"
	whole_path = /obj/item/chems/food/snacks/sliceable/meatbread

/obj/item/chems/food/snacks/slice/meatbread/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/xenomeatbread
	name = "xenomeatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman. Extra heretical."
	icon_state = "xenomeatbread"
	slice_path = /obj/item/chems/food/snacks/slice/xenomeatbread
	slices_num = 5
	filling_color = "#8aff75"
	center_of_mass = @"{'x':16,'y':9}"
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 10
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/sliceable/xenomeatbread/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 20)

/obj/item/chems/food/snacks/slice/xenomeatbread
	name = "xenomeatbread slice"
	desc = "A slice of delicious meatbread. Extra Heretical."
	icon_state = "xenobreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#8aff75"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':13}"
	whole_path = /obj/item/chems/food/snacks/sliceable/xenomeatbread

/obj/item/chems/food/snacks/slice/xenomeatbread/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/bananabread
	name = "banana-nut bread"
	desc = "A heavenly and filling treat."
	icon_state = "bananabread"
	slice_path = /obj/item/chems/food/snacks/slice/bananabread
	slices_num = 5
	filling_color = "#ede5ad"
	center_of_mass = @"{'x':16,'y':9}"
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 10
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/sliceable/bananabread/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/banana_cream, 20)

/obj/item/chems/food/snacks/slice/bananabread
	name = "banana-nut bread slice"
	desc = "A slice of delicious banana bread."
	icon_state = "bananabreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#ede5ad"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':8}"
	whole_path = /obj/item/chems/food/snacks/sliceable/bananabread

/obj/item/chems/food/snacks/slice/bananabread/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/tofubread
	name = "tofubread"
	desc = "Like meatbread but for vegetarians. Not guaranteed to give superpowers."
	icon_state = "tofubread"
	slice_path = /obj/item/chems/food/snacks/slice/tofubread
	slices_num = 5
	filling_color = "#f7ffe0"
	center_of_mass = @"{'x':16,'y':9}"
	nutriment_desc = list("tofu" = 10)
	nutriment_amt = 10
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/slice/tofubread
	name = "tofubread slice"
	desc = "A slice of delicious tofubread."
	icon_state = "tofubreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#f7ffe0"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':13}"
	whole_path = /obj/item/chems/food/snacks/sliceable/tofubread

/obj/item/chems/food/snacks/slice/tofubread/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/bread
	name = "bread"
	desc = "Some plain old bread."
	icon_state = "bread"
	slice_path = /obj/item/chems/food/snacks/slice/bread
	slices_num = 5
	filling_color = "#ffe396"
	center_of_mass = @"{'x':16,'y':9}"
	nutriment_desc = list("bread" = 6)
	nutriment_amt = 6
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/slice/bread
	name = "bread slice"
	desc = "A slice of home."
	icon_state = "breadslice"
	trash = /obj/item/trash/plate
	filling_color = "#d27332"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':4}"
	whole_path = /obj/item/chems/food/snacks/sliceable/bread

/obj/item/chems/food/snacks/slice/bread/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/creamcheesebread
	name = "cream cheese bread"
	desc = "Yum yum yum!"
	icon_state = "creamcheesebread"
	slice_path = /obj/item/chems/food/snacks/slice/creamcheesebread
	slices_num = 5
	filling_color = "#fff896"
	center_of_mass = @"{'x':16,'y':9}"
	nutriment_desc = list("bread" = 6, "cream" = 3, "cheese" = 3)
	nutriment_amt = 5
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/sliceable/creamcheesebread/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 15)

/obj/item/chems/food/snacks/slice/creamcheesebread
	name = "cream cheese bread slice"
	desc = "A slice of yum!"
	icon_state = "creamcheesebreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#fff896"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':13}"
	whole_path = /obj/item/chems/food/snacks/sliceable/creamcheesebread

/obj/item/chems/food/snacks/slice/creamcheesebread/filled
	filled = TRUE