//*******************************************************************************************
//  FILE:   XComDownloadableContentInfo_WOTC_RustyPCSIcons.uc                                    
//  
//	File created by RustyDios	15/09/19	12:20	
//	LAST UPDATED				15/02/22    23:30
//
//	Adds an event listener to fix PCS Icons for custom PCS'
//		Current Fixes for	BIO Division 2.0	Bio PCS: Damage Control
//							All PCS Icons		LW PCS'     MOCX
//
//	Coded with help from Iridar and the XCOM Modders Discord
//
//*******************************************************************************************

class X2DownloadableContentInfo_WOTC_RustyPCSIcons extends X2DownloadableContentInfo;

static event OnLoadedSavedGame(){}

static event InstallNewCampaign(XComGameState StartState){}

static event OnPostTemplatesCreated()
{
	local X2ItemTemplateManager					AllItems;			//holder for all items

	AllItems				= class'X2ItemTemplateManager'.static.GetItemTemplateManager();

    // fixes up the inventory icons to match the new colours
	PatchImages_Item(AllItems.FindItemTemplate('LongJumpPCS'), "UILib_RD_PCS.INV_PCS_MOCX_LONG");
	PatchImages_Item(AllItems.FindItemTemplate('MimeticSkinPCS'), "UILib_RD_PCS.INV_PCS_MOCX_STEALTH");

    PatchImages_Item(AllItems.FindItemTemplate('PCSTacticalCoverage'), "UILib_RD_PCS.INV_PCS_HIVE_SPAWN");
    PatchImages_Item(AllItems.FindItemTemplate('PCSTacticalWithdraw'), "UILib_RD_PCS.INV_PCS_HIVE_SPAWN");
    PatchImages_Item(AllItems.FindItemTemplate('PCSTacticalSensesOffense'), "UILib_RD_PCS.INV_PCS_HIVE_RUSH");
    PatchImages_Item(AllItems.FindItemTemplate('PCSTacticalSensesDefense'), "UILib_RD_PCS.INV_PCS_HIVE_RUSH");

}

static function PatchImages_Item (X2ItemTemplate Template, string ImagePath)
{
	if (Template != none)
	{
		Template.strImage = "img:///" $ImagePath;
		`LOG("Patched Image Item :: " @Template.GetItemFriendlyName() , true, 'Rusty_ColouredPCS');
	}
}
