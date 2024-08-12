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
	item_flags = ITEM_FLAG_IS_WEAPON
	slot_flags = SLOT_BACK
	icon_state = ICON_STATE_WORLD
	pickup_sound = 'sound/foley/scrape1.ogg'
	drop_sound = 'sound/foley/tooldrop1.ogg'
	abstract_type = /obj/item/twohanded

	var/wielded = 0
	var/force_wielded = 0
	var/force_unwielded
	var/wieldsound = 'sound/foley/scrape1.ogg'
	var/unwieldsound = 'sound/foley/tooldrop1.ogg'
	var/base_name
	var/unwielded_material_force_multiplier = 0.25
	var/wielded_parry_bonus = 15

/obj/item/twohanded/get_max_weapon_value()
	return force_wielded

/obj/item/twohanded/update_twohanding()
	var/mob/living/M = loc
	if(istype(M) && M.can_wield_item(src) && is_held_twohanded(M))
		wielded = TRUE
		if(wieldsound)
			playsound(src, wieldsound, 50)
		force = force_wielded
	else
		wielded = FALSE
		if(unwieldsound)
			playsound(src, unwieldsound, 50)
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

/obj/item/twohanded/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && wielded && (slot in list(BP_L_HAND, BP_R_HAND)))
		overlay.icon_state = "[overlay.icon_state]-wielded"
	. = ..()

/*
 * Fireaxe
 */
/obj/item/twohanded/fireaxe
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"
	icon = 'icons/obj/items/tool/fireaxe.dmi'
	max_force = 60	//for wielded
	material_force_multiplier = 0.6
	unwielded_material_force_multiplier = 0.3
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	material = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_NAME

/obj/item/twohanded/fireaxe/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_HATCHET = TOOL_QUALITY_DEFAULT))

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

//spears, bay edition
/obj/item/twohanded/spear
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	icon = 'icons/obj/items/weapon/spear.dmi'
	material_force_multiplier = 0.33 // 12/19 with hardness 60 (steel) or 10/16 with hardness 50 (glass)
	unwielded_material_force_multiplier = 0.20
	thrown_material_force_multiplier = 0.6 // 20 when thrown with weight 15 (glass)
	throw_speed = 3
	edge = 0
	sharp = 1
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	material = /decl/material/solid/glass
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	does_spin = FALSE
	var/shaft_material = /decl/material/solid/metal/steel
	var/cable_color = COLOR_RED

/obj/item/twohanded/spear/shatter(var/consumed)
	if(!consumed)
		SSmaterials.create_object(shaft_material, get_turf(src), 1, /obj/item/stack/material/rods)
		new /obj/item/stack/cable_coil(get_turf(src), 3, cable_color)
	..()

/obj/item/twohanded/spear/on_update_icon()
	. = ..()
	add_overlay(list(
			get_shaft_overlay("shaft"),
			mutable_appearance(icon, "cable", cable_color)
		))


/obj/item/twohanded/spear/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay)
		if(check_state_in_icon("[overlay.icon_state]-shaft", overlay.icon))
			overlay.overlays += get_shaft_overlay("[overlay.icon_state]-shaft")
		if(check_state_in_icon("[overlay.icon_state]-cable", overlay.icon))
			overlay.overlays += mutable_appearance(icon, "[overlay.icon_state]-cable", cable_color)
	. = ..()

/obj/item/twohanded/spear/proc/get_shaft_overlay(var/base_state)
	var/decl/material/M = GET_DECL(shaft_material)
	var/mutable_appearance/shaft = mutable_appearance(icon, base_state, M.color)
	shaft.alpha = 155 + 100 * M.opacity
	return shaft

/obj/item/twohanded/spear/diamond
	material = /decl/material/solid/gemstone/diamond
	shaft_material = /decl/material/solid/metal/gold
	cable_color = COLOR_PURPLE

/obj/item/twohanded/spear/steel
	material = /decl/material/solid/metal/steel
	shaft_material = /decl/material/solid/organic/wood
	cable_color = COLOR_GREEN

/obj/item/twohanded/spear/supermatter
	material = /decl/material/solid/exotic_matter
	shaft_material = /decl/material/solid/organic/wood/ebony
	cable_color = COLOR_INDIGO

/obj/item/twohanded/baseballbat
	name = "bat"
	desc = "HOME RUN!"
	icon = 'icons/obj/items/weapon/bat.dmi'
	w_class = ITEM_SIZE_LARGE
	throwforce = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	hitsound = 'sound/weapons/genhit3.ogg'
	material = /decl/material/solid/organic/wood/maple
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
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

/obj/item/twohanded/pipewrench
	name = "enormous pipe wrench"
	desc = "You are no longer asking nicely."
	icon = 'icons/obj/items/tool/pipewrench.dmi'
	max_force = 60
	material_force_multiplier = 0.6
	unwielded_material_force_multiplier = 0.3
	attack_verb = list("bludgeoned", "slammed", "smashed", "wrenched")
	material = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_NAME
	obj_flags = OBJ_FLAG_NO_STORAGE

/obj/item/twohanded/pipewrench/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_WRENCH = TOOL_QUALITY_DEFAULT))

/obj/item/twohanded/pipewrench/get_tool_quality(archetype)
	if(wielded && archetype == TOOL_WRENCH)
		return ..()
	return 0

/obj/item/twohanded/pipewrench/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return
	..()
	if(istype(A,/obj/structure/window) && wielded)
		var/obj/structure/window/W = A
		W.shatter()
