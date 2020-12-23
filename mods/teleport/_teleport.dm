#define COLOR_SUBSPACE "#3c1a6e"

/decl/modpack/teleport
	name = "Teleportation"
	dreams = list("teleport station", "portal")

/* Essentialy a set of helpers for interesting teleportation concept

Procs:
	subspace_shift(var/atom/movable/A, var/newz = null, var/effect = /obj/effect/shift)
	puts atom in/out of subspace, you can supply effect created in real space and exit Z-level

	timed_shift(var/atom/movable/A,var/time)
	shifts atom to subspace and holds it there for supplied tim

	do_teleport(atom,destination,0,/decl/teleport/subspace)
	teleports atom through subspace

Example Usage:
	subspace jumper
	reactive teleport armor

also see realm.dm for subspace protection and etc, you can set subspace area/turf for specific map

*/