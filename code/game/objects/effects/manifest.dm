/obj/effect/manifest
	name = "manifest"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	unacidable = 1//Just to be sure.

/obj/effect/manifest/Initialize()
	. = ..()
	invisibility = INVISIBILITY_ABSTRACT

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