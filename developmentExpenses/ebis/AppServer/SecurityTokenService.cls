 
 /*------------------------------------------------------------------------
    File        : SecurityTokenService
    Syntax      : 
    Author(s)   : Administrator
    Created     : Wed Sep 25 10:13:00 BST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
    
@program FILE(name="SecurityTokenService.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SecurityTokenService", URI="/SecurityTokenService", schemaName="dsSecurityTokenService", schemaFile="").

USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS AppServer.SecurityTokenService:

    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
	
	   
    /* TODO: Change to use your schema 
	DEFINE TEMP-TABLE eSecurityTokenService FIELD SecurityTokenServiceField AS INTEGER INDEX SecurityTokenServiceIndex IS UNIQUE PRIMARY SecurityTokenServiceField.
	DEFINE DATASET dsSecurityTokenService FOR eSecurityTokenService. 
    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, based on a filter string                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json"). 
    METHOD PUBLIC VOID ReadSecurityTokenService(
    		INPUT filter AS CHARACTER, 
    		OUTPUT DATASET dsSecurityTokenService):      
	         
        /* TODO: Add code to get a set of records and return the
           resulting records to the client. */      
    END METHOD.
	*/
	
	    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, based on a filter string                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/ValidateSession", alias="", mediaType="application/json"). 
    METHOD PUBLIC VOID ValidateSession
                             (INPUT  pcUserID AS CHARACTER,
                              INPUT  pcKey AS CHARACTER,
                              INPUT  pcPassword AS CHARACTER,
                              OUTPUT pcResult AS CHARACTER): 
    DEFINE VARIABLE lErrorFlag AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE cErrorText AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cGUID      AS CHARACTER NO-UNDO.  
    /* call RegisterMobex API */
    message "Calling API mobex/registermobex.p".
    RUN mobex/registermobex.p
      (INPUT pcKey,
       INPUT false,  /* debug mode false will now come from user record not mobile device */
       INPUT pcUserID,
       INPUT pcPassword,
       OUTPUT lErrorFlag,
       OUTPUT cErrorText,
       OUTPUT cGUID).
    
    /* output pcresult back to the device and comma separate the data - saves having to code for several return variables in OEMobile */
    ASSIGN
      pcResult = STRING(lErrorFlag) + "," + cErrorText + "," + cGUID.
     
    END METHOD.
	
	 
          
END CLASS.