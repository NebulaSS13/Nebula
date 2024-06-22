/decl/configuration_category/server
	name = "Server"
	desc = "Configuration options relating to the server itself."
	associated_configuration = list(
		/decl/config/num/kick_inactive,
		/decl/config/num/fps,
		/decl/config/num/tick_limit_mc_init,
		/decl/config/num/minimum_byond_version,
		/decl/config/num/minimum_byond_build,
		/decl/config/num/player_limit,
		/decl/config/num/respawn_delay,
		/decl/config/num/cult_ghostwriter_req_cultists,
		/decl/config/num/character_slots,
		/decl/config/num/loadout_slots,
		/decl/config/num/max_maint_drones,
		/decl/config/num/drone_build_time,
		/decl/config/num/max_character_traits,
		/decl/config/text/irc_bot_host,
		/decl/config/text/main_irc,
		/decl/config/text/admin_irc,
		/decl/config/text/server_name,
		/decl/config/text/server,
		/decl/config/text/serverurl,
		/decl/config/text/banappeals,
		/decl/config/text/wikiurl,
		/decl/config/text/forumurl,
		/decl/config/text/discordurl,
		/decl/config/text/githuburl,
		/decl/config/text/issuereporturl,
		/decl/config/text/hosted_by,
		/decl/config/toggle/panic_bunker,
		/decl/config/text/panic_bunker_message,
		/decl/config/toggle/do_not_prevent_spam,
		/decl/config/toggle/no_throttle_localhost,
		/decl/config/toggle/on/abandon_allowed,
		/decl/config/toggle/on/ooc_allowed,
		/decl/config/toggle/on/looc_allowed,
		/decl/config/toggle/on/dooc_allowed,
		/decl/config/toggle/on/dsay_allowed,
		/decl/config/toggle/on/aooc_allowed,
		/decl/config/toggle/on/enter_allowed,
		/decl/config/toggle/on/allow_ai,
		/decl/config/toggle/on/allow_drone_spawn,
		/decl/config/toggle/hub_visibility,
		/decl/config/toggle/usewhitelist,
		/decl/config/toggle/load_jobs_from_txt,
		/decl/config/toggle/disable_player_mice,
		/decl/config/toggle/uneducated_mice,
		/decl/config/toggle/use_alien_whitelist,
		/decl/config/toggle/use_alien_whitelist_sql,
		/decl/config/toggle/forbid_singulo_possession,
		/decl/config/toggle/use_loyalty_implants,
		/decl/config/toggle/no_click_cooldown,
		/decl/config/toggle/disable_webhook_embeds,
		/decl/config/toggle/delist_when_no_admins,
		/decl/config/toggle/wait_for_sigusr1_reboot,
		/decl/config/toggle/use_irc_bot,
		/decl/config/toggle/show_typing_indicator_for_whispers,
		/decl/config/toggle/announce_shuttle_dock_to_irc,
		/decl/config/toggle/guests_allowed,
		/decl/config/toggle/on/jobs_have_minimal_access,
		/decl/config/toggle/on/admin_legacy_system,
		/decl/config/toggle/on/ban_legacy_system
	)

/decl/config/num/kick_inactive
	uid = "kick_inactive"
	desc = "Disconnect players who did nothing during the set amount of minutes."

/decl/config/num/fps
	uid = "fps"
	default_value = 20
	desc = list(
		"Defines world FPS. Defaults to 20.",
		"Can also accept ticklag values (0.9, 0.5, etc) which will automatically be converted to FPS."
	)

/decl/config/num/fps/sanitize_value()
	..()
	if(value <= 0)
		value = default_value

/decl/config/num/fps/set_value(new_value)
	// Handle ticklag-formatted FPS (0.7 etc)
	if(new_value > 0 && new_value < 1)
		new_value = round(10 / new_value)
	return ..(new_value)

/decl/config/num/fps/update_post_value_set()
	world.fps = value
	. = ..()

/decl/config/num/tick_limit_mc_init
	uid = "tick_limit_mc_init"
	desc = "SSinitialization throttling."
	default_value = TICK_LIMIT_MC_INIT_DEFAULT

/decl/config/num/minimum_byond_version
	uid = "minimum_byond_version"
	default_value = 0
	desc = "Clients will be unable to connect unless their version is equal to or higher than this (a number, e.g. 511)."

/decl/config/num/minimum_byond_build
	uid = "minimum_byond_build"
	default_value = 0
	desc = "Clients will be unable to connect unless their build is equal to or higher than this (a number, e.g. 1000)."

/decl/config/num/player_limit
	uid = "player_limit"
	desc = "The maximum number of non-admin players online."
	default_value = 0

