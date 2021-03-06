 
 /*------------------------------------------------------------------------
    File        : ebisdata
    Syntax      : 
    Author(s)   : John.Goodland
    Created     : Wed Apr 17 11:26:50 BST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
    
@program FILE(name="ebisdata.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="eBISdata", URI="/ebisdata", schemaName="eeBis", schemaFile="ebis/AppServer/dseBIS.i").

USING Progress.Json.ObjectModel.JsonObject.
USING Progress.Json.ObjectModel.JsonArray. 
USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS ebisdata INHERITS BusinessEntity:

    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
	 
	  
	{"dseBIS.i"} 
	DEFINE TEMP-TABLE expenseForm NO-UNDO  
    FIELD expenseDate       AS CHARACTER
    FIELD expenseGroup      AS CHARACTER 
    FIELD expenseType       AS CHARACTER  
    FIELD expenseReason     AS CHARACTER  
    FIELD expenseAmount     AS CHARACTER   
    FIELD expenseNotes      AS CHARACTER  
    FIELD expenseMilesClaim AS CHARACTER
    FIELD expenseMilesRate  AS CHARACTER
    FIELD expenseFrom       AS CHARACTER  
    FIELD expenseTo         AS CHARACTER  
    FIELD expenseImage      AS clob
    FIELD expense_ID        AS CHARACTER
    FIELD expenseStatus     AS CHARACTER
    FIELD expenseCharge     AS CHARACTER
    FIELD expensePurpose    AS CHARACTER
    FIELD expenseOOP        AS CHARACTER
    FIELD expensePayee      AS CHARACTER
    FIELD expenseNoPeople   AS CHARACTER
    FIELD expenseNoNights   AS CHARACTER
    FIELD expenseEveMeal    AS CHARACTER
    FIELD expenseBreak      AS CHARACTER
    FIELD expenseLunch      AS CHARACTER
    FIELD expenseVisit      AS CHARACTER
    FIELD expenseRound      AS CHARACTER
    FIELD expenseVehicle    AS CHARACTER
    FIELD expenseYTDMiles   AS CHARACTER
    FIELD expensePeople     AS CHARACTER
    FIELD expenseStoredJny  AS CHARACTER
    FIELD expenseOOPFlag    AS CHARACTER
    FIELD expenseAddType    AS CHARACTER
    FIELD expenseAddChk     AS CHARACTER 
    FIELD expenseAddValue   AS CHARACTER 
    FIELD expenseAddResource AS CHARACTER
    FIELD expenseUserID     AS CHARACTER
    FIELD expenseFromDate   AS CHARACTER
    FIELD expenseToDate     AS CHARACTER
    FIELD expenseUnitPrice  AS CHARACTER 
    FIELD expenseNoReceipt  AS CHARACTER 
    FIELD expenseGUID       AS CHARACTER 
    FIELD expenseTypeCode   AS CHARACTER
    FIELD expenseProject    AS CHARACTER.
    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, based on a filter string                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json"). 
    METHOD PUBLIC VOID ReadeBISdata(
    		INPUT filter AS CHARACTER, 
    		OUTPUT TABLE eeBis):      
	 
        /* TODO: Add code to get a set of records and return the
           resulting records to the client. */      
    END METHOD.
	  
    /*------------------------------------------------------------------------------
            Purpose: Create one or more new records                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/  
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateeBISdata(INPUT-OUTPUT TABLE eeBis):    		
	
        /* TODO: Add code to create a record from data passed
           in from the client. */         
    END METHOD.    
	
    /*------------------------------------------------------------------------------
            Purpose:  Update one or more records                                                                  
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateeBISdata(INPUT-OUTPUT TABLE eeBis):    		
	          
        /* TODO: Add code to update a record from data passed
           in from the client. */          
    END METHOD.
	  
    /*------------------------------------------------------------------------------
            Purpose:    Delete a record                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteeBISdata(INPUT-OUTPUT TABLE eeBis):     		       
	   
        /* TODO: Add code to delete a record passed in from the client. */   
    END METHOD.
      
    /*------------------------------------------------------------------------------
            Purpose:    Add a single line into EBIS
            Notes:      testing and debuging
    ------------------------------------------------------------------------------*/
