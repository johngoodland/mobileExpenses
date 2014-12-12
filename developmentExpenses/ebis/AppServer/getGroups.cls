 
 /*------------------------------------------------------------------------
    File        : getGroups
    Syntax      : 
    Author(s)   : John.Goodland
    Created     : Tue Jul 09 15:43:46 BST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
     
@program FILE(name="getGroups.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="getGroups", URI="/getGroups", schemaName="eGroup", schemaFile="ebis/AppServer/dseGroups.i").


USING Progress.Json.ObjectModel.JsonObject.
USING Progress.Json.ObjectModel.JsonArray.
USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS AppServer.getGroups INHERITS BusinessEntity:

    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
	
	
	{"dseGroups.i"} 
    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, based on a filter string                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json"). 
    METHOD PUBLIC VOID ReadgetGroups(
    		INPUT filter AS CHARACTER, 
    		OUTPUT TABLE eGroup):
    		          
	EMPTY TEMP-TABLE eGroup NO-ERROR.
	
	DEFINE VARIABLE oFilter    AS  JsonObject NO-UNDO.
    DEFINE VARIABLE pcUserID   AS  CHARACTER  NO-UNDO.  
    DEFINE VARIABLE lErrorFlag AS  CHARACTER  NO-UNDO.  
    DEFINE VARIABLE cErrorText AS  CHARACTER  NO-UNDO.   
    
    /* parse out the filter looking for the user */
    oFilter = ParseFilter(filter). 
    pcUserId = oFilter:GetCharacter('UserID').  
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
        cGroup = ttgGroup
        cDesc  = ttgDescription
        cType  = ttgType
        cPolicyLink = ttgPolicyLink 
        cRecModLast = ttgRecModLast.
    END.
    
           /* TODO: call to expenses api to get groups - TBC */
                      /* run ... output temp-table */
           
           /* for now build temp table with a dataset */
      /*     
           EMPTY TEMP-TABLE eGroup no-error.  
           CREATE eGroup.
           ASSIGN cGroup = "Accommodation"
                  cDesc  = "Overnight Hotel"
                  ctype  = "other".
           CREATE eGroup.
           ASSIGN cGroup = "Subsistence"
              cDesc  = "Dinner, Lunch etc"
                  ctype  = "other".
          CREATE eGroup.
           ASSIGN cGroup = "Transportation"
              cDesc  = "Car parking, tolls, train etc"
                  ctype  = "other".
           CREATE eGroup.
           ASSIGN cGroup = "Mileage"
              cDesc  = "Mileage (non hire car)"
                  ctype  = "Mileage". */
    END METHOD.
	
	
	
	 
          
END CLASS.