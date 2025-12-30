/*This file is a list of all preclaimed planes & layers

All planes & layers should be given a value here instead of using a magic/arbitrary number.

After fiddling with planes and layers for some time, I figured I may as well provide some documentation:

What are planes?
	Think of Planes as a sort of layer for a layer - if plane X is a larger number than plane Y, the highest number for a layer in X will be below the lowest
	number for a layer in Y.
	Planes also have the added bonus of having planesmasters.

What are Planesmasters?
	Planesmasters, when in the sight of a player, will have its appearance properties (for example, colour matrices, alpha, transform, etc)
	applied to all the other objects in the plane. This is all client sided.
	Usually you would want to add the planesmaster as an invisible image in the client's screen.

What can I do with Planesmasters?
	You can: Make certain players not see an entire plane,
	Make an entire plane have a certain colour matrices,
	Make an entire plane transform in a certain way,
	Make players see a plane which is hidden to normal players - I intend to implement this with the antag HUDs for example.
	Planesmasters can be used as a neater way to deal with client images or potentially to do some neat things

How do planes work?
	A plane can be any integer from -100 to 100. (If you want more, bug lummox.)
	All planes above 0, the 'base plane', are visible even when your character cannot 'see' them, for example, the HUD.
	All planes below 0, the 'base plane', are only visible when a character can see them.

How do I add a plane?
	Think of where you want the plane to appear, look through the pre-existing planes and find where it is above and where it is below
	Slot it in in that place, and change the pre-existing planes, making sure no plane shares a number.
	Add a description with a comment as to what the plane does.

How do I make something a planesmaster?
	Add the PLANE_MASTER appearance flag to the appearance_flags variable.

What is the naming convention for planes or layers?
	Make sure to use the name of your object before the _LAYER or _PLANE, eg: [NAME_OF_YOUR_OBJECT HERE]_LAYER or [NAME_OF_YOUR_OBJECT HERE]_PLANE
	Also, as it's a define, it is standard practice to use capital letters for the variable so people know this.

*/

/*
	from stddef.dm, planes & layers built into byond.

	FLOAT_LAYER = -1
	AREA_LAYER = 1
	TURF_LAYER = 2
	OBJ_LAYER = 3
	MOB_LAYER = 4
	FLY_LAYER = 5
	EFFECTS_LAYER = 5000
	TOPDOWN_LAYER = 10000
	BACKGROUND_LAYER = 20000
	EFFECTS_LAYER = 5000
	TOPDOWN_LAYER = 10000
	BACKGROUND_LAYER = 20000
	------

	FLOAT_PLANE = -32767
*/

#define CLICKCATCHER_PLANE -100

#define SPACE_PLANE               -99
	#define SPACE_LAYER                  1
#define SKYBOX_PLANE              -98
	#define SKYBOX_LAYER                 1

#define DUST_PLANE                 -97
	#define DEBRIS_LAYER                 1
	#define DUST_LAYER                   2

// Openspace uses planes -80 through -70.

#define OVER_OPENSPACE_PLANE        -3

