MANTIDIFY(/obj/item/storage/bag/trash/purple,   "sample collection carrier", "material storage")
MANTIDIFY(/obj/item/pickaxe/diamonddrill,       "lithobliterator",           "drilling")
MANTIDIFY(/obj/item/tank/jetpack/carbondioxide, "maneuvering pack",          "propulsion")

/obj/item/light/tube/ascent
	name = "mantid light filament"
	color = COLOR_CYAN
	b_color = COLOR_CYAN
	desc = "Some kind of strange alien lightbulb technology."

/obj/item/multitool/mantid
	name = "mantid multitool"
	desc = "An alien microcomputer of some kind."
	icon = 'mods/species/ascent/icons/ascent.dmi'
	icon_state = "multitool"

/obj/item/weldingtool/electric/mantid
	name = "mantid welding tool"
	desc = "An oddly shaped alien welding tool."
	icon = 'mods/species/ascent/icons/ascent.dmi'

/obj/item/mop/advanced/ascent
	name = "deck detritus delaminator"
	desc = "An alien staff with spongy filaments on one end."
	icon = 'mods/species/ascent/icons/ascent_doodads.dmi'
	item_state = "advmop"

/obj/item/chems/glass/bucket/ascent
	name = "portable liquid cleaning agent carrier"
	desc = "An alien container of some sort."
	icon = 'mods/species/ascent/icons/ascent_doodads.dmi'

/obj/item/knife/kitchen/cleaver/ascent
	name = "xenobiological flenser"
	desc = "A mindboggingly alien tool for flensing flesh."
	icon = 'mods/species/ascent/icons/ascent_doodads.dmi'
	icon_state = "xenobutch"


/obj/item/chems/drinks/cans/waterbottle/ascent
	name = "hydration cylinder"
	desc = "An alien portable long term storage device for potable water."
	icon = 'mods/species/ascent/icons/ascent_doodads.dmi'

/obj/item/chems/food/hydration
	name = "hydration ration"
	desc = "Approximately ten units of liquid hydration in a edible membrane. Unflavored."
	icon = 'mods/species/ascent/icons/ascent_doodads.dmi'
	icon_state = "h2o_ration"
	bitesize = 10

/obj/item/chems/food/hydration/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/water, 10)

/obj/item/storage/box/water/ascent
	name = "box of hydration cylinders"
	desc = "A box full of bottled water."
	icon = 'mods/species/ascent/icons/ascent_doodads.dmi'
	icon_state = "box"
	startswith = list(/obj/item/chems/drinks/cans/waterbottle/ascent = 7)
