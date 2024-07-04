/**
 * Global init hook.
 * Called in global_init.dm when the server is initialized.
 */
/hook/global_init

/**
 * Startup hook.
 * Called in world.dm when the server starts.
 */
/hook/startup

/**
 * Roundstart hook.
 * Called in ticker.dm when a round starts.
 */
/hook/roundstart

/**
 * Roundend hook.
 * Called in ticker.dm when a round ends.
 */
/hook/roundend

/**
 * Shutdown hook.
 * Called in world.dm when world/Del is called.
 */
/hook/shutdown

/**
 * Reboot hook.
 * Called in world.dm prior to the parent call in world/Reboot.
 */
/hook/reboot

/**
 * Death hook.
 * Called in death.dm when someone dies.
 * Parameters: var/mob/living/human, var/gibbed
 */
/hook/death

/**
 * Cloning hook.
 * Called in cloning.dm when someone is brought back by the wonders of modern science.
 * Parameters: var/mob/living/human
 */
/hook/clone

/**
 * Debrained hook.
 * Called in brain_item.dm when someone gets debrained.
 * Parameters: var/obj/item/organ/internal/brain
 */
/hook/debrain

