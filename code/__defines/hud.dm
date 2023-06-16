#define CLEAR_HUD_ALERTS(M)        if(istype(M?.hud_used, /datum/hud) && M.hud_used.alerts)                    { M.hud_used.alerts = null; }
#define SET_HUD_ALERT(M, A, V)     if(istype(M?.hud_used, /datum/hud))                                         { LAZYSET(M.hud_used.alerts, A, V); }
#define SET_HUD_ALERT_MIN(M, A, V) if(istype(M?.hud_used, /datum/hud) && V < LAZYACCESS(M.hud_used.alerts, A)) { LAZYSET(M.hud_used.alerts, A, V); }
#define SET_HUD_ALERT_MAX(M, A, V) if(istype(M?.hud_used, /datum/hud) && V > LAZYACCESS(M.hud_used.alerts, A)) { LAZYSET(M.hud_used.alerts, A, V); }
