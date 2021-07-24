/obj/item/chems/food/sliceable/carrotcake
	name = "carrot cake"
	desc = "A favorite desert of sophisticated rabbits."
	icon_state = "carrotcake"
	slice_path = /obj/item/chems/food/slice/carrotcake
	slices_num = 5
	filling_color = "#ffd675"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "carrot" = 15)
	nutriment_amt = 25
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/sliceable/carrotcake/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/eyedrops, 10)

/obj/item/chems/food/slice/carrotcake
	name = "carrot cake slice"
	desc = "Carrotty slice of carrot cake, carrots are good for your eyes! It's true! Probably!"
	icon_state = "carrotcake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#ffd675"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':14}"
	whole_path = /obj/item/chems/food/sliceable/carrotcake

/obj/item/chems/food/slice/carrotcake/filled
	filled = TRUE

/obj/item/chems/food/sliceable/braincake
	name = "brain cake"
	desc = "A squishy cake-thing."
	icon_state = "braincake"
	slice_path = /obj/item/chems/food/slice/braincake
	slices_num = 5
	filling_color = "#e6aedb"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "slime" = 15)
	nutriment_amt = 5
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/sliceable/braincake/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 25)
	reagents.add_reagent(/decl/material/liquid/neuroannealer, 10)

/obj/item/chems/food/slice/braincake
	name = "brain cake slice"
	desc = "Lemme tell you something about prions. THEY'RE DELICIOUS."
	icon_state = "braincakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#e6aedb"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':12}"
	whole_path = /obj/item/chems/food/sliceable/braincake

/obj/item/chems/food/slice/braincake/filled
	filled = TRUE

/obj/item/chems/food/sliceable/cheesecake
	name = "cheese cake"
	desc = "DANGEROUSLY cheesy."
	icon_state = "cheesecake"
	slice_path = /obj/item/chems/food/slice/cheesecake
	slices_num = 5
	filling_color = "#faf7af"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cake" = 10, "cream" = 10, "cheese" = 15)
	nutriment_amt = 10
	bitesize = 2

/obj/item/chems/food/sliceable/cheesecake/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 15)

/obj/item/chems/food/slice/cheesecake
	name = "cheese cake slice"
	desc = "Slice of pure cheestisfaction."
	icon_state = "cheesecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#faf7af"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':14}"
	whole_path = /obj/item/chems/food/sliceable/cheesecake

/obj/item/chems/food/slice/cheesecake/filled
	filled = TRUE

/obj/item/chems/food/sliceable/plaincake
	name = "vanilla cake"
	desc = "A plain cake, but a good cake."
	icon_state = "plaincake"
	slice_path = /obj/item/chems/food/slice/plaincake
	slices_num = 5
	filling_color = "#f7edd5"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "vanilla" = 15)
	nutriment_amt = 20
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/slice/plaincake
	name = "vanilla cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "plaincake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#f7edd5"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':14}"
	whole_path = /obj/item/chems/food/sliceable/plaincake

/obj/item/chems/food/slice/plaincake/filled
	filled = TRUE

/obj/item/chems/food/sliceable/orangecake
	name = "orange cake"
	desc = "A cake with added orange."
	icon_state = "orangecake"
	slice_path = /obj/item/chems/food/slice/orangecake
	slices_num = 5
	filling_color = "#fada8e"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "orange" = 15)
	nutriment_amt = 20
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/slice/orangecake
	name = "orange cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "orangecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#fada8e"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':14}"
	whole_path = /obj/item/chems/food/sliceable/orangecake

/obj/item/chems/food/slice/orangecake/filled
	filled = TRUE

/obj/item/chems/food/sliceable/limecake
	name = "lime cake"
	desc = "A cake with added lime."
	icon_state = "limecake"
	slice_path = /obj/item/chems/food/slice/limecake
	slices_num = 5
	filling_color = "#cbfa8e"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "lime" = 15)
	nutriment_amt = 20
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/slice/limecake
	name = "lime cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "limecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#cbfa8e"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':14}"
	whole_path = /obj/item/chems/food/sliceable/limecake

/obj/item/chems/food/slice/limecake/filled
	filled = TRUE

/obj/item/chems/food/sliceable/lemoncake
	name = "lemon cake"
	desc = "A cake with added lemon."
	icon_state = "lemoncake"
	slice_path = /obj/item/chems/food/slice/lemoncake
	slices_num = 5
	filling_color = "#fafa8e"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "lemon" = 15)
	nutriment_amt = 20
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/slice/lemoncake
	name = "lemon cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "lemoncake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#fafa8e"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':14}"
	whole_path = /obj/item/chems/food/sliceable/lemoncake

/obj/item/chems/food/slice/lemoncake/filled
	filled = TRUE

/obj/item/chems/food/sliceable/chocolatecake
	name = "chocolate cake"
	desc = "A cake with added chocolate."
	icon_state = "chocolatecake"
	slice_path = /obj/item/chems/food/slice/chocolatecake
	slices_num = 5
	filling_color = "#805930"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "chocolate" = 15)
	nutriment_amt = 20
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/slice/chocolatecake
	name = "chocolate cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "chocolatecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#805930"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':14}"
	whole_path = /obj/item/chems/food/sliceable/chocolatecake

/obj/item/chems/food/slice/chocolatecake/filled
	filled = TRUE

/obj/item/chems/food/sliceable/birthdaycake
	name = "birthday cake"
	desc = "Happy birthday!"
	icon_state = "birthdaycake"
	slice_path = /obj/item/chems/food/slice/birthdaycake
	slices_num = 5
	filling_color = "#ffd6d6"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cake" = 10, "sweetness" = 10)
	nutriment_amt = 20
	bitesize = 3
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/sliceable/birthdaycake/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 10)

/obj/item/chems/food/slice/birthdaycake
	name = "birthday cake slice"
	desc = "A slice of your birthday."
	icon_state = "birthdaycakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#ffd6d6"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':14}"
	whole_path = /obj/item/chems/food/sliceable/birthdaycake

/obj/item/chems/food/slice/birthdaycake/filled
	filled = TRUE

/obj/item/chems/food/sliceable/applecake
	name = "apple cake"
	desc = "A cake centred with apples."
	icon_state = "applecake"
	slice_path = /obj/item/chems/food/slice/applecake
	slices_num = 5
	filling_color = "#ebf5b8"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "apple" = 15)
	nutriment_amt = 15
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/slice/applecake
	name = "apple cake slice"
	desc = "A slice of heavenly cake."
	icon_state = "applecakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#ebf5b8"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':14}"
	whole_path = /obj/item/chems/food/sliceable/applecake

/obj/item/chems/food/slice/applecake/filled
	filled = TRUE

/obj/item/chems/food/sliceable/pumpkinpie
	name = "pumpkin pie"
	desc = "A delicious treat for the autumn months."
	icon_state = "pumpkinpie"
	slice_path = /obj/item/chems/food/slice/pumpkinpie
	slices_num = 5
	filling_color = "#f5b951"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("pie" = 5, "cream" = 5, "pumpkin" = 5)
	nutriment_amt = 15

/obj/item/chems/food/slice/pumpkinpie
	name = "pumpkin pie slice"
	desc = "A slice of pumpkin pie, with whipped cream on top. Perfection."
	icon_state = "pumpkinpieslice"
	trash = /obj/item/trash/plate
	filling_color = "#f5b951"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':12}"
	whole_path = /obj/item/chems/food/sliceable/pumpkinpie

/obj/item/chems/food/slice/pumpkinpie/filled
	filled = TRUE