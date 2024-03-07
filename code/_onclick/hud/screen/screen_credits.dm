
/obj/screen/credit
	icon_state = "blank"
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	alpha = 0
	screen_loc = "CENTER-7,BOTTOM+1"
	plane = HUD_PLANE
	layer = HUD_ABOVE_ITEM_LAYER
	maptext_height = WORLD_ICON_SIZE * 2
	maptext_width  = WORLD_ICON_SIZE * 14
	requires_ui_style = FALSE
	var/client/parent
	var/matrix/target

/obj/screen/credit/proc/rollem()
	var/matrix/M = matrix(transform)
	M.Translate(0, CREDIT_ANIMATE_HEIGHT)
	animate(src, transform = M, time = CREDIT_ROLL_SPEED)
	target = M
	animate(src, alpha = 255, time = CREDIT_EASE_DURATION, flags = ANIMATION_PARALLEL)
	spawn(CREDIT_ROLL_SPEED - CREDIT_EASE_DURATION)
		if(!QDELETED(src))
			animate(src, alpha = 0, transform = target, time = CREDIT_EASE_DURATION)
			sleep(CREDIT_EASE_DURATION)
			qdel(src)
	var/mob/owner = owner_ref?.resolve()
	if(istype(owner) && owner.client)
		owner.client.screen += src

/obj/screen/credit/Destroy()
	var/client/P = parent
	if(istype(P))
		P.screen -= src
		LAZYREMOVE(P.credits, src)
	parent = null
	return ..()
