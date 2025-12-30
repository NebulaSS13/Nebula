/*
	These defines specificy screen locations.  For more information, see the byond documentation on the screen_loc var.

	The short version:

	Everything is encoded as strings because apparently that's how Byond rolls.

	"1,1" is the bottom left square of the user's screen.  This aligns perfectly with the turf grid.
	"1:2,3:4" is the square (1,3) with pixel offsets (+2, +4); slightly right and slightly above the turf grid.
	Pixel offsets are used so you don't perfectly hide the turf under them, that would be crappy.

	The size of the user's screen is defined by client.view (indirectly by world.view), in our case "15x15".
	Therefore, the top right corner (except during admin shenanigans) is at "15,15"
*/

#define ui_entire_screen "WEST,SOUTH to EAST,NORTH"
#define ui_center_fullscreen "CENTER-7,CENTER-7"

//Lower left, persistent menu
#define ui_inventory "LEFT:6,BOTTOM:5"

//Lower center, persistent menu
#define ui_sstore1 "LEFT+2:10,BOTTOM:5"
#define ui_back "LEFT+3:22,BOTTOM:5"
#define ui_id "LEFT+4:26,BOTTOM:5"
#define ui_belt "RIGHT-5:16,BOTTOM:5"
#define ui_rhand "CENTER-1:16,BOTTOM:5"
#define ui_lhand "CENTER:16,BOTTOM:5"
#define ui_equip "CENTER-1:16,BOTTOM+1:5"
#define ui_swaphand1 "CENTER-1:16,BOTTOM+1:5"
#define ui_swaphand2 "CENTER:16,BOTTOM+1:5"
#define ui_storage1 "RIGHT-3:16,BOTTOM:5"
#define ui_storage2 "RIGHT-4:16,BOTTOM:5"

// Robot defines.
#define ui_inv1 "CENTER-1,BOTTOM:21"
#define ui_inv2 "CENTER,BOTTOM:21"
#define ui_inv3 "CENTER+1,BOTTOM:21"
#define ui_borg_store "CENTER+2,BOTTOM:21"
#define ui_borg_inventory "CENTER-2,BOTTOM:21"
#define ui_borg_drop_grab "CENTER-3,BOTTOM:21"

#define ui_construct_health "RIGHT:00,CENTER:15" //same height as humans, hugging the right border
#define ui_construct_fire "RIGHT-1:16,CENTER+1:13" //above health, slightly to the left
#define ui_construct_pull "RIGHT-1:28,BOTTOM+1:10" //above the zone selector icon

//Lower right, persistent menu
#define ui_dropbutton "RIGHT-4:22,BOTTOM:5"
#define ui_drop_throw "RIGHT-1:28,BOTTOM+1:7"
#define ui_pull_resist "RIGHT-2:26,BOTTOM+1:7"
#define ui_acti "CENTER,BOTTOM:5"
#define ui_movi "RIGHT-2:24,BOTTOM:5"
#define ui_attack_selector "RIGHT-2:27,BOTTOM+2:9"
#define ui_zonesel "RIGHT-1:28,BOTTOM:5"
#define ui_stamina "RIGHT-2:24,BOTTOM:8"

#define ui_borg_module "RIGHT-1:28,BOTTOM+1:7"

//Gun buttons
#define ui_gun1 "RIGHT-1:28,BOTTOM+3:7"
#define ui_gun2 "RIGHT-2:28,BOTTOM+3:7"
#define ui_gun3 "RIGHT-3:28,BOTTOM+3:7"
#define ui_gun_select "RIGHT-1:28,BOTTOM+2:7"

//Upper-middle right (damage indicators and up hint)
#define ui_up_hint "RIGHT-1:28,TOP-1:29"
#define ui_toxin "RIGHT-1:28,TOP-2:27"
#define ui_fire "RIGHT-1:28,TOP-3:25"
#define ui_oxygen "RIGHT-1:28,TOP-4:23"
#define ui_pressure "RIGHT-1:28,TOP-5:21"

