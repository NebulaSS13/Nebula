/obj/screen/psi/hub
	name = "Psi"
	icon_state = "psi_suppressed"
	screen_loc = "RIGHT-1:28,CENTER-3:11"
	hidden = FALSE
	maptext_x = 6
	maptext_y = -8
	requires_ui_style = FALSE
	var/image/on_cooldown
	var/list/components

/obj/screen/psi/hub/Initialize(mapload, mob/_owner, ui_style, ui_color, ui_alpha, ui_cat)
	. = ..()
	on_cooldown = image(icon, "cooldown")
	components = list(
		new /obj/screen/psi/armour(null, _owner),
		new /obj/screen/psi/toggle_psi_menu(null, _owner, null, null, null, null, src)
	)
	START_PROCESSING(SSprocessing, src)

/obj/screen/psi/hub/on_update_icon()
	var/mob/living/owner = owner_ref?.resolve()
	var/datum/ability_handler/psionics/psi = istype(owner) && owner.get_ability_handler(/datum/ability_handler/psionics)
	icon_state = psi?.suppressed ? "psi_suppressed" : "psi_active"
	if(world.time < psi?.next_power_use)
		overlays |= on_cooldown
	else
		overlays.Cut()
	var/offset = 1
	for(var/thing in components)
		var/obj/screen/psi/component = thing
		component.update_icon()
		if(!component.invisibility) component.screen_loc = "RIGHT-[++offset]:28,CENTER-3:11"

/obj/screen/psi/hub/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	for(var/thing in components)
		qdel(thing)
	components.Cut()
	. = ..()

/obj/screen/psi/hub/Process()
	var/mob/living/owner = owner_ref?.resolve()
	if(!istype(owner))
		qdel(src)
		return
	var/datum/ability_handler/psionics/psi = owner.get_ability_handler(/datum/ability_handler/psionics)
	if(!psi)
		return
	maptext = "[round((psi.stamina/psi.max_stamina)*100)]%"
	update_icon()

/obj/screen/psi/hub/handle_click(mob/user, params)

	var/mob/living/owner = owner_ref?.resolve()
	var/datum/ability_handler/psionics/psi = istype(owner) && owner.get_ability_handler(/datum/ability_handler/psionics)
	if(!psi)
		return

	var/list/click_params = params2list(params)
	if(click_params["shift"])
		owner.show_psi_assay(owner)
		return

	if(psi.suppressed && psi.stun)
		to_chat(owner, "<span class='warning'>You are dazed and reeling, and cannot muster enough focus to do that!</span>")
		return

	psi.suppressed = !psi.suppressed
	to_chat(owner, "<span class='notice'>You are <b>[psi?.suppressed ? "now suppressing" : "no longer suppressing"]</b> your psi-power.</span>")
	if(psi.suppressed)
		psi.cancel()
		psi.hide_auras()
	else
		sound_to(owner, sound('sound/effects/psi/power_unlock.ogg'))
		psi.show_auras()
	update_icon()
