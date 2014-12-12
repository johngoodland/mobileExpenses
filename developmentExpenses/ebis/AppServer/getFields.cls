 
 /*------------------------------------------------------------------------
    File        : getFields
    Syntax      : 
    Author(s)   : John.Goodland
    Created     : Thu Jul 11 13:42:39 BST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
     
@program FILE(name="getFields.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="getFields", URI="/getFields", schemaName="eFields", schemaFile="ebis/AppServer/dseFields.i").

USING Progress.Json.ObjectModel.JsonObject.
USING Progress.Json.ObjectModel.JsonArray. 
USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS AppServer.getFields INHERITS BusinessEntity:

    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
	
	
	{"dseFields.i"} 

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/

	METHOD PUBLIC CHARACTER getMobileField( INPUT cConvertField AS CHARACTER ):
		
	DEFINE VARIABLE result       AS  CHARACTER  NO-UNDO.
    DEFINE VARIABLE cMobileName  AS  CHARACTER  NO-UNDO.
    DEFINE VARIABLE cEBisName    AS  CHARACTER  NO-UNDO.
    DEFINE VARIABLE iPos         AS  INTEGER    NO-UNDO.
    DEFINE VARIABLE cEbisField   AS  CHARACTER  NO-UNDO.
    /* names changed from ebis to mobile  */
    ASSIGN
      cMobileName = 'cExpGroup,cExpType,cExpDate,cExpReason,cExpAmount,cExpCharge,cExpPurpose,cExpOOP,cExpPayee,cExpNoPeople,cExpNoNights,'
                  + 'cExpEveMeal,cExpBreak,cExpLunch,cExpPeople,cExpVisit,cExpFrom,cExpTo,cExpRound,cExpMap,cExpCalcMiles,cExpClaimMiles,'
                  + 'cExpVehicle,cExpYTDMiles,cExpNoPeople,cExpMap' 
      cEBisName   = 'cExpGroup,cExpType,cExpDate,cExpReason,cExpAmount,chkRecharge,lnAdd_purpose,lnAdd_oopExplanation,lnAdd_payee,lnAdd_numPeople,lnAdd_numNights,'
                  + 'lnAdd_chkIncEveMeal,lnAdd_chkIncBreakfast,lnAdd_chkIncLunch,lnAdd_people,lnAdd_visiting,lnAdd_fromLoc,lnAdd_toLoc,lnAdd_chkRoundtrip,'
                  + 'cExpMap,lnAdd_calcMiles,lnAdd_claimMiles,lnAdd_vehicle,lnAdd_ytdMiles,lnAdd_otherPeople,lnAdd_btnShowMap'.
		
	ASSIGN
      iPos = LOOKUP(cConvertField,cEBisName).
    
    IF iPos = 0 THEN RETURN cConvertField. /* send back same field and worry about it on the device */
    
    ASSIGN    
      result = ENTRY(iPos,cMobileName).
      
	RETURN result.

	END METHOD.

    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, based on a filter string                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json"). 
    METHOD PUBLIC VOID ReadgetTypes(
    		INPUT filter AS CHARACTER, 
    		OUTPUT TABLE eFields):      
	       
	EMPTY TEMP-TABLE eFields NO-ERROR.
	
	DEFINE VARIABLE oFilter      AS  JsonObject NO-UNDO.
    DEFINE VARIABLE pcUserID     AS  CHARACTER  NO-UNDO.  
    DEFINE VARIABLE lErrorFlag   AS  CHARACTER  NO-UNDO.  
    DEFINE VARIABLE cErrorText   AS  CHARACTER  NO-UNDO.   

    /* parse out the filter looking for the user */
    oFilter = ParseFilter(filter). 
    pcUserId = oFilter:GetCharacter('UserID'). 

    message "Calling API mobex/getgrouplist.p - but for fields".
    RUN mobex/getgrouplist.p
      (INPUT false,  /* debug mode false will now come from user record not mobile device */
       INPUT pcUserID,
       INPUT "", /* last group */
       OUTPUT TABLE ttGroups,
       OUTPUT TABLE ttRules,
       OUTPUT TABLE ttFields,
       OUTPUT lErrorFlag,
       OUTPUT cErrorText).
    
    FOR EACH ttGroups NO-LOCK BREAK BY ttgGroup:
      IF FIRST-OF(ttgGroup) THEN DO:
        /* mandatory fields */
        CREATE eFields.
        ASSIGN cGroup = ttgGroup
               iFieldOrder  = -100
               cFieldLabel = "Group" 
               cFieldName = "cExpGroup"
               cFieldDataType = "text"
               cFieldMandatory = "D"
               cFieldHidden = "S".
        CREATE eFields.
        ASSIGN cGroup = ttgGroup
               iFieldOrder  = -90
               cFieldLabel = "Type" 
               cFieldName = "cExpType"
               cFieldDataType = "text"
              cFieldMandatory = "O"
               cFieldHidden = "S".
        CREATE eFields.   
        ASSIGN cGroup = ttgGroup
               iFieldOrder  = -80
               cFieldLabel = "Date" 
               cFieldName = "cExpDate"
               cFieldDataType = "text"
               cFieldMandatory = "M"
               cFieldHidden = "S".
        CREATE eFields. 
        ASSIGN cGroup = ttgGroup
               iFieldOrder  = -70
               cFieldLabel = "Reason" 
               cFieldName = "cExpReason"
               cFieldDataType = "text"
               cFieldMandatory = "M"
               cFieldHidden = "S".
        CREATE eFields. 
        ASSIGN cGroup = ttgGroup
               iFieldOrder  = IF ttgroups.ttgType = "MILEAGE" THEN 998 ELSE -60
               cFieldLabel = "Amount" 
               cFieldName = "cExpAmount"
               cFieldDataType = "decimal"
               cFieldMandatory = IF ttgroups.ttgType = "MILEAGE" THEN "D" ELSE "M" 
               cFieldHidden = "S".   
        IF ttGroups.ttgType <> "MILEAGE" THEN DO:
          CREATE eFields. 
          ASSIGN cGroup = ttgGroup
                 iFieldOrder  = 999
                 cFieldLabel = "No Receipt" 
                 cFieldName = "chkNoReceipt"
                 cFieldDataType = "log"
                 cFieldMandatory = "O" 
                 cFieldHidden = "S".       
        END.
        ELSE DO:
          CREATE eFields. 
          ASSIGN cGroup = ttgGroup
                 iFieldOrder  = 997
                 cFieldLabel = "Unit Price" 
                 cFieldName = "cUnitPrice"
                 cFieldDataType = "decimal"
                 cFieldMandatory = "O" 
                 cFieldHidden = "S".           
        END.
        FOR EACH ttFields
          WHERE  ttFields.ttfGroup = ttGroups.ttgGroup NO-LOCK:
          CREATE eFields.
          ASSIGN 
            cGroup = ttfGroup
            iFieldOrder  = IF ttfOrder = 0 THEN 1 ELSE ttfOrder
            cFieldLabel  = ttfLabel
            cFieldName   = getMobileField(ttfName)
            cFieldDataType = ttfType
            cFieldMandatory = ttfMandatory
            cFieldHidden = "S" /* could use this field for default ttfDefault */.
        END.
      END.
    END. 
 
    /*
           CREATE eFields.
           ASSIGN cGroup = "Accommodation"
                  iFieldOrder  = 10
                  cFieldLabel = "Group" 
                  cFieldName = "cExpGroup"
                  cFieldDataType = "text"
                  cFieldMandatory = "D"
                  cFieldHidden = "S".
              CREATE eFields.
           ASSIGN cGroup = "Accommodation"
                  iFieldOrder  = 20
                  cFieldLabel = "Type" 
                  cFieldName = "cExpType"
                  cFieldDataType = "text"
                  cFieldMandatory = "O"
                  cFieldHidden = "S".
           CREATE eFields.   
           ASSIGN cGroup = "Accommodation"
                  iFieldOrder  = 30
                  cFieldLabel = "Date" 
                  cFieldName = "cExpDate"
                  cFieldDataType = "text"
                  cFieldMandatory = "M"
                  cFieldHidden = "S".
            CREATE eFields. 
            ASSIGN cGroup = "Accommodation"
                  iFieldOrder  = 40
                  cFieldLabel = "Reason" 
                  cFieldName = "cExpReason"
                  cFieldDataType = "text"
                  cFieldMandatory = "M"
                  cFieldHidden = "S".
 
             CREATE eFields.
             ASSIGN cGroup = "Accommodation"
                  iFieldOrder  = 50
                  cFieldLabel = "Amount" 
                  cFieldName = "cExpAmount"
                  cFieldDataType = "decimal"
                  cFieldMandatory = "M"
                  cFieldHidden = "S".
             CREATE eFields.
              ASSIGN cGroup = "Accommodation"
                  iFieldOrder  = 105
                  cFieldLabel = "Recharge Customer" 
                  cFieldName = "cExpCharge"
                  cFieldDataType = "text"
                  cFieldMandatory = "o"
                  cFieldHidden = "S".
                   CREATE eFields.
               ASSIGN cGroup = "Accommodation"
                  iFieldOrder  = 70
                  cFieldName = "cExpPurpose" 
                  cFieldLabel = "Purpose"
                  cFieldDataType = "text"
                  cFieldMandatory = "o"
                  cFieldHidden = "S".
                   CREATE eFields.
                ASSIGN cGroup = "Accommodation"
                  iFieldOrder  = 80
                  cFieldName = "cExpOOP" 
                  cFieldLabel = "OOP Reason"
                  cFieldDataType = "text"
                  cFieldMandatory = "o"
                  cFieldHidden = "H".
                   CREATE eFields.
                 ASSIGN cGroup = "Accommodation"
                  iFieldOrder  = 90
                  cFieldName = "cExpPayee" 
                  cFieldLabel = "Payee"
                  cFieldDataType = "text"
                  cFieldMandatory = "O"
                  cFieldHidden = "H".
                   CREATE eFields.
                   ASSIGN cGroup = "Accommodation"
                  iFieldOrder  = 100
                  cFieldName = "cExpNoPeople" 
                  cFieldLabel = "No. People"
                  cFieldDataType = "text"
                  cFieldMandatory = "O"
                  cFieldHidden = "H".
                   CREATE eFields.
                    ASSIGN cGroup = "Accommodation"
                  iFieldOrder  = 100
                  cFieldName = "cExpNoNights" 
                  cFieldLabel = "No. Nights"
                  cFieldDataType = "text"
                  cFieldMandatory = "O"
                  cFieldHidden = "S".
                   CREATE eFields.
                     ASSIGN cGroup = "Accommodation"
                  iFieldOrder  = 110
                  cFieldName = "cExpEveMeal" 
                  cFieldLabel = "Includes Evening Meal"
                  cFieldDataType = "text"
                  cFieldMandatory = "O"
                  cFieldHidden = "S".
                   CREATE eFields.
              ASSIGN cGroup = "Accommodation"
                  iFieldOrder  = 120
                  cFieldName = "cExpBreak" 
                  cFieldLabel = "Includes Breakfast"
                  cFieldDataType = "text"
                  cFieldMandatory = "O"
                  cFieldHidden = "S".
                   CREATE eFields.
                 ASSIGN cGroup = "Accommodation"
                  iFieldOrder  = 130
                  cFieldName = "cExpLunch" T
                  cFieldLabel = "Includes Lunch"
                  cFieldDataType = "text"
                  cFieldMandatory = "O"
                  cFieldHidden = "S".
 
            CREATE eFields.
           ASSIGN cGroup = "Subsistence"
                  iFieldOrder  = 10
                  cFieldLabel = "Group" 
                  cFieldName = "cExpGroup"
                  cFieldDataType = "text"
                  cFieldMandatory = "D"
                  cFieldHidden = "S".
              CREATE eFields.
           ASSIGN cGroup = "Subsistence"
                  iFieldOrder  = 20
                  cFieldLabel = "Type" 
                  cFieldName = "cExpType"
                  cFieldDataType = "text"
                  cFieldMandatory = "O"
                  cFieldHidden = "S".
               CREATE eFields.
           ASSIGN cGroup = "Subsistence"
                  iFieldOrder  = 30
                  cFieldLabel = "Date" 
                  cFieldName = "cExpDate"
                  cFieldDataType = "text"
                  cFieldMandatory = "M"
                  cFieldHidden = "S".
                   CREATE eFields.
            ASSIGN cGroup = "Subsistence"
                  iFieldOrder  = 40
                  cFieldLabel = "Reason" 
                  cFieldName = "cExpReason"
                  cFieldDataType = "text"
                  cFieldMandatory = "M"
                  cFieldHidden = "S".
                   CREATE eFields.
             ASSIGN cGroup = "Subsistence"
                  iFieldOrder  = 50
                  cFieldLabel = "Amount" 
                  cFieldName = "cExpAmount"
                  cFieldDataType = "decimal"
                  cFieldMandatory = "M"
                  cFieldHidden = "S".
                     CREATE eFields.
              ASSIGN cGroup = "Subsistence"
                  iFieldOrder  = 60
                  cFieldLabel = "Recharge Customer" 
                  cFieldName = "cExpCharge"
                  cFieldDataType = "text"
                  cFieldMandatory = "o"
                  cFieldHidden = "S".
               CREATE eFields.
           ASSIGN cGroup = "Transportation"
                  iFieldOrder  = 10
                  cFieldLabel = "Group" 
                  cFieldName = "cExpGroup"
                  cFieldDataType = "text"
                  cFieldMandatory = "D"
                  cFieldHidden = "S".
              CREATE eFields.
           ASSIGN cGroup = "Transportation"
                  iFieldOrder  = 20
                  cFieldLabel = "Type" 
                  cFieldName = "cExpType"
                  cFieldDataType = "text"
                  cFieldMandatory = "O"
                  cFieldHidden = "S".
               CREATE eFields.
           ASSIGN cGroup = "Transportation"
                  iFieldOrder  = 30
                  cFieldLabel = "Date" 
                  cFieldName = "cExpDate"
                  cFieldDataType = "text"
                  cFieldMandatory = "M"
                  cFieldHidden = "S".
                CREATE eFields.
            ASSIGN cGroup = "Transportation"
                  iFieldOrder  = 40
                  cFieldLabel = "Reason" 
                  cFieldName = "cExpReason"
                  cFieldDataType = "text"
                  cFieldMandatory = "M"
                  cFieldHidden = "S".
                   CREATE eFields.
             ASSIGN cGroup = "Transportation"
                  iFieldOrder  = 50
                  cFieldLabel = "Amount" 
                  cFieldName = "cExpAmount"
                  cFieldDataType = "decimal"
                  cFieldMandatory = "M"
                  cFieldHidden = "S".
           CREATE eFields.
           ASSIGN cGroup = "Mileage"
                  iFieldOrder  = 10
                  cFieldLabel = "Group" 
                  cFieldName = "cExpGroup"
                  cFieldDataType = "text"
                  cFieldMandatory = "D"
                  cFieldHidden = "S".
            CREATE eFields.
           ASSIGN cGroup = "Mileage"
                  iFieldOrder  = 20
                  cFieldLabel = "Type" 
                  cFieldName = "cExpType"
                  cFieldDataType = "text"
                  cFieldMandatory = "O"
                  cFieldHidden = "S".
             CREATE eFields.
                  ASSIGN cGroup = "Mileage"
                  iFieldOrder  = 30
                  cFieldLabel = "Date" 
                  cFieldName = "cExpDate"
                  cFieldDataType = "text"
                  cFieldMandatory = "M"
                  cFieldHidden = "S".
                CREATE eFields.
            ASSIGN cGroup = "Mileage"
                  iFieldOrder  = 40
                  cFieldLabel = "Reason" 
                  cFieldName = "cExpReason"
                  cFieldDataType = "text"
                  cFieldMandatory = "M"
                  cFieldHidden = "S".
                   CREATE eFields.
             ASSIGN cGroup = "Mileage"
                  iFieldOrder  = 150
                  cFieldLabel = "Amount"
                  cFieldName = "cExpAmount"
                  cFieldDataType = "decimal"
                  cFieldMandatory = "D"
                  cFieldHidden = "S".
              CREATE eFields.
              ASSIGN cGroup = "Mileage"
                  iFieldOrder  = 60
                  cFieldLabel = "Recharge Customer" 
                  cFieldName = "cExpCharge"
                  cFieldDataType = "text"
                  cFieldMandatory = "o"
                  cFieldHidden = "S".
              CREATE eFields.
              ASSIGN cGroup = "Mileage"
                  iFieldOrder  = 70
                  cFieldLabel = "From" 
                  cFieldName = "cExpFrom"
                  cFieldDataType = "text"
                  cFieldMandatory = "M"
                  cFieldHidden = "S".
             CREATE eFields.
              ASSIGN cGroup = "Mileage" 
                  iFieldOrder  = 80
                  cFieldLabel = "To" 
                  cFieldName = "cExpTo"
                  cFieldDataType = "text"
                  cFieldMandatory = "M"
                  cFieldHidden = "S".
             CREATE eFields.
              ASSIGN cGroup = "Mileage" 
                  iFieldOrder  = 90
                  cFieldLabel = "Visting" 
                  cFieldName = "cExpVisit"
                  cFieldDataType = "text"
                  cFieldMandatory = "M"
                  cFieldHidden = "m".
            CREATE eFields.
              ASSIGN cGroup = "Mileage" 
                  iFieldOrder  = 100
                  cFieldLabel = "Round Trip" 
                  cFieldName = "cExpRound"
                  cFieldDataType = "text"
                  cFieldMandatory = "o"
                  cFieldHidden = "S".
          CREATE eFields.
              ASSIGN cGroup = "Mileage" 
                  iFieldOrder  = 110
                  cFieldLabel = "Map" 
                  cFieldName = "cExpMap"
                  cFieldDataType = "text"
                  cFieldMandatory = "o"
                  cFieldHidden = "S".
                CREATE eFields.
              ASSIGN cGroup = "Mileage" 
                  iFieldOrder  = 120
                  cFieldLabel = "Calculated Miles" 
                  cFieldName = "cExpCalcMiles"
                  cFieldDataType = "text"
                  cFieldMandatory = "D"
                  cFieldHidden = "S".           
                  CREATE eFields.
              ASSIGN cGroup = "Mileage" 
                  iFieldOrder  = 130
                  cFieldLabel = "Claim Miles" 
                  cFieldName = "cExpClaimMiles"
                  cFieldDataType = "text"
                  cFieldMandatory = "o"
                  cFieldHidden = "S".
                  */
    END METHOD.
	
	
	
	 
          
END CLASS.