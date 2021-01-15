/obj/item/clothing/glasses/eyepatch
	name = "eyepatch"
	desc = "Yarr."
	body_parts_covered = 0
	icon = 'icons/clothing/eyes/eyepatch.dmi'
	var/flipped_icon = 'icons/clothing/eyes/eyepatch_right.dmi'

/obj/item/clothing/glasses/eyepatch/verb/flip_patch()
	set name = "Flip Patch"
	set category = "Object"
	set src in usr

	if(usr.incapacitated() || usr.restrained())
		return

	var/flipped
	if(icon == flipped_icon)
		icon = initial(icon)
		flipped = "left"
	else
		icon = flipped_icon
		flipped = "right"
	to_chat (usr, "You change \the [src] to cover the [flipped] eye.")
	update_icon()
	update_clothing_icon()

/obj/item/clothing/glasses/eyepatch/hud
	name = "iPatch"
	desc = "For the technologically inclined pirate. It connects directly to the optical nerve of the user, replacing the need for that useless eyeball."
	gender = NEUTER
	icon = 'icons/clothing/eyes/hudpatch.dmi'
	flipped_icon = 'icons/clothing/eyes/hudpatch_right.dmi'
	action_button_name = "Toggle iPatch"
	toggleable = TRUE
	electric = TRUE
	var/eye_color = COLOR_WHITE

/obj/item/clothing/glasses/eyepatch/hud/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/glasses/eyepatch/hud/equipped(mob/user)
	. = ..()
	update_icon()

/obj/item/clothing/glasses/eyepatch/hud/dropped(mob/user)
	. = ..()
	update_icon()
	
/obj/item/clothing/glasses/eyepatch/hud/on_update_icon()
	cut_overlays()
	if(active && check_state_in_icon("[icon_state]-eye", icon))
		var/image/eye = overlay_image(icon, "[icon_state]-eye", flags=RESET_COLOR)
		eye.color = eye_color
		if(plane != HUD_PLANE)
			eye.layer = ABOVE_LIGHTING_LAYER
			eye.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		add_overlay(eye)

/obj/item/clothing/glasses/eyepatch/hud/experimental_mob_overlay(mob/user_mob, slot, bodypart)
	var/image/res = ..()
	if(active && check_state_in_icon("[res.icon_state]-eye", res.icon))
		var/image/eye = overlay_image(res.icon, "[res.icon_state]-eye", flags = RESET_COLOR)
		eye.color = eye_color
		eye.layer = ABOVE_LIGHTING_LAYER
		eye.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		res.overlays += eye
	return res

/obj/item/clothing/glasses/eyepatch/hud/security
	name = "HUDpatch"
	desc = "A Security-type heads-up display that connects directly to the optical nerve of the user, replacing the need for that useless eyeball."
	hud = /obj/item/clothing/glasses/hud/security
	eye_color = COLOR_RED

/obj/item/clothing/glasses/eyepatch/hud/medical
	name = "MEDpatch"
	desc = "A Medical-type heads-up display that connects directly to the ocular nerve of the user, replacing the need for that useless eyeball."
	hud = /obj/item/clothing/glasses/hud/health
	eye_color = COLOR_CYAN

/obj/item/clothing/glasses/eyepatch/hud/meson
	name = "MESpatch"
	desc = "An optical meson scanner display that connects directly to the ocular nerve of the user, replacing the need for that useless eyeball."
	vision_flags = SEE_TURFS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	eye_color = COLOR_LIME

/obj/item/clothing/glasses/eyepatch/hud/science
	name = "SCIpatch"
	desc = "A Science-type heads-up display that connects directly to the ocular nerve of the user, replacing the need for that useless eyeball."
	hud_type = HUD_SCIENCE
	eye_color = COLOR_PINK

/obj/item/clothing/glasses/eyepatch/hud/meson/Initialize()
	. = ..()
	overlay = GLOB.global_hud.meson

/obj/item/clothing/glasses/eyepatch/monocle
	name = "monocle"
	desc = "Such a dapper eyepiece!"
	icon = 'icons/clothing/eyes/monocle.dmi'
	flipped_icon = 'icons/clothing/eyes/monocle_right.dmi'
	body_parts_covered = 0
