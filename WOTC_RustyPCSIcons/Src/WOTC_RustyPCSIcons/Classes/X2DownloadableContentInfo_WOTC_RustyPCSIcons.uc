//*******************************************************************************************
//  FILE:   XComDownloadableContentInfo_WOTC_RustyPCSIcons.uc                                    
//  
//	File created by RustyDios	15/09/19	12:20	
//	LAST UPDATED				15/03/21	14:50
//
//	Adds an event listener to fix PCS Icons for custom PCS'
//		Current Fixes for	BIO Division 2.0	Bio PCS: Damage Control
//							All PCS Icons		LW PCS'
//
//	Coded with help from Iridar and the XCOM Modders Discord
//
//*******************************************************************************************

class X2DownloadableContentInfo_WOTC_RustyPCSIcons extends X2DownloadableContentInfo;

static event OnLoadedSavedGame(){}

static event InstallNewCampaign(XComGameState StartState){}
