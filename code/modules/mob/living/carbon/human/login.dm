/mob/living/carbon/human/Login()
	..()
	if(client)
		for(var/obj/item/gear in get_equipped_items(TRUE))
			client.screen |= gear
	if(hud_used)
		hud_used.hidden_inventory_update()
		hud_used.persistant_inventory_update()
	if(species)
		species.handle_login_special(src)