#define ui_alien_toxin "RIGHT-1:28,TOP-2:25"
#define ui_alien_fire "RIGHT-1:28,TOP-3:25"
#define ui_alien_oxygen "RIGHT-1:28,TOP-4:25"

//Middle right (status indicators)
#define ui_nutrition "RIGHT-1:28,CENTER-2:11"
#define ui_nutrition_small "RIGHT-1:28,CENTER-2:24"
#define ui_temp "RIGHT-1:28,CENTER-1:13"
#define ui_health "RIGHT-1:28,CENTER:15"
#define ui_internal "RIGHT-1:28,CENTER+1:17"

// Robots have the health display where humans have the pressure damage indicator.
#define ui_borg_health "RIGHT-1:28,CENTER-1:13"

//Pop-up inventory
#define ui_shoes "LEFT+1:8,BOTTOM:5"

#define ui_iclothing "LEFT:6,BOTTOM+1:7"
#define ui_oclothing "LEFT+1:8,BOTTOM+1:7"
#define ui_gloves "LEFT+2:10,BOTTOM+1:7"

#define ui_glasses "LEFT:6,BOTTOM+2:9"
#define ui_mask "LEFT+1:8,BOTTOM+2:9"
#define ui_l_ear "LEFT+2:10,BOTTOM+2:9"
#define ui_r_ear "LEFT+2:10,BOTTOM+3:11"

#define ui_head "LEFT+1:8,BOTTOM+3:11"

#define ui_iarrowleft "BOTTOM-1,RIGHT-4"
#define ui_iarrowright "BOTTOM-1,RIGHT-2"

#define ui_ability_master "RIGHT-2:16,TOP-1:16"

// AI
#define ui_ai_core "LEFT:6,BOTTOM:5"
#define ui_ai_announcement "LEFT+1:10,BOTTOM:5"
#define ui_ai_cam_track "LEFT+2:12,BOTTOM:5"
#define ui_ai_cam_light "LEFT+3:14,BOTTOM:5"
#define ui_ai_cam_change_channel "LEFT+4:16,BOTTOM:5"
#define ui_ai_sensor "CENTER-2:18,BOTTOM:5"
#define ui_ai_crew_manifest "CENTER-1:20,BOTTOM:5"
#define ui_ai_take_image "CENTER:22,BOTTOM:5"
#define ui_ai_view_images "CENTER+1:24,BOTTOM:5"
#define ui_ai_state_laws "CENTER+2:26,BOTTOM:5"
#define ui_ai_call_shuttle "RIGHT-4:28,BOTTOM:5"

#define ui_ai_up "RIGHT-1:30,BOTTOM+1:5"
#define ui_ai_down "RIGHT-1:30,BOTTOM:5"

// AI: Customization
#define ui_ai_holo_change "RIGHT-1:30,BOTTOM+2:5"
#define ui_ai_color "RIGHT-1:30,BOTTOM+3:5"
#define ui_ai_core_icon "RIGHT-1:30,BOTTOM+4:5"
#define ui_ai_status "RIGHT-1:30,BOTTOM+5:5"

// AI: Tools
#define ui_ai_power_override "LEFT:6,TOP:0"
#define ui_ai_shutdown "LEFT+1:6,TOP:0"
#define ui_ai_holo_mov "LEFT:6, TOP-1:0"

// AI: Crew
#define ui_ai_crew_mon "RIGHT-1:30,TOP:0"
#define ui_ai_crew_rec "RIGHT-2:30, TOP:0"

// pAI
#define ui_pai_software "TOP,LEFT:6"
#define ui_pai_subsystems "TOP,LEFT+1:6"
#define ui_pai_shell "TOP,LEFT+2:6"
#define ui_pai_light "TOP,LEFT+3:6"
#define ui_pai_rest "TOP,LEFT+4:6"

// storage menu
#define ui_storage_default "LEFT+7,BOTTOM+7 to LEFT+10,BOTTOM+8"
