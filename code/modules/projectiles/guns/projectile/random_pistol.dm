
/obj/item/gun/projectile/pistol/random
	name = "pistol"
	icon  = 'icons/obj/guns/randompistol.dmi'
	icon_state = "preview"
	var/decl/gun_look/gun_look
	var/handle_icon
	var/ammo_offset
	var/safety_offset
	var/list/global/descriptor = list(
		"Shining", "Power", "Instant", "Reliable", "Neo", "Super", "Boom", "Big", "Nitro", "Automatic"
	)
	var/list/global/noun = list(
		"Justice", "Protection", "Defense", "Penetrator", "Compensator", "Police Special", "Combat", "Point & Shoot"
	)
	var/list/global/appearance_cache = list()

/obj/item/gun/projectile/pistol/random/Initialize()
	var/index = pick(caliber, rand(200,900), "P-[rand(10,99)]")
	desc = "A semi-automatic pistol of unknown origin. The inscription on the side claims the model is '[pick(descriptor)] [pick(noun)] [index]'"
	var/list/styles = decls_repository.get_decls_of_type(/decl/gun_look)
	var/decl/gun_look/style = pick(styles)
	gun_look = styles[style]
	handle_icon = gun_look.get_handle_icon()
	. = ..()
	has_inventory_icon = TRUE

/obj/item/gun/projectile/pistol/random/update_base_icon()
	var/base_state = get_world_inventory_state()
	icon_state = "[base_state]_[gun_look.base_icon_state]"
	overlays += image(icon, "[base_state]_[gun_look.front_icon_state]")
	overlays += image(icon, "[base_state]_[handle_icon]")

/obj/item/gun/projectile/pistol/random/get_ammo_indicator()
	var/mutable_appearance/ammo_indicator = ..()
	var/base_state = get_world_inventory_state()
	ammo_indicator.icon_state = replacetext(ammo_indicator.icon_state, "[base_state]_", "")
	ammo_indicator.pixel_x = gun_look.ammo_offset[base_state][1]
	ammo_indicator.pixel_y = gun_look.ammo_offset[base_state][2]
	return ammo_indicator

/obj/item/gun/projectile/pistol/random/get_safety_indicator()
	var/base_state = get_world_inventory_state()
	var/mutable_appearance/safety = mutable_appearance(icon, "safety[safety()]")
	safety.pixel_x = gun_look.safety_offset[base_state][1]
	safety.pixel_y = gun_look.safety_offset[base_state][2]
	return safety

/decl/gun_look
	var/base_icon_state =  "base"
	var/front_icon_state =  "gunbits1"
	 // offsets for LEDs, base state = x,y
	var/list/ammo_offset = list(
		ICON_STATE_WORLD = list(15, 15),
		ICON_STATE_INV = list(15, 17)
	)
	var/list/safety_offset = list(
		ICON_STATE_WORLD = list(17, 15),
		ICON_STATE_INV = list(17, 17)
	)

/decl/gun_look/proc/get_handle_icon()
	return  "handle[rand(1,3)]"

/decl/gun_look/two
	front_icon_state =  "gunbits2"
	ammo_offset = list(
		ICON_STATE_WORLD = list(11, 14),
		ICON_STATE_INV = list(8, 15)
	)
	safety_offset = list(
		ICON_STATE_WORLD = list(13, 14),
		ICON_STATE_INV = list(10, 15)
	)

/decl/gun_look/three
	front_icon_state =  "gunbits3"
	ammo_offset = list(
		ICON_STATE_WORLD = list(16, 14),
		ICON_STATE_INV = list(16, 15)
	)
	safety_offset = list(
		ICON_STATE_WORLD = list(18, 14),
		ICON_STATE_INV = list(18, 15)
	)

/decl/gun_look/four
	front_icon_state =  "gunbits4"
	ammo_offset = list(
		ICON_STATE_WORLD = list(16, 14),
		ICON_STATE_INV = list(16, 15)
	)
	safety_offset = list(
		ICON_STATE_WORLD = list(18, 14),
		ICON_STATE_INV = list(18, 15)
	)