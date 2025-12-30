/proc/wash_mob(var/mob/living/washing)
	if(!istype(washing))
		return
	var/mob/living/L = washing
	if(L.is_on_fire())
		L.visible_message("<span class='danger'>A cloud of steam rises up as the water hits \the [L]!</span>")
		L.extinguish_fire()
	L.adjust_fire_intensity(-20) //Douse ourselves with water to avoid fire more easily
	washing.clean()
