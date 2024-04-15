/decl/butchery_data/animal/bird
	abstract_type = /decl/butchery_data/animal/bird
	skin_material = /decl/material/solid/organic/skin/feathers
	meat_type     = /obj/item/chems/food/butchery/meat/chicken/game
	gut_type      = /obj/item/chems/food/butchery/offal/small

/decl/butchery_data/animal/bird/goose
	meat_amount   = 6
	bone_amount   = 8
	skin_amount   = 8

/decl/butchery_data/animal/bird/goose/dire/harvest_meat(mob/donor)
	. = ..()
	var/quill = new /obj/item/pen/fancy/quill(get_turf(donor))
	LAZYADD(., quill)

/decl/butchery_data/animal/bird/parrot
	meat_amount   = 3

/decl/butchery_data/animal/bird/parrot/space
	meat_amount   = 10
	bone_amount   = 20
	skin_amount   = 20
	stomach_type  = /obj/item/chems/food/butchery/stomach
	gut_type      = /obj/item/chems/food/butchery/offal

/decl/butchery_data/animal/bird/parrot/space/purple
	skin_material = /decl/material/solid/organic/skin/feathers/purple

/decl/butchery_data/animal/bird/parrot/space/blue
	skin_material = /decl/material/solid/organic/skin/feathers/blue

/decl/butchery_data/animal/bird/parrot/space/green
	skin_material = /decl/material/solid/organic/skin/feathers/green

/decl/butchery_data/animal/bird/parrot/space/brown
	skin_material = /decl/material/solid/organic/skin/feathers/brown

/decl/butchery_data/animal/bird/parrot/space/red
	skin_material = /decl/material/solid/organic/skin/feathers/red

/decl/butchery_data/animal/bird/parrot/space/black
	skin_material = /decl/material/solid/organic/skin/feathers/black
