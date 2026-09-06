// Does this really need to be its own thing...?
// Can it not just be a stock parts preset or something?
/obj/machinery/computer/air_control/supermatter_core
	frequency = 1438
	out_pressure_mode = 1

/datum/fabricator_recipe/imprinter/circuit/supermatter_control
	path = /obj/item/stock_parts/circuitboard/air_management/supermatter_core

/obj/item/stock_parts/circuitboard/air_management/supermatter_core
	name = "circuitboard (core control)"
	build_path = /obj/machinery/computer/air_control/supermatter_core
	frequency = 1438
	var/input_tag
	var/output_tag

	var/list/input_info = list()
	var/list/output_info = list()

	var/input_flow_setting = 700
	var/pressure_setting = 100

/obj/item/stock_parts/circuitboard/air_management/supermatter_core/construct(var/obj/machinery/computer/air_control/supermatter_core/SC)
	if(..(SC))
		SC.input_tag = input_tag
		SC.output_tag = output_tag

		SC.input_info = input_info.Copy()
		SC.output_info = output_info.Copy()

		SC.input_flow_setting = input_flow_setting
		SC.pressure_setting = input_flow_setting
		return 1

/obj/item/stock_parts/circuitboard/air_management/supermatter_core/deconstruct(var/obj/machinery/computer/air_control/supermatter_core/SC)
	if(..(SC))
		input_tag = SC.input_tag
		output_tag = SC.output_tag

		input_info = SC.input_info.Copy()
		output_info = SC.output_info.Copy()

		input_flow_setting = SC.input_flow_setting
		pressure_setting = SC.input_flow_setting
		return 1