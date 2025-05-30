// Add the vox merchant if the Vox modpack is enabled.
#ifdef MODPACK_VOX
#include "standard_merchants/vox_merchant.dm"
#endif

// Add some supermatter types to a specific merchant if the SM modpack is enabled.
#ifdef CONTENT_PACK_SUPERMATTER
#include "standard_merchants/supermatter_products.dm"
#endif

// Add beekeeping products to manufacturing beacons if the beekeeping modpack is enabled.
#ifdef MODPACK_BEEKEEPING
#include "standard_merchants/beekeeping_products.dm"
#endif

// Add the fishing merchant if the fishing modpack is enabled.
#ifdef CONTENT_PACK_FISHING
#include "standard_merchants/fishing_merchant.dm"
#endif

// Adds brain interfaces to a device merchant if the brain interface modpack is enabled.
#ifdef CONTENT_PACK_BRAIN_INTERFACE
#include "standard_merchants/brain_interface_products.dm"
#endif

// Adds fake carp grenades to the prank store merchant if the holodeck modpack is enabled.
#ifdef CONTENT_PACK_HOLODECK
#include "standard_merchants/holodeck_products.dm"
#endif

// Removes ERT backpacks from trading beacons if the ERT modpack is enabled.
#ifdef MODPACK_RESPONSE_TEAM
#include "standard_merchants/response_team_products.dm"
#endif

// Adds integrated electronic devices and the printer to the electronics store merchant if the circuits modpack is enabled.
#ifdef CONTENT_PACK_CIRCUITS
#include "standard_merchants/integrated_electronics_products.dm"
#endif