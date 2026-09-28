// Bushes.
/obj/structure/flora/plant/sif
	icon = 'mods/content/polaris/icons/structures/flora/flora_sif.dmi'
	use_seed_appearance = FALSE
	generate_plant_description = FALSE
	abstract_type = /obj/structure/flora/plant/sif
	color = COLOR_WHITE

/obj/structure/flora/plant/sif/Initialize(ml, _mat, _reinf_mat, datum/seed/_plant)
	. = ..()
	if(plant)
		growth_stage = plant.growth_stages
	if(!harvestable)
		harvestable = rand(1,3)
		update_icon()

/obj/structure/flora/plant/sif/eyes
	name = "eyebulbs"
	desc = "This is a mysterious-looking plant. They kind of look like eyeballs. Creepy."
	icon_state = "eyeplant1"
	plant = /datum/seed/grapes/eyebulbs::name

/obj/structure/flora/plant/sif/eyes/init_appearance()
	icon_state = "eyeplant[rand(0,2)]"

/obj/structure/flora/plant/sif/wabback
	name = "wabback tendrils"
	desc = "A 'plant' made up of hardened moss. It has tiny hairs that bunch together to look like snow."
	icon_state = "grass1"
	plant = /datum/seed/wabback/wild::name

/obj/structure/flora/plant/sif/wabback/init_appearance()
	icon_state = "grass[rand(0,2)]"

/obj/structure/flora/plant/sif/wabback/Initialize(ml, _mat, _reinf_mat, datum/seed/_plant)
	if(prob(5))
		plant = /datum/seed/wabback/white::name
	else if(prob(1))
		plant = /datum/seed/wabback/black::name
	return ..()

/obj/structure/flora/plant/sif/frostbelle
	name = "frostbelle shrub"
	desc = "A stocky plant with fins bearing luminescent veins along its branches."
	icon_state = "frostbelle1"
	use_seed_appearance = FALSE
	plant = /datum/seed/flower/frostbelle::name

/obj/structure/flora/plant/sif/frostbelle/init_appearance()
	icon_state = "frostbelle[rand(0,2)]"

/obj/structure/flora/plant/sif/subterranean
	name = "subterranean bulbs"
	desc = "This is a subterranean plant. It's bulbous ends glow faintly."
	icon_state = "glowplant1"
	plant = /datum/seed/cavebulbs::name

/obj/structure/flora/plant/sif/subterranean/init_appearance()
	icon_state = "glowplant[rand(0,2)]"

/obj/structure/flora/plant/sif/subterranean/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	set_light(2, 1, "#ff6633")

// Trees.
/obj/structure/flora/tree/sif
	name = "glowing tree"
	desc = "It's a tree, except this one seems quite alien. It glows a deep blue."
	icon = 'mods/content/polaris/icons/structures/flora/tree_sif.dmi'
	icon_state = "tree_sif0"
	material = /decl/material/solid/organic/wood/sif
	stump_type = /obj/structure/flora/stump/tree/sif
	light_offset_x = 1 // "equivalent to a pixel offset of 1, which due to how the logic works will mean no lighting offset"
	var/fruits

/obj/structure/flora/tree/sif/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	set_light(3-rand(0,3), 1, "#33ccff")
	fruits = rand(1, 3)

/obj/structure/flora/tree/sif/init_appearance()
	icon_state = "tree_sif[rand(0, 5)]"
	update_icon()

/obj/structure/flora/tree/sif/on_update_icon()
	. = ..()
	if(fruits > 0)
		set_overlays(emissive_overlay(icon, "[icon_state]_glow"))

/obj/structure/flora/tree/sif/attack_hand(mob/user)
	if(!user.check_intent(I_FLAG_HARM) && fruits)
		var/datum/seed/sifpod = SSplants.seeds[/datum/seed/sifpod::name]
		if(istype(sifpod))
			sifpod.harvest(user, force_amount = 1)
			fruits--
			if(fruits <= 0)
				update_icon()
			return TRUE
	. = ..()

/obj/structure/flora/stump/tree/sif
	icon = 'mods/content/polaris/icons/structures/flora/tree_sif.dmi'
	material = /decl/material/solid/organic/wood/sif
	icon_state = "tree_sif_stump"
