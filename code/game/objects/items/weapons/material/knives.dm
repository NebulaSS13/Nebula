//knives for stabbing and slashing and so on and so forth
/obj/item/material/knife //master obj
	name = "knife"
	desc = "You call that a knife? This is a master item - berate the admin or mapper who spawned this"
	icon = 'icons/obj/items/weapon/knives/kitchen.dmi'
	on_mob_icon = 'icons/obj/items/weapon/knives/kitchen.dmi'
	icon_state = "world"
	material_force_multiplier = 0.3
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	material = MAT_STEEL
	origin_tech = "{'materials':1}"
	unbreakable = TRUE
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	sharp = TRUE
	edge = TRUE
	item_flags = ITEM_FLAG_CAN_HIDE_IN_SHOES
	var/draw_handle
	var/handle_color
	var/valid_handle_colors

/obj/item/material/knife/on_update_icon()
	..()
	if(draw_handle)
		cut_overlays()
		if(!handle_color && length(valid_handle_colors))
			handle_color = pick(valid_handle_colors)
		add_overlay(overlay_image(icon, "[get_world_inventory_state()]_handle", handle_color, flags=RESET_COLOR|RESET_ALPHA))
	if(blood_overlay)
		add_overlay(blood_overlay)

/obj/item/material/knife/attack(mob/living/carbon/M, mob/living/carbon/user, target_zone)
	if(!istype(M))
		return ..()

	if(user.a_intent != I_HELP)
		if(user.zone_sel.selecting == BP_EYES)
			if((MUTATION_CLUMSY in user.mutations) && prob(50))
				M = user
			return eyestab(M, user)

	return ..()

//table knives
/obj/item/material/knife/table
	name = "table knife"
	desc = "A simple table knife, used to cut up individual portions of food."
	on_mob_icon = 'icons/obj/items/weapon/knives/table.dmi'
	material = MAT_ALUMINIUM
	material_force_multiplier = 0.1
	sharp = FALSE
	attack_verb = list("prodded")
	applies_material_name = FALSE
	w_class = ITEM_SIZE_SMALL

/obj/item/material/knife/table/plastic
	material = MAT_PLASTIC

/obj/item/material/knife/table/primitive
	name = "dueling knife"
	desc = "A length of leather-bound wood studded with razor-sharp teeth. How crude."
	on_mob_icon = 'icons/obj/items/weapon/knives/savage.dmi'
	material = MAT_WOOD
	applies_material_colour = FALSE
	w_class = ITEM_SIZE_NORMAL

/obj/item/material/knife/table/primitive/get_autopsy_descriptors()
	. = ..()
	. += "serrated"

//kitchen knives
/obj/item/material/knife/kitchen
	name = "kitchen knife"
	on_mob_icon = 'icons/obj/items/weapon/knives/kitchen.dmi'
	desc = "A general purpose chef's knife made by SpaceCook Incorporated. Guaranteed to stay sharp for years to come."
	applies_material_name = FALSE
	draw_handle = TRUE

/obj/item/material/knife/kitchen/cleaver
	name = "butcher's cleaver"
	desc = "A heavy blade used to process food, especially animal carcasses."
	on_mob_icon = 'icons/obj/items/weapon/knives/cleaver.dmi'
	armor_penetration = 5
	material_force_multiplier = 0.18
	attack_verb = list("cleaved", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/material/knife/kitchen/cleaver/bronze
	name = "master chef's cleaver"
	desc = "A heavy blade used to process food. This one is so fancy, it must be for a truly exceptional chef. There aren't any here, so what it's doing here is anyone's guess."
	material = MAT_BRONZE
	material_force_multiplier = 1 //25 with material bronze

//fighting knives
/obj/item/material/knife/combat
	name = "combat knife"
	desc = "A blade with a saw-like pattern on the reverse edge and a heavy handle."
	on_mob_icon = 'icons/obj/items/weapon/knives/tactical.dmi'
	material_force_multiplier = 0.2
	w_class = ITEM_SIZE_SMALL
	max_force = 15
	draw_handle = TRUE

/obj/item/material/knife/combat/get_autopsy_descriptors()
	. = ..()
	. += "serrated"

/obj/item/material/knife/combat/glass
	material = MAT_GLASS

/obj/item/material/knife/combat/titanium
	material = MAT_TITANIUM

//random stuff
/obj/item/material/knife/hook
	name = "meat hook"
	desc = "A sharp, metal hook what sticks into things."
	on_mob_icon = 'icons/obj/items/weapon/knives/hook.dmi'
	sharp = FALSE

/obj/item/material/knife/ritual
	name = "ritual knife"
	desc = "The unearthly energies that once powered this blade are now dormant."
	on_mob_icon = 'icons/obj/items/weapon/knives/ritual.dmi'
	applies_material_colour = FALSE
	applies_material_name = FALSE

/obj/item/material/knife/ritual/get_autopsy_descriptors()
	. = ..()
	. += "curved"

//Utility knives
/obj/item/material/knife/utility
	name = "utility knife"
	desc = "An utility knife with a polymer handle, commonly used through human space."
	on_mob_icon = 'icons/obj/items/weapon/knives/utility.dmi'
	max_force = 5
	material_force_multiplier = 0.2
	w_class = ITEM_SIZE_SMALL
	draw_handle = TRUE

/obj/item/material/knife/utility/lightweight
	name = "lightweight utility knife"
	desc = "A lightweight utility knife made out of a titanium alloy."
	material = MAT_TITANIUM
	draw_handle = FALSE