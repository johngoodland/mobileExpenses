
/*------------------------------------------------------------------------
    File        : gatewayparse.i
    Purpose     : 

    Syntax      :

    Description : Split out the filter from the gateway	

    Author(s)   : john
    Created     : Fri Jan 24 11:16:00 GMT 2014
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE TEMP-TABLE ttADVGateway
    FIELD cAttribute AS CHARACTER
    FIELD cValue     AS CHARACTER
INDEX Primary IS PRIMARY cAttribute.

/* ********************  Preprocessor Definitions  ******************** */

/* ************************  Function Prototypes ********************** */


FUNCTION ADV_getValue RETURNS CHARACTER 
	( ipcAttribute AS character ) FORWARD.

FUNCTION ADVBuildGatewayTT RETURNS LOGICAL 
	( ipcADVFilter AS CHARACTER ) FORWARD.

/* ***************************  Main Block  *************************** */



/* **********************  Internal Procedures  *********************** */

PROCEDURE ADV_parseFilter:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER  ipcADVQuery      AS CHARACTER  NO-UNDO.
 DEFINE OUTPUT PARAMETER opcADVJSONFilter AS CHARACTER  NO-UNDO.
  
 DEFINE VARIABLE iADVPos AS INTEGER NO-UNDO.
 
 iADVpos = INDEX(ipcADVQuery,'}&ADV').
 IF iADVpos <> 0 THEN DO:
   ASSIGN 
     opcADVJSONFilter = SUBSTRING(ipcADVQuery,1,iADVpos).
   ADVBuildGatewayTT(SUBSTRING(ipcADVQuery,iADVPos + 2,255)).  
 END.
 ELSE DO:
   iADVpos = INDEX(ipcADVQuery,'&ADV').
   IF iADVPos <> 0 THEN DO:
     ADVBuildGatewayTT(SUBSTRING(ipcADVQuery,iADVPos,255)).
     ASSIGN 
       opcADVJSONFilter = "".
   END.
   ELSE 
     ASSIGN
       opcADVJSONFilter = ipcADVQuery.
 END.

END PROCEDURE.


/* ************************  Function Implementations ***************** */

FUNCTION ADV_getValue RETURNS CHARACTER 
	( ipcAttribute AS CHARACTER   ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/	  
  DEFINE VARIABLE cADVResult AS CHARACTER NO-UNDO.

  cADVResult = "".
  FOR FIRST ttADVGateway 
      WHERE ttADVGateway.cAttribute = ipcAttribute NO-LOCK:
    ASSIGN
     cADVResult = ttADVGateway.cValue.
  END.
  
  RETURN cADVResult.

		
END FUNCTION.

FUNCTION ADVBuildGatewayTT RETURNS LOGICAL 
	( ipcADVFilter AS CHARACTER  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iADVLoop      AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cADVFilter    AS CHARACTER    NO-UNDO.	
  
  EMPTY TEMP-TABLE ttADVGateway NO-ERROR.
  DO iADVLoop = 1 TO NUM-ENTRIES(ipcADVFilter,"&").
    cADVFilter = ENTRY(iADVLoop,ipcADVFilter,"&").
    CREATE ttADVGateway.
    ASSIGN
      ttADVGateway.cAttribute = ENTRY(1,cADVFilter,"=")
      ttADVGateway.cVALUE = ENTRY(2,cADVFilter,"=").
  END.
 
  RETURN TRUE.

END FUNCTION.

