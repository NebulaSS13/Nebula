/obj/item/implant/adrenalin
	name = "adrenalin implant"
	desc = "Removes all stuns and knockdowns."
	origin_tech = @'{"materials":1,"biotech":2,"esoteric":2}'
	hidden = TRUE
	var/uses = 3

/obj/item/implant/adrenalin/get_data()
	return {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> Cybersun Industries Adrenalin Implant<BR>
	<b>Life:</b> Five days.<BR>
	<b>Important Notes:</b> <font color='red'>Illegal</font><BR>
	<HR>
	<b>Implant Details:</b> Subjects injected with implant can activate a massive injection of adrenalin.<BR>
	<b>Function:</b> Contains nanobots to stimulate body to mass-produce Adrenalin.<BR>
	<b>Special Features:</b> Will prevent and cure most forms of brainwashing.<BR>
	<b>Integrity:</b> Implant can only be used three times before the nanobots are depleted."}

/obj/item/implant/adrenalin/trigger(emote, mob/source)
	if (emote == "pale")
		activate()

/obj/item/implant/adrenalin/activate()//this implant is unused but I'm changing it for the sake of consistency
	if (uses < 1 || malfunction || !imp_in)
		return 0
	uses--
	to_chat(imp_in, SPAN_NOTICE("You feel a sudden surge of energy!"))

	imp_in.set_status_condition(STAT_STUN, 0)
	imp_in.set_status_condition(STAT_WEAK, 0)
	imp_in.set_status_condition(STAT_PARA, 0)

/obj/item/implant/adrenalin/implanted(mob/source)
	var/activation_string = "can be activated by using the pale emote, <B>say *pale</B> to attempt to activate."
	source.StoreMemory("\A [src] [activation_string]", /decl/memory_options/system)
	to_chat(source, "\The [src] [activation_string]")
	return TRUE

/obj/item/implanter/adrenalin
	name = "implanter-adrenalin"
	imp = /obj/item/implant/adrenalin

/obj/item/implantcase/adrenalin
	name = "glass case - 'adrenalin'"
	imp = /obj/item/implant/adrenalin