/decl/config/num/use_age_restriction_for_jobs
	uid = "use_age_restriction_for_jobs"
	default_value = 0
	desc = list(
		"Unhash this entry to have certain jobs require your account to be at least a certain number of days old to select. You can configure the exact age requirement for different jobs by editing",
		"the minimal_player_age variable in the files in folder /code/game/jobs/job/.. for the job you want to edit. Set minimal_player_age to 0 to disable age requirement for that job.",
		"REQUIRES the database set up to work. Keep it hashed if you don't have a database set up.",
		"NOTE: If you have just set-up the database keep this DISABLED, as player age is determined from the first time they connect to the server with the database up. If you just set it up, it means",
		"you have noone older than 0 days, since noone has been logged yet. Only turn this on once you have had the database up for 30 days."
	)

/decl/config/num/use_age_restriction_for_antags
	uid = "use_age_restriction_for_antags"
	desc = list(
		"Unhash this entry to have certain antag roles require your account to be at least a certain number of days old for round start and auto-spawn selection.",
		"Non-automatic antagonist recruitment, such as being converted to cultism is not affected. Has the same database requirements and notes as USE_AGE_RESTRICTION_FOR_JOBS."
	)

/decl/config/num/respawn_delay
	uid = "respawn_delay"
	default_value = 30
	min_value = 0
	desc = "Respawn delay in minutes before one may respawn as a crew member."

/decl/config/num/cult_ghostwriter_req_cultists
	uid = "cult_ghostwriter_req_cultists"
	default_value = 10
	desc = "Sets the minimum number of cultists needed for ghosts to write in blood."

/decl/config/num/character_slots
	uid = "character_slots"
	default_value = 10
	desc = "Sets the number of available character slots."

/decl/config/num/loadout_slots
	uid = "loadout_slots"
	default_value = 3
	desc = "Sets the number of loadout slots per character."

/decl/config/num/max_maint_drones
	uid = "max_maint_drones"
	desc = "This many drones can be active at the same time."
	default_value = 5

/decl/config/num/drone_build_time
	uid = "drone_build_time"
	desc = "A drone will become available every X ticks since last drone spawn. Default is 2 minutes."
	default_value = 1200

/decl/config/num/max_character_traits
	uid = "max_character_traits"
	default_value = 5
	desc = "Remove the # to define a different cap for trait points in chargen."

/decl/config/text/irc_bot_host
	uid = "irc_bot_host"
	default_value = "localhost"
	desc = "Host where the IRC bot is hosted. Port 45678 needs to be open."

/decl/config/text/main_irc
	uid = "main_irc"
	default_value = "#main"
	desc = "IRC channel to send information to. Leave blank to disable."

/decl/config/text/admin_irc
	uid = "admin_irc"
	desc = "IRC channel to send adminhelps to. Leave blank to disable adminhelps-to-irc."

// server name (for world name / status)
/decl/config/text/server_name
	uid = "server_name"
	desc = "Server name: This appears at the top of the screen in-game."
	default_value = "Nebula 13"

/decl/config/text/server
	uid = "server"
	desc = "Set a server location for world reboot. Don't include the byond://, just give the address and port."

/decl/config/text/serverurl
	uid = "serverurl"
	desc = list(
		"Set a server URL for the IRC bot to use; like SERVER, don't include the byond://",
		"Unlike SERVER, this one shouldn't break auto-reconnect."
	)

/decl/config/text/banappeals
	uid = "banappeals"
	desc = "Ban appeals URL - usually for a forum or wherever people should go to contact your admins."

/decl/config/text/wikiurl
	uid = "wikiurl"
	desc = "Wiki address."

/decl/config/text/forumurl
	uid = "forumurl"
	desc = "Discussion forum address."

/decl/config/text/discordurl
	uid = "discordurl"
	desc = "Discord server permanent invite address."

/decl/config/text/githuburl
	uid = "githuburl"
	desc = "GitHub address."

/decl/config/text/issuereporturl
	uid = "issuereporturl"
	desc = "GitHub new issue address."

/decl/config/text/hosted_by
	uid = "hostedby"
	desc = "Set a hosted by name for UNIX platforms."

/decl/config/toggle/panic_bunker
	uid = "panic_bunker"
	desc = "Is the panic bunker currently on by default?"

/decl/config/text/panic_bunker_message
	uid = "panic_bunker_message"
	default_value = "Sorry! The panic bunker is enabled. Please head to our Discord or forum to get yourself added to the panic bunker bypass."
	desc = "A message when user did not pass the panic bunker."

/decl/config/toggle/do_not_prevent_spam
	uid = "do_not_prevent_spam"
	desc = "Determines if action spam kicking should be DISABLED. Not recommended; this helps protect from spam attacks."

/decl/config/toggle/no_throttle_localhost
	uid = "no_throttle_localhost"
	desc = list(
		"Whether or not to make localhost immune to throttling.",
		"Localhost will still be throttled internally; it just won't be affected by it."
	)

/decl/config/toggle/on/abandon_allowed
	uid = "abandon_allowed"
	desc = "Comment to disable respawning by default."

/decl/config/toggle/on/ooc_allowed
	uid = "ooc_allowed"
	desc = "Comment to disable the OOC channel by default."

/decl/config/toggle/on/looc_allowed
	uid = "looc_allowed"
	desc = "Comment to disable the LOOC channel by default."

