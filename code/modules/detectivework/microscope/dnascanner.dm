//DNA machine
/obj/machinery/forensic/dnascanner
	name = "DNA analyzer"
	desc = "A high tech machine that is designed to read DNA samples properly."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dna_open"
	anchored = TRUE
	density = TRUE
	stat_immune = 0
	base_type = /obj/machinery/forensic/dnascanner

	var/scanning = 0
	var/scanner_progress = 0
	var/scanner_rate = 5

/obj/machinery/forensic/dnascanner/interface_interact(user)
	ui_interact(user)
	return TRUE

/obj/machinery/forensic/dnascanner/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null)
	var/list/data = list()
	data["scan_progress"] = round(scanner_progress)
	data["scanning"] = scanning
	data["bloodsamp"] = (sample ? sample.name : "")
	data["bloodsamp_desc"] = sample ? (sample.desc ? sample.desc : "No information on record.") : ""

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		ui = new(user, src, ui_key, "dnaforensics.tmpl", "QuikScan DNA Analyzer", 540, 326)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/forensic/dnascanner/OnTopic(user, href_list)
	if(..())
		return TOPIC_HANDLED

	if(href_list["scanItem"])
		if(scanning)
			scanning = 0
			return TOPIC_HANDLED
		else
			if(sample)
				scanner_progress = 0
				scanning = 1
				to_chat(user, SPAN_NOTICE("Scan initiated."))
				update_icon()
				return TOPIC_REFRESH
			else
				to_chat(user, SPAN_WARNING("Insert an item to scan."))
				return TOPIC_HANDLED

	if(href_list["ejectItem"])
		if(sample)
			sample.dropInto(loc)
			clear_sample()
			return TOPIC_REFRESH

/obj/machinery/forensic/dnascanner/Process()
	if(scanning)
		if(!sample || sample.loc != src)
			clear_sample()
			scanning = 0
			return
		scanner_progress += scanner_rate
		if(scanner_progress >= 100)
			complete_scan()

/obj/machinery/forensic/dnascanner/proc/complete_scan()
	visible_message(SPAN_NOTICE("[src] makes an insistent chime."), 2)
	playsound(src, 'sound/machines/chime.ogg', 40)
	scanning = 0
	print_report()
	update_icon()

/obj/machinery/forensic/dnascanner/on_update_icon()
	..()
	if(!(stat & (NOPOWER|BROKEN)) && scanning)
		icon_state = "dna_working"
	else
		icon_state = "dna_open[(stat & (NOPOWER|BROKEN)) ? "-unpowered" : null]"
