/obj/screen/exosuit
	name = "hardpoint"
	icon = 'icons/mecha/mech_hud.dmi'
	icon_state = "base"
	requires_ui_style = FALSE
	apply_screen_overlay = FALSE
	var/initial_maptext
	var/height = 14

/obj/screen/exosuit/Initialize(mapload, mob/_owner, ui_style, ui_color, ui_cat, ui_alpha)
	. = ..()
	var/mob/living/exosuit/newowner = get_owning_exosuit()
	if(!istype(newowner))
		return INITIALIZE_HINT_QDEL
	if(initial_maptext)
		maptext = MECH_UI_STYLE(initial_maptext)

/obj/screen/exosuit/handle_click(mob/user, params)
	var/mob/living/exosuit/owner = get_owning_exosuit()
	return owner && (user == owner || user.loc == owner)

/obj/screen/exosuit/proc/get_owning_exosuit()
	var/mob/living/exosuit/owner = owner_ref?.resolve()
	if(istype(owner) && !QDELETED(owner))
		return owner

/obj/screen/exosuit/radio
	name = "radio"
	maptext_x = 5
	maptext_y = 12
	initial_maptext = "RADIO"

/obj/screen/exosuit/radio/handle_click(mob/user, params)
	if(!..())
		return FALSE
	var/mob/living/exosuit/owner = get_owning_exosuit()
	if(owner.radio)
		owner.radio.attack_self(user)
	else
		to_chat(user, SPAN_WARNING("There is no radio installed."))
	return TRUE

/obj/screen/exosuit/hardpoint
	name = "hardpoint"
	var/hardpoint_tag
	var/obj/item/holding
	icon_state = "hardpoint"

	maptext_x = 34
	maptext_y = 3
	maptext_width = 72

/obj/screen/exosuit/hardpoint/handle_mouse_drop(atom/over, mob/user)
	if(holding)
		holding.screen_loc = screen_loc
		return TRUE
	. = ..()

/obj/screen/exosuit/hardpoint/proc/update_system_info()

	// No point drawing it if we have no item to use or nobody to see it.
	var/mob/living/exosuit/owner = get_owning_exosuit()
	if(!holding || !istype(owner))
		return

	var/has_pilot_with_client = owner.client
	if(!has_pilot_with_client && LAZYLEN(owner.pilots))
		for(var/thing in owner.pilots)
			var/mob/pilot = thing
			if(pilot.client)
				has_pilot_with_client = TRUE
				break
	if(!has_pilot_with_client)
		return

	var/list/new_overlays = list()
	if(!owner.get_cell() || (owner.get_cell().charge <= 0))
		overlays.Cut()
		maptext = ""
		return

	maptext =  STYLE_SMALLFONTS_OUTLINE("[holding.get_hardpoint_maptext()]", 7, COLOR_WHITE, COLOR_BLACK)

	var/ui_damage = (!owner.body.diagnostics || !owner.body.diagnostics.is_functional() || ((owner.emp_damage>EMP_GUI_DISRUPT) && prob(owner.emp_damage)))

	var/value = holding.get_hardpoint_status_value()
	if(isnull(value))
		overlays.Cut()
		return

	if(ui_damage)
		value = -1
		maptext = STYLE_SMALLFONTS_OUTLINE("ERROR", 7, COLOR_WHITE, COLOR_BLACK)
	else
		if((owner.emp_damage>EMP_GUI_DISRUPT) && prob(owner.emp_damage*2))
			if(prob(10))
				value = -1
			else
				value = rand(1,MECH_BAR_CAP)
		else
			value = round(value * MECH_BAR_CAP)

	// Draw background.
	if(!global.default_hardpoint_background)
		global.default_hardpoint_background = image(icon = 'icons/mecha/mech_hud.dmi', icon_state = "bar_bkg")
		global.default_hardpoint_background.pixel_x = 34
	new_overlays += global.default_hardpoint_background

	if(value == 0)
		if(!global.hardpoint_bar_empty)
			global.hardpoint_bar_empty = image(icon='icons/mecha/mech_hud.dmi',icon_state="bar_flash")
			global.hardpoint_bar_empty.pixel_x = 24
			global.hardpoint_bar_empty.color = "#ff0000"
		new_overlays += global.hardpoint_bar_empty
	else if(value < 0)
		if(!global.hardpoint_error_icon)
			global.hardpoint_error_icon = image(icon='icons/mecha/mech_hud.dmi',icon_state="bar_error")
			global.hardpoint_error_icon.pixel_x = 34
		new_overlays += global.hardpoint_error_icon
	else
		value = min(value, MECH_BAR_CAP)
		// Draw statbar.
		if(!LAZYLEN(global.hardpoint_bar_cache))
			for(var/i=0;i<MECH_BAR_CAP;i++)
				var/image/bar = image(icon='icons/mecha/mech_hud.dmi',icon_state="bar")
				bar.pixel_x = 24+(i*2)
				if(i>5)
					bar.color = "#00ff00"
				else if(i>1)
					bar.color = "#ffff00"
				else
					bar.color = "#ff0000"
				global.hardpoint_bar_cache += bar
		for(var/i=1;i<=value;i++)
			new_overlays += global.hardpoint_bar_cache[i]
	overlays = new_overlays

