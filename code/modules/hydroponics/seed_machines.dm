/obj/item/disk/botany
	name = "flora data disk"
	desc = "A small disk used for carrying data on plant genetics."
	color = COLOR_GREEN
	label = "label_dna"

	var/list/genes = list()
	var/genesource = "unknown"

/obj/item/disk/botany/attack_self(var/mob/user)
	if(genes.len)
		var/choice = alert(user, "Are you sure you want to wipe the disk?", "Xenobotany Data", "No", "Yes")
		if(src && user && genes && choice && choice == "Yes" && user.Adjacent(get_turf(src)))
			to_chat(user, "You wipe the disk data.")
			SetName(initial(name))
			desc = initial(name)
			genes = list()
			genesource = "unknown"

/obj/item/box/botanydisk
	name = "flora disk box"
	desc = "A box of flora data disks, apparently."

/obj/item/box/botanydisk/WillContain()
	return list(/obj/item/disk/botany = 14)

/obj/machinery/botany
	icon = 'icons/obj/hydroponics/hydroponics_machines.dmi'
	icon_state = "hydrotray3"
	density = TRUE
	anchored = TRUE

	var/obj/item/seeds/seed // Currently loaded seed packet.
	var/obj/item/disk/botany/loaded_disk //Currently loaded data disk.

	var/open = 0
	var/active = 0
	var/action_time = 5
	var/last_action = 0
	var/eject_disk = 0
	var/failed_task = 0
	var/disk_needs_genes = 0

/obj/machinery/botany/Process()
	if(!active) return

	if(world.time > last_action + action_time)
		finished_task()

/obj/machinery/botany/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/botany/proc/finished_task()
	active = 0
	if(failed_task)
		failed_task = 0
		visible_message("[html_icon(src)] [src] pings unhappily, flashing a red warning light.")
	else
		visible_message("[html_icon(src)] [src] pings happily.")

	if(eject_disk)
		eject_disk = 0
		if(loaded_disk)
			loaded_disk.dropInto(loc)
			visible_message("[html_icon(src)] [src] beeps and spits out [loaded_disk].")
			loaded_disk = null

/obj/machinery/botany/attackby(obj/item/used_item, mob/user)
	if(istype(used_item,/obj/item/seeds))
		if(seed)
			to_chat(user, "There is already a seed loaded.")
			return TRUE
		var/obj/item/seeds/S = used_item
		if(S.seed && S.seed.get_trait(TRAIT_IMMUTABLE) > 0)
			to_chat(user, "That seed is not compatible with our genetics technology.")
		else if(user.try_unequip(used_item, src))
			seed = used_item
			to_chat(user, "You load [used_item] into [src].")
		return TRUE

	if(IS_SCREWDRIVER(used_item))
		open = !open
		to_chat(user, "<span class='notice'>You [open ? "open" : "close"] the maintenance panel.</span>")
		return TRUE

	if(open && IS_CROWBAR(used_item))
		dismantle()
		return TRUE

	if(istype(used_item,/obj/item/disk/botany))
		if(loaded_disk)
			to_chat(user, "There is already a data disk loaded.")
			return TRUE
		var/obj/item/disk/botany/B = used_item
		if(B.genes && B.genes.len)
			if(!disk_needs_genes)
				to_chat(user, "That disk already has gene data loaded.")
				return TRUE
		else
			if(disk_needs_genes)
				to_chat(user, "That disk does not have any gene data loaded.")
				return TRUE
		if(!user.try_unequip(used_item, src))
			return TRUE
		loaded_disk = used_item
		to_chat(user, "You load [used_item] into [src].")
		return TRUE
	return ..()

// Allows for a trait to be extracted from a seed packet, destroying that seed.
/obj/machinery/botany/extractor
	name = "lysis-isolation centrifuge"
	icon_state = "traitcopier"

	var/datum/seed/genetics // Currently scanned seed genetic structure.
	var/degradation = 0     // Increments with each scan, stops allowing gene mods after a certain point.

