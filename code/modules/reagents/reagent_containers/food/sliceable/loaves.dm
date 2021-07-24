/obj/item/chems/food/sliceable/meatbread
	name = "meatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman."
	icon_state = "meatbread"
	slice_path = /obj/item/chems/food/slice/meatbread
	slices_num = 5
	filling_color = "#ff7575"
	center_of_mass = @"{'x':19,'y':9}"
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 10
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/sliceable/meatbread/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 20)

/obj/item/chems/food/slice/meatbread
	name = "meatbread slice"
	desc = "A slice of delicious meatbread."
	icon_state = "meatbreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#ff7575"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':13}"
	whole_path = /obj/item/chems/food/sliceable/meatbread

/obj/item/chems/food/slice/meatbread/filled
	filled = TRUE

/obj/item/chems/food/sliceable/xenomeatbread
	name = "xenomeatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman. Extra heretical."
	icon_state = "xenomeatbread"
	slice_path = /obj/item/chems/food/slice/xenomeatbread
	slices_num = 5
	filling_color = "#8aff75"
	center_of_mass = @"{'x':16,'y':9}"
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 10
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/sliceable/xenomeatbread/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 20)

/obj/item/chems/food/slice/xenomeatbread
	name = "xenomeatbread slice"
	desc = "A slice of delicious meatbread. Extra Heretical."
	icon_state = "xenobreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#8aff75"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':13}"
	whole_path = /obj/item/chems/food/sliceable/xenomeatbread

/obj/item/chems/food/slice/xenomeatbread/filled
	filled = TRUE

/obj/item/chems/food/sliceable/bananabread
	name = "banana-nut bread"
	desc = "A heavenly and filling treat."
	icon_state = "bananabread"
	slice_path = /obj/item/chems/food/slice/bananabread
	slices_num = 5
	filling_color = "#ede5ad"
	center_of_mass = @"{'x':16,'y':9}"
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 10
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/sliceable/bananabread/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/banana_cream, 20)

/obj/item/chems/food/slice/bananabread
	name = "banana-nut bread slice"
	desc = "A slice of delicious banana bread."
	icon_state = "bananabreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#ede5ad"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':8}"
	whole_path = /obj/item/chems/food/sliceable/bananabread

/obj/item/chems/food/slice/bananabread/filled
	filled = TRUE

/obj/item/chems/food/sliceable/tofubread
	name = "tofubread"
	desc = "Like meatbread but for vegetarians. Not guaranteed to give superpowers."
	icon_state = "tofubread"
	slice_path = /obj/item/chems/food/slice/tofubread
	slices_num = 5
	filling_color = "#f7ffe0"
	center_of_mass = @"{'x':16,'y':9}"
	nutriment_desc = list("tofu" = 10)
	nutriment_amt = 10
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/slice/tofubread
	name = "tofubread slice"
	desc = "A slice of delicious tofubread."
	icon_state = "tofubreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#f7ffe0"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':13}"
	whole_path = /obj/item/chems/food/sliceable/tofubread

/obj/item/chems/food/slice/tofubread/filled
	filled = TRUE

/obj/item/chems/food/sliceable/bread
	name = "bread"
	desc = "Some plain old bread."
	icon_state = "bread"
	slice_path = /obj/item/chems/food/slice/bread
	slices_num = 5
	filling_color = "#ffe396"
	center_of_mass = @"{'x':16,'y':9}"
	nutriment_desc = list("bread" = 6)
	nutriment_amt = 6
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/slice/bread
	name = "bread slice"
	desc = "A slice of home."
	icon_state = "breadslice"
	trash = /obj/item/trash/plate
	filling_color = "#d27332"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':4}"
	whole_path = /obj/item/chems/food/sliceable/bread

/obj/item/chems/food/slice/bread/filled
	filled = TRUE

/obj/item/chems/food/sliceable/creamcheesebread
	name = "cream cheese bread"
	desc = "Yum yum yum!"
	icon_state = "creamcheesebread"
	slice_path = /obj/item/chems/food/slice/creamcheesebread
	slices_num = 5
	filling_color = "#fff896"
	center_of_mass = @"{'x':16,'y':9}"
	nutriment_desc = list("bread" = 6, "cream" = 3, "cheese" = 3)
	nutriment_amt = 5
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/sliceable/creamcheesebread/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 15)

/obj/item/chems/food/slice/creamcheesebread
	name = "cream cheese bread slice"
	desc = "A slice of yum!"
	icon_state = "creamcheesebreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#fff896"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':13}"
	whole_path = /obj/item/chems/food/sliceable/creamcheesebread

/obj/item/chems/food/slice/creamcheesebread/filled
	filled = TRUE