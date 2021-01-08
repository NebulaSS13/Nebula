/mob/living/starlight_soul
	name = "soul"
	desc = "A captured soul."
	anchored = 1

	meat_type = null
	meat_amount = 0
	skin_material = null
	skin_amount = 0
	bone_material = null
	bone_amount = 0

/mob/living/starlight_soul/Initialize(var/maploading, var/mob/living/old_mob)
	. = ..()
	if(old_mob)
		name = old_mob.real_name

/mob/living/starlight_soul/proc/set_deity(var/mob/living/deity/deity)
	var/mob/observer/eye/freelook/cult/eye
	if(eyeobj)
		eye = eyeobj
		eyeobj.release(src)
	else
		eye = new(src)
		eye.suffix = "Soul"
		eyeobj = eye
	eye.visualnet = deity.eyenet
	var/decl/special_role/godcultist/godcult = decls_repository.get_decl(/decl/special_role/godcultist)
	godcult.add_antagonist_mind(src.mind,1,"lost soul of [deity]", "You have been captured by \the [deity]! You now can only see into your own reality through the same rips and tears it uses. Your only chance at another body will be one in your captor's image...",specific_god=deity)
	eyeobj.possess(src)

/mob/living/starlight_soul/Destroy()
	if(eyeobj)
		QDEL_NULL(eyeobj)
	. = ..()