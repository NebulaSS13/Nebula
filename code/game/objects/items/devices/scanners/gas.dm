#define DEFAULT_MODE 0
#define MV_MODE 1 //moles and volume
#define MAT_TRAIT_MODE 2 //gas traits and constants

/obj/item/scanner/gas
	name = "gas analyzer"
	desc = "A hand-held environmental scanner which reports current gas levels. Has a button to cycle modes."
	icon = 'icons/obj/items/device/scanner/atmos_scanner.dmi'
	icon_state = "atmos"
	item_state = "analyzer"

	origin_tech = "{'magnets':1,'engineering':1}"
	window_width = 350
	window_height = 400
	var/mode = DEFAULT_MODE

/obj/item/scanner/gas/get_header()
	return "[..()]<a href='?src=\ref[src];switchmode=1'>Switch Mode</a>"

/obj/item/scanner/gas/OnTopic(var/user, var/list/href_list)
	..()
	if(href_list["switchmode"])
		++mode
		switch(mode)
			if(MV_MODE)
				to_chat(user, "You set the gas analyzer to Moles and volume.")
			if(MAT_TRAIT_MODE)
				to_chat(user, "You set the gas analyzer to Gas traits and data.")
			else
				to_chat(user, "You set the gas analyzer to Default.")
				mode = DEFAULT_MODE
		playsound(src.loc, 'sound/machines/button4.ogg', 30, 0)

/obj/item/scanner/gas/is_valid_scan_target(atom/O)
	return istype(O)

/obj/item/scanner/gas/scan(atom/A, mob/user)
	var/air_contents = A.return_air()
	if(!air_contents)
		to_chat(user, "<span class='warning'>Your [src] flashes a red light as it fails to analyze \the [A].</span>")
		return
	scan_data = atmosanalyzer_scan(A, air_contents, mode)
	scan_data = jointext(scan_data, "<br>")
	user.show_message(SPAN_NOTICE(scan_data))

/proc/atmosanalyzer_scan(var/atom/target, var/datum/gas_mixture/mixture, mode)
	. = list()
	. += "Results of the analysis of \the [target]:"
	if(!mixture)
		mixture = target.return_air()

	if(mixture)
		var/pressure = mixture.return_pressure()
		var/total_moles = mixture.total_moles

		if (total_moles>0)
			if(abs(pressure - ONE_ATMOSPHERE) < 10)
				. += "<span class='notice'>Pressure: [round(pressure,0.01)] kPa</span>"
			else
				. += "<span class='warning'>Pressure: [round(pressure,0.01)] kPa</span>"

			var/perGas_add_string = ""
			for(var/mix in mixture.gas)
				var/percentage = round(mixture.gas[mix]/total_moles * 100, 0.01)
				if(!percentage)
					continue
				var/decl/material/mat = GET_DECL(mix)
				switch(mode)
					if(MV_MODE)
						perGas_add_string = ", Moles: [round(mixture.gas[mix], 0.01)]"
					if(MAT_TRAIT_MODE)
						var/list/traits = list()
						if(mat.gas_flags & XGM_GAS_FUEL)
							traits += "can be used as combustion fuel"
						if(mat.gas_flags & XGM_GAS_OXIDIZER)
							traits += "can be used as oxidizer"
						if(mat.gas_flags & XGM_GAS_CONTAMINANT)
							traits += "contaminates clothing with toxic residue"
						if(mat.flags & MAT_FLAG_FUSION_FUEL)
							traits += "can be used to fuel fusion reaction"
						perGas_add_string = "\n\tSpecific heat: [mat.gas_specific_heat] J/(mol*K), Molar mass: [mat.gas_molar_mass] kg/mol.[traits.len ? "\n\tThis gas [english_list(traits)]" : ""]"
				. += "[capitalize(mat.gas_name)]: [percentage]%[perGas_add_string]"
			var/totalGas_add_string = ""
			if(mode == MV_MODE)
				totalGas_add_string = ", Total moles: [round(mixture.total_moles, 0.01)], Volume: [mixture.volume]L"
			. += "Temperature: [round(mixture.temperature-T0C)]&deg;C / [round(mixture.temperature)]K[totalGas_add_string]"

			return
	. += "<span class='warning'>\The [target] has no gases!</span>"

#undef DEFAULT_MODE
#undef MV_MODE
#undef MAT_TRAIT_MODE