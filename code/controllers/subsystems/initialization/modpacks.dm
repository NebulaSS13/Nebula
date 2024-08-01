SUBSYSTEM_DEF(modpacks)
	name = "Modpacks"
	init_order = SS_INIT_MODPACKS
	flags = SS_NO_FIRE
	var/list/loaded_modpacks = list()

	// Compiled modpack information.
	var/list/default_submap_whitelisted_species = list()
	var/list/default_submap_blacklisted_species = list(SPECIES_ALIEN, SPECIES_GOLEM)

/datum/controller/subsystem/modpacks/Initialize()
	var/list/all_modpacks = decls_repository.get_decls_of_subtype(/decl/modpack)

	// Pre-init and register all compiled modpacks.
	for(var/package in all_modpacks)
		var/decl/modpack/manifest = all_modpacks[package]
		var/fail_msg = manifest.pre_initialize()
		if(QDELETED(manifest))
			PRINT_STACK_TRACE("Modpack of type [package] is null or queued for deletion.")
			continue
		if(fail_msg)
			PRINT_STACK_TRACE("Modpack [manifest.name] ([package]) failed to pre-initialize: [fail_msg].")
			continue
		if(loaded_modpacks[manifest.name])
			PRINT_STACK_TRACE("Attempted to register duplicate modpack name [manifest.name].")
			continue
		loaded_modpacks[manifest.name] = manifest

	// Handle init and post-init (two stages in case a modpack needs to implement behavior based on the presence of other packs).
	for(var/package in all_modpacks)
		var/decl/modpack/manifest = all_modpacks[package]
		var/fail_msg = manifest.initialize()
		if(fail_msg)
			PRINT_STACK_TRACE("Modpack [(istype(manifest) && manifest.name) || "Unknown"] failed to initialize: [fail_msg]")
	for(var/package in all_modpacks)
		var/decl/modpack/manifest = all_modpacks[package]
		var/fail_msg = manifest.post_initialize()
		if(fail_msg)
			PRINT_STACK_TRACE("Modpack [(istype(manifest) && manifest.name) || "Unknown"] failed to post-initialize: [fail_msg]")

	// Update compiled infolists and apply.
	default_submap_whitelisted_species |= global.using_map.default_species
	for(var/decl/submap_archetype/submap in decls_repository.get_decls_unassociated(/decl/submap_archetype))
		if(islist(submap.whitelisted_species) && !length(submap.whitelisted_species))
			submap.whitelisted_species |= SSmodpacks.default_submap_whitelisted_species
		if(islist(submap.blacklisted_species) && !length(submap.blacklisted_species))
			submap.blacklisted_species |= SSmodpacks.default_submap_blacklisted_species

	. = ..()
