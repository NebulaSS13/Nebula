/decl/special_role/ert
	name = "Emergency Responder"
	name_plural = "Emergency Responders"
	antag_text = "You are an <b>anti</b> antagonist! Within the rules, \
		try to save the installation and its inhabitants from the ongoing crisis. \
		Try to make sure other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those without explicit exceptions apply to the ERT.</b>"
	welcome_text = "You shouldn't see this"
	leader_welcome_text = "You shouldn't see this"
	landmark_id = "Response Team"

	flags = ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED
	antaghud_indicator = "hudloyalist"
	default_access = list(access_cent_specops)

	hard_cap = 5
	hard_cap_round = 7
	initial_spawn_req = 5
	initial_spawn_target = 7
	show_objectives_on_creation = 0 //we are not antagonists, we do not need the antagonist shpiel/objectives
	default_outfit = /decl/hierarchy/outfit/ert
	base_to_load = "ERT Base"

/decl/special_role/ert/create_default(var/mob/source)
	var/mob/living/human/M = ..()
	if(istype(M))
		M.set_age(rand(25,45))

/decl/special_role/ert/Initialize()
	. = ..()
	leader_welcome_text = "As leader of the Emergency Response Team, you answer only to [global.using_map.company_name], and have authority to override the Captain where it is necessary to achieve your mission goals. It is recommended that you attempt to cooperate with the captain where possible, however."
	welcome_text = "As member of the Emergency Response Team, you answer only to your leader and [global.using_map.company_name] officials."

/decl/special_role/ert/greet(var/datum/mind/player)
	if(!..())
		return
	to_chat(player.current, "The Emergency Response Team works for Asset Protection; your job is to protect [global.using_map.company_name]'s ass-ets. There is a code red alert on [station_name()], you are tasked to go and fix the problem.")
	to_chat(player.current, "You should first gear up and discuss a plan with your team. More members may be joining, don't move out before you're ready.")

//Equip proc has been moved to the map specific folders.
