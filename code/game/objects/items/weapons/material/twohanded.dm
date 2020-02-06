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
	icon_state = "fireaxe0"
	base_icon = "fireaxe"
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"

	max_force = 60	//for wielded
	material_force_multiplier = 0.6
	unwielded_material_force_multiplier = 0.3
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	applies_material_colour = 0
	base_worth = 31

/obj/item/material/twohanded/fireaxe/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
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
	icon_state = "spearglass0"
	base_icon = "spearglass"
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	max_force = 20	//for wielded
	applies_material_colour = 0
	material_force_multiplier = 0.33 // 12/19 with hardness 60 (steel) or 10/16 with hardness 50 (glass)
	unwielded_material_force_multiplier = 0.20
	thrown_material_force_multiplier = 1.5 // 20 when thrown with weight 15 (glass)
	throw_speed = 3
	edge = 0
	sharp = 1
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	material = MAT_GLASS
	does_spin = FALSE
	base_worth = 7

/obj/item/material/twohanded/spear/shatter(var/consumed)
	if(!consumed)
		new /obj/item/stack/material/rods(get_turf(src), 1)
		new /obj/item/stack/cable_coil(get_turf(src), 3)
	..()

/obj/item/material/twohanded/spear/javelin //short spears for short folks; can be wielded two handed even when mob_small
	icon_state = "spearglass0"
	base_icon = "spearglass"
	name = "javelin"
	desc = "A short spear good for throwing and okay for stabbing. Favoured by yinglets because they can wield it more easily than a longer spear."
	max_force = 20 
	material_force_multiplier = 0.29 //17 with steel, 14 with glass. 
	unwielded_material_force_multiplier = 0.22 //13 with steel, 11 with glass. 
	thrown_material_force_multiplier = 1.8 //better for throwing than spear
	//result for humans: Still better to wield a regular spear with two hands, but if you want to use it one handed a javelin is better.
	// result for yinglets and other small mobs: A javelin is a better choice.


/obj/item/material/twohanded/spear/javelin/update_twohanding() //overrides to allow two hands
	var/mob/living/M = loc
	if(istype(M) && is_held_twohanded(M))
		wielded = 1
		force = force_wielded
	else
		wielded = 0
		force = force_unwielded
	update_icon()

/obj/item/material/twohanded/spear/attackby(obj/item/W, mob/user) // make a javelin from a spear
	. = ..()
	if(istype(W, /obj/item/wirecutters))
		visible_message(SPAN_NOTICE("[user] cuts off a length of \the [src], making it shorter."), blind_message = SPAN_NOTICE("You hear the snipping of wirecutters."))
		playsound(user.loc,'sound/items/Wirecutter.ogg', 100, 1)
		user.put_in_hands(new /obj/item/material/twohanded/spear/javelin(get_turf(user), material.type))
		qdel(src)

/obj/item/material/twohanded/baseballbat
	name = "bat"
	desc = "HOME RUN!"
	icon_state = "metalbat0"
	base_icon = "metalbat"
	item_state = "metalbat"
	w_class = ITEM_SIZE_LARGE
	throwforce = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	hitsound = 'sound/weapons/genhit3.ogg'
	material = MAT_MAPLE
	max_force = 40	//for wielded
	material_force_multiplier = 1.1           // 22 when wielded with weight 20 (steel)
	unwielded_material_force_multiplier = 0.7 // 15 when unwielded based on above.
	melee_accuracy_bonus = -10

//Predefined materials go here.
/obj/item/material/twohanded/baseballbat/metal/Initialize(mapload)
	..(mapload, MAT_ALUMINIUM)

/obj/item/material/twohanded/baseballbat/uranium/Initialize(mapload)
	. = ..(mapload, MAT_URANIUM)

/obj/item/material/twohanded/baseballbat/gold/Initialize(mapload)
	. = ..(mapload, MAT_GOLD)

/obj/item/material/twohanded/baseballbat/platinum/Initialize(mapload)
	. = ..(mapload, MAT_PLATINUM)

/obj/item/material/twohanded/baseballbat/diamond/Initialize(mapload)
	. = ..(mapload, MAT_DIAMOND)
