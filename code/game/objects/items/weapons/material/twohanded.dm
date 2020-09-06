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
/obj/item/twohanded
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

/obj/item/twohanded/get_max_weapon_value()
	return force_wielded

/obj/item/twohanded/update_twohanding()
	var/mob/living/M = loc
	if(istype(M) && M.can_wield_item(src) && is_held_twohanded(M))
		wielded = 1
		force = force_wielded
	else
		wielded = 0
		force = force_unwielded
	update_icon()
	..()

/obj/item/twohanded/update_force()
	..()
	base_name = name
	force_unwielded = round(force*unwielded_material_force_multiplier)
	force_wielded = force
	force = force_unwielded


/obj/item/twohanded/Initialize()
	. = ..()
	update_icon()

/obj/item/twohanded/get_parry_chance(mob/user)
	. = ..()
	if(wielded)
		. += wielded_parry_bonus

/obj/item/twohanded/on_update_icon()
	..()
	icon_state = "[base_icon][wielded]"
	LAZYSET(item_state_slots, BP_L_HAND, icon_state)
	LAZYSET(item_state_slots, BP_R_HAND, icon_state)
	LAZYSET(item_state_slots, BP_SHOULDERS, base_icon)

/*
 * Fireaxe
 */
/obj/item/twohanded/fireaxe  // DEM AXES MAN, marker -Agouri
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
	material = /decl/material/solid/metal/steel
	applies_material_colour = FALSE
	applies_material_name = TRUE

/obj/item/twohanded/fireaxe/afterattack(atom/A, mob/user, proximity)
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

/obj/item/twohanded/fireaxe/ishatchet()
	return TRUE

//spears, bay edition
/obj/item/twohanded/spear
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	icon_state = "preview"
	icon = 'icons/obj/items/weapon/spear.dmi'
	material_force_multiplier = 0.33 // 12/19 with hardness 60 (steel) or 10/16 with hardness 50 (glass)
	unwielded_material_force_multiplier = 0.20
	thrown_material_force_multiplier = 0.6 // 20 when thrown with weight 15 (glass)
	throw_speed = 3
	edge = 0
	sharp = 1
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	material = /decl/material/solid/glass
	applies_material_colour = TRUE
	applies_material_name = TRUE
	does_spin = FALSE
	var/shaft_material = /decl/material/solid/metal/steel
	var/cable_color = COLOR_RED

/obj/item/twohanded/spear/shatter(var/consumed)
	if(!consumed)
		new /obj/item/stack/material/rods(get_turf(src), 1, shaft_material)
		new /obj/item/stack/cable_coil(get_turf(src), 3, cable_color)
	..()

/obj/item/twohanded/spear/on_update_icon()
	overlays.Cut()
	if(applies_material_colour && material)
		color = material.color
		alpha = 100 + material.opacity * 255
	overlays += get_shaft_overlay("shaft")
	overlays += get_mutable_overlay(icon, "cable", cable_color)

/obj/item/twohanded/spear/experimental_mob_overlay(mob/user_mob, slot, bodypart)
	var/image/ret = ..()
	if(wielded && check_state_in_icon("[ret.icon_state]_wielded", icon))
		ret.icon_state = "[ret.icon_state]_wielded"
	ret.overlays += get_shaft_overlay("[ret.icon_state]_shaft")
	ret.overlays += get_mutable_overlay(icon, "[ret.icon_state]_cable", cable_color)
	return ret

/obj/item/twohanded/spear/proc/get_shaft_overlay(var/base_state)
	var/decl/material/M = decls_repository.get_decl(shaft_material)
	var/mutable_appearance/shaft = get_mutable_overlay(icon, base_state, M.color)
	shaft.alpha = 155 + 100 * M.opacity
	return shaft

/obj/item/twohanded/spear/diamond
	material = /decl/material/solid/gemstone/diamond
	shaft_material = /decl/material/solid/metal/gold
	cable_color = COLOR_PURPLE

/obj/item/twohanded/spear/steel
	material = /decl/material/solid/metal/steel
	shaft_material = /decl/material/solid/wood
	cable_color = COLOR_GREEN

/obj/item/twohanded/spear/supermatter
	material = /decl/material/solid/exotic_matter
	shaft_material = /decl/material/solid/wood/ebony
	cable_color = COLOR_INDIGO

/obj/item/twohanded/baseballbat
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
	material = /decl/material/solid/wood/maple
	applies_material_colour = TRUE
	applies_material_name = TRUE
	max_force = 40	//for wielded
	material_force_multiplier = 0.4           // 24 when wielded with weight 60 (steel)
	unwielded_material_force_multiplier = 0.25 // 15 when unwielded based on above.
	melee_accuracy_bonus = -10

//Predefined materials go here.
/obj/item/twohanded/baseballbat/aluminium
	material = /decl/material/solid/metal/aluminium

/obj/item/twohanded/baseballbat/uranium
	material = /decl/material/solid/metal/uranium

/obj/item/twohanded/baseballbat/gold
	material = /decl/material/solid/metal/gold

/obj/item/twohanded/baseballbat/platinum
	material = /decl/material/solid/metal/platinum

/obj/item/twohanded/baseballbat/diamond
	material = /decl/material/solid/gemstone/diamond
