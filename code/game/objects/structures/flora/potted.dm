////////////////////////////////////////
// Base Flora
////////////////////////////////////////
/obj/structure/flora
	desc                   = "A form of vegetation."
	anchored               = TRUE
	density                = FALSE                                  //Plants usually have no collisions
	w_class                = ITEM_SIZE_NORMAL                       //Size determines material yield
	material               = /decl/material/solid/plantmatter       //Generic plantstuff
	tool_interaction_flags = 0 
	hitsound               = 'sound/effects/hit_bush.ogg'
	var/tmp/snd_cut        = 'sound/effects/plants/brush_leaves.ogg' //Sound to play when cutting the plant down
	var/remains_type       = /obj/effect/decal/cleanable/plant_bits //What does the plant leaves behind in addition to the materials its made out of. (part_type is like this, but it drops instead of materials)

/obj/structure/flora/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	init_appearance()

/**Picks and sets the appearance exactly once for the plant if randomly picked. */
/obj/structure/flora/proc/init_appearance()
	return

/obj/structure/flora/attackby(obj/item/O, mob/user)
	if(can_cut_down(O, user))
		return cut_down(O, user)
	. = ..()

/**Whether the item used by user can cause cut_down to be called. Used to bypass default attack proc for some specific items/tools. */
/obj/structure/flora/proc/can_cut_down(var/obj/item/I, var/mob/user)
	return (I.force >= 5) && I.sharp //Anything sharp and relatively strong can cut us instantly

/**What to do when the can_cut_down check returns true. Normally simply calls dismantle. */
/obj/structure/flora/proc/cut_down(var/obj/item/I, var/mob/user)
	if(snd_cut)
		playsound(src, snd_cut, 40, TRUE)
	dismantle()
	return TRUE

//Drop some bits when destroyed
/obj/structure/flora/physically_destroyed(skip_qdel)
	if(!..(TRUE)) //Tell parents we'll delete ourselves
		return
	var/turf/T = get_turf(src)
	if(T)
		. = !isnull(create_remains())
		if(snd_cut)
			playsound(src, snd_cut, 60, TRUE)
	//qdel only after we do our thing, since we have to access members
	if(!skip_qdel)
		qdel(src)

/**Returns an instance of the object the plant leaves behind when destroyed. Null means it leaves nothing. */
/obj/structure/flora/proc/create_remains()
	return new remains_type(get_turf(src), material, reinf_material)

////////////////////////////////////////
// Trees
////////////////////////////////////////
/obj/structure/flora/tree
	name         = "tree"
	density      = TRUE
	pixel_x      = -16
	layer        = ABOVE_HUMAN_LAYER
	material     = /decl/material/solid/wood
	w_class      = ITEM_SIZE_STRUCTURE
	hitsound     = 'sound/effects/hit_wood.ogg'
	snd_cut      = 'sound/effects/plants/tree_fall.ogg'
	var/protects_against_weather = TRUE
	var/stump_type //What kind of tree stump we're leaving behind

/obj/structure/flora/tree/get_material_health_modifier()
	return 2.5 //Prefer removing via tools than bashing

/obj/structure/flora/tree/can_cut_down(obj/item/I, mob/user)
	return IS_HATCHET(I) //Axes can bypass having to damage the tree to break it

/obj/structure/flora/tree/cut_down(obj/item/I, mob/user)
	if(I.do_tool_interaction(TOOL_HATCHET, user, src, 5 SECONDS))
		. = ..()

/obj/structure/flora/tree/dismantle()
	var/turf/T = get_turf(src)
	if(T)
		var/obj/structure/flora/stump/stump = new stump_type(T, material, reinf_material)
		if(istype(stump))
			stump.icon_state = icon_state //A bit dirty maybe, but its probably not worth writing a whole system for this when we have 3 kinds of trees..
	. = ..()

/obj/structure/flora/tree/pine
	name         = "pine tree"
	desc         = "A pine tree."
	icon         = 'icons/obj/flora/pinetrees.dmi'
	icon_state   = "pine_1"
	stump_type   = /obj/structure/flora/stump/tree/pine

/obj/structure/flora/tree/pine/init_appearance()
	icon_state = "pine_[rand(1, 3)]"
	
/obj/structure/flora/tree/pine/xmas
	name         = "\improper Christmas tree"
	desc         = "O Christmas tree, O Christmas tree..."
	icon         = 'icons/obj/flora/pinetrees.dmi'
	icon_state   = "pine_c"
	stump_type   = /obj/structure/flora/stump/tree/pine/xmas

/obj/structure/flora/tree/pine/xmas/init_appearance()
	return //Only one possible icon

