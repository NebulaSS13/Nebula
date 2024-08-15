
/obj/item/gun/projectile/pistol/random
	name = "pistol"
	icon = 'icons/obj/guns/random_pistol/base.dmi'
	var/decl/gun_look/gun_look
	var/handle_icon
	// ammo and safety offsets were moved to gun_look
	var/static/list/descriptor = list(
		"Shining", "Power", "Instant", "Reliable", "Neo", "Super", "Boom", "Big", "Nitro", "Automatic"
	)
	var/static/list/noun = list(
		"Justice", "Protection", "Defense", "Penetrator", "Compensator", "Police Special", "Combat", "Point & Shoot"
	)

/obj/item/gun/projectile/pistol/random/Initialize()
	var/index = pick(caliber, rand(200,900), "P-[rand(10,99)]")
	desc = "A semi-automatic pistol of unknown origin. The inscription on the side claims the model is '[pick(descriptor)] [pick(noun)] [index]'"
	var/list/styles = decls_repository.get_decls_of_type(/decl/gun_look)
	gun_look = styles[pick(styles)]
	handle_icon = pick(gun_look.handle_icons)
	. = ..()

/obj/item/gun/projectile/pistol/random/on_update_icon()
	. = ..()
	add_overlay(image(gun_look.icon, icon_state))
	add_overlay(image(handle_icon, icon_state))

/obj/item/gun/projectile/pistol/random/get_ammo_indicator()
	return gun_look.adjust_ammo_indicator(..(), get_world_inventory_state())

/obj/item/gun/projectile/pistol/random/get_safety_indicator()
	var/mutable_appearance/safety = mutable_appearance(icon, "safety[safety()]")
	return gun_look.adjust_safety_indicator(safety, get_world_inventory_state())

/decl/gun_look
	var/icon =  'icons/obj/guns/random_pistol/looks/plated.dmi'
	 // offsets for LEDs, base state = x,y
	var/list/ammo_offset = list(
		ICON_STATE_WORLD = list(15, 15),
		ICON_STATE_INV = list(15, 17)
	)
	var/list/safety_offset = list(
		ICON_STATE_WORLD = list(17, 15),
		ICON_STATE_INV = list(17, 17)
	)
	var/list/handle_icons = list(
		'icons/obj/guns/random_pistol/handle/ergonomic.dmi',
		'icons/obj/guns/random_pistol/handle/black.dmi',
		'icons/obj/guns/random_pistol/handle/revolver.dmi'
	)

/decl/gun_look/proc/adjust_ammo_indicator(mutable_appearance/ammo_indicator, base_state)
	ammo_indicator.icon_state = replacetext(ammo_indicator.icon_state, "[base_state]_", "")
	ammo_indicator.pixel_x = ammo_offset[base_state][1]
	ammo_indicator.pixel_y = ammo_offset[base_state][2]
	return ammo_indicator

/decl/gun_look/proc/adjust_safety_indicator(mutable_appearance/safety, base_state)
	safety.pixel_x = safety_offset[base_state][1]
	safety.pixel_y = safety_offset[base_state][2]
	return safety
/decl/gun_look/cover
	icon =  'icons/obj/guns/random_pistol/looks/cover.dmi'
	ammo_offset = list(
		ICON_STATE_WORLD = list(11, 14),
		ICON_STATE_INV = list(8, 15)
	)
	safety_offset = list(
		ICON_STATE_WORLD = list(13, 14),
		ICON_STATE_INV = list(10, 15)
	)

/decl/gun_look/short
	icon =  'icons/obj/guns/random_pistol/looks/short.dmi'
	ammo_offset = list(
		ICON_STATE_WORLD = list(16, 14),
		ICON_STATE_INV = list(16, 15)
	)
	safety_offset = list(
		ICON_STATE_WORLD = list(18, 14),
		ICON_STATE_INV = list(18, 15)
	)

/decl/gun_look/drilled
	icon =  'icons/obj/guns/random_pistol/looks/drilled.dmi'
	ammo_offset = list(
		ICON_STATE_WORLD = list(16, 14),
		ICON_STATE_INV = list(16, 15)
	)
	safety_offset = list(
		ICON_STATE_WORLD = list(18, 14),
		ICON_STATE_INV = list(18, 15)
	)