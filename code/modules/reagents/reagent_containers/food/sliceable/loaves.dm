/obj/item/food/sliceable/meatbread
	name = "meatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman."
	icon_state = "meatbread"
	slice_path = /obj/item/food/slice/meatbread
	slice_num = 5
	filling_color = "#ff7575"
	center_of_mass = @'{"x":19,"y":9}'
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 10
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/food/sliceable/meatbread/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 20)

/obj/item/food/slice/meatbread
	name = "meatbread slice"
	desc = "A slice of delicious meatbread."
	icon_state = "meatbreadslice"
	plate = /obj/item/plate
	filling_color = "#ff7575"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":13}'
	whole_path = /obj/item/food/sliceable/meatbread

/obj/item/food/slice/meatbread/filled
	filled = TRUE

/obj/item/food/sliceable/xenomeatbread
	name = "xenomeatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman. Extra heretical."
	icon_state = "xenomeatbread"
	slice_path = /obj/item/food/slice/xenomeatbread
	slice_num = 5
	filling_color = "#8aff75"
	center_of_mass = @'{"x":16,"y":9}'
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 10
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/food/sliceable/xenomeatbread/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 20)

/obj/item/food/slice/xenomeatbread
	name = "xenomeatbread slice"
	desc = "A slice of delicious meatbread. Extra Heretical."
	icon_state = "xenobreadslice"
	plate = /obj/item/plate
	filling_color = "#8aff75"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":13}'
	whole_path = /obj/item/food/sliceable/xenomeatbread

/obj/item/food/slice/xenomeatbread/filled
	filled = TRUE

/obj/item/food/sliceable/bananabread
	name = "banana-nut bread"
	desc = "A heavenly and filling treat."
	icon_state = "bananabread"
	slice_path = /obj/item/food/slice/bananabread
	slice_num = 5
	filling_color = "#ede5ad"
	center_of_mass = @'{"x":16,"y":9}'
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 10
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/food/sliceable/bananabread/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/banana_cream, 20)

/obj/item/food/slice/bananabread
	name = "banana-nut bread slice"
	desc = "A slice of delicious banana bread."
	icon_state = "bananabreadslice"
	plate = /obj/item/plate
	filling_color = "#ede5ad"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":8}'
	whole_path = /obj/item/food/sliceable/bananabread

/obj/item/food/slice/bananabread/filled
	filled = TRUE

/obj/item/food/sliceable/tofubread
	name = "tofubread"
	desc = "Like meatbread but for vegetarians. Not guaranteed to give superpowers."
	icon_state = "tofubread"
	slice_path = /obj/item/food/slice/tofubread
	slice_num = 5
	filling_color = "#f7ffe0"
	center_of_mass = @'{"x":16,"y":9}'
	nutriment_desc = list("tofu" = 10)
	nutriment_amt = 10
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/food/slice/tofubread
	name = "tofubread slice"
	desc = "A slice of delicious tofubread."
	icon_state = "tofubreadslice"
	plate = /obj/item/plate
	filling_color = "#f7ffe0"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":13}'
	whole_path = /obj/item/food/sliceable/tofubread

/obj/item/food/slice/tofubread/filled
	filled = TRUE

/obj/item/food/sliceable/bread
	name = "bread"
	desc = "Some plain old bread."
	icon_state = "bread"
	slice_path = /obj/item/food/slice/bread
	slice_num = 5
	filling_color = "#ffe396"
	center_of_mass = @'{"x":16,"y":9}'
	nutriment_desc = list("bread" = 6)
	nutriment_amt = 6
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/food/slice/bread
	name = "bread slice"
	desc = "A slice of home."
	icon_state = "breadslice"
	plate = /obj/item/plate
	filling_color = "#d27332"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":4}'
	whole_path = /obj/item/food/sliceable/bread

/obj/item/food/slice/bread/filled
	filled = TRUE

/obj/item/food/sliceable/creamcheesebread
	name = "cream cheese bread"
	desc = "Yum yum yum!"
	icon_state = "creamcheesebread"
	slice_path = /obj/item/food/slice/creamcheesebread
	slice_num = 5
	filling_color = "#fff896"
	center_of_mass = @'{"x":16,"y":9}'
	nutriment_desc = list("bread" = 6, "cream" = 3, "cheese" = 3)
	nutriment_amt = 5
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/food/sliceable/creamcheesebread/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 15)

/obj/item/food/slice/creamcheesebread
	name = "cream cheese bread slice"
	desc = "A slice of yum!"
	icon_state = "creamcheesebreadslice"
	plate = /obj/item/plate
	filling_color = "#fff896"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":13}'
	whole_path = /obj/item/food/sliceable/creamcheesebread

/obj/item/food/slice/creamcheesebread/filled
	filled = TRUE