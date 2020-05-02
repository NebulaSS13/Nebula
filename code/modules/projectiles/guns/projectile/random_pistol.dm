
/obj/item/gun/projectile/pistol/random
	name = "pistol"
	icon  = 'icons/obj/guns/randompistol.dmi'
	icon_state = "base"
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

/obj/item/gun/projectile/pistol/random/Initialize()
	var/index = pick(caliber, rand(200,900), "P-[rand(10,99)]")
	desc = "A semi-automatic pistol of unknown origin. The inscription on the side claims the model is '[pick(descriptor)] [pick(noun)] [index]'"
	var/list/styles = decls_repository.get_decls_of_type(/decl/gun_look)
	var/decl/gun_look/style = pick(styles)
	gun_look = styles[style]
	handle_icon = gun_look.get_handle_icon()
	. = ..()

/obj/item/gun/projectile/pistol/random/on_update_icon()
	overlays.Cut()
	icon_state = gun_look.base_icon_state
	overlays += image(icon, gun_look.front_icon_state)
	overlays += image(icon, handle_icon)

	var/image/safety = image(icon, "safety[safety()]")
	safety.pixel_x = gun_look.safety_x
	safety.pixel_y = gun_look.safety_y
	overlays += safety

	var/image/ammo_indicator = image(icon, "ammo_ok")
	if(!ammo_magazine || !LAZYLEN(ammo_magazine.stored_ammo))
		ammo_indicator.icon_state = "ammo_bad"
	else if(LAZYLEN(ammo_magazine.stored_ammo) <= 0.5 * ammo_magazine.max_ammo)
		ammo_indicator.icon_state = "ammo_warn"
	ammo_indicator.pixel_x = gun_look.ammo_x
	ammo_indicator.pixel_y = gun_look.ammo_y
	overlays += ammo_indicator

/decl/gun_look
	var/base_icon_state =  "base"
	var/front_icon_state =  "gunbits1"
	var/ammo_x = 15 // offsets for LEDs
	var/ammo_y = 17
	var/safety_x = 17
	var/safety_y = 17

/decl/gun_look/proc/get_handle_icon()
	return  "handle[rand(1,3)]"

/decl/gun_look/two
	front_icon_state =  "gunbits2"
	ammo_x = 8
	ammo_y = 15
	safety_x = 10
	safety_y = 15

/decl/gun_look/three
	front_icon_state =  "gunbits3"
	ammo_x = 16
	ammo_y = 15
	safety_x = 18
	safety_y = 15

/decl/gun_look/four
	front_icon_state =  "gunbits4"
	ammo_x = 16
	ammo_y = 15
	safety_x = 18
	safety_y = 15