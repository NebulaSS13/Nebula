/decl/configuration_category/ninja
	name = "Ninja"
	desc = "Configuration options relating to the Ninja gamemode and antagonist."
	configuration_file_location = "config/gamemodes/ninja.txt"
	associated_configuration = list(
		/decl/config/toggle/ninjas_allowed
	)

/decl/config/toggle/ninjas_allowed
	uid = "random_ninjas_allowed"
	desc = "Remove the # to let ninjas spawn in random antag events."

// verbs
/datum/admins/proc/toggle_space_ninja()
	set category = "Server"
	set desc="Toggle space ninjas spawning as random antags."
	set name="Toggle Space Ninjas"
	if(!check_rights(R_ADMIN))
		return
	toggle_config_value(/decl/config/toggle/ninjas_allowed)
	log_and_message_admins("toggled Space Ninjas [get_config_value(/decl/config/toggle/ninjas_allowed) ? "on" : "off"].")
	SSstatistics.add_field_details("admin_verb","TSN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