/obj/structure/flora/tree/dead
	name                     = "dead tree"
	desc                     = "A dead looking tree."
	icon                     = 'icons/obj/flora/deadtrees.dmi'
	icon_state               = "tree_1"
	protects_against_weather = FALSE
	stump_type               = /obj/structure/flora/stump/tree/dead

/obj/structure/flora/tree/dead/init_appearance()
	icon_state = "tree_[rand(1, 6)]"

////////////////////////////////////////
// Stumps
////////////////////////////////////////
/obj/structure/flora/stump
	name = "stump"

/obj/structure/flora/stump/get_material_health_modifier()
	return 2.5 //Make stumps worth removing with shovels instead of bashing them

/obj/structure/flora/stump/can_cut_down(obj/item/I, mob/user)
	return IS_SHOVEL(I)

/obj/structure/flora/stump/cut_down(obj/item/I, mob/user)
	if(I.do_tool_interaction(TOOL_SHOVEL, user, src, 8 SECONDS))
		. = ..()

//Base tree stump
/obj/structure/flora/stump/tree
	name       = "tree stump"
	icon       = 'icons/obj/flora/tree_stumps.dmi'
	w_class    = ITEM_SIZE_HUGE
	pixel_x    = -16 //All trees are offset 16 pixels
	material   = /decl/material/solid/wood

//dead trees
/obj/structure/flora/stump/tree/dead
	name       = "dead tree stump"
	icon_state = "tree_1"

/obj/structure/flora/stump/tree/dead/init_appearance()
	icon_state = "tree_[rand(1, 6)]"

//pine trees
/obj/structure/flora/stump/tree/pine
	icon_state = "pine_1"

/obj/structure/flora/stump/tree/pine/init_appearance()
	icon_state = "pine_[rand(1, 3)]"

//christmas tree
/obj/structure/flora/stump/tree/pine/xmas
	icon_state = "pine_c"

////////////////////////////////////////
// Grass
////////////////////////////////////////
/obj/structure/flora/grass
	name    = "grass"
	icon    = 'icons/obj/flora/snowflora.dmi'

/obj/structure/flora/grass/get_material_health_modifier()
	return 0.03

/obj/structure/flora/grass/brown
	icon_state = "snowgrass1bb"

/obj/structure/flora/grass/brown/init_appearance()
	icon_state = "snowgrass[rand(1, 3)]bb"

/obj/structure/flora/grass/green
	icon_state = "snowgrass1gb"

/obj/structure/flora/grass/green/init_appearance()
	icon_state = "snowgrass[rand(1, 3)]gb"

/obj/structure/flora/grass/both
	icon_state = "snowgrassall1"

/obj/structure/flora/grass/both/init_appearance()
	icon_state = "snowgrassall[rand(1, 3)]"

////////////////////////////////////////
// bushes
////////////////////////////////////////
/obj/structure/flora/bush
	name       = "bush"
	icon       = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"
	w_class    = ITEM_SIZE_HUGE

/obj/structure/flora/bush/get_material_health_modifier()
	return 0.5

/obj/structure/flora/bush/init_appearance()
	icon_state = "firstbush_[rand(1, 4)]"

/obj/structure/flora/bush/snow
	icon       = 'icons/obj/flora/snowflora.dmi'
	icon_state = "snowbush1"

/obj/structure/flora/bush/snow/init_appearance()
	icon_state = "snowbush[rand(1, 6)]"

/obj/structure/flora/bush/reedbush
	icon_state = "reedbush_1"

/obj/structure/flora/bush/reedbush/init_appearance()
	icon_state = "reedbush_[rand(1, 4)]"

/obj/structure/flora/bush/leafybush
	icon_state = "leafybush_1"

/obj/structure/flora/bush/leafybush/init_appearance()
	icon_state = "leafybush_[rand(1, 3)]"

/obj/structure/flora/bush/palebush
	icon_state = "palebush_1"

/obj/structure/flora/bush/palebush/init_appearance()
	icon_state = "palebush_[rand(1, 4)]"

/obj/structure/flora/bush/stalkybush
	icon_state = "stalkybush_1"

/obj/structure/flora/bush/stalkybush/init_appearance()
	icon_state = "stalkybush_[rand(1, 3)]"

/obj/structure/flora/bush/grassybush
	icon_state = "grassybush_1"

/obj/structure/flora/bush/grassybush/init_appearance()
	icon_state = "grassybush_[rand(1, 4)]"

/obj/structure/flora/bush/fernybush
	icon_state = "fernybush_1"

/obj/structure/flora/bush/fernybush/init_appearance()
	icon_state = "fernybush_[rand(1, 3)]"

