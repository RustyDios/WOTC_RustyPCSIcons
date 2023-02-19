//*******************************************************************************************
//  FILE:   X2EventListener_PCSIcons_Fix                                 
//  
//	File created by RustyDios	15/09/19	12:20	
//	LAST UPDATED				19/02/23	16:15
//
//	Adds an event listener to fix PCS Icons for custom PCS'
//		Current Fixes for	All PCS Icons	LW PCS'		ABBA
//							BIO Div2.0		HIVE		MOCX	
//
//	Coded with help from Iridar and the XCOM Modders Discord
//
//*******************************************************************************************

class X2EventListener_PCSIcons_Fix extends X2EventListener config (RustyPCSIcons);

struct ColouredPCSIconOverride
{
	var name PCSName;
	var string IconPath;
	var string InvImagePath;
};

var config bool bEnableLogging, bEnableUnknownIcon;
var config array<ColouredPCSIconOverride> ColouredPCSIconOverrides;

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
	Template.AddCHEvent('OnGetPCSImage', FixPCSIcons, ELD_Immediate, 30);

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
	local name TemplateName;
	local bool bIsSet;
	local int i;

	Tuple = XComLWTuple(EventData);
	
	if (Tuple == none)
	{
		//EARLY BAILOUT SOMETHING WENT VERY WRONG
		`LOG("NO TUPLE DATA. ABORTED", default.bEnableLogging, 'Rusty_ColouredPCS');
		return ELR_NoInterrupt;

	}

	//GRAB THE PCS ITEM
	ItemState = XComGameState_Item(Tuple.Data[0].o);
	bIsSet = false;

	if (ItemState != none)
	{
		`LOG("PCS Icon being adjusted:" @ItemState.GetMyTemplateName(), default.bEnableLogging, 'Rusty_ColouredPCS');
		`LOG("PCS Icon Currently Set :" @Tuple.Data[1].s, default.bEnableLogging, 'Rusty_ColouredPCS');

		TemplateName = ItemState.GetMyTemplateName();

		for(i = 0 ; i < default.ColouredPCSIconOverrides.length ; i++)
		{
			if (TemplateName == default.ColouredPCSIconOverrides[i].PCSName)
			{
				Tuple.Data[1].s = "img:///" $ default.ColouredPCSIconOverrides[i].IconPath;
				bIsSet = true;
				continue;
			}
		}

		//FIRST CHECK POINT FOR CONFIG MATCH
		if (bIsSet)
		{
			bIsSet = false;

			`LOG("NEW PCS Icon Set :" @Tuple.Data[1].s, default.bEnableLogging, 'Rusty_ColouredPCS');

			return ELR_NoInterrupt;
		}

		`LOG("No exact name Coloured PCS match for :: " @ItemState.GetMyTemplateName(), default.bEnableLogging, 'Rusty_ColouredPCS');

		//FALLBACK OPTIONS IN CASE EXACT NAME MATCH FAILS ... ONLY CHECK IF WE'VE NOT FOUND A MATCH ... 
		if (!bIsSet && InStr(ItemState.GetMyTemplateName(), "PCSPsi", , true) != INDEX_NONE)			{Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_psi";		bIsSet = true;	}
		if (!bIsSet && InStr(ItemState.GetMyTemplateName(), "PCSHack", , true) != INDEX_NONE)			{Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_hack";		bIsSet = true;	}
		if (!bIsSet && InStr(ItemState.GetMyTemplateName(), "PCSSpeed", , true) != INDEX_NONE)			{Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_mobility";	bIsSet = true;	}
		if (!bIsSet && InStr(ItemState.GetMyTemplateName(), "PCSFocus", , true) != INDEX_NONE)			{Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_will";		bIsSet = true;	}
		if (!bIsSet && InStr(ItemState.GetMyTemplateName(), "PCSDefense", , true) != INDEX_NONE)		{Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_Defense";	bIsSet = true;	}
		if (!bIsSet && InStr(ItemState.GetMyTemplateName(), "PCSAgility", , true) != INDEX_NONE)		{Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_dodge";	bIsSet = true;	}
		if (!bIsSet && InStr(ItemState.GetMyTemplateName(), "PCSPerception", , true) != INDEX_NONE)		{Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_aim";		bIsSet = true;	}
		if (!bIsSet && InStr(ItemState.GetMyTemplateName(), "PCSConditioning", , true) != INDEX_NONE)	{Tuple.Data[1].s = "img:///UILib_RD_PCS.UIPerk_combatstim_rd_health";	bIsSet = true;	}

		//SECOND CHECK POINT FOR UNMATCHED NAME BUT STANDARD FORMAT INCLUDED
		if (bIsSet)
		{
			bIsSet = false;

			`LOG("NEW PCS Icon Set :" @Tuple.Data[1].s, default.bEnableLogging, 'Rusty_ColouredPCS');

			return ELR_NoInterrupt;
		}

		`LOG("PCS not caught by Coloured PCS Backup either !", default.bEnableLogging, 'Rusty_ColouredPCS');

		//FINAL ADJUST FOR UNKNOWN PCS IF ENABLED IF WE GOT HERE
		if (default.bEnableUnknownIcon)
		{
			Tuple.Data[1].s = "img:///UILib_RD_PCS.implants_unknown";

			`LOG("PCS icon set with unknown image! for" @ItemState.GetMyTemplateName(), true, 'Rusty_ColouredPCS');
	
			return ELR_NoInterrupt;
		}

	} //end itemstate !=none

	//return with no adjustments
	return ELR_NoInterrupt;
}

//	default image icons are based off StatType improved, note how PsiOffense and Dodge shared icons
//	also PCS' with no stat (ability use abused) wouldn't get an image...	ECharStatType
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

[eStat_Defense]		//covered by bio division, LW
[eStat_Hacking]		//covered by Failsafe, mods
[eStat_PsiOffense]	//covered by PexM, mods

[eStat_CombatSims]	//# of PCS can equip?

//things I think should have a PCS added, LW covers some of these ...
[eStat_ShieldHP]
[eStat_CritChance]		[eStat_FlankingCritChance]	[eStat_FlankingAimBonus]		
[eStat_DetectionRadius]	[eStat_SightRadius]
[eStat_HackDefense]
[eStat_ArmorChance]		[eStat_ArmorMitigation]		[eStat_ArmorPiercing]

//things that should not have a PCS
[eStat_Strength]		used in vs test for knockout from zerkers and stunnies
[eStat_AlertLevel]		enemy behaviour pattern
[eStat_UtilityItems]	# of utility item slots

//things I have no idea of what they are wrt PCS
[eStat_ReserveActionPoints]		[eStat_FlightFuel]
[eStat_BackpackSize]			[eStat_HighCoverConcealment]

*/
