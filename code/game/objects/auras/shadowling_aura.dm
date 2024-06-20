/obj/aura/shadowling_aura
	name = "Shadowling Aura"
	var/added_mutation = FALSE

/obj/aura/shadowling_aura/added_to(var/mob/living/L)
	..()
	if(L.add_genetic_condition(GENE_COND_SPACE_RESISTANCE))
		added_mutation = TRUE

/obj/aura/shadowling_aura/removed()
	if(added_mutation)
		added_mutation = FALSE
		user.remove_genetic_condition(GENE_COND_SPACE_RESISTANCE)
	..()

/obj/aura/shadowling_aura/bullet_act(var/obj/item/projectile/P)
	if(P.damage_flags() & DAM_LASER)
		P.damage *= 2
	if(P.agony)
		P.agony *= 2
	return 0