/*    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").                                   */
/*    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/CaptureExpense", alias="", mediaType="application/json").*/
/*    METHOD PUBLIC VOID CaptureExpense  (INPUT pcMobileData    AS LONGCHAR                                                             */
/*                                       ): /* JSON */                                                                                  */
/*    /* data returned is yyyy-mm-dd - remember this with json dataset*/                                                                */
/*    DEFINE VARIABLE pcmobiledate AS CHAR NO-UNDO.                                                                                     */
/*      DEFINE VARIABLE pcmobiletype AS CHAR NO-UNDO.                                                                                   */
/*      DEFINE VARIABLE pcMobileReason AS CHAR NO-UNDO.                                                                                 */
/*      DEFINE VARIABLE pcMobileAmount AS CHAR NO-UNDO.                                                                                 */
/*    pcmobiledate = STRING(TODAY).                                                                                                     */
/*    MESSAGE "ok - capture " pcmobiledate "*" pcMobileType.                                                                            */
/*    MESSAGE "Running eBis claimline".                                                                                                 */
/*    DEFINE VARIABLE pFromAddress as char no-undo init "WR11 4TL".                                                                     */
/*    DEFINE VARIABLE pToAddress as char no-undo init "NN4 7YE".                                                                        */
/*    DEFINE VARIABLE pFromDate as date no-undo init TODAY.                                                                             */
/*    DEFINE VARIABLE pToDate as date no-undo init TODAY.                                                                               */
/*    DEFINE VARIABLE lErrorFlag as logical no-undo.                                                                                    */
/*    DEFINE VARIABLE cErrorText as char no-undo.                                                                                       */
/*    DEFINE VARIABLE oLineGUID as char no-undo.                                                                                        */
/*    def var pLineGUID as char no-undo init "".                                                                                        */
/*    RUN mobex/updateClaimLine.p (true, "demoa",                                                                                       */
/*                          pLineGUID, /* pLineGUID, */                                                                                 */
/*                          pcMobileDate,                                                                                               */
/*                          pcMobileType,                                                                                               */
/*                          "", /* pType */                                                                                             */
/*                          pcMobileReason,                                                                                             */
/*                          0, /* pCompany, */                                                                                          */
/*                          "", /* pDepartment, */                                                                                      */
/*                          pcMobileAmount,                                                                                             */
/*                          pFromAddress,                                                                                               */
/*                          pToAddress,                                                                                                 */
/*                          no, /* lRoundTrip, */                                                                                       */
/*                          0, /* pTotalMiles, */                                                                                       */
/*                          pFromDate,                                                                                                  */
/*                          pToDate,                                                                                                    */
/*                          1, /* pNights, */                                                                                           */
/*                          "", /* pNotes, */                                                                                           */
/*                          output lErrorFlag, output cErrorText, output oLineGUID).                                                    */
/*    MESSAGE lerrorflag "*" cErrorText "*" oLineGuid.                                                                                  */
/*    END METHOD.                                                                                                                       */
     /*------------------------------------------------------------------------------
            Purpose:    add a JSON dataset to ebis                                                              
            Notes:                                                                        
    ------------------------------------------------------------------------------*/     
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/CaptureExpense?filter=~{filter~}", alias="", mediaType="application/json"). 
    
    METHOD PUBLIC VOID CaptureExpense   ( INPUT pcMobileData       AS longchar,
                                          INPUT filter             AS character,
                                          OUTPUT pcResult       AS CHARACTER): /* return string of mobile guid, ebis guid */
                                          
    DEFINE VARIABLE cJSONString AS  CHARACTER NO-UNDO.
    DEFINE VARIABLE pcUserID    AS  CHARACTER NO-UNDO.
   /* DEFINE VARIABLE pcUserID    AS  CHARACTER NO-UNDO. */
 
    /* data returned is yyyy-mm-dd - remember this with json dataset*/
    MESSAGE "Running eBis claimline inside json update - creating file with datax".

    cJSONString = ADV_parseFilter(filter).
    pcUserID = ADV_getValue("ADV_feedUser").
    MESSAGE "*" pcuserID.