/obj/structure/flora/bush/sunnybush
	icon_state = "sunnybush_1"

/obj/structure/flora/bush/sunnybush/init_appearance()
	icon_state = "sunnybush_[rand(1, 3)]"

/obj/structure/flora/bush/genericbush
	icon_state = "genericbush_1"

/obj/structure/flora/bush/genericbush/init_appearance()
	icon_state = "genericbush_[rand(1, 4)]"

/obj/structure/flora/bush/pointybush
	icon_state = "pointybush_1"

/obj/structure/flora/bush/pointybush/init_appearance()
	icon_state = "pointybush_[rand(1, 4)]"

/obj/structure/flora/bush/lavendergrass
	icon_state = "lavendergrass_1"

/obj/structure/flora/bush/lavendergrass/init_appearance()
	icon_state = "lavendergrass_[rand(1, 4)]"

/obj/structure/flora/bush/ywflowers
	icon_state = "ywflowers_1"

/obj/structure/flora/bush/ywflowers/init_appearance()
	icon_state = "ywflowers_[rand(1, 3)]"

/obj/structure/flora/bush/brflowers
	icon_state = "brflowers_1"

/obj/structure/flora/bush/brflowers/init_appearance()
	icon_state = "brflowers_[rand(1, 3)]"

/obj/structure/flora/bush/ppflowers
	icon_state = "ppflowers_1"

/obj/structure/flora/bush/ppflowers/init_appearance()
	icon_state = "ppflowers_[rand(1, 4)]"

/obj/structure/flora/bush/sparsegrass
	icon_state = "sparsegrass_1"

/obj/structure/flora/bush/sparsegrass/init_appearance()
	icon_state = "sparsegrass_[rand(1, 3)]"

/obj/structure/flora/bush/fullgrass
	icon_state = "fullgrass_1"

/obj/structure/flora/bush/fullgrass/init_appearance()
	icon_state = "fullgrass_[rand(1, 3)]"

////////////////////////////////////////
// Potted Plants
////////////////////////////////////////
/obj/structure/flora/pottedplant
	name         = "potted plant"
	desc         = "Really brings the room together."
	icon         = 'icons/obj/structures/potted_plants.dmi'
	icon_state   = "plant-01"
	anchored     = FALSE
	layer        = ABOVE_HUMAN_LAYER
	w_class      = ITEM_SIZE_LARGE
	remains_type = /obj/effect/decal/cleanable/dirt
	hitsound     = 'sound/effects/glass_crack2.ogg'
	snd_cut      = 'sound/effects/break_ceramic.ogg'
	material     = /decl/material/solid/stone/ceramic
	matter       = list(
		/decl/material/solid/clay        = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/sand        = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/plantmatter = MATTER_AMOUNT_SECONDARY,     //#TODO: Maybe eventually drop the plant, or some seeds or something?
	)

/obj/structure/flora/pottedplant/get_material_health_modifier()
	return 0.80

//potted plants credit: Flashkirby
//potted plants 27-30: Cajoes
/obj/structure/flora/pottedplant/fern
	name = "potted fern"
	desc = "This is an ordinary looking fern. It looks like it could do with some water."
	icon_state = "plant-02"

/obj/structure/flora/pottedplant/overgrown
	name = "overgrown potted plants"
	desc = "This is an assortment of colourful plants. Some parts are overgrown."
	icon_state = "plant-03"

/obj/structure/flora/pottedplant/bamboo
	name = "potted bamboo"
	desc = "These are bamboo shoots. The tops looks like they've been cut short."
	icon_state = "plant-04"

/obj/structure/flora/pottedplant/largebush
	name = "large potted bush"
	desc = "This is a large bush. The leaves stick upwards in an odd fashion."
	icon_state = "plant-05"

/obj/structure/flora/pottedplant/thinbush
	name = "thin potted bush"
	desc = "This is a thin bush. It appears to be flowering."
	icon_state = "plant-06"

/obj/structure/flora/pottedplant/mysterious
	name = "mysterious potted bulbs"
	desc = "This is a mysterious looking plant. Touching the bulbs cause them to shrink."
	icon_state = "plant-07"

/obj/structure/flora/pottedplant/smalltree
	name = "small potted tree"
	desc = "This is a small tree. It is rather pleasant."
	icon_state = "plant-08"

/obj/structure/flora/pottedplant/unusual
	name = "unusual potted plant"
	desc = "This is an unusual plant. It's bulbous ends emit a soft blue light."
	icon_state = "plant-09"

/obj/structure/flora/pottedplant/unusual/Initialize()
	. = ..()
	set_light(l_range = 2, l_power = 2, l_color = "#007fff")

