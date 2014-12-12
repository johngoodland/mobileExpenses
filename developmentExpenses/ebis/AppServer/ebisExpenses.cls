 
 /*------------------------------------------------------------------------
    File        : ebisExpenses
    Syntax      : 
    Author(s)   : John.Goodland
    Created     : Fri Apr 19 12:51:24 BST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
    
@program FILE(name="ebisExpenses.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="ebisExpenses", URI="/ebisExpenses", schemaName="eeBis", schemaFile="ebis/AppServer/dseBIS.i").

USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS ebisExpenses:

    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
	
	
	{"dseBIS.i"} 
    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, based on a filter string                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json"). 
    METHOD PUBLIC VOID ReadebisExpenses(
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
    METHOD PUBLIC VOID CreateebisExpenses(INPUT-OUTPUT TABLE eeBis):    		
	            
        /* TODO: Add code to create a record from data passed
           in from the client. */        
    END METHOD.    
	
    /*------------------------------------------------------------------------------
            Purpose:  Update one or more records                                                                  
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateebisExpenses(INPUT-OUTPUT TABLE eeBis):    		
	          
        /* TODO: Add code to update a record from data passed
           in from the client. */          
    END METHOD.
	 
    /*------------------------------------------------------------------------------
            Purpose:    Delete a record                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteebisExpenses(INPUT-OUTPUT TABLE eeBis):     		       
	   
        /* TODO: Add code to delete a record passed in from the client. */   
    END METHOD.
	 
          
END CLASS.