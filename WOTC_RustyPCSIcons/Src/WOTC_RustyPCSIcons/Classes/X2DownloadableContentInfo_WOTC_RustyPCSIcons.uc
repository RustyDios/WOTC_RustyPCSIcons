//*******************************************************************************************
//  FILE:   XComDownloadableContentInfo_WOTC_RustyPCSIcons.uc                                    
//  
//	File created by RustyDios	15/09/19	12:20	
//	LAST UPDATED				17/04/24	20:00
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
	local array<ColouredPCSIconOverride> ColouredPCSIconOverrides;
	local X2ItemTemplateManager	ItemMgr;
	local bool bLogged;
	local int i;

	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ColouredPCSIconOverrides = class'X2EventListener_PCSIcons_Fix'.default.ColouredPCSIconOverrides;
	bLogged = class'X2EventListener_PCSIcons_Fix'.default.bEnableLogging;

    // fixes up the inventory icons to match the new colours
	for (i = 0 ; i < ColouredPCSIconOverrides.length ; i++)
	{
		if (ColouredPCSIconOverrides[i].InvImagePath != "")
		{
			PatchImages_Item(ItemMgr.FindItemTemplate( ColouredPCSIconOverrides[i].PCSName), ColouredPCSIconOverrides[i].InvImagePath, bLogged);
		}
	}
}

static function PatchImages_Item (X2ItemTemplate Template, string ImagePath, bool bEnableLogging)
{
	if (Template != none)
	{
		Template.strImage = "img:///" $ImagePath;
		`LOG("Patched Image Item :: " @Template.GetItemFriendlyName() , bEnableLogging, 'Rusty_ColouredPCS');
	}
}
