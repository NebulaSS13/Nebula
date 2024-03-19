// Keys used to set and retrieve icons from the UI decl system.
#define UI_ICON_INTERACTION "icon_interaction"
#define UI_ICON_ZONE_SELECT "icon_zone_sel"
#define UI_ICON_MOVEMENT    "icon_movement"
#define UI_ICON_INVENTORY   "icon_inventory"
#define UI_ICON_ATTACK      "icon_attack"
#define UI_ICON_HANDS       "icon_hands"
#define UI_ICON_INTERNALS   "icon_internals"
#define UI_ICON_HEALTH      "icon_health"
#define UI_ICON_CRIT_MARKER "icon_crit_marker"
#define UI_ICON_NUTRITION   "icon_nutrition"
#define UI_ICON_HYDRATION   "icon_hydration"
#define UI_ICON_FIRE_INTENT "icon_fire_intent"
#define UI_ICON_INTENT      "icon_intent"
#define UI_ICON_UP_HINT     "icon_uphint"
#define UI_ICON_STATUS      "icon_status"
#define UI_ICON_STATUS_FIRE "icon_status_fire"
#define UI_ICON_CHARGE      "icon_charge"

#define GET_HUD_ALERT(M, A)        ((istype(M?.hud_used, /datum/hud) && (A in M.hud_used.alerts)) ? M.hud_used.alerts[A] : 0)

#define CLEAR_HUD_ALERTS(M)        if(istype(M?.hud_used, /datum/hud) && M.hud_used.alerts)                    { M.hud_used.alerts = null; }
#define SET_HUD_ALERT(M, A, V)     if(istype(M?.hud_used, /datum/hud))                                         { LAZYSET(M.hud_used.alerts, A, V); }
#define SET_HUD_ALERT_MIN(M, A, V) if(istype(M?.hud_used, /datum/hud) && V < LAZYACCESS(M.hud_used.alerts, A)) { LAZYSET(M.hud_used.alerts, A, V); }
#define SET_HUD_ALERT_MAX(M, A, V) if(istype(M?.hud_used, /datum/hud) && V > LAZYACCESS(M.hud_used.alerts, A)) { LAZYSET(M.hud_used.alerts, A, V); }
