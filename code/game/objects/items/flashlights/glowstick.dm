//Glowsticks
/obj/item/flashlight/flare/glowstick
	name = "green glowstick"
	desc = "A military-grade glowstick."
	w_class = ITEM_SIZE_SMALL
	color = "#49f37c"
	icon = 'icons/obj/lighting/glowstick.dmi'
	randpixel = 12
	produce_heat = 0
	activation_sound = 'sound/effects/glowstick.ogg'
	flashlight_range = 3
	flashlight_power = 2
	offset_on_overlay_x = 0

/obj/item/flashlight/flare/glowstick/Initialize()
	. = ..()
	fuel = rand(1600, 2000)
	light_color = color

/obj/item/flashlight/flare/glowstick/activate(var/mob/user)
	if(istype(user))
		user.visible_message("<span class='notice'>[user] cracks and shakes \the [src].</span>", "<span class='notice'>You crack and shake \the [src], turning it on!</span>")

/obj/item/flashlight/flare/glowstick/red
	name = "red glowstick"
	color = "#fc0f29"

/obj/item/flashlight/flare/glowstick/blue
	name = "blue glowstick"
	color = "#599dff"

/obj/item/flashlight/flare/glowstick/orange
	name = "orange glowstick"
	color = "#fa7c0b"

/obj/item/flashlight/flare/glowstick/yellow
	name = "yellow glowstick"
	color = "#fef923"

/obj/item/flashlight/flare/glowstick/random
	name = "glowstick"
	desc = "A party-grade glowstick."
	color = "#ff00ff"

/obj/item/flashlight/flare/glowstick/random/Initialize()
	color = rgb(rand(50,255),rand(50,255),rand(50,255))
	. = ..()
