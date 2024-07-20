//knives for stabbing and slashing and so on and so forth
/obj/item/knife //master obj
	name = "knife"
	desc = "You call that a knife? This is a master item - berate the admin or mapper who spawned this"
	icon = 'icons/obj/items/weapon/knives/kitchen.dmi'
	icon_state = ICON_STATE_WORLD
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	material = /decl/material/solid/metal/steel
	origin_tech = @'{"materials":1}'
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	sharp = TRUE
	edge = TRUE
	item_flags = ITEM_FLAG_CAN_HIDE_IN_SHOES | ITEM_FLAG_IS_WEAPON
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	pickup_sound = 'sound/foley/knife1.ogg'
	drop_sound = 'sound/foley/knifedrop3.ogg'

	var/draw_handle
	var/handle_color
	var/valid_handle_colors

/obj/item/knife/Initialize(ml, material_key)
	. = ..()
	if(!has_extension(src, /datum/extension/tool))
		set_extension(src, /datum/extension/tool/variable/simple, list(
			TOOL_SCALPEL =     TOOL_QUALITY_MEDIOCRE,
			TOOL_SAW =         TOOL_QUALITY_BAD,
			TOOL_RETRACTOR =   TOOL_QUALITY_BAD,
			TOOL_SCREWDRIVER = TOOL_QUALITY_BAD
		))

/obj/item/knife/on_update_icon()
	. = ..()
	if(draw_handle)
		if(!handle_color && length(valid_handle_colors))
			handle_color = pick(valid_handle_colors)
		add_overlay(overlay_image(icon, "[get_world_inventory_state()]_handle", handle_color, flags=RESET_COLOR|RESET_ALPHA))

/obj/item/knife/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	if(user.a_intent != I_HELP && user.get_target_zone() == BP_EYES)
		if(user.has_genetic_condition(GENE_COND_CLUMSY) && prob(50))
			target = user
		return eyestab(target, user)
	return ..()

/obj/item/knife/can_take_wear_damage()
	return FALSE //Prevents knives from shattering/breaking from usage

/obj/item/knife/primitive
	name = "dueling knife"
	desc = "A length of leather-bound wood studded with razor-sharp teeth. How crude."
	icon = 'icons/obj/items/weapon/knives/savage.dmi'
	material = /decl/material/solid/organic/wood
	material_alteration = MAT_FLAG_ALTERATION_NAME
	w_class = ITEM_SIZE_NORMAL

/obj/item/knife/primitive/get_autopsy_descriptors()
	. = ..()
	. += "serrated"

//kitchen knives
/obj/item/knife/kitchen
	name = "kitchen knife"
	icon = 'icons/obj/items/weapon/knives/kitchen.dmi'
	desc = "A general purpose chef's knife made by SpaceCook Incorporated. Guaranteed to stay sharp for years to come."
	material_alteration = MAT_FLAG_ALTERATION_COLOR
	draw_handle = TRUE

/obj/item/knife/kitchen/cleaver
	name = "butcher's cleaver"
	desc = "A heavy blade used to process food, especially animal carcasses."
	icon = 'icons/obj/items/weapon/knives/cleaver.dmi'
	armor_penetration = 5
	attack_verb = list("cleaved", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/knife/kitchen/cleaver/bronze
	name = "master chef's cleaver"
	desc = "A heavy blade used to process food. This one is so fancy, it must be for a truly exceptional chef. There aren't any here, so what it's doing here is anyone's guess."
	material = /decl/material/solid/metal/bronze

//fighting knives
/obj/item/knife/combat
	name               = "combat knife"
	desc               = "A blade with a saw-like pattern on the reverse edge and a heavy handle."
	icon               = 'icons/obj/items/weapon/knives/tactical.dmi'
	w_class            = ITEM_SIZE_SMALL
	draw_handle        = TRUE
	_base_attack_force = 15

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
	material_alteration = MAT_FLAG_ALTERATION_NONE

/obj/item/knife/ritual/get_autopsy_descriptors()
	. = ..()
	. += "curved"

//Utility knives
/obj/item/knife/utility
	name = "utility knife"
	desc = "An utility knife with a polymer handle, commonly used through human space."
	icon = 'icons/obj/items/weapon/knives/utility.dmi'
	w_class = ITEM_SIZE_SMALL
	draw_handle = TRUE

/obj/item/knife/utility/lightweight
	name = "lightweight utility knife"
	desc = "A lightweight utility knife made out of a titanium alloy."
	material = /decl/material/solid/metal/titanium
	draw_handle = FALSE