/*
    OUTPUT TO "c:\john1.txt".  
    export pcMobileData.
    OUTPUT CLOSE. 
 */
    pcMobileData = REPLACE(pcMobileData,"data:image/jpeg;base64,","").  
 /*
   OUTPUT TO "c:\john.txt".
   export pcMobileData.  
   OUTPUT CLOSE. 
  */
  
    DEFINE VARIABLE cSourceType AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cReadMode AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFile AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lRetOK AS LOGICAL NO-UNDO.
  
    ASSIGN 
      cSourceType = "LONGCHAR" 
      cReadMode   = "empty"
      pcResult    = "".

    lRetOK = TEMP-TABLE expenseForm:READ-JSON(cSourceType, pcMobileData, cReadMode).
    MESSAGE "data is " STRING(lRetOk).
    IF NOT lRetOk THEN RETURN.
  
    FOR EACH expenseForm NO-LOCK:

      MESSAGE "Running eBis claimline inside json update".
      DEFINE VARIABLE pFromDate     AS DATE      NO-UNDO init TODAY.
      DEFINE VARIABLE pToDate       AS DATE      NO-UNDO init TODAY.
      DEFINE VARIABLE lErrorFlag    AS LOGICAL   NO-UNDO.
      DEFINE VARIABLE cErrorText    AS CHARACTER NO-UNDO.
      DEFINE VARIABLE oLineGUID     AS CHARACTER NO-UNDO.
      DEFINE VARIABLE cClaimDate    AS CHARACTER NO-UNDO.
      DEFINE VARIABLE dClaimDate    AS DATE      NO-UNDO.
      DEFINE VARIABLE oImageContent AS LONGCHAR  NO-UNDO.
      DEFINE VARIABLE myMemptr      AS MEMPTR    NO-UNDO.
      DEFINE VARIABLE pLineGUID     AS CHARACTER NO-UNDO init "".
      
      /* data returned is yyyy-mm-dd - remember this with json dataset*/   
      ASSIGN
        cClaimDate = SUBSTRING(expenseForm.expenseDate,9,2)
        cClaimDate = cClaimDate + "/" + SUBSTRING(expenseForm.expenseDate,6,2)
        cClaimDate = cClaimDate + "/" + SUBSTRING(expenseForm.expenseDate,1,4).
    
      dClaimDate = DATE(cClaimDate).
      assign lErrorFlag = YES.
      /* run expense api adding line */
      MESSAGE "guid is " expenseForm.expenseGUID "*oop" expenseForm.expenseOOP "*" expenseForm.expenseAddChk.
      RUN mobex/updateClaimLine.p (false, /*debugging comes from user record now */ 
                            pcUserID ,
                            expenseForm.expenseGUID, /* pLineGUID, */
                            dClaimDate, 
                            IF expenseForm.expenseGroup = ? THEN "" ELSE expenseForm.expenseGroup,
                            IF expenseForm.expenseType = ? THEN "" ELSE expenseForm.expenseTypeCode,
                            IF expenseForm.expenseReason = ? THEN "" ELSE expenseForm.expenseReason,
                            0, /* pCompany, */
                            "", /* pDepartment, */
                            IF expenseForm.expenseAmount = ? THEN 0 ELSE DECIMAL(expenseForm.expenseAmount),
                            IF expenseForm.expenseCharge = ? THEN false ELSE IF expenseForm.expenseCharge = "on" THEN YES ELSE FALSE,
                            IF expenseForm.expenseStoredJny = ? THEN "" ELSE expenseForm.expenseStoredJny,
                            IF expenseForm.expenseOOPFlag = ? THEN NO ELSE IF expenseForm.expenseOOPFlag = "Yes" THEN YES ELSE FALSE,
                            IF expenseForm.expenseOOP = ? THEN "" ELSE expenseForm.expenseOOP, 
                            IF expenseForm.expenseType = ? THEN "" ELSE expenseForm.expenseType,
                            IF expenseForm.expenseVisit = ? THEN "" ELSE  expenseForm.expenseVisit,
                            IF expenseForm.expensePurpose = ? THEN "" ELSE expenseForm.expensePurpose, 
                            IF expenseForm.expenseFrom = ? THEN "" ELSE expenseForm.expenseFrom,
                            IF expenseForm.expenseTo = ? THEN "" ELSE expenseForm.expenseTo,
                            IF expenseForm.expenseRound = ? THEN NO ELSE IF expenseForm.expenseRound = "on" THEN YES ELSE FALSE,
                            IF expenseForm.expenseMilesRate = ? THEN 0 ELSE DECIMAL(expenseForm.expenseMilesRate),
                            IF expenseForm.expenseMilesClaim = ? THEN 0 ELSE DECIMAL(expenseForm.expenseMilesClaim), /* pTotalMiles, */
                            IF expenseForm.expenseVehicle = ? THEN "" ELSE expenseForm.expenseVehicle,
                            IF expenseForm.expenseYTDMiles = ? THEN 0 ELSE DECIMAL(expenseForm.expenseYTDMiles),
                            IF expenseForm.expensePeople = ? THEN "" ELSE expenseForm.expensePeople,
                            IF expenseForm.expensePayee = ? THEN "" ELSE expenseForm.expensePayee,
                            IF expenseForm.expenseNoPeople = ? THEN 0 ELSE INTEGER(expenseForm.expenseNoPeople),
                            IF expenseForm.expenseNoNights = ? THEN 0 ELSE INTEGER(expenseForm.expenseNoNights),      
                            IF expenseForm.expenseEveMeal = ? THEN NO ELSE IF expenseForm.expenseEveMeal = "on" THEN YES ELSE FALSE,
                            IF expenseForm.expenseLunch  = ? THEN NO ELSE IF expenseForm.expenseLunch = "on" THEN YES ELSE FALSE,
                            IF expenseForm.expenseBreak  = ? THEN NO ELSE IF expenseForm.expenseBreak  = "on" THEN YES ELSE FALSE,
                            IF expenseForm.expenseAddChk = ? THEN "" ELSE expenseForm.expenseAddChk,      
                            IF expenseForm.expenseAddValue = ? THEN 0 ELSE DECIMAL(expenseForm.expenseAddValue),
                            IF expenseForm.expenseAddResource = ? THEN "" ELSE expenseForm.expenseAddResource, 
                            IF expenseForm.expenseProject = ? THEN "" ELSE expenseForm.expenseProject,
                            IF expenseForm.expenseNoReceipt = ? THEN NO ELSE IF expenseForm.expenseNoReceipt = "on" THEN YES ELSE FALSE,
                            output lErrorFlag, output cErrorText, output oLineGUID).  
     /* build returning guids */
     IF oLineGUID NE "" THEN DO: /* got a guid build string */
       /* build returning string for locked claims support mobileGUID/eBISGUID */
       MESSAGE expenseForm.expense_ID + "*" + olineguid.
       ASSIGN
         pcResult = IF LENGTH(pcResult) = 0 THEN expenseForm.expense_ID + "," + oLineGUID 
                    ELSE pcResult + "," + expenseForm.expense_ID + "," + oLineGUID .  
     END.
     /* create image */
     IF lErrorFlag = NO AND oLineGUID NE "" THEN DO:
       IF expenseForm.expenseImage <> ? THEN DO:
         MESSAGE "Creating image".

         DEFINE VARIABLE decdmptr   AS MEMPTR    NO-UNDO.    
         DEFINE VARIABLE decdlngc   AS LONGCHAR  NO-UNDO.
         DEFINE VARIABLE cFilename  AS CHARACTER NO-UNDO.
         DEFINE VARIABLE cImageFile AS CHARACTER NO-UNDO.
         DEFINE VARIABLE cActFile   AS CHARACTER NO-UNDO.
         DEFINE VARIABLE cCreate    AS CHARACTER NO-UNDO.
 
         COPY-LOB FROM expenseForm.expenseImage TO decdlngc.
         decdmptr = BASE64-DECODE(decdlngc).
         /* hardcoded filename directory for now */
         ASSIGN
           cImageFile= "mb" + STRING(ETIME) + STRING(RANDOM(1,99999),"99999") + ".jpg"
           cFilename = cImageFile
           cCreate   = "C:\advanced\customer\oalive80\" + cImageFile
           cActFile  = "mb\" + cImageFile.
       
         COPY-LOB FROM decdmptr TO FILE cFileName.
    
         /*  os-copy cCreate cFileName. */
          /*  copy-lob from  expenseForm.expenseImage to file "f:\06\eliv5080\mb\test.jpg". */
  
         RUN mobex/updateAttachment.p (true, pcUserID,
                                       oLineGUID,
                                       cActFile,
                                       "mobile image",
                                       "add",
                                       decdlngc,
                                       OUTPUT lErrorFlag, OUTPUT cErrorText).  
         message lerrorflag.
        message cerrortext.
       END.
       ELSE DO:
         RUN mobex/updateAttachment.p (true, pcUserID,
                                       oLineGUID,
                                       '',
                                       "mobile image",
                                       "del",
                                       decdlngc,
                                       OUTPUT lErrorFlag, OUTPUT cErrorText).  
       END.                   
     END.
      
     MESSAGE lerrorflag "*" cErrorText "*" oLineGuid.
  END. /* for each eebis */

  END METHOD.
END CLASS.