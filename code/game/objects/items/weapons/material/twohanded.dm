/* Two-handed Weapons
 * Contains:
 * 		Twohanded
 *		Fireaxe
 *		Double-Bladed Energy Swords
 */

/*##################################################################
##################### TWO HANDED WEAPONS BE HERE~ -Agouri :3 ########
####################################################################*/

//Rewrote TwoHanded weapons stuff and put it all here. Just copypasta fireaxe to make new ones ~Carn
//This rewrite means we don't have two variables for EVERY item which are used only by a few weapons.
//It also tidies stuff up elsewhere.

/*
 * Twohanded
 */
/obj/item/material/twohanded
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	var/wielded = 0
	var/force_wielded = 0
	var/force_unwielded
	var/wieldsound = null
	var/unwieldsound = null
	var/base_icon
	var/base_name
	var/unwielded_material_force_multiplier = 0.25
	var/wielded_parry_bonus = 15

/obj/item/material/twohanded/get_max_weapon_value()
	return force_wielded

/obj/item/material/twohanded/update_twohanding()
	var/mob/living/M = loc
	if(istype(M) && M.can_wield_item(src) && is_held_twohanded(M))
		wielded = 1
		force = force_wielded
	else
		wielded = 0
		force = force_unwielded
	update_icon()
	..()

/obj/item/material/twohanded/update_force()
	..()
	base_name = name
	force_unwielded = round(force*unwielded_material_force_multiplier)
	force_wielded = force
	force = force_unwielded


/obj/item/material/twohanded/Initialize()
	. = ..()
	update_icon()

/obj/item/material/twohanded/get_parry_chance(mob/user)
	. = ..()
	if(wielded)
		. += wielded_parry_bonus

/obj/item/material/twohanded/on_update_icon()
	..()
	icon_state = "[base_icon][wielded]"
	item_state_slots[slot_l_hand_str] = icon_state
	item_state_slots[slot_r_hand_str] = icon_state
	item_state_slots[slot_back_str] = base_icon

/*
 * Fireaxe
 */
/obj/item/material/twohanded/fireaxe  // DEM AXES MAN, marker -Agouri
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"
	icon = 'icons/obj/items/tool/fireaxe.dmi'
	icon_state = "fireaxe0"
	base_icon = "fireaxe"

	max_force = 60	//for wielded
	material_force_multiplier = 0.6
	unwielded_material_force_multiplier = 0.3
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	applies_material_colour = 0

/obj/item/material/twohanded/fireaxe/afterattack(atom/A, mob/user, proximity)
	if(!proximity) return
	..()
	if(A && wielded)
		if(istype(A,/obj/structure/window))
			var/obj/structure/window/W = A
			W.shatter()
		else if(istype(A,/obj/structure/grille))
			qdel(A)
		else if(istype(A,/obj/effect/vine))
			var/obj/effect/vine/P = A
			P.die_off()

/obj/item/material/twohanded/fireaxe/ishatchet()
	return TRUE

//spears, bay edition
/obj/item/material/twohanded/spear
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	on_mob_icon = 'icons/obj/items/weapon/spear.dmi'
	icon_state = "preview"
	icon = 'icons/obj/items/weapon/spear.dmi'
	material_force_multiplier = 0.33 // 12/19 with hardness 60 (steel) or 10/16 with hardness 50 (glass)
	unwielded_material_force_multiplier = 0.20
	thrown_material_force_multiplier = 0.6 // 20 when thrown with weight 15 (glass)
	throw_speed = 3
	edge = 0
	sharp = 1
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	material = MAT_GLASS
	does_spin = FALSE
	var/shaft_material = MAT_STEEL
	var/cable_color = COLOR_RED

/obj/item/material/twohanded/spear/shatter(var/consumed)
	if(!consumed)
		new /obj/item/stack/material/rods(get_turf(src), 1, shaft_material)
		new /obj/item/stack/cable_coil(get_turf(src), 3, cable_color)
	..()

/obj/item/material/twohanded/spear/on_update_icon()
	overlays.Cut()
	if(applies_material_colour && material)
		color = material.icon_colour
		alpha = 100 + material.opacity * 255
	overlays += get_shaft_overlay("shaft")
	overlays += get_cable_overlay("cable")

/obj/item/material/twohanded/spear/experimental_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	if(wielded)
		ret.icon_state += "_wielded"
	ret.overlays += get_shaft_overlay("[ret.icon_state]_shaft")
	ret.overlays += get_cable_overlay("[ret.icon_state]_cable")
	return ret

/obj/item/material/twohanded/spear/proc/get_shaft_overlay(var/base_state)
	var/mutable_appearance/shaft = new()
	shaft.icon = icon
	shaft.icon_state = base_state
	var/material/M = SSmaterials.get_material_datum(shaft_material)
	shaft.color = M.icon_colour
	shaft.alpha = 155 + 100 * M.opacity
	shaft.appearance_flags = RESET_COLOR | RESET_ALPHA
	shaft.plane = FLOAT_PLANE
	return shaft

/obj/item/material/twohanded/spear/proc/get_cable_overlay(var/base_state)
	var/mutable_appearance/cable = new()
	cable.icon = icon
	cable.icon_state = base_state
	cable.color = cable_color
	cable.appearance_flags = RESET_COLOR | RESET_ALPHA
	cable.plane = FLOAT_PLANE
	return cable

/obj/item/material/twohanded/spear/diamond
	material = MAT_DIAMOND
	shaft_material = MAT_GOLD
	cable_color = COLOR_PURPLE

/obj/item/material/twohanded/spear/steel
	material = MAT_STEEL
	shaft_material = MAT_WOOD
	cable_color = COLOR_GREEN

/obj/item/material/twohanded/spear/supermatter
	material = MAT_SUPERMATTER
	shaft_material = MAT_EBONY
	cable_color = COLOR_INDIGO

/obj/item/material/twohanded/baseballbat
	name = "bat"
	desc = "HOME RUN!"
	icon = 'icons/obj/items/weapon/bat.dmi'
	icon_state = "metalbat0"
	base_icon = "metalbat"
	item_state = "metalbat"
	w_class = ITEM_SIZE_LARGE
	throwforce = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	hitsound = 'sound/weapons/genhit3.ogg'
	material = MAT_MAPLE
	max_force = 40	//for wielded
	material_force_multiplier = 0.4           // 24 when wielded with weight 60 (steel)
	unwielded_material_force_multiplier = 0.25 // 15 when unwielded based on above.
	melee_accuracy_bonus = -10

//Predefined materials go here.
/obj/item/material/twohanded/baseballbat/aluminium/Initialize(mapload)
	. = ..(mapload, MAT_ALUMINIUM)

/obj/item/material/twohanded/baseballbat/uranium/Initialize(mapload)
	. = ..(mapload, MAT_URANIUM)

/obj/item/material/twohanded/baseballbat/gold/Initialize(mapload)
	. = ..(mapload, MAT_GOLD)

/obj/item/material/twohanded/baseballbat/platinum/Initialize(mapload)
	. = ..(mapload, MAT_PLATINUM)

/obj/item/material/twohanded/baseballbat/diamond/Initialize(mapload)
	. = ..(mapload, MAT_DIAMOND)
