/obj/effect/manifest
	name = "manifest"
	icon = 'icons/effects/markers.dmi'
	icon_state = "x"

/obj/effect/manifest/Initialize()
	. = ..()
	set_invisibility(INVISIBILITY_ABSTRACT)

/obj/effect/manifest/proc/manifest()
	var/dat = "<B>Crew Manifest</B>:<BR>"
	for(var/mob/living/human/M in SSmobs.mob_list)
		dat += text("    <B>[]</B> -  []<BR>", M.name, M.get_assignment())
	var/obj/item/paper/P = new /obj/item/paper( src.loc )
	P.info = dat
	P.SetName("paper- 'Crew Manifest'")
	//SN src = null
	qdel(src)
	return