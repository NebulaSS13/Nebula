/mob
	density = 1
	plane = DEFAULT_PLANE
	layer = MOB_LAYER

	appearance_flags = PIXEL_SCALE | LONG_GLIDE
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

	var/shift_to_open_context_menu = FALSE

	var/mob_flags
	var/last_quick_move_time = 0
	var/list/client_images // Lazylist of images applied to/removed from the client on login/logout
	var/datum/mind/mind

	var/lastKnownIP = null
	var/computer_id = null
	var/last_ckey

	var/stat = CONSCIOUS //Whether a mob is alive or dead. TODO: Move this to living - Nodrak

	var/obj/screen/cells = null

	var/obj/screen/hands = null
	var/obj/screen/purged = null
	var/obj/screen/internals = null
	var/obj/screen/oxygen = null
	var/obj/screen/toxin = null
	var/obj/screen/fire = null
	var/obj/screen/bodytemp = null
	var/obj/screen/healths = null
	var/obj/screen/throw_icon = null
	var/obj/screen/nutrition_icon = null
	var/obj/screen/hydration_icon = null
	var/obj/screen/pressure = null
	var/obj/screen/pain = null
	var/obj/screen/up_hint = null
	var/obj/screen/gun/item/item_use_icon = null
	var/obj/screen/gun/radio/radio_use_icon = null
	var/obj/screen/gun/move/gun_move_icon = null
	var/obj/screen/gun/mode/gun_setting_icon = null

	var/obj/screen/movable/ability_master/ability_master = null

	/*A bunch of this stuff really needs to go under their own defines instead of being globally attached to mob.
	A variable should only be globally attached to turfs/objects/whatever, when it is in fact needed as such.
	The current method unnecessarily clusters up the variable list, especially for humans (although rearranging won't really clean it up a lot but the difference will be noticable for other mobs).
	I'll make some notes on where certain variable defines should probably go.
	Changing this around would probably require a good look-over the pre-existing code.
	*/
	var/obj/screen/zone_sel/zone_sel = null

	/// Cursor icon used when holding shift over things.
	var/examine_cursor_icon = 'icons/effects/mouse_pointers/examine_pointer.dmi'

	var/use_me = 1 //Allows all mobs to use the me verb by default, will have to manually specify they cannot
	var/damageoverlaytemp = 0
	var/obj/machinery/machine = null

	var/sdisabilities = 0	//Carbon
	var/disabilities = 0	//Carbon

	var/next_move = null
	var/real_name = null

	var/resting =    0
	var/lying =      0

	var/radio_interrupt_cooldown = 0    // TODO move this to /human

	var/unacidable = 0
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

	var/obj/buckled = null//Living
	var/obj/item/back = null//Human/Monkey
	var/obj/item/storage/s_active = null//Carbon
	var/obj/item/clothing/mask/wear_mask = null//Carbon
	var/in_throw_mode = 0

	var/can_pull_size = ITEM_SIZE_STRUCTURE // Maximum w_class the mob can pull.
	var/can_pull_mobs = MOB_PULL_SAME       // Whether or not the mob can pull other mobs.

	var/datum/dna/dna = null//Carbon
	var/list/active_genes
	var/list/mutations = list() // TODO: Lazylist this var.
	//see: setup.dm for list of mutations

	var/radiation = 0.0//Carbon

	var/voice_name = "unidentifiable voice"

	var/faction = MOB_FACTION_NEUTRAL //Used for checking whether hostile simple animals will attack you, possibly more stuff later
	var/blinded = null

	//The last mob/living/carbon to push/drag/grab this mob (mostly used by slimes friend recognition)
	var/weakref/last_handled_by_mob

	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

	var/update_icon = 1 //Set to 1 to trigger update_icon() at the next life() call

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

	var/datum/ai/ai						// Type abused. Define with path and will automagically create. Determines behaviour for clientless mobs.

	var/holder_type
