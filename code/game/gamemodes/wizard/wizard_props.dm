/obj/structure/talisman_altar
	name = "Altar"
	desc = "A bloodstained altar dedicated to the worship of some unknown dark entity."
	icon = 'icons/obj/cult.dmi'
	icon_state = "talismanaltar"
	density = TRUE
	anchored = TRUE

/obj/structure/fake_pylon
	name = "\improper Pylon"
	desc = "A floating crystal that hums with an unearthly energy."
	icon = 'icons/obj/structures/pylon.dmi'
	icon_state = "pylon"
	light_power = 0.5
	light_range = 13
	light_color = "#3e0000"

// A de-culted version of the cult gateway, for the wizard base map.
/obj/effect/gateway/active/spooky
	light_range=5
	light_color="#ff0000"