// Bushes.
/obj/structure/flora/sif
	icon = 'mods/content/polaris/icons/structures/flora/flora_sif.dmi'

/obj/structure/flora/sif/eyes
	name = "eyebulbs"
	desc = "This is a mysterious-looking plant. They kind of look like eyeballs. Creepy."
	icon_state = "eyeplant1"

/obj/structure/flora/sif/eyes/init_appearance()
	icon_state = "eyeplant[rand(0,2)]"

/obj/structure/flora/sif/tendrils
	name = "wabback tendrils"
	desc = "A 'plant' made up of hardened moss. It has tiny hairs that bunch together to look like snow."
	icon_state = "grass1"

/obj/structure/flora/sif/tendrils/init_appearance()
	icon_state = "grass[rand(0,2)]"

/obj/structure/flora/sif/frostbelle
	name = "frostbelle shrub"
	desc = "A stocky plant with fins bearing luminescent veins along its branches."
	icon_state = "frostbelle1"

/obj/structure/flora/sif/frostbelle/init_appearance()
	icon_state = "frostbelle[rand(0,2)]"

/obj/structure/flora/sif/subterranean
	name = "subterranean bulbs"
	desc = "This is a subterranean plant. It's bulbous ends glow faintly."
	icon_state = "glowplant1"

/obj/structure/flora/sif/subterranean/init_appearance()
	icon_state = "glowplant[rand(0,2)]"

/obj/structure/flora/sif/subterranean/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	set_light(2, 1, "#ff6633")

// Trees.
/obj/structure/flora/tree/sif
	name = "glowing tree"
	desc = "It's a tree, except this one seems quite alien. It glows a deep blue."
	icon = 'mods/content/polaris/icons/structures/flora/tree_sif.dmi'
	icon_state = "pine_1"
	stump_type = /obj/structure/flora/stump/tree/sif
	light_offset_x = 1 // "equivalent to a pixel offset of 1, which due to how the logic works will mean no lighting offset"

/obj/structure/flora/tree/sif/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	set_light(3-rand(0,3), 1, "#33ccff")

/obj/structure/flora/stump/tree/sif
	icon = 'mods/content/polaris/icons/structures/flora/tree_sif.dmi'
	icon_state = "tree_sif_stump"

/obj/structure/flora/tree/sif/init_appearance()
	icon_state = "tree_sif[rand(0, 6)]"
	update_icon()

/obj/structure/flora/tree/sif/on_update_icon()
	. = ..()
	set_overlays(emissive_overlay(icon, "[icon_state]_glow"))

// Other flora.
/obj/structure/flora/mushroom
	name = "mushroom"
	desc = "Hey, this one seems like a fun guy."
	icon = 'mods/content/polaris/icons/structures/flora/mushrooms.dmi'
	icon_state = "mush1"

/obj/structure/flora/mushroom/init_appearance()
	. = ..()
	icon_state = "mush[rand(1,4)]"
	if(prob(50))
		set_scale(-1, 1)
	default_pixel_x += rand(-4, 4)
	reset_offsets()
