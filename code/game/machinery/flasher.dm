// It is a gizmo that flashes a small area

/obj/machinery/flasher
	name = "mounted flash"
	desc = "A wall-mounted flashbulb device."
	icon = 'icons/obj/machines/flash_mounted.dmi'
	icon_state = "mflash1"
	directional_offset = @'{"NORTH":{"y":-32}, "SOUTH":{"y":32}, "EAST":{"x":32}, "WEST":{"x":-32}}'
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/range = 2 //this is roughly the size of brig cell
	var/disable = 0
	var/last_flash = 0 //Don't want it getting spammed like regular flashes
	var/strength = 10 //How weakened targets are when flashed.
	var/base_state = "mflash"
	anchored = TRUE
	idle_power_usage = 2
	movable_flags = MOVABLE_FLAG_PROXMOVE

	uncreated_component_parts = list(
		/obj/item/stock_parts/radio/receiver,
		/obj/item/stock_parts/power/apc
	)
	public_methods = list(
		/decl/public_access/public_method/flasher_flash
	)
	stock_part_presets = list(/decl/stock_part_preset/radio/receiver/flasher = 1)


/obj/machinery/flasher/on_update_icon()
	if ( !(stat & (BROKEN|NOPOWER)) )
		icon_state = "[base_state]1"
//		src.sd_SetLuminosity(2)
	else
		icon_state = "[base_state]1-p"
//		src.sd_SetLuminosity(0)

//Don't want to render prison breaks impossible
/obj/machinery/flasher/attackby(obj/item/W, mob/user)
	if(IS_WIRECUTTER(W))
		add_fingerprint(user, 0, W)
		src.disable = !src.disable
		if (src.disable)
			user.visible_message("<span class='warning'>[user] has disconnected the [src]'s flashbulb!</span>", "<span class='warning'>You disconnect the [src]'s flashbulb!</span>")
		if (!src.disable)
			user.visible_message("<span class='warning'>[user] has connected the [src]'s flashbulb!</span>", "<span class='warning'>You connect the [src]'s flashbulb!</span>")
	else
		..()

//Let the AI trigger them directly.
/obj/machinery/flasher/attack_ai()
	if (src.anchored)
		return src.flash()
	else
		return

/obj/machinery/flasher/proc/flash()
	if (stat & NOPOWER)
		return

	if ((src.disable) || (src.last_flash && world.time < src.last_flash + 150))
		return

	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
	flick("[base_state]_flash", src)
	src.last_flash = world.time
	use_power_oneoff(1500)

	for (var/mob/living/O in viewers(src, null))
		if (get_dist(src, O) > src.range)
			continue

		var/flash_time = strength
		if(isliving(O))
			if(O.eyecheck() > FLASH_PROTECTION_NONE)
				continue
			if(ishuman(O))
				var/mob/living/human/H = O
				flash_time = round(H.get_flash_mod() * flash_time)
				if(flash_time <= 0)
					return
				var/vision_organ_tag = H.get_vision_organ_tag()
				if(vision_organ_tag)
					var/obj/item/organ/internal/E = GET_INTERNAL_ORGAN(H, vision_organ_tag)
					if(E && E.is_bruised() && prob(E.damage + 50))
						H.flash_eyes()
						E.damage += rand(1, 5)

		if(!O.is_blind())
			do_flash(O, flash_time)

/obj/machinery/flasher/proc/do_flash(var/mob/living/victim, var/flash_time)
	victim.flash_eyes()
	ADJ_STATUS(victim, STAT_BLURRY, flash_time)
	ADJ_STATUS(victim, STAT_CONFUSE, flash_time + 2)
	SET_STATUS_MAX(victim, STAT_STUN, flash_time / 2)
	SET_STATUS_MAX(victim, STAT_WEAK, 3)

/obj/machinery/flasher/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(prob(75/severity))
		flash()
	..(severity)

/obj/machinery/flasher/portable //Portable version of the flasher. Only flashes when anchored
	name = "portable flasher"
	desc = "A portable flashing device. Wrench to activate and deactivate. Cannot detect slow movements."
	icon_state = "pflash1"
	icon = 'icons/obj/machines/flash_portable.dmi'
	strength = 8
	anchored = FALSE
	base_state = "pflash"
	density = TRUE

/obj/machinery/flasher/portable/HasProximity(atom/movable/AM)
	. = ..()
	if(!. || !anchored || disable || last_flash && world.time < last_flash + 150)
		return
	if(isliving(AM))
		var/mob/living/M = AM
		if(!MOVING_DELIBERATELY(M))
			flash()

/obj/machinery/flasher/portable/attackby(obj/item/W, mob/user)
	if(IS_WRENCH(W))
		add_fingerprint(user)
		src.anchored = !src.anchored

		if (!src.anchored)
			user.show_message(text("<span class='warning'>[src] can now be moved.</span>"))
			src.overlays.Cut()

		else if (src.anchored)
			user.show_message(text("<span class='warning'>[src] is now secured.</span>"))
			src.overlays += "[base_state]-s"

/obj/machinery/button/flasher
	name = "flasher button"
	desc = "A remote control switch for a mounted flasher."
	cooldown = 5 SECONDS

/decl/public_access/public_method/flasher_flash
	name = "flash"
	desc = "Performs a flash, if possible."
	call_proc = TYPE_PROC_REF(/obj/machinery/flasher, flash)

/decl/stock_part_preset/radio/receiver/flasher
	frequency = BUTTON_FREQ
	receive_and_call = list("button_active" = /decl/public_access/public_method/flasher_flash)