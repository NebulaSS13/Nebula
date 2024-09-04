/obj/structure/decoration/gargoyle
	name     = "gargoyle"
	desc     = "A leering statue of a monstrous gargoyle."
	icon     = 'icons/obj/structures/decorations/gargoyle.dmi'
	material = /decl/material/solid/stone/basalt
	color    = /decl/material/solid/stone/basalt::color

/obj/structure/decoration/gargoyle/plinth
	icon     = 'icons/obj/structures/decorations/gargoyle_plinth.dmi'

/obj/structure/decoration/gargoyle/standing
	icon     = 'icons/obj/structures/decorations/gargoyle_standing.dmi'

/obj/structure/decoration/gargoyle/random/Initialize(ml, _mat, _reinf_mat)
	icon = pick(list(
		'icons/obj/structures/decorations/gargoyle.dmi',
		'icons/obj/structures/decorations/gargoyle_plinth.dmi',
		'icons/obj/structures/decorations/gargoyle_standing.dmi'
	))
	. = ..()
