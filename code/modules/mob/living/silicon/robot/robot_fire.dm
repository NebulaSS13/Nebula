/mob/living/silicon/robot/update_fire()
	overlays -= image("icon"='icons/mob/OnFire.dmi', "icon_state"="Standing")
	if(is_on_fire())
		overlays += image("icon"='icons/mob/OnFire.dmi', "icon_state"="Standing")
