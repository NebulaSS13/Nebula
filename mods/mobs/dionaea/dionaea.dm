/decl/modpack/dionaea
	name = "Diona Nymphs"

/decl/modpack/dionaea/post_initialize()
	. = ..()
	var/list/aminals = global.href_to_mob_type["Animals"]
	if(!islist(aminals))
		global.href_to_mob_type["Animals"] = list("Diona Nymph" = /mob/living/simple_animal/alien/diona)
	else
		aminals["Diona Nymph"] = /mob/living/simple_animal/alien/diona
