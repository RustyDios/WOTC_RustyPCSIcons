//*******************************************************************************************
//  FILE:   X2EventListener_PCSIcons_Fix                                 
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

class X2EventListener_PCSIcons_Fix extends X2EventListener;

//add the listener
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreatePCSIconsFix());

	return Templates;
}

//create the listener	OnGetPCSImage
static function X2EventListenerTemplate CreatePCSIconsFix()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'PCSIconsFix');

	Template.RegisterInTactical = true;		//listen during missions
	Template.RegisterInStrategy = true;		//listen during avenger

	//set to listen for event, do a thing, at this time ... priority 30 means it should run after other mods, like MOCX, PexM and LWotC
	Template.AddCHEvent('OnGetPCSImage', FixPCSIcons, ELD_Immediate,30);

	return Template;
}

/*	
	//Called from UiUtilities_Image GetPCSImage
	Tuple = new class'XComLWTuple';
	Tuple.id = 'GetPCSImageTuple';
	Tuple.Data.Add(2);
	
	Tuple.Data[0].kind = XComLWTVObject;
	Tuple.Data[0].o = Item;

	Tuple.Data[1].kind = XComLWTVString;
	Tuple.Data[1].s = ""; // To be used for return value

	`XEVENTMGR.TriggerEvent('OnGetPCSImage', Tuple);
*/

//what does the listener do when it hears a call?
static function EventListenerReturn FixPCSIcons(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Item	ItemState;
	local XComLWTuple			Tuple;

	Tuple = XComLWTuple(EventData);
	ItemState = XComGameState_Item(Tuple.Data[0].o);

	if (ItemState != none)
	{
		//Bio Division Icon override the above fix with a colour version
		if (InStr(ItemState.GetMyTemplateName(), "PCSBioDamageControl", , true) != INDEX_NONE)		{Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_BB";	}

		////HIVE ..... PCSTacticalCoverage   PCSTacticalWithdraw     PCSTacticalSensesOffense    PCSTacticalSensesDefense
		if (InStr(ItemState.GetMyTemplateName(), "PCSTacticalCoverage", , true) != INDEX_NONE)		{Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_SPAWN";	}
		if (InStr(ItemState.GetMyTemplateName(), "PCSTacticalWithdraw", , true) != INDEX_NONE)		{Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_SPAWN";	}
		if (InStr(ItemState.GetMyTemplateName(), "PCSTacticalSensesOffense", , true) != INDEX_NONE)	{Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_RUSH";	}
		if (InStr(ItemState.GetMyTemplateName(), "PCSTacticalSensesDefense", , true) != INDEX_NONE)	{Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_RUSH";	}

		//BaseGame PCS'
		if (InStr(ItemState.GetMyTemplateName(), "PCSSpeed", , true) != INDEX_NONE)			{Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_mobility";		}
		if (InStr(ItemState.GetMyTemplateName(), "PCSConditioning", , true) != INDEX_NONE)	{Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_health";		}
		if (InStr(ItemState.GetMyTemplateName(), "PCSPerception", , true) != INDEX_NONE)	{Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_aim";			}
		if (InStr(ItemState.GetMyTemplateName(), "PCSAgility", , true) != INDEX_NONE)		{Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_dodge";		}
		if (InStr(ItemState.GetMyTemplateName(), "PCSFocus", , true) != INDEX_NONE)			{Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_will";			}

		//Add icons for the two new PCS' no config option
		if (InStr(ItemState.GetMyTemplateName(), "PCSPsi", , true) != INDEX_NONE)		{Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_psi";		}
		if (InStr(ItemState.GetMyTemplateName(), "PCSHack", , true) != INDEX_NONE)		{Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_hack";		}

		//LWotC PCS' matched exactly by name
		switch (ItemState.GetMyTemplateName())
		{
			case 'DepthPerceptionPCS':		Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_DepthPerception"; 		break;
			case 'HyperReactivePupilsPCS':	Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_HyperReactivePupils"; 	break;
			case 'CombatAwarenessPCS':		Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_ThreatAssesment"; 		break;
			case 'DamageControlPCS':		Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_DamageControl"; 		break;
			case 'ImpactFieldsPCS':			Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_ImpactFields"; 			break;
			case 'BodyShieldPCS':			Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_BodyShield"; 			break;
			case 'EmergencyLifeSupportPCS':	Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_EmergencyLifeSupport";	break;
			case 'IronSkinPCS':  			Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_Ironskin"; 				break;
			case 'SmartMacrophagesPCS':  	Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_SmartMacrophages"; 		break;
			case 'CombatRushPCS':  			Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_CombatRush"; 			break;
			default:  break;
		}
	}

	return ELR_NoInterrupt;
}

//	default image icons are based off StatType improved, note how PsiOffense and Dodge shared icons
//	also PCS' with no stat (ability use abused) wouldn't get an image...
/*
switch(StatType)
	{
	case eStat_HP:          return "img:///UILibrary_Common.implants_health";	//conditioning
	case eStat_Mobility:    return "img:///UILibrary_Common.implants_mobility";	//speed
	case eStat_Offense:     return "img:///UILibrary_Common.implants_offense";	//perception
	case eStat_PsiOffense:  return "img:///UILibrary_Common.implants_psi";		//??
	case eStat_Will:        return "img:///UILibrary_Common.implants_will";		//focus
	case eStat_Dodge:		return "img:///UILibrary_Common.implants_psi";		//agility
	case eStat_Hacking		??													//??
	case eStat_Defense		??													//??
	case eStat_Armor		??													//??
	default:                return "img:///UILibrary_Common.implants_empty";
	}

[eStat_HP]			//base game conditioning
[eStat_Offense]		//base game perception (aim)
[eStat_Mobility]	//base game speed	
[eStat_Will]		//base game focus
[eStat_Dodge]		//base game agility	

[eStat_Defense]		//covered by bio division
[eStat_Hacking]		//covered by mods
[eStat_PsiOffense]	//covered by mods

[eStat_CombatSims]	//# of PCS can equip?

//things I think should have a PCS added, LW covers some of these...
[eStat_CritChance]		[eStat_FlankingCritChance]	[eStat_FlankingAimBonus]		
[eStat_DetectionRadius]	[eStat_SightRadius]
[eStat_HackDefense]
[eStat_ArmorChance]		[eStat_ArmorMitigation]		[eStat_ArmorPiercing]

//things I have no idea of what they are
[eStat_Strength]		[eStat_AlertLevel]			[eStat_ReserveActionPoints]
[eStat_FlightFuel]		[eStat_UtilityItems]		[eStat_BackpackSize]		
[eStat_HighCoverConcealment]
*/
