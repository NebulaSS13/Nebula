/obj/item/food/sliceable/carrotcake
	name = "carrot cake"
	desc = "A favorite desert of sophisticated rabbits."
	icon = 'icons/obj/food/baked/cakes/carrot.dmi'
	slice_path = /obj/item/food/slice/carrotcake
	slice_num = 5
	filling_color = "#ffd675"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "carrot" = 15)
	nutriment_amt = 25
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/food/sliceable/carrotcake/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/eyedrops, 10)

/obj/item/food/slice/carrotcake
	name = "carrot cake slice"
	desc = "Carrotty slice of carrot cake, carrots are good for your eyes! It's true! Probably!"
	icon = 'icons/obj/food/baked/cakes/slices/carrot.dmi'
	plate = /obj/item/plate
	filling_color = "#ffd675"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":14}'
	whole_path = /obj/item/food/sliceable/carrotcake

/obj/item/food/slice/carrotcake/filled
	filled = TRUE

/obj/item/food/sliceable/braincake
	name = "brain cake"
	desc = "A squishy cake-thing."
	icon = 'icons/obj/food/baked/cakes/brain.dmi'
	slice_path = /obj/item/food/slice/braincake
	slice_num = 5
	filling_color = "#e6aedb"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "slime" = 15)
	nutriment_amt = 5
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/food/sliceable/braincake/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 25)
	add_to_reagents(/decl/material/liquid/neuroannealer,     10)

/obj/item/food/slice/braincake
	name = "brain cake slice"
	desc = "Lemme tell you something about prions. THEY'RE DELICIOUS."
	icon = 'icons/obj/food/baked/cakes/slices/brain.dmi'
	plate = /obj/item/plate
	filling_color = "#e6aedb"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":12}'
	whole_path = /obj/item/food/sliceable/braincake

/obj/item/food/slice/braincake/filled
	filled = TRUE

/obj/item/food/sliceable/cheesecake
	name = "cheese cake"
	desc = "DANGEROUSLY cheesy."
	icon = 'icons/obj/food/baked/cakes/cheese.dmi'
	slice_path = /obj/item/food/slice/cheesecake
	slice_num = 5
	filling_color = "#faf7af"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("cake" = 10, "cream" = 10, "cheese" = 15)
	nutriment_amt = 10
	bitesize = 2

/obj/item/food/sliceable/cheesecake/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/cheese, 15)

/obj/item/food/slice/cheesecake
	name = "cheese cake slice"
	desc = "Slice of pure cheestisfaction."
	icon = 'icons/obj/food/baked/cakes/slices/cheese.dmi'
	plate = /obj/item/plate
	filling_color = "#faf7af"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":14}'
	whole_path = /obj/item/food/sliceable/cheesecake

/obj/item/food/slice/cheesecake/filled
	filled = TRUE

/obj/item/food/sliceable/plaincake
	name = "vanilla cake"
	desc = "A plain cake, but a good cake."
	icon = 'icons/obj/food/baked/cakes/plain.dmi'
	slice_path = /obj/item/food/slice/plaincake
	slice_num = 5
	filling_color = "#f7edd5"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "vanilla" = 15)
	nutriment_amt = 20
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/food/slice/plaincake
	name = "vanilla cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon = 'icons/obj/food/baked/cakes/slices/plain.dmi'
	plate = /obj/item/plate
	filling_color = "#f7edd5"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":14}'
	whole_path = /obj/item/food/sliceable/plaincake

/obj/item/food/slice/plaincake/filled
	filled = TRUE

/obj/item/food/sliceable/orangecake
	name = "orange cake"
	desc = "A cake with added orange."
	icon = 'icons/obj/food/baked/cakes/orange.dmi'
	slice_path = /obj/item/food/slice/orangecake
	slice_num = 5
	filling_color = "#fada8e"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "oranges" = 15)
	nutriment_amt = 20
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/food/slice/orangecake
	name = "orange cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon = 'icons/obj/food/baked/cakes/slices/orange.dmi'
	plate = /obj/item/plate
	filling_color = "#fada8e"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":14}'
	whole_path = /obj/item/food/sliceable/orangecake

