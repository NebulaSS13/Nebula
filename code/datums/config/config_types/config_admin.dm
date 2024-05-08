/decl/configuration_category/admin
	name = "Admin"
	desc = "Configuration options relating to administration."
	associated_configuration = list(
		/decl/config/num/mod_tempban_max,
		/decl/config/num/mod_job_tempban_max,
		/decl/config/num/autostealth,
		/decl/config/toggle/on/guest_jobban,
		/decl/config/toggle/on/auto_local_admin,
		/decl/config/toggle/on/admin_jump,
		/decl/config/toggle/on/admin_spawning,
		/decl/config/toggle/on/admin_revive,
		/decl/config/toggle/admin_ooccolor,
		/decl/config/toggle/mods_can_job_tempban,
		/decl/config/toggle/mods_can_tempban,
		/decl/config/toggle/allow_unsafe_narrates
	)

/decl/config/num/mod_tempban_max
	uid = "mod_tempban_max"
	default_value = 1440
	desc = "Maximum mod tempban duration (in minutes)."

/decl/config/num/mod_job_tempban_max
	uid = "mod_job_tempban_max"
	default_value = 1440
	desc = "Maximum mod job tempban duration (in minutes)."

/decl/config/num/autostealth
	uid = "autostealth"
	default_value = 0
	desc = "Sets a value in minutes after which to auto-hide staff who are AFK."

/decl/config/toggle/on/guest_jobban
	uid = "guest_jobban"
	desc = list(
		"Set to jobban 'Guest-' accounts from Captain, HoS, HoP, CE, RD, CMO, Warden, Security, Detective, and AI positions.",
		"Set to 1 to jobban them from those positions, set to 0 to allow them."
	)

/decl/config/toggle/on/auto_local_admin
	uid = "auto_local_admin"
	desc = "Set to 0/1 to disable/enable automatic admin rights for users connecting from the host the server is running on."

/decl/config/toggle/on/admin_jump
	uid = "allow_admin_jump"
	desc = "Allows admin jumping."

/decl/config/toggle/on/admin_spawning
	uid = "allow_admin_spawning"
	desc = "Allows admin item spawning."

/decl/config/toggle/on/admin_revive
	uid = "allow_admin_rev"
	desc = "Allows admin revives."

/decl/config/toggle/admin_ooccolor
	uid = "allow_admin_ooccolor"
	desc = "Comment this out to stop admins being able to choose their personal OOC color."

/decl/config/toggle/mods_can_tempban
	uid = "mods_can_tempban"
	desc = "Chooses whether mods have the ability to tempban or not."

/decl/config/toggle/mods_can_job_tempban
	uid = "mods_can_job_tempban"
	desc = "Chooses whether mods have the ability to issue tempbans for jobs or not."

/decl/config/toggle/allow_unsafe_narrates
	uid = "allow_unsafe_narrates"
	desc = "Determines if admins are allowed to narrate using HTML tags."

/decl/config/toggle/visible_examine
	uid = "visible_examine"
	desc = "Determines if a visible message should be shown when someone examines something ('Dave looks at you.')."

/decl/config/toggle/allow_loadout_customization
	uid = "loadout_customization"
	desc = "Determines if all loadout items are allowed to have name and desc customized by default."
