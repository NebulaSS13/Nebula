/mob/living/silicon/robot/syndicate
	lawupdate = 0
	scrambledcodes = 1
	icon_state = "securityrobot"
	modtype = "Security"
	lawchannel = "State"
	idcard = /obj/item/card/id/syndicate
	module = /obj/item/robot_module/syndicate
	silicon_radio = /obj/item/radio/borg/syndicate
	spawn_sound = 'sound/mecha/nominalsyndi.ogg'
	cell = /obj/item/cell/super
	pitch_toggle = 0

/mob/living/silicon/robot/syndicate/Initialize(mapload, supplied_lawset)
	. = ..(mapload, supplied_lawset || /decl/lawset/syndicate_override)
	
/mob/living/silicon/robot/combat
	lawupdate = 0
	scrambledcodes = 1
	modtype = "Combat"
	module = /obj/item/robot_module/security/combat
	spawn_sound = 'sound/mecha/nominalsyndi.ogg'
	cell = /obj/item/cell/super
	pitch_toggle = 0
