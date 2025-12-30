/obj/structure/chair/rustic
	name_prefix = "rustic"
	desc = "A simple, rustic-looking chair. Looks like it'd hurt to sit on for too long..."
	icon = 'icons/obj/structures/furniture/chair_rustic.dmi'
	material = /decl/material/solid/organic/wood/walnut
	color = /decl/material/solid/organic/wood/walnut::color
	user_comfort = -0.5
	buckle_pixel_shift = TRUE // use chair offset

/obj/structure/chair/rustic_fancy
	name_prefix = "fancy"
	desc = "An ornate, detailed chair made from wood. It has armrests!"
	icon = 'icons/obj/structures/furniture/chair_rustic_fancy.dmi'
	material = /decl/material/solid/organic/wood/oak
	color = COLOR_WHITE // preview state is precolored
	initial_padding_material = /decl/material/solid/organic/cloth
	initial_padding_color = COLOR_CHERRY_RED
	user_comfort = 1.25

/obj/structure/chair/rustic_fancy/ebony
	material = /decl/material/solid/organic/wood/ebony
