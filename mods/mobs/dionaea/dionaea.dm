/decl/modpack/dionaea
	name = "Diona Nymphs"

/decl/modpack/dionaea/initialize()
	. = ..()
	LAZYSET(global.holder_mob_icons, "nymph", 'mods/mobs/dionaea/icons/nymph_holder.dmi')