#define DEFAULT_PLANE                   0
//BELOW PLATING
	#define UNDER_TURF_LAYER            1
	//PLATING
	#define PLATING_LAYER               1.5
	//ABOVE PLATING
	#define HOLOMAP_LAYER               1.51
	#define DECAL_PLATING_LAYER         1.52
	#define DISPOSALS_PIPE_LAYER        1.53
	#define LATTICE_LAYER               1.54
	#define PIPE_LAYER                  1.55
	#define WIRE_LAYER                  1.56
	#define WIRE_TERMINAL_LAYER         1.57
	#define ABOVE_WIRE_LAYER            1.58
	//TURF PLANE
	//TURF_LAYER = 2
	#define TURF_OVER_EDGE_LAYER        TURF_LAYER + (FLOOR_LAYER_CONSTANT*100)
	#define TURF_DETAIL_LAYER           TURF_OVER_EDGE_LAYER + 0.01
	#define TURF_SHADOW_LAYER           TURF_OVER_EDGE_LAYER + 0.02
	//ABOVE TURF
	#define DECAL_LAYER                 TURF_OVER_EDGE_LAYER + 0.03
	#define RUNE_LAYER                  TURF_OVER_EDGE_LAYER + 0.04
	#define AO_LAYER                    TURF_OVER_EDGE_LAYER + 0.045
	#define ABOVE_TILE_LAYER            TURF_OVER_EDGE_LAYER + 0.05
	#define EXPOSED_PIPE_LAYER          TURF_OVER_EDGE_LAYER + 0.06
	#define EXPOSED_WIRE_LAYER          TURF_OVER_EDGE_LAYER + 0.07
	#define EXPOSED_WIRE_TERMINAL_LAYER TURF_OVER_EDGE_LAYER + 0.08
	#define CATWALK_LAYER               TURF_OVER_EDGE_LAYER + 0.09
	#define BLOOD_LAYER                 TURF_OVER_EDGE_LAYER + 0.10
	#define MOUSETRAP_LAYER             TURF_OVER_EDGE_LAYER + 0.11
	#define PLANT_LAYER                 TURF_OVER_EDGE_LAYER + 0.12
	//HIDING MOB
	#define HIDING_MOB_LAYER            TURF_OVER_EDGE_LAYER + 0.14
	#define SHALLOW_FLUID_LAYER         TURF_OVER_EDGE_LAYER + 0.15
	#define MOB_SHADOW_LAYER            TURF_OVER_EDGE_LAYER + 0.16
	//OBJ
	#define BELOW_DOOR_LAYER            TURF_OVER_EDGE_LAYER + 0.17
	#define OPEN_DOOR_LAYER             TURF_OVER_EDGE_LAYER + 0.18
	#define BELOW_TABLE_LAYER           TURF_OVER_EDGE_LAYER + 0.19
	#define TABLE_LAYER                 TURF_OVER_EDGE_LAYER + 0.20
	#define BELOW_OBJ_LAYER             TURF_OVER_EDGE_LAYER + 0.21
	#define STRUCTURE_LAYER             TURF_OVER_EDGE_LAYER + 0.22
	#define ABOVE_STRUCTURE_LAYER       TURF_OVER_EDGE_LAYER + 0.23
	// OBJ_LAYER                        3
	#define ABOVE_OBJ_LAYER             3.01
	#define CLOSED_DOOR_LAYER           3.02
	#define ABOVE_DOOR_LAYER            3.03
	#define SIDE_WINDOW_LAYER           3.04
	#define FULL_WINDOW_LAYER           3.05
	#define ABOVE_WINDOW_LAYER          3.06
	//LYING MOB AND HUMAN
	#define UNDER_MOB_LAYER             3.065
	#define LYING_MOB_LAYER             3.07
	#define LYING_HUMAN_LAYER           3.08
	#define BASE_ABOVE_OBJ_LAYER        3.09
	//HUMAN
	#define BASE_HUMAN_LAYER            3.10
	//MOB
	#define MECH_UNDER_LAYER            3.11
	// MOB_LAYER                        4
	#define MECH_BASE_LAYER             4.01
	#define MECH_INTERMEDIATE_LAYER     4.02
	#define MECH_PILOT_LAYER            4.03
	#define MECH_LEG_LAYER              4.04
	#define MECH_COCKPIT_LAYER          4.05
	#define MECH_ARM_LAYER              4.06
	#define MECH_GEAR_LAYER             4.07
	//ABOVE HUMAN
	#define ABOVE_HUMAN_LAYER           4.08
	#define VEHICLE_LOAD_LAYER          4.09
	#define CAMERA_LAYER                4.10
	//BLOB
	#define BLOB_SHIELD_LAYER           4.11
	#define BLOB_NODE_LAYER             4.12
	#define BLOB_CORE_LAYER	            4.13
	//EFFECTS BELOW LIGHTING
	#define BELOW_PROJECTILE_LAYER      4.14
	#define DEEP_FLUID_LAYER            4.15
	#define FIRE_LAYER                  4.16
	#define PROJECTILE_LAYER            4.17
	#define ABOVE_PROJECTILE_LAYER      4.18
	#define SINGULARITY_LAYER           4.19
	#define SINGULARITY_EFFECT_LAYER    4.20
	#define POINTER_LAYER               4.21
	// Z-Mimic-managed lighting
	#define MIMICED_LIGHTING_LAYER      4.22

	//FLY_LAYER                          5
	//OBSERVER
	#define BASE_AREA_LAYER             999

#define OBSERVER_PLANE           1
  #define OBSERVER_LAYER           1

#define LIGHTING_PLANE           2 // For Lighting. - The highest plane (ignoring all other even higher planes)
  #define LIGHTBULB_LAYER          1
  #define LIGHTING_LAYER           2

#define EMISSIVE_PLANE           3 // For over-lighting overlays (ex. cigarette glows)
  #define EMISSIVE_LAYER           1

#define ABOVE_LIGHTING_PLANE     4 // laser beams, etc. that shouldn't be affected by darkness
  #define ABOVE_LIGHTING_LAYER     1
  #define BEAM_PROJECTILE_LAYER    2
  #define SUBSPACE_WALL_LAYER      3
  #define OBFUSCATION_LAYER        4

#define FULLSCREEN_PLANE         5 // for fullscreen overlays that do not cover the hud.
  #define FULLSCREEN_LAYER         0
  #define DAMAGE_LAYER             1
  #define IMPAIRED_LAYER           2
  #define BLIND_LAYER              3
  #define CRIT_LAYER               4

#define HUD_PLANE                6
  #define UNDER_HUD_LAYER          0
  #define HUD_BASE_LAYER           2
  #define HUD_ITEM_LAYER           3
  #define HUD_ABOVE_ITEM_LAYER     4
  #define HUD_ABOVE_HUD_LAYER      5
