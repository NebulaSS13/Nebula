/obj/item/material/coin
	name = "coin"
	icon = 'icons/obj/coin.dmi'
	icon_state = "coin1"
	applies_material_colour = TRUE
	randpixel = 8
	force = 1
	throwforce = 1
	max_force = 5
	material_force_multiplier = 0.1
	thrown_material_force_multiplier = 0.1
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	var/string_colour
	var/can_flip = TRUE

/obj/item/material/coin/Initialize()
	. = ..()
	icon_state = "coin[rand(1,10)]"

/obj/item/material/coin/on_update_icon()
	..()
	if(!isnull(string_colour))
		var/image/I = image(icon = icon, icon_state = "coin_string_overlay")
		I.appearance_flags |= RESET_COLOR
		I.color = string_colour
		overlays += I
	else
		overlays.Cut()

/obj/item/material/coin/attackby(var/obj/item/W, var/mob/user)
	if(isCoil(W) && isnull(string_colour))
		var/obj/item/stack/cable_coil/CC = W
		if(CC.use(1))
			string_colour = CC.color
			to_chat(user, "<span class='notice'>You attach a string to the coin.</span>")
			update_icon()
			return
	else if(isWirecutter(W) && !isnull(string_colour))
		new /obj/item/stack/cable_coil/single(get_turf(user))
		string_colour = null
		to_chat(user, "<span class='notice'>You detach the string from the coin.</span>")
		update_icon()
	else ..()

// "Coin Flipping, A.wav" by InspectorJ (www.jshaw.co.uk) of Freesound.org
/obj/item/material/coin/attack_self(var/mob/user)
	if(!can_flip)
		to_chat(user, SPAN_WARNING("\The [src] is already being flipped!"))
		return
	coin_flip(user)

/obj/item/material/coin/proc/coin_flip(var/mob/user)
	if(!can_flip)
		return
	can_flip = FALSE
	playsound(usr.loc, 'sound/effects/coin_flip.ogg', 75, 1)
	user.visible_message(SPAN_NOTICE("\The [user] flips \the [src] into the air."))
	sleep(1.5 SECOND)
	if(!QDELETED(user) && !QDELETED(src) && loc == user)
		user.visible_message(SPAN_NOTICE("...and catches it, revealing that \the [src] landed on [(prob(50) && "tails") || "heads"]!"))
	can_flip = TRUE
	return

// Subtypes.
/obj/item/material/coin/gold
	material = MAT_GOLD

/obj/item/material/coin/silver
	material = MAT_SILVER

/obj/item/material/coin/diamond
	material = MAT_DIAMOND

/obj/item/material/coin/iron
	material = MAT_IRON

/obj/item/material/coin/uranium
	material = MAT_URANIUM

/obj/item/material/coin/platinum
	material = MAT_PLATINUM

/obj/item/material/coin/phoron
	material = MAT_PHORON
