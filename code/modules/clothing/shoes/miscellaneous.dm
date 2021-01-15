/obj/item/clothing/shoes/syndigaloshes
	name = "brown shoes"
	desc = "A pair of brown shoes. They seem to have extra grip."
	icon = 'icons/clothing/feet/colored_shoes.dmi'
	markings_icon = "_coloring"
	markings_color = WOOD_COLOR_CHOCOLATE
	permeability_coefficient = 0.05
	item_flags = ITEM_FLAG_NOSLIP
	origin_tech = "{'esoteric':3}"
	var/list/clothing_choices = list()
	siemens_coefficient = 0.8
	bodytype_restricted = null
	matter = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/clothing/shoes/jackboots/swat
	name = "\improper SWAT boots"
	desc = "When you want to turn up the heat."
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH, 
		bullet = ARMOR_BALLISTIC_RIFLE, 
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_SMALL, 
		bomb = ARMOR_BOMB_RESISTANT, 
		bio = ARMOR_BIO_MINOR
		)
	item_flags = ITEM_FLAG_NOSLIP
	siemens_coefficient = 0.6

/obj/item/clothing/shoes/jackboots/swat/combat //Basically SWAT shoes combined with galoshes.
	name = "combat boots"
	desc = "When you REALLY want to turn up the heat."
	applies_material_colour = FALSE
	color = "#694e30"
	force = 5

/obj/item/clothing/shoes/jackboots/jungleboots
	name = "jungle boots"
	desc = "A pair of durable brown boots. Waterproofed for use planetside."
	applies_material_colour = FALSE
	color = "#694e30"
	artificail_shine = 0

/obj/item/clothing/shoes/jackboots/desertboots
	name = "desert boots"
	desc = "A pair of durable tan boots. Designed for use in hot climates."
	applies_material_colour = FALSE
	color = "#9c8c6a"
	artificail_shine = 0

/obj/item/clothing/shoes/jackboots/duty
	name = "duty boots"
	desc = "A pair of steel-toed synthleather boots with a mirror shine."
	artificail_shine = 40

/obj/item/clothing/shoes/jackboots/tactical
	name = "tactical boots"
	desc = "Tan boots with extra padding and armor."
	applies_material_colour = FALSE
	color = "#9c8c6a"
	artificail_shine = 0

/obj/item/clothing/shoes/dress
	name = "dress shoes"
	desc = "The height of fashion, and they're pre-polished!"
	icon = 'icons/clothing/feet/laceups.dmi'
	can_add_hidden_item = FALSE
	can_add_cuffs = FALSE
	color = "#1c1c1c"
	shine = 60
	var/inset_color = "#b3885e"

/obj/item/clothing/shoes/dress/on_update_icon()
	. = ..()
	if(check_state_in_icon("[icon_state]_inset", icon))
		overlays += overlay_image(icon, "[icon_state]_inset", inset_color, RESET_COLOR)

/obj/item/clothing/shoes/dress/white
	name = "white dress shoes"
	desc = "Brilliantly white shoes, not a spot on them."
	color = COLOR_WHITE
	shine = 0  //already shiny

/obj/item/clothing/shoes/sandal
	name = "sandals"
	desc = "A pair of rather plain wooden sandals."
	icon = 'icons/clothing/feet/sandals.dmi'
	bodytype_restricted = null
	body_parts_covered = 0
	wizard_garb = 1
	can_add_hidden_item = FALSE
	can_add_cuffs = FALSE

/obj/item/clothing/shoes/sandal/marisa
	name = "magic shoes"
	desc = "A pair of magic, black shoes."
	icon = 'icons/clothing/feet/generic_shoes.dmi'
	color = COLOR_GRAY40
	body_parts_covered = SLOT_FEET

/obj/item/clothing/shoes/clown_shoes
	desc = "The prankster's standard-issue clowning shoes. Damn they're huge!"
	name = "clown shoes"
	icon = 'icons/clothing/feet/clown.dmi'
	force = 0
	bodytype_restricted = null
	can_add_hidden_item = FALSE
	var/footstep = 1	//used for squeeks whilst walking

/obj/item/clothing/shoes/clown_shoes/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_shoes_str, 1)

/obj/item/clothing/shoes/clown_shoes/handle_movement(var/turf/walking, var/running)
	if(running)
		if(footstep >= 2)
			footstep = 0
			playsound(src, "clownstep", 50, 1) // this will get annoying very fast.
		else
			footstep++
	else
		playsound(src, "clownstep", 20, 1)

/obj/item/clothing/shoes/cult
	name = "boots"
	desc = "A pair of boots worn by the followers of Nar-Sie."
	icon = 'icons/clothing/feet/cult.dmi'
	force = 2
	siemens_coefficient = 0.7

	cold_protection = SLOT_FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = SLOT_FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	bodytype_restricted = null

/obj/item/clothing/shoes/slippers
	name = "bunny slippers"
	desc = "Fluffy!"
	icon = 'icons/clothing/feet/bunny_slippers.dmi'
	force = 0
	bodytype_restricted = null
	w_class = ITEM_SIZE_SMALL
	can_add_hidden_item = FALSE
	can_add_cuffs = FALSE

/obj/item/clothing/shoes/swimmingfins
	name = "swimming fins"
	desc = "Help you swim good."
	icon = 'icons/clothing/feet/flippers.dmi'
	item_flags = ITEM_FLAG_NOSLIP
	bodytype_restricted = null
	can_add_hidden_item = FALSE
	can_add_cuffs = FALSE

/obj/item/clothing/shoes/swimmingfins/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_shoes_str, 1)

/obj/item/clothing/shoes/athletic
	name = "athletic shoes"
	desc = "A pair of sleek atheletic shoes. Made by and for the sporty types."
	icon = 'icons/clothing/feet/sports.dmi'

/obj/item/clothing/shoes/dress/sneakies
	desc = "The height of fashion, and they're pre-polished. Upon further inspection, the soles appear to be on backwards. They look uncomfortable."
	move_trail = /obj/effect/decal/cleanable/blood/tracks/footprints/reversed
	item_flags = ITEM_FLAG_SILENT

/obj/item/clothing/shoes/heels
	name = "high heels"
	desc = "A pair of colourable high heels."
	icon = 'icons/clothing/feet/high_heels.dmi'
	can_add_cuffs = FALSE

/obj/item/clothing/shoes/heels/black
	name = "black high heels"
	desc = "A pair of black high heels."
	color = COLOR_GRAY15

obj/item/clothing/shoes/heels/red
	name = "red high heels"
	desc = "A pair of red high heels."
	color = COLOR_RED

/obj/item/clothing/shoes/rainbow
	name = "rainbow shoes"
	desc = "Very fabulous shoes."
	icon = 'icons/clothing/feet/rainbow.dmi'

/obj/item/clothing/shoes/flats
	name = "flats"
	desc = "Sleek flats."
	icon = 'icons/clothing/feet/flats.dmi'

/obj/item/clothing/shoes/flats/black
	name = "black flats"
	color = COLOR_GRAY15