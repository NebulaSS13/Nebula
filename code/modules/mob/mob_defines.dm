/mob
	density = TRUE
	plane = DEFAULT_PLANE
	layer = MOB_LAYER
	abstract_type = /mob
	is_spawnable_type = TRUE

	appearance_flags = DEFAULT_APPEARANCE_FLAGS | LONG_GLIDE
	animate_movement = 2
	movable_flags = MOVABLE_FLAG_PROXMOVE

	virtual_mob = /mob/observer/virtual/mob

	movement_handlers = list(
		/datum/movement_handler/mob/death,
		/datum/movement_handler/mob/conscious,
		/datum/movement_handler/mob/eye,
		/datum/movement_handler/move_relay,
		/datum/movement_handler/mob/buckle_relay,
		/datum/movement_handler/mob/delay,
		/datum/movement_handler/mob/stop_effect,
		/datum/movement_handler/mob/physically_capable,
		/datum/movement_handler/mob/physically_restrained,
		/datum/movement_handler/mob/space,
		/datum/movement_handler/mob/multiz,
		/datum/movement_handler/mob/movement
	)

	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

	var/shift_to_open_context_menu = FALSE

	var/mob_flags
	var/last_quick_move_time = 0
	var/list/client_images // Lazylist of images applied to/removed from the client on login/logout
	var/datum/mind/mind

	var/lastKnownIP = null
	var/computer_id = null
	var/last_ckey

	var/stat = CONSCIOUS //Whether a mob is alive or dead. TODO: Move this to living - Nodrak

	var/obj/screen/robot_module/select/hands
	var/obj/screen/warning_cells/cells
	var/obj/screen/internals/internals
	var/obj/screen/oxygen/oxygen
	var/obj/screen/toxins/toxin
	var/obj/screen/fire_warning/fire
	var/obj/screen/bodytemp/bodytemp
	var/obj/screen/health_warning/healths
	var/obj/screen/throw_toggle/throw_icon
	var/obj/screen/maneuver/maneuver_icon
	var/obj/screen/food/nutrition_icon
	var/obj/screen/drink/hydration_icon
	var/obj/screen/pressure/pressure
	var/obj/screen/fullscreen/pain/pain
	var/obj/screen/up_hint/up_hint
	var/obj/screen/gun/item/item_use_icon
	var/obj/screen/gun/radio/radio_use_icon
	var/obj/screen/gun/move/gun_move_icon
	var/obj/screen/gun/mode/gun_setting_icon
	var/obj/screen/ability_master/ability_master

	/*A bunch of this stuff really needs to go under their own defines instead of being globally attached to mob.
	A variable should only be globally attached to turfs/objects/whatever, when it is in fact needed as such.
	The current method unnecessarily clusters up the variable list, especially for humans (although rearranging won't really clean it up a lot but the difference will be noticable for other mobs).
	I'll make some notes on where certain variable defines should probably go.
	Changing this around would probably require a good look-over the pre-existing code.
	*/
	var/obj/screen/zone_selector/zone_sel = null

	/// Cursor icon used when holding shift over things.
	var/examine_cursor_icon = 'icons/effects/mouse_pointers/examine_pointer.dmi'

	var/damageoverlaytemp = 0
	var/obj/machinery/machine = null

	var/next_move = null
	var/real_name = null

	var/radio_interrupt_cooldown = 0    // TODO move this to /human

	var/list/pinned                     // Lazylist of things pinning this creature to walls (see living_defense.dm)
	var/list/embedded                   // Embedded items, since simple mobs don't have organs.
	var/list/languages = list()         // TODO: lazylist this var. For speaking/listening.
	var/species_language = null			// For species who want reset to use a specified default.
	var/only_species_language  = 0		// For species who can only speak their default and no other languages. Does not effect understanding.
	var/list/speak_emote = list("says") // Verbs used when speaking. Defaults to 'say' if speak_emote is null.
	var/emote_type = 1		// Define emote default type, 1 for seen emotes, 2 for heard emotes
	var/facing_dir = null   // Used for the ancient art of moonwalking.

	var/name_archive //For admin things like possession
	var/mob_sort_value = INFINITY // used for sorted player list, higher means closer to the bottom of the list.
	var/timeofdeath = 0

	var/bodytemperature = 310.055	//98.7 F

	var/shakecamera = 0
	var/a_intent = I_HELP//Living

	var/decl/move_intent/move_intent = /decl/move_intent/walk
	var/list/move_intents = list(/decl/move_intent/walk)

	var/decl/move_intent/default_walk_intent
	var/decl/move_intent/default_run_intent

	var/datum/storage/active_storage
	var/obj/buckled = null//Living
	var/in_throw_mode = 0

	var/can_pull_size = ITEM_SIZE_STRUCTURE // Maximum w_class the mob can pull.
	var/can_pull_mobs = MOB_PULL_SAME       // Whether or not the mob can pull other mobs.

	var/radiation = 0.0//Carbon

	var/faction = MOB_FACTION_NEUTRAL //Used for checking whether hostile simple animals will attack you, possibly more stuff later

	//The last mob/living to push/drag/grab this mob (mostly used by slimes friend recognition)
	var/weakref/last_handled_by_mob

	var/status_flags = CANSTUN|CANWEAKEN|CANPARALYSE|CANPUSH	//bitflags defining which status effects can be inflicted (replaces canweaken, canstun, etc)

	var/area/lastarea = null

	var/digitalcamo = 0 // Can they be tracked by the AI?

	var/obj/control_object //Used by admins to possess objects. All mobs should have this var

	//Whether or not mobs can understand other mobtypes. These stay in /mob so that ghosts can hear everything.
	var/universal_speak = FALSE // Set to TRUE to enable the mob to speak to everyone -- TLE
	var/universal_understand = FALSE // Set to TRUE to enable the mob to understand everyone, not necessarily speak

	//If set, indicates that the client "belonging" to this (clientless) mob is currently controlling some other mob
	//so don't treat them as being SSD even though their client var is null.
	var/mob/teleop = null

	var/turf/listed_turf  //the current turf being examined in the stat panel
	var/list/shouldnt_see // Lazylist of objects that this mob shouldn't see in the stat panel. this silliness is needed because of AI alt+click and cult blood runes

	var/mob_size = MOB_SIZE_MEDIUM

	var/flavor_text = ""

	var/datum/skillset/skillset = /datum/skillset

	var/list/additional_vision_handlers // A lazylist of atoms from which additional vision data is retrieved

	var/list/progressbars = null //for stacking do_after bars

	var/datum/mob_controller/ai						// Type abused. Define with path and will automagically create. Determines behaviour for clientless mobs.

	var/holder_type
	/// If this mob is or was piloted by a player with typing indicators enabled, an instance of one.
	var/atom/movable/typing_indicator/typing_indicator
	/// Whether this mob is currently typing, if piloted by a player.
	var/is_typing

	/// Used for darksight, required on all mobs to ensure lighting renders properly.
	var/obj/screen/lighting_plane_master/lighting_master

	// Offset the overhead text if necessary.
	var/offset_overhead_text_x = 0
	var/offset_overhead_text_y = 0