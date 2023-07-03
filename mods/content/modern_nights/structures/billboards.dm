//BILLBOARDS

var/global/list/billboard_ads = list(
	"ssl",
	"ntbuilding",
	"keeptidy",
	"smoke",
	"tunguska",
	"rent",
	"vets",
	"army",
	"fitness",
	"movie1",
	"movie2",
	"blank",
	"gentrified",
	"legalcoke",
	"pollux",
	"vacay",
	"atluscity",
	"sunstar",
	"speedweed",
	"golf",
	"visit_texas"
)

var/global/list/billboard_types_weighted = list(
	"billboard" = 100,
	"billboard1" = 25,
	"billboard2" = 25,
	"billboard3" = 25,
	"billboard4" = 25
)

/obj/structure/billboard
	name = "billboard ad"
	desc = "Goodness, what are they selling us this time?"
	icon = 'mods/content/modern_nights/icons/obj/billboards.dmi'
	icon_state = "billboard"
	var/force_state // if set, override the automatic/random icon state
	light_range = 4
	light_power = 2
	light_color = "#ebf7fe"  //white blue
	density = TRUE
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER
	pixel_y = 10

	var/current_ad

/obj/structure/billboard/Destroy()
	set_light(0)
	return ..()

/obj/structure/billboard/Initialize()
	. = ..()
	if (force_state)
		icon_state = force_state
	else
		icon_state = pickweight(global.billboard_types_weighted)

	update_icon()

/obj/structure/billboard/on_update_icon()
	. = ..()

	if(!current_ad)
		current_ad = pick(global.billboard_ads)
	add_overlay(current_ad)

/obj/structure/billboard/city
	name = "city billboard"
	desc = "A billboard"
	icon_state = "billboard"
	light_range = 4
	light_power = 5
	light_color = "#bbfcb6"  //watered lime
	current_ad = "welcome"

/obj/structure/billboard/sign/lisa
	icon_state = "billboard"
	current_ad = "lisa"