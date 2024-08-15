/obj/screen/pai
	icon = 'icons/mob/screen/pai.dmi'
	abstract_type = /obj/screen/pai
	requires_ui_style = FALSE
	user_incapacitation_flags = INCAPACITATION_KNOCKOUT

/obj/screen/pai/shell
	name = "Toggle Chassis"

/obj/screen/pai/rest
	name = "Rest"

/obj/screen/pai/light
	name = "Toggle Light"

/obj/screen/pai/software
	name = "Software Interface"
	icon_state = "pai"
	screen_loc = ui_pai_software

/obj/screen/pai/software/handle_click(mob/user, params)
	var/mob/living/silicon/pai/pai = user
	if(istype(pai))
		pai.paiInterface()

/obj/screen/pai/shell
	name = "Toggle Chassis"
	icon_state = "pai_holoform"
	screen_loc = ui_pai_shell

/obj/screen/pai/shell/handle_click(mob/user, params)
	var/mob/living/silicon/pai/pai = user
	if(istype(pai))
		if(pai.is_in_card)
			pai.unfold()
		else
			pai.fold()

/obj/screen/pai/chassis
	name = "Holochassis Appearance Composite"
	icon_state = "pai_holoform"

/obj/screen/pai/rest
	name = "Rest"
	icon_state = "pai_rest"
	screen_loc = ui_pai_rest

/obj/screen/pai/rest/handle_click(mob/user, params)
	var/mob/living/silicon/pai/pai = user
	if(istype(pai))
		pai.lay_down()

/obj/screen/pai/light
	name = "Toggle Integrated Lights"
	icon_state = "light"
	screen_loc = ui_pai_light

/obj/screen/pai/light/handle_click(mob/user, params)
	var/mob/living/silicon/pai/pai = user
	if(istype(pai))
		pai.toggle_integrated_light()

/obj/screen/pai/subsystems
	name = "Subsystems"
	icon_state = "subsystems"
	screen_loc = ui_pai_subsystems

/obj/screen/pai/subsystems/handle_click(mob/user, params)
	var/mob/living/silicon/pai/pai = user
	if(istype(pai))
		var/ss_name = input(usr, "Activates the given subsystem", "Subsystems", "") in pai.silicon_subsystems_by_name
		if (!ss_name)
			return
		var/stat_silicon_subsystem/SSS = pai.silicon_subsystems_by_name[ss_name]
		if(istype(SSS))
			SSS.Click()