/obj/screen/exosuit/hardpoint/Initialize(mapload, mob/_owner, ui_style, ui_color, ui_alpha, ui_cat, newtag)
	. = ..()
	hardpoint_tag = newtag
	name = "hardpoint ([hardpoint_tag])"

/obj/screen/exosuit/hardpoint/handle_click(mob/user, params)
	if(!..())
		return FALSE
	var/mob/living/exosuit/owner = get_owning_exosuit()
	if(!owner.hatch_closed)
		to_chat(user, SPAN_WARNING("Error: Hardpoint interface disabled while [owner.body.hatch_descriptor] is open."))
		return TRUE

	var/modifiers = params2list(params)
	if(modifiers["ctrl"])
		if(owner.hardpoints_locked)
			to_chat(user, SPAN_WARNING("Hardpoint ejection system is locked."))
			return TRUE
		if(owner.remove_system(hardpoint_tag))
			to_chat(user, SPAN_NOTICE("You disengage and discard the system mounted to your [hardpoint_tag] hardpoint."))
		else
			to_chat(user, SPAN_DANGER("You fail to remove the system mounted to your [hardpoint_tag] hardpoint."))
		return TRUE

	if(owner.selected_hardpoint == hardpoint_tag)
		icon_state = "hardpoint"
		owner.clear_selected_hardpoint()
	else if(owner.set_hardpoint(hardpoint_tag))
		icon_state = "hardpoint_selected"
	return TRUE

/obj/screen/exosuit/eject
	name = "eject"
	maptext_x = 5
	maptext_y = 12
	initial_maptext = "EJECT"

/obj/screen/exosuit/eject/handle_click(mob/user, params)
	if(!..())
		return FALSE
	var/mob/living/exosuit/owner = get_owning_exosuit()
	owner.eject(user)
	return TRUE

/obj/screen/exosuit/rename
	name = "rename"
	maptext_x = 1
	maptext_y = 12
	initial_maptext = "RENAME"

/obj/screen/exosuit/rename/handle_click(mob/user, params)
	if(!..())
		return FALSE
	var/mob/living/exosuit/owner = get_owning_exosuit()
	owner.rename(user)
	return TRUE

/obj/screen/exosuit/power
	name = "power"
	icon_state = null
	maptext_x = -16
	maptext_width = 64
	maptext_y = -8

/obj/screen/exosuit/toggle
	name = "toggle"
	var/uitext = ""
	var/toggled = FALSE

/obj/screen/exosuit/toggle/Initialize(mapload, mob/_owner, ui_style, ui_color, ui_alpha)
	. = ..()
	queue_icon_update()

/obj/screen/exosuit/toggle/on_update_icon()
	. = ..()
	icon_state = "[initial(icon_state)][toggled ? "_enabled" : ""]"
	maptext = "<font color='[toggled ? COLOR_WHITE : COLOR_GRAY]'>[MECH_UI_STYLE(uitext)]</font>"

/obj/screen/exosuit/toggle/handle_click(mob/user, params)
	if(..())
		toggled(user)
		return TRUE
	return FALSE

/obj/screen/exosuit/toggle/proc/toggled(mob/user)
	toggled = !toggled
	queue_icon_update()
	return toggled

/obj/screen/exosuit/toggle/power_control
	name = "Power control"
	icon_state = "small_important"
	maptext_x = 3
	maptext_y = 13
	height = 12
	uitext = "POWER"

/obj/screen/exosuit/toggle/power_control/toggled(mob/user)
	. = ..()
	var/mob/living/exosuit/owner = get_owning_exosuit()
	if(owner)
		owner.toggle_power(user)

