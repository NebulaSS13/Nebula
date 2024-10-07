/*

	ABILITY DECL SYSTEM NOTES

	- Mobs have an extension, /datum/extension/abilities
	- This extension has a list of associated handlers, /datum/ability_handler
	- The handlers have a list of associated ability decls, /decl/ability, which are indexes for associative metadata lists.
	- The abilities have an associated targeting handler, /decl/ability_targeting, which handles single target, turf target, AOE, etc.
	- Handlers are added/removed with mob.add_ability_handler(handler_type) and mob.remove_ability_handler(handler_type)
	- The extension will be added to the mob automatically when adding a handler, and removed if the last handler is removed.
	- Abilities are added/removed with mob.add_ability(ability_type, preset metadata if any) and mob.remove_ability(ability_type)
	- Handlers for abilities will be inferred from the /decl and added to the mob automatically.
	- Metadata is retrieved with handler.get_metadata(ability type or instance)

	- Upon invocation, an ability will:
		- retrieve handler and metadata from the user mob
		- validate the handler/metadata/user against whatever requirements the ability has
		- resolve the initial click target to the appropriate target for the ability (turf under the clicked target for example)
		- check any additional requirements like charges, cooldowns, etc.
		- if a projectile ability, spawn and launch a projectile that will carry the ability and metadata to the destination target.
		- apply the ability to the destination target
		- while applying the ability, the targeting decl will be used to grab all applicable targets at or near the point of use (projectile hit or clicked target)
		- the ability effects will then get applied (fire, ice, explosion, so on)
		- the ability will then set cooldown as appropriate in metadata, deduct charges, etc

*/