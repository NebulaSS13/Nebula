/obj/random/material
	name = "random material"
	desc = "This is a random material."
	icon = /obj/item/stack/material/sheet::icon
	icon_state = /obj/item/stack/material/sheet::icon_state

/obj/random/material/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/stack/material/sheet/mapped/steel/ten,
		/obj/item/stack/material/pane/mapped/glass/ten,
		/obj/item/stack/material/pane/mapped/rglass/ten,
		/obj/item/stack/material/panel/mapped/plastic/ten,
		/obj/item/stack/material/plank/mapped/wood/ten,
		/obj/item/stack/material/cardstock/mapped/cardboard/ten,
		/obj/item/stack/material/sheet/reinforced/mapped/plasteel/ten,
		/obj/item/stack/material/sheet/mapped/steel/fifty,
		/obj/item/stack/material/sheet/reinforced/mapped/fiberglass/fifty,
		/obj/item/stack/material/ingot/mapped/copper/fifty,
		/obj/item/stack/material/pane/mapped/glass/fifty,
		/obj/item/stack/material/pane/mapped/rglass/fifty,
		/obj/item/stack/material/panel/mapped/plastic/fifty,
		/obj/item/stack/material/plank/mapped/wood/fifty,
		/obj/item/stack/material/cardstock/mapped/cardboard/fifty,
		/obj/item/stack/material/sheet/reinforced/mapped/plasteel/fifty,
		/obj/item/stack/material/rods/mapped/steel/ten,
		/obj/item/stack/material/rods/mapped/steel/fifty
	)
	return spawnable_choices

/obj/random/material/refined
	name = "random refined material"
	desc = "This is a random refined metal."
	icon = /obj/item/stack/material/rods::icon
	icon_state = /obj/item/stack/material/rods::icon_state

/obj/random/material/refined/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/stack/material/sheet/mapped/steel/ten,
		/obj/item/stack/material/pane/mapped/glass/ten,
		/obj/item/stack/material/pane/mapped/rglass/five,
		/obj/item/stack/material/pane/mapped/borosilicate/five,
		/obj/item/stack/material/pane/mapped/rborosilicate/five,
		/obj/item/stack/material/sheet/reinforced/mapped/plasteel/five,
		/obj/item/stack/material/ingot/mapped/gold/five,
		/obj/item/stack/material/ingot/mapped/iron/ten,
		/obj/item/stack/material/ingot/mapped/copper/ten,
		/obj/item/stack/material/sheet/shiny/mapped/aluminium/ten,
		/obj/item/stack/material/ingot/mapped/lead/ten,
		/obj/item/stack/material/gemstone/mapped/diamond/three,
		/obj/item/stack/material/aerogel/mapped/deuterium/five,
		/obj/item/stack/material/puck/mapped/uranium/five,
		/obj/item/stack/material/ingot/mapped/silver/five,
		/obj/item/stack/material/ingot/mapped/platinum/five,
		/obj/item/stack/material/segment/mapped/mhydrogen/three,
		/obj/item/stack/material/ingot/mapped/osmium/three,
		/obj/item/stack/material/sheet/reinforced/mapped/titanium/five,
		/obj/item/stack/material/aerogel/mapped/tritium/three,
		/obj/item/stack/material/brick/mapped/concrete/ten
	)

/obj/random/material/precious
	name = "random precious metal"
	desc = "This is a small stack of a random precious metal."
	icon = /obj/item/stack/material/ingot::icon
	icon_state = /obj/item/stack/material/ingot::icon_state

/obj/random/material/precious/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/stack/material/ingot/mapped/gold/five,
		/obj/item/stack/material/ingot/mapped/copper/five,
		/obj/item/stack/material/ingot/mapped/silver/five,
		/obj/item/stack/material/ingot/mapped/platinum/five,
		/obj/item/stack/material/ingot/mapped/osmium/five
	)
	return spawnable_choices

/obj/random/boulder
	name = "random rock outcrop"
	desc = "This is a random rock outcrop."
	icon = /obj/structure/boulder::icon
	icon_state = /obj/structure/boulder::icon_state

/obj/random/boulder/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/structure/boulder          = 100,
		/obj/structure/boulder/iron     = 100,
		/obj/structure/boulder/coal     = 100,
		/obj/structure/boulder/silver   = 65,
		/obj/structure/boulder/gold     = 50,
		/obj/structure/boulder/uranium  = 30,
		/obj/structure/boulder/platinum = 15,
		/obj/structure/boulder/lead     = 15,
		/obj/structure/boulder/diamond  = 7
	)
	return spawnable_choices
