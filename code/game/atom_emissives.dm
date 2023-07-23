/atom/movable/proc/update_emissive_blocker()
	if (!blocks_emissive)
		return
	if (blocks_emissive == EMISSIVE_BLOCK_GENERIC)
		return fast_emissive_blocker(src)
	if (blocks_emissive == EMISSIVE_BLOCK_UNIQUE)
		if (!em_block && !QDELETED(src))
			appearance_flags |= KEEP_TOGETHER
			render_target = ref(src)
			var/mutable_appearance/gen_emissive_blocker = emissive_blocker(
				icon = icon,
				appearance_flags = appearance_flags,
				source = render_target
			)
			em_block = gen_emissive_blocker
		return em_block

/atom/movable/update_overlays()
	. = ..()
	var/emissive_blocker = update_emissive_blocker()
	if (emissive_blocker)
		. += emissive_blocker
