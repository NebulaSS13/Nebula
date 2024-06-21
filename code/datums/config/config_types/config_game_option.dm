/decl/configuration_category/game_options
	name = "Game Options"
	desc = "Configuration options relating to gameplay, such as movement, health and stamina."
	associated_configuration = list(
		/decl/config/num/movement_human,
		/decl/config/num/movement_robot,
		/decl/config/num/movement_animal,
		/decl/config/num/movement_run,
		/decl/config/num/movement_walk,
		/decl/config/num/movement_creep,
		/decl/config/num/movement_glide_size,
		/decl/config/num/movement_min_sprint_cost,
		/decl/config/num/movement_skill_sprint_cost_range,
		/decl/config/num/movement_min_stamina_recovery,
		/decl/config/num/movement_max_stamina_recovery,
		/decl/config/num/max_gear_cost,
		/decl/config/num/max_acts_per_interval,
		/decl/config/num/act_interval,
		/decl/config/num/dex_malus_brainloss_threshold,
		/decl/config/num/default_darksight_range,
		/decl/config/num/default_darksight_effectiveness,
		/decl/config/toggle/grant_default_darksight,
		/decl/config/num/expected_round_length,
		/decl/config/toggle/on/allow_diagonal_movement,
		/decl/config/toggle/expanded_alt_interactions,
		/decl/config/toggle/ert_admin_call_only,
		/decl/config/toggle/ghosts_can_possess_animals,
		/decl/config/toggle/assistant_maint,
		/decl/config/toggle/ghost_interaction,
		/decl/config/toggle/aliens_allowed,
		/decl/config/toggle/allow_character_comments,
		/decl/config/num/hide_comments_older_than,
		/decl/config/toggle/stack_crafting_uses_tools,
		/decl/config/toggle/on/stack_crafting_uses_types
	)

/decl/config/num/movement_human
	uid = "human_delay"
	desc = "These modify the run/walk speed of all mobs before the mob-specific modifiers are applied."

/decl/config/num/movement_robot
	uid = "robot_delay"
	desc = "These modify the run/walk speed of all mobs before the mob-specific modifiers are applied."

/decl/config/num/movement_animal
	uid = "animal_delay"
	desc = "These modify the run/walk speed of all mobs before the mob-specific modifiers are applied."

/decl/config/num/movement_run
	uid = "run_delay"
	default_value = 2
	desc = "These modify the run/walk speed of all mobs before the mob-specific modifiers are applied."

/decl/config/num/movement_walk
	uid = "walk_delay"
	default_value = 4
	desc = "These modify the run/walk speed of all mobs before the mob-specific modifiers are applied."

/decl/config/num/movement_creep
	uid = "creep_delay"
	default_value = 6
	desc = "These modify the run/walk speed of all mobs before the mob-specific modifiers are applied."

/decl/config/num/movement_glide_size
	uid = "glide_size_delay"
	default_value = 1
	desc = "Set this to 0 for perfectly smooth movement gliding, or 1 or more for delayed chess move style movements."

/decl/config/num/movement_min_sprint_cost
	uid = "minimum_sprint_cost"
	default_value = 0.8
	rounding = 0.01
	desc = "Value used for expending stamina during sprinting."

/decl/config/num/movement_skill_sprint_cost_range
	uid = "skill_sprint_cost_range"
	default_value = 0.8
	rounding = 0.01
	desc = "Determines the severity of athletics skill when applied to stamina cost."

/decl/config/num/movement_min_stamina_recovery
	uid = "minimum_stamina_recovery"
	default_value = 1
	desc = "Minimum stamina recovered per tick when resting."

/decl/config/num/movement_max_stamina_recovery
	uid = "maximum_stamina_recovery"
	default_value = 3
	desc = "Maximum stamina recovered per tick when resting."

/decl/config/num/max_gear_cost
	uid = "max_gear_cost"
	default_value = 10
	desc = "How many loadout points are available. Use 0 to disable loadout, and any negative number to indicate infinite points."

/decl/config/num/max_gear_cost/sanitize_value()
	..()
	if(value < 0)
		value = INFINITY

/decl/config/num/max_acts_per_interval
	uid = "max_acts_per_interval"
	default_value = 140
	desc = "Defines the number of actions permitted per interval before a user is kicked for spam."

/decl/config/num/act_interval
	uid = "act_interval"
	default_value = 0.1
	rounding = 0.01
	desc = "Determines the length of the spam kicking interval in seconds."

/decl/config/num/dex_malus_brainloss_threshold
	uid = "dex_malus_brainloss_threshold"
	default_value = 30
	desc = "Threshold of where brain damage begins to affect dexterity (70 brainloss above this means zero dexterity). Default is 30."

/decl/config/num/default_darksight_range
	uid = "default_darksight_range"
	default_value = 2
	desc = "The range of default darksight if above is uncommented."

/decl/config/num/default_darksight_effectiveness
	uid = "default_darksight_effectiveness"
	default_value = 0.05
	rounding = 0.01
	desc = "The effectiveness of default darksight if above is uncommented."

/decl/config/num/expected_round_length
	uid = "expected_round_length"
	default_value = 3
	desc = "Expected round length in hours."

/decl/config/toggle/grant_default_darksight
	uid = "grant_default_darksight"
	desc = "Whether or not all human mobs have very basic darksight by default."

/decl/config/toggle/on/allow_diagonal_movement
	uid = "allow_diagonal_movement"
	desc = "Allow multiple input keys to be pressed for diagonal movement."

/decl/config/toggle/expanded_alt_interactions
	uid = "expanded_alt_interactions"
	desc = "Determines if objects should provide expanded alt interactions when alt-clicked, such as use or grab."

/decl/config/toggle/ert_admin_call_only
	uid = "ert_admin_call_only"
	desc = "Restricted ERT to be only called by admins."

/decl/config/toggle/ghosts_can_possess_animals
	uid = "ghosts_can_possess_animals"
	desc = "Determines of ghosts are allowed to possess any animal."

/decl/config/toggle/assistant_maint
	uid = "assistant_maint"
	desc = "Remove the # to give assistants maint access."

/decl/config/toggle/ghost_interaction
	uid = "ghost_interaction"
	desc = "Remove the # to let ghosts spin chairs."

/decl/config/toggle/aliens_allowed
	uid = "aliens_allowed"
	desc = "Remove the # to let aliens spawn."

/decl/config/toggle/allow_character_comments
	uid = "allow_character_comments"
	desc = "Remove the # to allow people to leave public comments on each other's characters via the comments system."

/decl/config/num/hide_comments_older_than
	uid = "hide_comments_older_than"
	desc = "Specify a number of days after which to hide comments on public profiles (to avoid bloat from retired characters)."

/decl/config/toggle/stack_crafting_uses_tools
	uid = "stack_crafting_uses_tools"
	desc = "Enables or disables checking for specific tool types by some stack crafting recipes."

/decl/config/toggle/on/stack_crafting_uses_types
	uid = "stack_crafting_uses_types"
	desc = "Enables or disables checking for specific stack types by some stack crafting recipes."
