//*******************************************************************************************
//  FILE:   XComDownloadableContentInfo_WOTC_RustyPCSIcons.uc                                    
//  
//	File created by RustyDios	15/09/19	12:20	
//	LAST UPDATED				19/02/23	16:40
//
//	Adds an event listener to fix PCS Icons for custom PCS'
//		Current Fixes for	BIO Division 2.0	Bio PCS: Damage Control
//							All PCS Icons		LW PCS'     MOCX
//
//	Coded with help from Iridar and the XCOM Modders Discord
//
//*******************************************************************************************

class X2DownloadableContentInfo_WOTC_RustyPCSIcons extends X2DownloadableContentInfo config (RustyPCSIcons);

static event OnLoadedSavedGame(){}

static event InstallNewCampaign(XComGameState StartState){}

static event OnPostTemplatesCreated()
{
	local X2ItemTemplateManager	ItemMgr;
	local int i;

	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

    // fixes up the inventory icons to match the new colours
	for (i = 0 ; i < class'X2EventListener_PCSIcons_Fix'.default.ColouredPCSIconOverrides.length ; i++)
	{
		if (class'X2EventListener_PCSIcons_Fix'.default.ColouredPCSIconOverrides[i].InvImagePath != "")
		{
			PatchImages_Item(ItemMgr.FindItemTemplate(
					class'X2EventListener_PCSIcons_Fix'.default.ColouredPCSIconOverrides[i].PCSName),
			 		class'X2EventListener_PCSIcons_Fix'.default.ColouredPCSIconOverrides[i].InvImagePath);
		}
	}
}

static function PatchImages_Item (X2ItemTemplate Template, string ImagePath)
{
	if (Template != none)
	{
		Template.strImage = "img:///" $ImagePath;
		`LOG("Patched Image Item :: " @Template.GetItemFriendlyName() , class'X2EventListener_PCSIcons_Fix'.default.bEnableLogging, 'Rusty_ColouredPCS');
	}
}