/obj/screen/exosuit/toggle/power_control/on_update_icon()
	var/mob/living/exosuit/owner = get_owning_exosuit()
	if(istype(owner))
		toggled = (owner.power == MECH_POWER_ON)
	. = ..()

/obj/screen/exosuit/toggle/air
	name = "air"
	icon_state = "small_important"
	maptext_x = 9
	maptext_y = 13
	height = 12
	uitext = "AIR"

/obj/screen/exosuit/toggle/air/toggled(mob/user)
	var/mob/living/exosuit/owner = get_owning_exosuit()
	if(owner)
		owner.use_air = ..()
		to_chat(user, SPAN_NOTICE("Auxiliary atmospheric system [owner.use_air ? "enabled" : "disabled"]."))

/obj/screen/exosuit/toggle/maint
	name = "toggle maintenance protocol"
	icon_state = "small"
	maptext_x = 5
	maptext_y = 13
	height = 12
	uitext = "MAINT"

/obj/screen/exosuit/toggle/maint/toggled(mob/user)
	var/mob/living/exosuit/owner = get_owning_exosuit()
	if(owner)
		owner.maintenance_protocols = ..()
		to_chat(user, SPAN_NOTICE("Maintenance protocols [owner.maintenance_protocols ? "enabled" : "disabled"]."))

/obj/screen/exosuit/toggle/hardpoint
	name = "toggle hardpoint lock"
	maptext_x = 5
	maptext_y = 12
	uitext = "GEAR"

/obj/screen/exosuit/toggle/hardpoint/toggled(mob/user)
	var/mob/living/exosuit/owner = get_owning_exosuit()
	if(owner)
		owner.hardpoints_locked = ..()
		to_chat(user, SPAN_NOTICE("Hardpoint system access is now [owner.hardpoints_locked ? "disabled" : "enabled"]."))

/obj/screen/exosuit/toggle/hatch
	name = "toggle hatch lock"
	maptext_x = 5
	maptext_y = 12
	uitext = "LOCK"

/obj/screen/exosuit/toggle/hatch/toggled(mob/user)
	var/mob/living/exosuit/owner = get_owning_exosuit()
	if(owner)
		if(!owner.hatch_locked && !owner.hatch_closed)
			to_chat(user, SPAN_WARNING("You cannot lock the hatch while it is open."))
			return
		owner.hatch_locked = ..()
		to_chat(user, SPAN_NOTICE("The [owner.body.hatch_descriptor] is [owner.hatch_locked ? "now" : "no longer" ] locked."))

/obj/screen/exosuit/toggle/hatch_open
	name = "open or close hatch"
	maptext_x = 4
	maptext_y = 12

/obj/screen/exosuit/toggle/hatch_open/toggled(mob/user)
	var/mob/living/exosuit/owner = get_owning_exosuit()
	if(owner)
		if(owner.hatch_locked && owner.hatch_closed)
			to_chat(user, SPAN_WARNING("You cannot open the hatch while it is locked."))
			return
		owner.hatch_closed = ..()
		to_chat(user, SPAN_NOTICE("The [owner.body.hatch_descriptor] is now [owner.hatch_closed ? "closed" : "open" ]."))
		owner.update_icon()

/obj/screen/exosuit/toggle/hatch_open/on_update_icon()
	var/mob/living/exosuit/owner = get_owning_exosuit()
	if(owner)
		toggled = owner.hatch_closed
	. = ..()
	if(owner)
		if(toggled)
			maptext = MECH_UI_STYLE("OPEN")
			maptext_x = 5
		else
			maptext = MECH_UI_STYLE("CLOSE")
			maptext_x = 4

//Controls if cameras set the vision flags
/obj/screen/exosuit/toggle/camera
	name = "toggle camera matrix"
	icon_state = "small_important"
	maptext_x = 1
	maptext_y = 13
	height = 12
	uitext = "SENSOR"

/obj/screen/exosuit/toggle/camera/on_update_icon()
	var/mob/living/exosuit/owner = get_owning_exosuit()
	if(istype(owner) && owner.head)
		toggled = owner.head.active_sensors
	. = ..()

/obj/screen/exosuit/toggle/camera/toggled(mob/user)
	var/mob/living/exosuit/owner = get_owning_exosuit()
	if(!istype(owner) || !owner.head)
		to_chat(user, SPAN_WARNING("I/O Error: Camera systems not found."))
		return
	if(!owner.head.vision_flags)
		to_chat(user,  SPAN_WARNING("Alternative sensor configurations not found. Contact manufacturer for more details."))
		return
	if(!owner.get_cell())
		to_chat(user,  SPAN_WARNING("The augmented vision systems are offline."))
		return
	owner.head.active_sensors = ..()
	to_chat(user, SPAN_NOTICE("[owner.head.name] advanced sensor mode is [owner.head.active_sensors ? "now" : "no longer" ] active."))