/obj/item/food/slice/orangecake/filled
	filled = TRUE

/obj/item/food/sliceable/limecake
	name = "lime cake"
	desc = "A cake with added lime."
	icon = 'icons/obj/food/baked/cakes/lime.dmi'
	slice_path = /obj/item/food/slice/limecake
	slice_num = 5
	filling_color = "#cbfa8e"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "lime" = 15)
	nutriment_amt = 20
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/food/slice/limecake
	name = "lime cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon = 'icons/obj/food/baked/cakes/slices/lime.dmi'
	plate = /obj/item/plate
	filling_color = "#cbfa8e"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":14}'
	whole_path = /obj/item/food/sliceable/limecake

/obj/item/food/slice/limecake/filled
	filled = TRUE

/obj/item/food/sliceable/lemoncake
	name = "lemon cake"
	desc = "A cake with added lemon."
	icon = 'icons/obj/food/baked/cakes/lemon.dmi'
	slice_path = /obj/item/food/slice/lemoncake
	slice_num = 5
	filling_color = "#fafa8e"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "lemon" = 15)
	nutriment_amt = 20
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/food/slice/lemoncake
	name = "lemon cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon = 'icons/obj/food/baked/cakes/slices/lemon.dmi'
	plate = /obj/item/plate
	filling_color = "#fafa8e"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":14}'
	whole_path = /obj/item/food/sliceable/lemoncake

/obj/item/food/slice/lemoncake/filled
	filled = TRUE

/obj/item/food/sliceable/chocolatecake
	name = "chocolate cake"
	desc = "A cake with added chocolate."
	icon = 'icons/obj/food/baked/cakes/chocolate.dmi'
	slice_path = /obj/item/food/slice/chocolatecake
	slice_num = 5
	filling_color = "#805930"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "chocolate" = 15)
	nutriment_amt = 20
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/food/slice/chocolatecake
	name = "chocolate cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon = 'icons/obj/food/baked/cakes/slices/chocolate.dmi'
	plate = /obj/item/plate
	filling_color = "#805930"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":14}'
	whole_path = /obj/item/food/sliceable/chocolatecake

/obj/item/food/slice/chocolatecake/filled
	filled = TRUE

/obj/item/food/sliceable/birthdaycake
	name = "birthday cake"
	desc = "Happy birthday!"
	icon = 'icons/obj/food/baked/cakes/birthday.dmi'
	slice_path = /obj/item/food/slice/birthdaycake
	slice_num = 5
	filling_color = "#ffd6d6"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("cake" = 10, "sweetness" = 10)
	nutriment_amt = 20
	bitesize = 3
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/food/sliceable/birthdaycake/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/sprinkles, 10)

/obj/item/food/slice/birthdaycake
	name = "birthday cake slice"
	desc = "A slice of your birthday."
	icon = 'icons/obj/food/baked/cakes/slices/birthday.dmi'
	plate = /obj/item/plate
	filling_color = "#ffd6d6"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":14}'
	whole_path = /obj/item/food/sliceable/birthdaycake

/obj/item/food/slice/birthdaycake/filled
	filled = TRUE

/obj/item/food/sliceable/applecake
	name = "apple cake"
	desc = "A cake centred with apples."
	icon = 'icons/obj/food/baked/cakes/apple.dmi'
	slice_path = /obj/item/food/slice/applecake
	slice_num = 5
	filling_color = "#ebf5b8"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "apple" = 15)
	nutriment_amt = 15
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/food/slice/applecake
	name = "apple cake slice"
	desc = "A slice of heavenly cake."
	icon = 'icons/obj/food/baked/cakes/slices/apple.dmi'
	plate = /obj/item/plate
	filling_color = "#ebf5b8"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":14}'
	whole_path = /obj/item/food/sliceable/applecake

/obj/item/food/slice/applecake/filled
	filled = TRUE

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