/decl/config/toggle/on/dooc_allowed
	uid = "dooc_allowed"
	desc = "Comment to disable the dead OOC channel by default."

/decl/config/toggle/on/dsay_allowed
	uid = "dsay_allowed"
	desc = "Comment to disable ghost chat by default."

/decl/config/toggle/on/aooc_allowed
	uid = "aooc_allowed"
	desc = "Comment to disable the AOOC channel by default."

/decl/config/toggle/on/enter_allowed
	uid = "enter_allowed"
	desc = "Comment to prevent anyone from joining the round by default."

/decl/config/toggle/on/allow_ai
	uid = "allow_ai"
	desc = "Allow AI job."

/decl/config/toggle/on/allow_drone_spawn
	uid = "allow_drone_spawn"
	desc = "Allow ghosts to join as maintenance drones."

/decl/config/toggle/hub_visibility
	uid = "hub_visibility"
	desc = "Hub visibility: If you want to be visible on the hub, uncomment the below line and be sure that Dream Daemon is set to visible. This can be changed in-round as well with toggle-hub-visibility if Dream Daemon is set correctly."

/decl/config/toggle/hub_visibility/update_post_value_set()
	. = ..()
	world.update_hub_visibility()

/decl/config/toggle/usewhitelist
	uid = "usewhitelist"
	desc = list(
		"Set to jobban everyone who's key is not listed in data/whitelist.txt from Captain, HoS, HoP, CE, RD, CMO, Warden, Security, Detective, and AI positions.",
		"Uncomment to 1 to jobban, leave commented out to allow these positions for everyone (but see GUEST_JOBBAN above and regular jobbans)."
	)

/decl/config/toggle/load_jobs_from_txt
	uid = "load_jobs_from_txt"
	desc = "Toggle for having jobs load up from the .txt"

/decl/config/toggle/disable_player_mice
	uid = "disable_player_mice"

/decl/config/toggle/uneducated_mice
	uid = "uneducated_mice"
	desc = "Set to 1 to prevent newly-spawned mice from understanding human speech."

/decl/config/toggle/use_alien_whitelist
	uid = "usealienwhitelist"
	desc = "Determines if non-admins are restricted from using humanoid alien races."

/decl/config/toggle/use_alien_whitelist_sql
	uid = "usealienwhitelist_sql"
	desc = "Determines if the alien whitelist should use SQL instead of the legacy system. (requires the above uncommented as well)."

/decl/config/toggle/forbid_singulo_possession
	uid = "forbid_singulo_possession"
	desc = "Remove the # mark infront of this to forbid admins from posssessing the singularity."

/decl/config/toggle/use_loyalty_implants
	uid = "use_loyalty_implants"
	desc = "Remove the # in front of this config option to have loyalty implants spawn by default on your server."

/decl/config/toggle/no_click_cooldown
	uid = "no_click_cooldown"

/decl/config/toggle/disable_webhook_embeds
	uid = "disable_webhook_embeds"
	desc = "Determines if Discord webhooks should be sent in plaintext rather than as embeds."

/decl/config/toggle/delist_when_no_admins
	uid = "delist_when_no_admins"
	desc = "Determines if the server should hide itself from the hub when no admins are online.."

/decl/config/toggle/wait_for_sigusr1_reboot
	uid = "wait_for_sigusr1_reboot"
	desc = "Determines if Dream Daemon should refuse to reboot for any reason other than SIGUSR1."

/decl/config/toggle/use_irc_bot
	uid = "use_irc_bot"
	desc = "Determines if data is sent to the IRC bot. Generally requires MAIN_IRC and associated setup."

/decl/config/toggle/show_typing_indicator_for_whispers
	uid = "show_typing_indicator_for_whispers"
	desc = "Determinese if a typing indicator shows overhead for people currently writing whispers."

/decl/config/toggle/announce_shuttle_dock_to_irc
	uid = "announce_shuttle_dock_to_irc"
	desc = "Determines if announce shuttle dock announcements are sent to the main IRC channel, if MAIN_IRC has also been setup."

/decl/config/toggle/guests_allowed
	uid = "guests_allowed"
	desc = "Determines whether or not people without a registered ckey (i.e. guest-*) can connect to your server."

/decl/config/toggle/on/ban_legacy_system
	uid = "ban_legacy_system"
	desc = "Add a # infront of this if you want to use the SQL based banning system. The legacy systems use the files in the data folder. You need to set up your database to use the SQL based system."

/decl/config/toggle/on/admin_legacy_system
	uid = "admin_legacy_system"
	desc = "Add a # infront of this if you want to use the SQL based admin system, the legacy system uses admins.txt. You need to set up your database to use the SQL based system."

/decl/config/toggle/on/jobs_have_minimal_access
	uid = "jobs_have_minimal_access"
	desc = "Add a # here if you wish to use the setup where jobs have more access. This is intended for servers with low populations - where there are not enough players to fill all roles, so players need to do more than just one job. Also for servers where they don't want people to hide in their own departments."
