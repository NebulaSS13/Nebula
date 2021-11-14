/decl/persistence_handler/paper/sticky
	name = "stickynotes"
	paper_type = /obj/item/paper/sticky

/decl/persistence_handler/paper/sticky/CreateEntryInstance(var/turf/creating, var/list/tokens)
	var/atom/paper = ..()
	if(paper)
		paper.default_pixel_x = tokens["offset_x"]
		paper.default_pixel_y = tokens["offset_y"]
		paper.reset_offsets(0)
		paper.color =   tokens["color"]
	return paper

/decl/persistence_handler/paper/sticky/CompileEntry(var/atom/entry)
	. = ..()
	var/obj/item/paper/sticky/paper = entry
	.["offset_x"] = paper.pixel_x
	.["offset_y"] = paper.pixel_y
	.["color"] = paper.color
