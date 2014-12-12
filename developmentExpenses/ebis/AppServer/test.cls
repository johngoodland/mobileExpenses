 
 /*------------------------------------------------------------------------
    File        : test
    Syntax      : 
    Author(s)   : John.Goodland
    Created     : Tue Apr 02 16:05:32 BST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
    
@program FILE(name="test.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="test", URI="/test", schemaName="dstest", schemaFile="").

USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS test:

    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
	
	   
    /* TODO: Change to use your schema */ 
	DEFINE TEMP-TABLE etest FIELD testField AS INTEGER INDEX testIndex IS UNIQUE PRIMARY testField.
	DEFINE DATASET dstest FOR etest. 
    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, based on a filter string                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json"). 
    METHOD PUBLIC VOID Readtest(
    		INPUT filter AS CHARACTER, 
    		OUTPUT DATASET dstest):      
	         
        /* TODO: Add code to get a set of records and return the
           resulting records to the client. */      
    END METHOD.
	  
    /*------------------------------------------------------------------------------
            Purpose: Create one or more new records                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/  
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID Createtest(INPUT-OUTPUT DATASET dstest):    		
	            
        /* TODO: Add code to create a record from data passed
           in from the client. */        
    END METHOD.    
	
    /*------------------------------------------------------------------------------
            Purpose:  Update one or more records                                                                  
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID Updatetest(INPUT-OUTPUT DATASET dstest):    		
	          
        /* TODO: Add code to update a record from data passed
           in from the client. */          
    END METHOD.
	
    /*------------------------------------------------------------------------------
            Purpose:    Delete a record                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID Deletetest(INPUT-OUTPUT DATASET dstest):     		       
	   
        /* TODO: Add code to delete a record passed in from the client. */   
    END METHOD.
	 
          
END CLASS.