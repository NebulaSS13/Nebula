/obj/item/lockpick
	name = "lockpick"
	icon_state = ICON_STATE_WORLD + "1"
	icon = 'icons/obj/items/lockpick.dmi'
	desc = "A slender tool used for picking locks."
	lock_picking_level = 25 // 20 * (25 / length of lock string) - 50% base success for 'sunken keep'
	material = /decl/material/solid/metal/steel
	color = /decl/material/solid/metal/steel::color
	material_alteration = MAT_FLAG_ALTERATION_ALL
	w_class = ITEM_SIZE_TINY
	max_health = 60
	var/use_icon_state

// Purely for aesthetics.
/obj/item/lockpick/rake
	use_icon_state = "1"
/obj/item/lockpick/hook
	use_icon_state = "2"
/obj/item/lockpick/lever
	use_icon_state = "3"

/obj/item/lockpick/Initialize(ml, material_key)
	. = ..()
	if(isnull(use_icon_state))
		use_icon_state = num2text(rand(1,3))
	update_icon()

/obj/item/lockpick/on_update_icon()
	. = ..()
	icon_state = "[get_world_inventory_state()][use_icon_state]"

/datum/storage/lockpick_roll
	can_hold      = list(/obj/item/lockpick)
	storage_slots = 5

/obj/item/lockpick_roll
	name                = "roll of lockpicks"
	desc                = "A stitched roll used to store thin, strangely-shaped tools commonly used used to pick locks."
	icon                = 'icons/obj/items/lockpick_roll.dmi'
	icon_state          = ICON_STATE_WORLD
	material            = /decl/material/solid/organic/leather
	color               = /decl/material/solid/organic/leather::color
	material_alteration = MAT_FLAG_ALTERATION_ALL
	storage             = /datum/storage/lockpick_roll

/obj/item/lockpick_roll/filled/WillContain()
	return list(
		/obj/item/lockpick/rake  = 2,
		/obj/item/lockpick/hook  = 2,
		/obj/item/lockpick/lever = 1
	)

/obj/item/lockpick_roll/attack_self(mob/user)
	if(!storage?.opened)
		storage.open(user)
		return TRUE
	return ..()

/obj/item/lockpick_roll/on_update_icon()
	. = ..()
	icon_state = ICON_STATE_WORLD
	if(!storage?.opened)
		icon_state = "[icon_state]-rolled"
	else if(length(contents))
		var/x_offset = -9
		for(var/i = 1 to length(contents))
			var/obj/item/lockpick/thing = contents[i]
			if(istype(thing))
				var/image/lockpick         = new /image
				lockpick.color             = thing.color
				lockpick.icon              = thing.icon
				lockpick.icon_state        = thing.icon_state
				lockpick.appearance_flags |= RESET_COLOR
				lockpick.pixel_x           = x_offset
				add_overlay(lockpick)
			x_offset += 4
		add_overlay("[icon_state]-cover")
	compile_overlays()
