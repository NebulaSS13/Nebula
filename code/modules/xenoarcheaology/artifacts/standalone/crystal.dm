/obj/structure/crystal/xeno
	name = "large crystal"
	icon = 'icons/obj/structures/crystals/xeno.dmi'
	material = /obj/item/shard/borosilicate
	material_alteration = MAT_FLAG_ALTERATION_NONE
	has_shadow = FALSE
	alpha = 255
	max_health = 200
	var/energized = FALSE

/obj/structure/crystal/xeno/get_random_states()
	var/static/list/random_states = pick("green","purple")
	return random_states

/obj/structure/crystal/xeno/Initialize()
	. = ..()
	desc = pick(list(
		"It shines faintly as it catches the light.",
		"It appears to have a faint inner glow.",
		"It seems to draw you inward as you look it at.",
		"Something twinkles faintly as you look at it.",
		"It's mesmerizing to behold."
	))

/obj/structure/crystal/xeno/on_update_icon()
	. = ..()
	if(energized)
		icon_state = "[icon_state]_active"

/obj/structure/crystal/xeno/get_artifact_scan_data()
	. = "Crystal formation - pseudo-organic crystalline matrix, unlikely to have formed naturally. No known technology exists to synthesize this exact composition."
	if(energized)
		. += " Stimulation of the inner crystal lattice has caused it to enter a metastable energy level, indicating potential uses in power storage and energy manipulation."

// Placeholder functionality so that these do something
/obj/structure/crystal/xeno/bullet_act(obj/item/projectile/the_bullet)
	var/proj_damage = the_bullet.get_structure_damage()
	if(!(the_bullet.damage_flags & DAM_LASER) || (proj_damage < 10) || energized)
		return ..()
	visible_message(SPAN_WARNING("\The [src] begins glowing..."))
	energized = TRUE
	update_icon()