/obj/machinery/botany/extractor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	if(!user)
		return

	var/list/data = list()

	data["geneMasks"] = SSplants.gene_masked_list
	data["activity"] = active
	data["degradation"] = degradation

	if(loaded_disk)
		data["disk"] = 1
	else
		data["disk"] = 0

	if(seed)
		data["loaded"] = "[seed.name]"
	else
		data["loaded"] = 0

	if(genetics)
		data["hasGenetics"] = 1
		data["sourceName"] = genetics.display_name
		if(!genetics.roundstart)
			data["sourceName"] += " (variety #[genetics.uid])"
	else
		data["hasGenetics"] = 0
		data["sourceName"] = 0

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "botany_isolator.tmpl", "Lysis-isolation Centrifuge UI", 470, 450)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/botany/OnTopic(mob/user, href_list)
	if((. = ..()))
		return

	if(href_list["eject_packet"])
		if(!seed) return TOPIC_REFRESH // You must be mistaken! We have no seed.
		seed.dropInto(loc)

		if(seed.seed.name == "new line" || isnull(SSplants.seeds[seed.seed.name]))
			seed.seed.uid = sequential_id(/datum/seed/)
			seed.seed.name = "[seed.seed.uid]"
			SSplants.seeds[seed.seed.name] = seed.seed

		seed.update_seed()
		visible_message("[html_icon(src)] \The [src] beeps and spits out [seed].")

		seed = null
		. = TOPIC_REFRESH

	if(href_list["eject_disk"])
		if(!loaded_disk) return TOPIC_REFRESH
		loaded_disk.dropInto(loc)
		visible_message("[html_icon(src)] \The [src] beeps and spits out [loaded_disk].")
		loaded_disk = null
		. = TOPIC_REFRESH

/obj/machinery/botany/extractor/OnTopic(mob/user, href_list)
	if((. = ..()))
		return

	if(href_list["scan_genome"])
		if(!seed) return TOPIC_REFRESH
		last_action = world.time
		active = TRUE
		if(prob(user.skill_fail_chance(SKILL_BOTANY, 100, SKILL_ADEPT)))
			failed_task = TRUE
		else
			genetics = seed.seed
			degradation = 0

		QDEL_NULL(seed)

	if(href_list["get_gene"])
		if(!genetics || !loaded_disk)
			return TOPIC_REFRESH

		var/decl/plant_gene/gene_master = locate(href_list["get_gene"])
		if(ispath(gene_master))
			gene_master = GET_DECL(gene_master)

		if(!istype(gene_master))
			return TOPIC_HANDLED // Potential href hacking?

		last_action = world.time
		active = TRUE
		loaded_disk.genes += new /datum/plantgene(gene_master, genetics)
		loaded_disk.genesource = "[genetics.display_name]"
		if(!genetics.roundstart)
			loaded_disk.genesource += " (variety #[genetics.uid])"
		loaded_disk.name += " ([gene_master.name], #[genetics.uid])"
		loaded_disk.desc += " The label reads \'gene [gene_master.name], sampled from [genetics.display_name]\'."
		eject_disk = TRUE
		degradation += rand(20,60) + user.skill_fail_chance(SKILL_BOTANY, 100, SKILL_ADEPT)
		var/expertise = max(0, user.get_skill_value(SKILL_BOTANY) - SKILL_ADEPT)
		degradation = max(0, degradation - 10*expertise)
		if(degradation >= 100)
			failed_task = TRUE
			genetics = null
			degradation = 0

	if(href_list["clear_buffer"])
		if(!genetics) return
		genetics = null
		degradation = 0

	src.updateUsrDialog()
	return

// Fires an extracted trait into another packet of seeds with a chance
// of destroying it based on the size/complexity of the plasmid.
/obj/machinery/botany/editor
	name = "bioballistic delivery system"
	icon_state = "traitgun"
	disk_needs_genes = 1

/obj/machinery/botany/editor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	if(!user)
		return

	var/list/data = list()

	data["activity"] = active

	if(seed)
		data["degradation"] = seed.modified
	else
		data["degradation"] = 0

	if(loaded_disk && loaded_disk.genes.len)
		data["disk"] = 1
		data["sourceName"] = loaded_disk.genesource
		data["locus"] = ""

		for(var/datum/plantgene/P in loaded_disk.genes)
			if(data["locus"] != "") data["locus"] += ", "
			data["locus"] += "[P.genetype.name]"

	else
		data["disk"] = 0
		data["sourceName"] = 0
		data["locus"] = 0

	if(seed)
		data["loaded"] = "[seed.name]"
	else
		data["loaded"] = 0

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "botany_editor.tmpl", "Bioballistic Delivery UI", 470, 450)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/botany/editor/OnTopic(mob/user, href_list)
	if((. = ..()))
		return

	if(href_list["apply_gene"])
		if(!loaded_disk || !seed) return TOPIC_REFRESH
		last_action = world.time
		active = TRUE

		if(!isnull(SSplants.seeds[seed.seed.name]))
			seed.seed = seed.seed.diverge(1)
			seed.update_seed()

		if(prob(seed.modified))
			failed_task = TRUE
			seed.modified = 101

		for(var/datum/plantgene/gene in loaded_disk.genes)
			seed.seed.apply_gene(gene)
			var/expertise = max(user.get_skill_value(SKILL_BOTANY) - SKILL_ADEPT)
			seed.modified += rand(5,10) + min(-5, 30 * expertise)