/obj/structure/flora/pottedplant/orientaltree
	name = "potted oriental tree"
	desc = "This is a rather oriental style tree. It's flowers are bright pink."
	icon_state = "plant-10"

/obj/structure/flora/pottedplant/smallcactus
	name = "small potted cactus"
	desc = "This is a small cactus. Its needles are sharp."
	icon_state = "plant-11"

/obj/structure/flora/pottedplant/tall
	name = "tall potted plant"
	desc = "This is a tall plant. Tiny pores line its surface."
	icon_state = "plant-12"

/obj/structure/flora/pottedplant/sticky
	name = "sticky potted plant"
	desc = "This is an odd plant. Its sticky leaves trap insects."
	icon_state = "plant-13"

/obj/structure/flora/pottedplant/smelly
	name = "smelly potted plant"
	desc = "This is some kind of tropical plant. It reeks of rotten eggs."
	icon_state = "plant-14"

/obj/structure/flora/pottedplant/small
	name = "small potted plant"
	desc = "This is a pot of assorted small flora. Some look familiar."
	icon_state = "plant-15"

/obj/structure/flora/pottedplant/aquatic
	name = "aquatic potted plant"
	desc = "This is apparently an aquatic plant. It's probably fake."
	icon_state = "plant-16"

/obj/structure/flora/pottedplant/shoot
	name = "small potted shoot"
	desc = "This is a small shoot. It still needs time to grow."
	icon_state = "plant-17"

/obj/structure/flora/pottedplant/flower
	name = "potted flower"
	desc = "This is a slim plant. Sweet smelling flowers are supported by spindly stems."
	icon_state = "plant-18"

/obj/structure/flora/pottedplant/crystal
	name = "crystalline potted plant"
	desc = "These are rather cubic plants. Odd crystal formations grow on the end."
	icon_state = "plant-19"

/obj/structure/flora/pottedplant/subterranean
	name = "subterranean potted plant"
	desc = "This is a subterranean plant. It's bulbous ends glow faintly."
	icon_state = "plant-20"

/obj/structure/flora/pottedplant/subterranean/Initialize()
	. = ..()
	set_light(l_range = 1, l_power = 0.5, l_color = "#ff6633")

/obj/structure/flora/pottedplant/minitree
	name = "potted tree"
	desc = "This is a miniature tree. Apparently it was grown to 1/5 scale."
	icon_state = "plant-21"

/obj/structure/flora/pottedplant/stoutbush
	name = "stout potted bush"
	desc = "This is a stout bush. Its leaves point up and outwards."
	icon_state = "plant-22"

/obj/structure/flora/pottedplant/drooping
	name = "drooping potted plant"
	desc = "This is a small plant. The drooping leaves make it look like its wilted."
	icon_state = "plant-23"

/obj/structure/flora/pottedplant/tropical
	name = "tropical potted plant"
	desc = "This is some kind of tropical plant. It hasn't begun to flower yet."
	icon_state = "plant-24"

/obj/structure/flora/pottedplant/dead
	name = "dead potted plant"
	desc = "This is the dried up remains of a dead plant. Someone should replace it."
	icon_state = "plant-25"

/obj/structure/flora/pottedplant/large
	name = "large potted plant"
	desc = "This is a large plant. Three branches support pairs of waxy leaves."
	icon_state = "plant-26"

/obj/structure/flora/pottedplant/decorative
	name = "decorative potted plant"
	desc = "This is a decorative shrub. It's been trimmed into the shape of an apple."
	icon_state = "applebush"

/obj/structure/flora/pottedplant/deskfern
	name = "fancy ferny potted plant"
	desc = "This leafy desk fern could do with a trim."
	icon_state = "plant-27"

/obj/structure/flora/pottedplant/floorleaf
	name = "fancy leafy floor plant"
	desc = "This plant has remarkably waxy leaves."
	icon_state = "plant-28"

/obj/structure/flora/pottedplant/deskleaf
	name = "fancy leafy potted desk plant"
	desc = "A tiny waxy leafed plant specimen."
	icon_state = "plant-29"

/obj/structure/flora/pottedplant/deskferntrim
	name = "fancy trimmed ferny potted plant"
	desc = "This leafy desk fern seems to have been trimmed too much."
	icon_state = "plant-30"

////////////////////////////////////////
// Floral Remains
////////////////////////////////////////
/obj/effect/decal/cleanable/plant_bits
	name            = "plant remains"
	icon            = 'icons/effects/decals/plant_remains.dmi'
	icon_state      = "leafy_bits"
	cleanable_scent = "freshly cut plants"