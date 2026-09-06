// Keys used to create HUD elements, and to set and retrieve icons from the UI decl system.
#define HUD_STAMINA      /decl/hud_element/stamina
#define HUD_DROP         /decl/hud_element/drop
#define HUD_RESIST       /decl/hud_element/resist
#define HUD_THROW        /decl/hud_element/throw_toggle
#define HUD_MANEUVER     /decl/hud_element/maneuver
#define HUD_ZONE_SELECT  /decl/hud_element/zone_selector
#define HUD_MOVEMENT     /decl/hud_element/movement
#define HUD_INVENTORY    /decl/hud_element/inventory
#define HUD_ATTACK       /decl/hud_element/attack
#define HUD_HANDS        /decl/hud_element/hands
#define HUD_INTERNALS    /decl/hud_element/internals
#define HUD_HEALTH       /decl/hud_element/health
#define HUD_INTENT       /decl/hud_element/intent
#define HUD_CRIT_MARKER  /decl/hud_element/crit
#define HUD_NUTRITION    /decl/hud_element/nutrition
#define HUD_HYDRATION    /decl/hud_element/hydration
#define HUD_FIRE_INTENT  /decl/hud_element/gun_mode
#define HUD_UP_HINT      /decl/hud_element/upward
#define HUD_BODYTEMP     /decl/hud_element/bodytemp
#define HUD_PRESSURE     /decl/hud_element/pressure
#define HUD_TOX          /decl/hud_element/toxins
#define HUD_OXY          /decl/hud_element/oxygen
#define HUD_FIRE         /decl/hud_element/fire
#define HUD_CHARGE       /decl/hud_element/charge
#define HUD_ROBOT_MODULE /decl/hud_element/module_selection
#define HUD_MODIFIERS    /decl/hud_element/modifiers

#define GET_HUD_ALERT(M, A)        ((istype(M?.hud_used, /datum/hud) && (A in M.hud_used.alerts)) ? M.hud_used.alerts[A] : 0)
#define CLEAR_HUD_ALERTS(M)        if(istype(M?.hud_used, /datum/hud) && M.hud_used.alerts)                    { M.hud_used.alerts = null; }
#define SET_HUD_ALERT(M, A, V)     if(istype(M?.hud_used, /datum/hud))                                         { LAZYSET(M.hud_used.alerts, A, V); }
#define SET_HUD_ALERT_MIN(M, A, V) if(istype(M?.hud_used, /datum/hud) && V < LAZYACCESS(M.hud_used.alerts, A)) { LAZYSET(M.hud_used.alerts, A, V); }
#define SET_HUD_ALERT_MAX(M, A, V) if(istype(M?.hud_used, /datum/hud) && V > LAZYACCESS(M.hud_used.alerts, A)) { LAZYSET(M.hud_used.alerts, A, V); }
