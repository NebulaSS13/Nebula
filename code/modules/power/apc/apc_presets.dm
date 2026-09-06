// Various APC types
/obj/machinery/apc/inactive
	lighting = 0
	equipment = 0
	environ = 0
	locked = FALSE

/obj/machinery/apc/critical
	is_critical = 1

/obj/machinery/apc/high
	uncreated_component_parts = list(
		/obj/item/cell/high
	)

/obj/machinery/apc/high/inactive
	lighting = 0
	equipment = 0
	environ = 0
	locked = FALSE

/obj/machinery/apc/super
	uncreated_component_parts = list(
		/obj/item/cell/super
	)

/obj/machinery/apc/super/critical
	is_critical = 1

/obj/machinery/apc/hyper
	uncreated_component_parts = list(
		/obj/item/cell/hyper
	)

/obj/machinery/apc/derelict
	lighting = 0
	equipment = 0
	environ = 0
	locked = 0
	uncreated_component_parts = list(
		/obj/item/cell/crap/empty
	)

/obj/machinery/apc/derelict/full
	uncreated_component_parts = list(
		/obj/item/cell/crap
	)