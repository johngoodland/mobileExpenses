 
 /*------------------------------------------------------------------------
    File        : getFormData
    Syntax      : 
    Author(s)   : Administrator
    Created     : Thu Nov 14 11:01:49 GMT 2013
    Notes       : 
  ----------------------------------------------------------------------*/
    
@program FILE(name="getFormData.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="getFormData", URI="/getFormData", schemaName="dsFormData", schemaFile="ebis/AppServer/getFormData.cls").

USING Progress.Json.ObjectModel.JsonObject.
USING Progress.Json.ObjectModel.JsonArray. 
USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS getFormData INHERITS BusinessEntity:

    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
	{dsFormData.i}
	
	/*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    METHOD PUBLIC CHARACTER getMobileField( INPUT cConvertField AS CHARACTER, 
                                            INPUT lRules AS Logical ):
         
    DEFINE VARIABLE result       AS  CHARACTER  NO-UNDO.
    DEFINE VARIABLE cMobileName  AS  CHARACTER  NO-UNDO.
    DEFINE VARIABLE cEBisName    AS  CHARACTER  NO-UNDO.
    DEFINE VARIABLE iPos         AS  INTEGER    NO-UNDO.
    DEFINE VARIABLE cEbisField   AS  CHARACTER  NO-UNDO.
    DEFINE VARIABLE iLoop        AS  INTEGER    NO-UNDO.
    /* names changed from ebis to mobile  */
    ASSIGN
      cMobileName = 'cExpGroup,cExpType,cExpDate,cExpReason,cExpAmount,cExpCharge,cExpPurpose,cExpOOP,cExpPayee,cExpNoPeople,cExpNoNights,'
                  + 'cExpEveMeal,cExpBreak,cExpLunch,cExpPeople,cExpVisit,cExpFrom,cExpTo,cExpRound,cExpMap,cExpCalcMiles,cExpClaimMiles,'
                  + 'cExpVehicle,cExpYTDMiles,cExpNoPeople,cExpMap' 
      cEBisName   = 'cExpGroup,cExpType,cExpDate,cExpReason,lnAmount,chkRecharge,lnAdd_purpose,lnAdd_oopExplanation,lnAdd_payee,lnAdd_numPeople,lnAdd_numNights,'
                  + 'lnAdd_chkIncEveMeal,lnAdd_chkIncBrkfst,lnAdd_chkIncLunch,lnAdd_people,lnAdd_visiting,lnAdd_fromLoc,lnAdd_toLoc,lnAdd_chkRoundtrip,'
                  + 'cExpMap,lnAdd_calcMiles,lnAdd_claimMiles,lnAdd_vehicle,lnAdd_ytdMiles,lnAdd_otherPeople,lnAdd_btnShowMap'.
        
    ASSIGN
      iPos = LOOKUP(cConvertField,cEBisName).
    
    IF iPos = 0 THEN DO: 
      IF lRules = FALSE THEN RETURN cConvertField. /* send back same field and worry about it on the device */
      ELSE DO: /* got a rule with something more than just fieldname, need to replace all in string. */
         DO iLoop = 1 TO NUM-ENTRIES(cEbisName).
         MESSAGE cConvertField.
           IF INDEX(cConvertField,ENTRY(iLoop,cEbisName)) <> 0 THEN DO:
             cConvertField = REPLACE(cConvertField,ENTRY(iLoop,cEbisName), ENTRY(iLoop,cMobileName)).
             MESSAGE cConvertField.
           END.
         END.
         RETURN cConvertField.
      END.  
    END.
    ELSE
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
    METHOD PUBLIC VOID ReadgetFormData(
    		INPUT filter AS CHARACTER, 
    		OUTPUT DATASET dsFormData):
 
    EMPTY TEMP-TABLE eGroup NO-ERROR.
    EMPTY TEMP-TABLE eFields NO-ERROR.
    EMPTY TEMP-TABLE eRules NO-ERROR.
    EMPTY TEMP-TABLE eTypes NO-ERROR.
    DATASET dsFormData:EMPTY-DATASET().
    
    DEFINE VARIABLE oFilter     AS  JsonObject NO-UNDO.
    DEFINE VARIABLE pcUserID    AS  CHARACTER  NO-UNDO.  
    DEFINE VARIABLE lErrorFlag  AS  CHARACTER  NO-UNDO.  
    DEFINE VARIABLE cErrorText  AS  CHARACTER  NO-UNDO.   
    DEFINE VARIABLE cJSONString AS  CHARACTER NO-UNDO.
 
 
     cJSONString = ADV_parseFilter(filter).
     pcUserID = ADV_getValue("ADV_feedUser").
      MESSAGE cJSONString.
      MESSAGE ADV_getValue("ADV_feedUser").
    /* parse out the filter looking for the user 
    oFilter = ParseFilter(filter). 
    pcUserId = oFilter:GetCharacter('UserID').  */
    /* pcUserID = "demoa". */
    /* call RegisterMobex API */
    message "Calling API mobex/getgrouplist.p".
    RUN mobex/getgrouplist.p
      (INPUT false,  /* debug mode false will now come from user record not mobile device */
       INPUT pcUserID,
       INPUT "", /* last group */
       OUTPUT TABLE ttGroups,
       OUTPUT TABLE ttRules,
       OUTPUT TABLE ttFields,
       OUTPUT lErrorFlag,
       OUTPUT cErrorText).
    
    FOR EACH ttGroups.
      CREATE eGroup.
      ASSIGN 
        eGroup.cGroup = ttgGroup
        eGroup.cDesc  = ttgDescription
        eGroup.cType  = ttgType
        eGroup.cPolicyLink = ttgPolicyLink 
        eGroup.cRecModLast = ttgRecModLast.
    END.
    FOR EACH ttRules.
      CREATE eRules.
      ASSIGN
        eRules.cGroup     = ttrGroup
        eRules.ttrRule    = ttRules.ttrRule  
        eRules.ttrMessage = ttRules.ttrMessage
        eRules.ttrLeftSide = getMobileField(ttRules.ttrLeftSide, true)     
        eRules.ttrOperand  = ttRules.ttrOperand  
        eRules.ttrRightSide = getMobileField(ttRules.ttrRightSide, true). 
    END. 
    FOR EACH ttGroups NO-LOCK BREAK BY ttgGroup:
      IF FIRST-OF(ttgGroup) THEN DO:
        /* mandatory fields */
        CREATE eFields.
        ASSIGN eFields.cGroup = ttgGroup
               iFieldOrder  = -100
               cFieldLabel = "Group" 
               cFieldName = "cExpGroup"
               cFieldDataType = "text"
               cFieldMandatory = "D"
               cFieldHidden = "S".
        CREATE eFields.
        ASSIGN eFields.cGroup = ttgGroup
               iFieldOrder  = -90
               cFieldLabel = "Type" 
               cFieldName = "cExpType"
               cFieldDataType = "text"
               cFieldMandatory = "O"
               cFieldHidden = "S".
        CREATE eFields.   
        ASSIGN eFields.cGroup = ttgGroup
               iFieldOrder  = -80
               cFieldLabel = "Date" 
               cFieldName = "cExpDate"
               cFieldDataType = "text"
               cFieldMandatory = "M"
               cFieldHidden = "S".
        CREATE eFields. 
        ASSIGN eFields.cGroup = ttgGroup
               iFieldOrder  = -70
               cFieldLabel = "Reason" 
               cFieldName = "cExpReason"
               cFieldDataType = "text"
               cFieldMandatory = "M"
               cFieldHidden = "S".
        CREATE eFields. 
        ASSIGN eFields.cGroup = ttgGroup
               iFieldOrder  = IF ttgroups.ttgType = "MILEAGE" THEN 998 ELSE -60
               cFieldLabel = "Amount" 
               cFieldName = "cExpAmount"
               cFieldDataType = "decimal"
               cFieldMandatory = IF ttgroups.ttgType = "MILEAGE" THEN "D" ELSE "M" 
               cFieldHidden = "S".   
        IF ttGroups.ttgType <> "MILEAGE" THEN DO:
          CREATE eFields. 
          ASSIGN eFields.cGroup = ttgGroup
                 iFieldOrder  = 999
                 cFieldLabel = "No Receipt" 
                 cFieldName = "chkNoReceipt"
                 cFieldDataType = "log"
                 cFieldMandatory = "O" 
                 cFieldHidden = "S".       
        END.
        ELSE DO:
          CREATE eFields. 
          ASSIGN eFields.cGroup = ttgGroup
                 iFieldOrder  = 997
                 cFieldLabel = "Unit Price" 
                 cFieldName = "cUnitPrice"
                 cFieldDataType = "decimal"
                 cFieldMandatory = "O" 
                 cFieldHidden = "S".           
        END.
        FOR EACH ttFields
          WHERE  ttFields.ttfGroup = ttGroups.ttgGroup NO-LOCK:
          IF ttFields.ttfName BEGINS "lnAdd_link" THEN NEXT.
          CREATE eFields.
          ASSIGN 
            eFields.cGroup = ttfGroup
            iFieldOrder  = IF ttfOrder = 0 THEN 1 ELSE ttfOrder
            cFieldLabel  = ttfLabel
            cFieldName   = getMobileField(ttfName, false)
            cFieldDataType = ttfType
            cFieldMandatory = IF cFieldName = 'cExpCalcMiles' THEN "D" ELSE ttfMandatory
            cFieldHidden = "S" /* could use this field for default ttfDefault */.
        END.
      END.
    END. 
     
    /* another REST call is expensive so combine on sync with formdata */
        message "Calling API mobex/getTypelist.p".
    RUN mobex/gettypeslist.p
      (INPUT false,  /* debug mode false will now come from user record not mobile device */
       INPUT pcUserID,
       INPUT "", /* last Type */
       OUTPUT TABLE ttTypes,
       OUTPUT lErrorFlag,
       OUTPUT cErrorText).
   
    FOR EACH ttTypes:
      CREATE eTypes.
      ASSIGN 
        eTypes.cGroup        = tttGroup
        eTypes.cType         = tttType
        eTypes.cDescription  = tttDescription
        eTypes.cTypePrice    = tttPrice
        eTypes.cTypeMax      = tttMax
        eTypes.cRecModLast   = tttRecModLast.
    END.   
    END METHOD.
	        
END CLASS.