/obj/screen/exosuit/needle
	vis_flags = VIS_INHERIT_ID
	icon_state = "heatprobe_needle"

/obj/screen/exosuit/heat
	name = "heat probe"
	icon_state = "heatprobe"
	var/celsius = TRUE
	var/obj/screen/exosuit/needle/gauge_needle = null
	desc = "TEST"

/obj/screen/exosuit/heat/Initialize(mapload, mob/_owner, ui_style, ui_color, ui_alpha)
	. = ..()
	gauge_needle = new /obj/screen/exosuit/needle(null, _owner)
	add_vis_contents(gauge_needle)

/obj/screen/exosuit/heat/Destroy()
	QDEL_NULL(gauge_needle)
	. = ..()

/obj/screen/exosuit/heat/handle_click(mob/user, params)
	if(!..())
		return FALSE
	var/mob/living/exosuit/owner = get_owning_exosuit()
	var/modifiers = params2list(params)
	if(modifiers["shift"])
		if(owner.material)
			user.show_message(SPAN_NOTICE("Your suit's safe operating limit ceiling is [(celsius ? "[owner.material.temperature_damage_threshold - T0C] °C" : "[owner.material.temperature_damage_threshold] K" )]."), VISIBLE_MESSAGE)
		return TRUE
	if(modifiers["ctrl"])
		celsius = !celsius
		user.show_message(SPAN_NOTICE("You switch the chassis probe display to use [celsius ? "celsius" : "kelvin"]."), VISIBLE_MESSAGE)
		return TRUE
	if(owner.body && owner.body.diagnostics?.is_functional() && owner.loc)
		user.show_message(SPAN_NOTICE("The life support panel blinks several times as it updates:"), VISIBLE_MESSAGE)
		user.show_message(SPAN_NOTICE("Chassis heat probe reports temperature of [(celsius ? "[owner.bodytemperature - T0C] °C" : "[owner.bodytemperature] K" )]."), VISIBLE_MESSAGE)
		if(owner.material.temperature_damage_threshold < owner.bodytemperature)
			user.show_message(SPAN_WARNING("Warning: Current chassis temperature exceeds operating parameters."), VISIBLE_MESSAGE)
		var/air_contents = owner.loc.return_air()
		if(!air_contents)
			user.show_message(SPAN_WARNING("The external air probe isn't reporting any data!"), VISIBLE_MESSAGE)
		else
			user.show_message(SPAN_NOTICE("External probes report: [jointext(atmosanalyzer_scan(owner.loc, air_contents), "<br>")]"), VISIBLE_MESSAGE)
	else
		user.show_message(SPAN_WARNING("The life support panel isn't responding."), VISIBLE_MESSAGE)
	return TRUE

/obj/screen/exosuit/heat/proc/Update()
	//Relative value of heat
	var/mob/living/exosuit/owner = get_owning_exosuit()
	if(istype(owner) && owner.body && owner.body.diagnostics?.is_functional() && gauge_needle)
		var/value = clamp(owner.bodytemperature / (owner.material.temperature_damage_threshold * 1.55), 0, 1)
		var/matrix/rot_matrix = matrix()
		rot_matrix.Turn(Interpolate(-90, 90, value))
		rot_matrix.Translate(0, -2)
		animate(gauge_needle, transform = rot_matrix, 0.1, easing = SINE_EASING)

// This is basically just a holder for the updates the exosuit does.
/obj/screen/exosuit/health
	name = "exosuit integrity"
	icon_state = "health"

/obj/screen/exosuit/health/handle_click(mob/user, params)
	if(!..())
		return FALSE
	var/mob/living/exosuit/owner = get_owning_exosuit()
	if(!owner.body || !owner.get_cell() || !owner.body.diagnostics?.is_functional())
		return FALSE
	user.setClickCooldown(0.2 SECONDS)
	to_chat(user, SPAN_NOTICE("The diagnostics panel blinks several times as it updates:"))
	playsound(owner.loc,'sound/effects/scanbeep.ogg',30,0)
	for(var/obj/item/mech_component/MC in list(owner.arms, owner.legs, owner.body, owner.head))
		MC.return_diagnostics(user)
	return TRUE
