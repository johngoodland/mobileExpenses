  
 /*------------------------------------------------------------------------
    File        : getTypes
    Syntax      : 
    Author(s)   : John.Goodland
    Created     : Thu Jul 11 14:27:37 BST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
    
@program FILE(name="getTypes.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="getTypes", URI="/getTypes", schemaName="eTypes", schemaFile="ebis/AppServer/dseTypes.i").

USING Progress.Json.ObjectModel.JsonObject.
USING Progress.Json.ObjectModel.JsonArray.
USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS AppServer.getTypes INHERITS BusinessEntity:

    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
	
	
	{"dseTypes.i"} 
    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, based on a filter string                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json"). 
    METHOD PUBLIC VOID ReadgetTypes(
    		INPUT filter AS CHARACTER, 
    		OUTPUT TABLE eTypes):   
    
    /* clear out temp-table */
    EMPTY TEMP-TABLE eTypes NO-ERROR.
    		        
	DEFINE VARIABLE oFilter    AS  JsonObject NO-UNDO.
    DEFINE VARIABLE pcUserID   AS  CHARACTER  NO-UNDO.  
    DEFINE VARIABLE lErrorFlag AS  CHARACTER  NO-UNDO.  
    DEFINE VARIABLE cErrorText AS  CHARACTER  NO-UNDO.   
     
    /* parse out the filter looking for the user */
    oFilter = ParseFilter(filter). 
    pcUserId = oFilter:GetCharacter('UserID').    
	
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
        cGroup = tttGroup
        cType = tttType
        cDescription  = tttDescription
        cTypePrice    = tttPrice
        cTypeMax      = tttMax
        cRecModLast   = tttRecModLast.
    END.         

           /* TODO: call to expenses api to get types - TBC */
                     /* run ... output temp-table */
           /*
           /* for now build temp table with a dataset */     
           CREATE eTypes.
           ASSIGN cGroup = "Accommodation"
                  cType = "Hotel"
                  cDescription  = "Hotel"
                  cTypePrice    = "typeprice"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001". 
           CREATE eTypes.
           ASSIGN cGroup = "Accommodation"
                  cType = "Internet"
                  cDescription  = "Internet Use"
                  cTypePrice    = "typeprice"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001" .
           CREATE eTypes.
           ASSIGN cGroup = "Accommodation"
                  cType = "Laundry"
                  cDescription  = "Laundry Services"
                  cTypePrice    = "typeprice"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001" .     
           CREATE eTypes.
           ASSIGN cGroup = "Accommodation"
                  cType = "Room Service"
                  cDescription  = "Room Service"
                  cTypePrice    = "typeprice"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001" .
           CREATE eTypes.
           ASSIGN cGroup = "Accommodation"
                  cType = "Hotel Car Park"
                  cDescription  = "Hotel Car Parking"
                  cTypePrice    = "typeprice"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001".
           CREATE eTypes.
           ASSIGN cGroup = "Subsistence"
                  cType = "Lunch"
                  cDescription  = "Lunch"
                  cTypePrice    = "typeprice"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001" .
           CREATE eTypes.
           ASSIGN cGroup = "Subsistence"
                  cType = "Evening Meal"
                  cDescription  = "Evening Meal"
                  cTypePrice    = "typeprice"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001" .
           CREATE eTypes.
           ASSIGN cGroup = "Subsistence"
                  cType = "Breakfast"
                  cDescription  = "Breakfast"
                  cTypePrice    = "typeprice"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001"   .   
           CREATE eTypes.
           ASSIGN cGroup = "Subsistence"
                  cType = "Drinks(Non Alcoholic)"
                  cDescription  = "Drinks Alcohol free"
                  cTypePrice    = "typeprice"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001"   .          
                   CREATE eTypes.
           ASSIGN cGroup = "Subsistence"
                  cType = "Drinks(Alcoholic)"
                  cDescription  = "Drinks Alcohol"
                  cTypePrice    = "typeprice"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001"   . 
    
            CREATE eTypes.
           ASSIGN cGroup = "Transportation"
                  cType = "Agent Fees"
                  cDescription  = "Agent Fees"
                  cTypePrice    = "typeprice"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001" .
           CREATE eTypes.
           ASSIGN cGroup = "Transportation"
                  cType = "Airfare"
                  cDescription  = "Airfare"
                  cTypePrice    = "typeprice"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001" .
           CREATE eTypes.
           ASSIGN cGroup = "Transportation"
                  cType = "Bag Check Fees"
                  cDescription  = "Bag Check Fees"
                  cTypePrice    = "typeprice"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001"     . 
           CREATE eTypes.
           ASSIGN cGroup = "Transportation"
                  cType = "Bus"
                  cDescription  = "Bus"
                  cTypePrice    = "typeprice"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001".
           CREATE eTypes.
           ASSIGN cGroup = "Transportation"
                  cType = "Fuel (Rental Car Only)"
                  cDescription  = "Fuel (Rental Car Only)"
                  cTypePrice    = "typeprice"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001"   .   
           CREATE eTypes.
           ASSIGN cGroup = "Transportation"
                  cType = "Parking"
                  cDescription  = "Parking"
                  cTypePrice    = "typeprice"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001".
         CREATE eTypes.
           ASSIGN cGroup = "Transportation"
                  cType = "Rental Car"
                  cDescription  = "Rental Car"
                  cTypePrice    = "typeprice"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001"  .    
           CREATE eTypes.
           ASSIGN cGroup = "Transportation"
                  cType = "Train"
                  cDescription  = "Train"
                  cTypePrice    = "typeprice"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001".
                           CREATE eTypes.
           ASSIGN cGroup = "Mileage"
                  cType = "Business Miles 10K (45p)"
                  cDescription  = "Business Miles upto 10K (45p)"
                  cTypePrice    = "Mileage"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001"  .     
           CREATE eTypes.
           ASSIGN cGroup =  "Mileage"
                  cType = "Business Miles over 10K (25p)"
                  cDescription  = "Business Miles over 10K (25p)"
                  cTypePrice    = "Mileage"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001".
            CREATE eTypes.
           ASSIGN cGroup = "Mileage"
                  cType = "Flat rate 16p per mile"
                  cDescription  = "Flat rate 16p per mile"
                  cTypePrice    = "Mileage"
                  cTypeMax      = "typemax"
                  cRecModLast   = "01/01/2001".
           */       
    END METHOD.
 
          
END CLASS.