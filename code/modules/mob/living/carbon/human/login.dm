/mob/living/carbon/human/Login()
	..()
	// Callback needed as SOMETHING in inventory code fucks with 
	// screen loc and screen presence after this proc runs.
	addtimer(CALLBACK(src, .proc/refresh_inventory_ui), 0)
	if(species)
		species.handle_login_special(src)

/mob/living/carbon/human/proc/refresh_inventory_ui()
	if(client)
		for(var/obj/item/gear in get_equipped_items(TRUE))
			gear.reconsider_client_screen_presence(client, get_inventory_slot(gear))
		if(hud_used)
			hud_used.hidden_inventory_update()
			hud_used.persistant_inventory_update()
