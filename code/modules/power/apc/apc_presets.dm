// Various APC types
/obj/machinery/power/apc/inactive
	lighting = 0
	equipment = 0
	environ = 0
	locked = FALSE

/obj/machinery/power/apc/critical
	is_critical = 1

/obj/machinery/power/apc/high
	uncreated_component_parts = list(
		/obj/item/cell/high
	)

/obj/machinery/power/apc/high/inactive
	lighting = 0
	equipment = 0
	environ = 0
	locked = FALSE

/obj/machinery/power/apc/super
	uncreated_component_parts = list(
		/obj/item/cell/super
	)

/obj/machinery/power/apc/super/critical
	is_critical = 1

/obj/machinery/power/apc/hyper
	uncreated_component_parts = list(
		/obj/item/cell/hyper
	)

/obj/machinery/power/apc/derelict
	lighting = 0
	equipment = 0
	environ = 0
	locked = 0
	uncreated_component_parts = list(
		/obj/item/cell/crap/empty
	)

/obj/machinery/power/apc/derelict/full
	uncreated_component_parts = list(
		/obj/item/cell/crap
	)