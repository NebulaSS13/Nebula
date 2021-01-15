var/exterior_burned_states = icon_states('icons/turf/exterior/burned.dmi')
/turf/exterior/concrete/proc/set_burned(var/skip_update)
	burned = pick(global.exterior_burned_states)
	if(!skip_update)
		queue_icon_update()

var/exterior_broken_states = icon_states('icons/turf/exterior/broken.dmi')
/turf/exterior/concrete/proc/set_broken(var/skip_update)
	broken = pick(global.exterior_broken_states)
	if(!skip_update)
		queue_icon_update()

/turf/exterior/concrete
	name = "concrete"
	desc = "A flat expanse of artificial stone-like artificial material."
	icon = 'icons/turf/exterior/concrete.dmi'
	diggable = FALSE
	var/broken 
	var/burned

/turf/exterior/concrete/Initialize(var/ml)
	if(broken)
		set_broken(TRUE)
	if(burned)
		set_burned(TRUE)
	. = ..()

/turf/exterior/concrete/on_update_icon(update_neighbors)
	. = ..()
	if(broken)
		add_overlay(get_damage_overlay(broken, BLEND_MULTIPLY, 'icons/turf/exterior/broken.dmi'))
	if(burned)
		add_overlay(get_damage_overlay(burned, BLEND_MULTIPLY, 'icons/turf/exterior/burned.dmi'))

/turf/exterior/concrete/reinforced
	name = "reinforced concrete"
	desc = "Stone-like artificial material. It has been reinforced with an unknown compound"

/turf/exterior/concrete/reinforced/on_update_icon()
	. = ..()
	add_overlay("hexacrete")

/turf/exterior/concrete/reinforced/damaged
	broken = TRUE

/turf/exterior/concrete/reinforced/road
	name = "asphalt"
	color = COLOR_GRAY40
