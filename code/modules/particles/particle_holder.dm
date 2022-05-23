/atom/movable/particle_holder
	name = null
	anchored = TRUE
	layer = FLY_LAYER
	mouse_opacity = 0
	appearance_flags = PIXEL_SCALE

	/// Current source of this particle holder.
	var/atom/movable/source

/atom/movable/particle_holder/Initialize(mapload, param_time, param_color)
	. = ..()
	if(ismovable(loc))
		source = loc
		add_vis_contents(source, src)
		events_repository.register(/decl/observ/destroyed, source, src, /datum/proc/qdel_self)

	color = param_color

	if(param_time > 0)
		QDEL_IN(src, param_time)

/atom/movable/particle_holder/Destroy()
	if(source)
		events_repository.unregister(/decl/observ/destroyed, source, src)
		remove_vis_contents(source, src)
	source = null
	return ..()

/atom/movable/particle_holder/proc/toggle(state)
	particles.spawning = state ? initial(particles.spawning) : 0
