/obj/structure/crystal
	name = "large crystal"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano70"
	density = TRUE
	var/base_state = null
	var/energized = FALSE

/obj/structure/crystal/Initialize()
	. = ..()

	base_state = pick("ano7","ano8")

	desc = pick(
	"It shines faintly as it catches the light.",
	"It appears to have a faint inner glow.",
	"It seems to draw you inward as you look it at.",
	"Something twinkles faintly as you look at it.",
	"It's mesmerizing to behold.")

/obj/structure/crystal/on_update_icon()
	. = ..()
	icon_state = "[base_state][energized ? 0 : 1]"

/obj/structure/crystal/Destroy()
	src.visible_message("<span class='warning'>[src] shatters!</span>")
	if(prob(75))
		new /obj/item/shard/borosilicate(src.loc)
	if(prob(50))
		new /obj/item/shard/borosilicate(src.loc)
	if(prob(25))
		new /obj/item/shard/borosilicate(src.loc)
	if(prob(75))
		new /obj/item/shard(src.loc)
	if(prob(50))
		new /obj/item/shard(src.loc)
	if(prob(25))
		new /obj/item/shard(src.loc)
	return ..()

/obj/structure/crystal/get_artifact_scan_data()
	. = "Crystal formation - pseudo-organic crystalline matrix, unlikely to have formed naturally. No known technology exists to synthesize this exact composition."
	if(energized)
		. += " Stimulation of the inner crystal lattice has caused it to enter a metastable energy level, indicating potential uses in power storage and energy manipulation."

// Placeholder functionality so that these do something
/obj/structure/crystal/bullet_act(obj/item/projectile/the_bullet)
	var/proj_damage = the_bullet.get_structure_damage()
	if(!(the_bullet.damage_flags & DAM_LASER) || (proj_damage < 10) || energized)
		return ..()
	visible_message(SPAN_WARNING("\The [src] begins glowing..."))
	energized = TRUE
	update_icon()