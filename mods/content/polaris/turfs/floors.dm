/decl/flooring/wood/sif
	color              = /decl/material/solid/organic/wood/sif::color
	build_type         = /obj/item/stack/tile/wood/sif
	force_material     = /decl/material/solid/organic/wood/sif
	uid = "flooring_wood_sif"

/decl/flooring/wood/rough/sif
	color              = /decl/material/solid/organic/wood/sif::color
	build_type         = /obj/item/stack/tile/wood/rough/sif
	force_material     = /decl/material/solid/organic/wood/sif
	uid = "flooring_wood_rough_sif"

/decl/flooring/laminate/sif
	build_type         = /obj/item/stack/tile/wood/laminate/sif
	force_material     = /decl/material/solid/organic/wood/chipboard/sif
	uid                = "floor_wood_lami_sifwood"

/decl/flooring/grass/sif
	name = "growth"
	desc = "A layer of Sivian moss that has adapted to the sheer cold climate."
	color = "#447171"
	force_material = /decl/material/solid/organic/plantmatter/grass/sif
	uid = "flooring_grass_sif"

/decl/flooring/grass/wild/sif
	name = "thick growth"
	desc = "A thick, rough layer of Sivian moss that has adapted to the sheer cold climate."
	color = "#446471"
	uid = "flooring_grass_wild_sif"

/decl/flooring/tiling/steel_dirty
	build_type = /obj/item/stack/tile/floor_steel_dirty
	uid = "flooring_steel_tile_dirty"

/obj/item/stack/tile/floor_steel_dirty
	name = "dirty steel tile"
	singular_name = "dirty steel tile"
	icon_state = "tile"
	material = /decl/material/solid/metal/steel
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/turf/floor/wood/sif
	_flooring = /decl/flooring/wood/sif
	color = /decl/material/solid/organic/wood/sif::color

/turf/floor/wood/broken/sif
	_flooring = /decl/flooring/wood/sif
	color = /decl/material/solid/organic/wood/sif::color

/turf/floor/tiled/steel_dirty
	_flooring = /decl/flooring/tiling/steel_dirty

/turf/floor/grass/sif
	name = "growth"
	color = "#447171"
	_flooring = /decl/flooring/grass/sif

/turf/floor/grass/wild/sif
	name = "thick growth"
	color = "#446471"
	_flooring = /decl/flooring/grass/wild/sif
