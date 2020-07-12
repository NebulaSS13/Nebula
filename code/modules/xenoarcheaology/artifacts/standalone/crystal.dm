/obj/structure/crystal
	name = "large crystal"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "crystal"
	density = 1

/obj/structure/crystal/Initialize()
	. = ..()

	icon_state = pick("ano70","ano80")

	desc = pick(
	"It shines faintly as it catches the light.",
	"It appears to have a faint inner glow.",
	"It seems to draw you inward as you look it at.",
	"Something twinkles faintly as you look at it.",
	"It's mesmerizing to behold.")

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
	return "Crystal formation - pseudo-organic crystalline matrix, unlikely to have formed naturally. No known technology exists to synthesize this exact composition."

//todo: laser_act
