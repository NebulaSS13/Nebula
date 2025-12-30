/*

Overview:
	The connection_manager class stores connections in each cardinal direction on a turf.
	It isn't always present if a turf has no connections, check if(connections) before using.
	Contains procs for mass manipulation of connection data.

Class Vars:

	NSEWUD - Connections to this turf in each cardinal direction.

Class Procs:

	get(d)
		Returns the connection (if any) in this direction.
		Preferable to accessing the connection directly because it checks validity.

	place(connection/c, d)
		Called by air_master.connect(). Sets the connection in the specified direction to c.

	update_all()
		Called after turf/update_air_properties(). Updates the validity of all connections on this turf.

	erase_all()
		Called when the turf is changed with ChangeTurf(). Erases all existing connections.

Macros:
	check(connection/c)
		Checks for connection validity. It's possible to have a reference to a connection that has been erased.


*/

// macro-ized to cut down on proc calls
#define check(c) (c && c.valid())

/turf/var/tmp/connection_manager/connections

/connection_manager
	var/connection/north_connection
	var/connection/south_connection
	var/connection/east_connection
	var/connection/west_connection

#ifdef MULTIZAS
	var/connection/upward_connection
	var/connection/downward_connection
#endif

/connection_manager/proc/get(d)
	switch(d)
		if(NORTH)
			if(check(north_connection)) return north_connection
			else return null
		if(SOUTH)
			if(check(south_connection)) return south_connection
			else return null
		if(EAST)
			if(check(east_connection)) return east_connection
			else return null
		if(WEST)
			if(check(west_connection)) return west_connection
			else return null

		#ifdef MULTIZAS
		if(UP)
			if(check(upward_connection)) return upward_connection
			else return null
		if(DOWN)
			if(check(downward_connection)) return downward_connection
			else return null
		#endif

/connection_manager/proc/place(connection/c, d)
	switch(d)
		if(NORTH) north_connection = c
		if(SOUTH) south_connection = c
		if(EAST)  east_connection = c
		if(WEST)  west_connection = c

		#ifdef MULTIZAS
		if(UP)    upward_connection = c
		if(DOWN)  downward_connection = c
		#endif

/connection_manager/proc/update_all()
	if(check(north_connection))    north_connection.update()
	if(check(south_connection))    south_connection.update()
	if(check(east_connection))     east_connection.update()
	if(check(west_connection))     west_connection.update()
	#ifdef MULTIZAS
	if(check(upward_connection))   upward_connection.update()
	if(check(downward_connection)) downward_connection.update()
	#endif

/connection_manager/proc/erase_all()
	if(check(north_connection))    north_connection.erase()
	if(check(south_connection))    south_connection.erase()
	if(check(east_connection))     east_connection.erase()
	if(check(west_connection))     west_connection.erase()
	#ifdef MULTIZAS
	if(check(upward_connection))   upward_connection.erase()
	if(check(downward_connection)) downward_connection.erase()
	#endif

#undef check
