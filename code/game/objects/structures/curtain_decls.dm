//
// Curtain types declaration
//
/decl/curtain_kind
	var/name = "curtain"
	var/color = COLOR_WHITE
	var/alpha = 255
	var/material_key = /decl/material/solid/organic/plastic

/decl/curtain_kind/proc/make_item(var/loc)
	var/obj/item/curtain/C = new(loc)
	C.set_curtain_kind(src)
	return C

/decl/curtain_kind/proc/make_structure(var/loc, var/dir, var/opened = FALSE)
	var/obj/structure/curtain/C = new(loc)
	C.set_curtain_kind(src)
	C.set_dir(dir)
	C.set_opacity(opened)
	return C

//Cloth curtains
/decl/curtain_kind/cloth
	material_key = /decl/material/solid/organic/cloth

/decl/curtain_kind/cloth/bed
	name = "bed curtain"
	color = "#854636"

/decl/curtain_kind/cloth/black
	name = "black curtain"
	color = "#222222"

/decl/curtain_kind/cloth/bar
	name = "bar curtain"
	color = "#854636"

//Plastic curtains
/decl/curtain_kind/plastic
	name = "plastic curtain"
	color = "#b8f5e3"
	material_key = /decl/material/solid/organic/plastic

/decl/curtain_kind/plastic/medical
	alpha = 200

/decl/curtain_kind/plastic/privacy
	name = "privacy curtain"

/decl/curtain_kind/plastic/shower
	name = "shower curtain"
	color = "#acd1e9"
	alpha = 200

/decl/curtain_kind/plastic/shower/engineering
	color = "#ffa500"

/decl/curtain_kind/plastic/shower/security
	color = COLOR_DARK_RED

/decl/curtain_kind/plastic/canteen
	name = "privacy curtain"
	color = COLOR_BLUE_GRAY
