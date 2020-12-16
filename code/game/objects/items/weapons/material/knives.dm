//knives for stabbing and slashing and so on and so forth
/obj/item/knife //master obj
	name = "knife"
	desc = "You call that a knife? This is a master item - berate the admin or mapper who spawned this"
	icon = 'icons/obj/items/weapon/knives/kitchen.dmi'
	icon_state = ICON_STATE_WORLD
	material_force_multiplier = 0.3
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	material = /decl/material/solid/metal/steel
	origin_tech = "{'materials':1}"
	unbreakable = TRUE
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	sharp = TRUE
	edge = TRUE
	item_flags = ITEM_FLAG_CAN_HIDE_IN_SHOES
	applies_material_name = TRUE
	applies_material_colour = TRUE
	var/draw_handle
	var/handle_color
	var/valid_handle_colors

/obj/item/knife/on_update_icon()
	..()
	if(draw_handle)
		cut_overlays()
		if(!handle_color && length(valid_handle_colors))
			handle_color = pick(valid_handle_colors)
		add_overlay(overlay_image(icon, "[get_world_inventory_state()]_handle", handle_color, flags=RESET_COLOR|RESET_ALPHA))
	if(blood_overlay)
		add_overlay(blood_overlay)

/obj/item/knife/attack(mob/living/carbon/M, mob/living/carbon/user, target_zone)
	if(!istype(M))
		return ..()

	if(user.a_intent != I_HELP)
		if(user.zone_sel.selecting == BP_EYES)
			if((MUTATION_CLUMSY in user.mutations) && prob(50))
				M = user
			return eyestab(M, user)

	return ..()

//table knives
/obj/item/knife/table
	name = "table knife"
	desc = "A simple table knife, used to cut up individual portions of food."
	icon = 'icons/obj/items/weapon/knives/table.dmi'
	material = /decl/material/solid/metal/aluminium
	material_force_multiplier = 0.1
	sharp = FALSE
	attack_verb = list("prodded")
	applies_material_name = FALSE
	w_class = ITEM_SIZE_SMALL

/obj/item/knife/table/plastic
	material = /decl/material/solid/plastic

/obj/item/knife/table/primitive
	name = "dueling knife"
	desc = "A length of leather-bound wood studded with razor-sharp teeth. How crude."
	icon = 'icons/obj/items/weapon/knives/savage.dmi'
	material = /decl/material/solid/wood
	applies_material_colour = FALSE
	w_class = ITEM_SIZE_NORMAL

/obj/item/knife/table/primitive/get_autopsy_descriptors()
	. = ..()
	. += "serrated"

//kitchen knives
/obj/item/knife/kitchen
	name = "kitchen knife"
	icon = 'icons/obj/items/weapon/knives/kitchen.dmi'
	desc = "A general purpose chef's knife made by SpaceCook Incorporated. Guaranteed to stay sharp for years to come."
	applies_material_name = FALSE
	draw_handle = TRUE

/obj/item/knife/kitchen/cleaver
	name = "butcher's cleaver"
	desc = "A heavy blade used to process food, especially animal carcasses."
	icon = 'icons/obj/items/weapon/knives/cleaver.dmi'
	armor_penetration = 5
	material_force_multiplier = 0.18
	attack_verb = list("cleaved", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/knife/kitchen/cleaver/bronze
	name = "master chef's cleaver"
	desc = "A heavy blade used to process food. This one is so fancy, it must be for a truly exceptional chef. There aren't any here, so what it's doing here is anyone's guess."
	material = /decl/material/solid/metal/bronze
	material_force_multiplier = 1 //25 with material bronze

//fighting knives
/obj/item/knife/combat
	name = "combat knife"
	desc = "A blade with a saw-like pattern on the reverse edge and a heavy handle."
	icon = 'icons/obj/items/weapon/knives/tactical.dmi'
	material_force_multiplier = 0.2
	w_class = ITEM_SIZE_SMALL
	max_force = 15
	draw_handle = TRUE

/obj/item/knife/combat/get_autopsy_descriptors()
	. = ..()
	. += "serrated"

/obj/item/knife/combat/glass
	material = /decl/material/solid/glass

/obj/item/knife/combat/titanium
	material = /decl/material/solid/metal/titanium

//random stuff
/obj/item/knife/hook
	name = "meat hook"
	desc = "A sharp, metal hook what sticks into things."
	icon = 'icons/obj/items/weapon/knives/hook.dmi'
	sharp = FALSE

/obj/item/knife/ritual
	name = "ritual knife"
	desc = "The unearthly energies that once powered this blade are now dormant."
	icon = 'icons/obj/items/weapon/knives/ritual.dmi'
	applies_material_colour = FALSE
	applies_material_name = FALSE

/obj/item/knife/ritual/get_autopsy_descriptors()
	. = ..()
	. += "curved"

//Utility knives
/obj/item/knife/utility
	name = "utility knife"
	desc = "An utility knife with a polymer handle, commonly used through human space."
	icon = 'icons/obj/items/weapon/knives/utility.dmi'
	max_force = 5
	material_force_multiplier = 0.2
	w_class = ITEM_SIZE_SMALL
	draw_handle = TRUE

/obj/item/knife/utility/lightweight
	name = "lightweight utility knife"
	desc = "A lightweight utility knife made out of a titanium alloy."
	material = /decl/material/solid/metal/titanium
	draw_handle = FALSE