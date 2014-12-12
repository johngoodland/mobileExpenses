 
 /*------------------------------------------------------------------------
    File        : manage
    Syntax      : 
    Author(s)   : Administrator
    Created     : Wed Jan 15 11:29:34 GMT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
    
@program FILE(name="manage.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="manage", URI="/manage", schemaName="eeBis", schemaFile="ebis/AppServer/dseBIS.i").

USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS manage:

    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
	 
	
	{"dseBIS.i"} 
	
	
    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, based on a filter string                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    /*@openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json"). 
    METHOD PUBLIC VOID Readmanage(
    		INPUT filter AS CHARACTER, 
    		OUTPUT TABLE eeBis):
    	DEFINE VARIABLE pcWhere AS CHARACTER.
    	IF filter BEGINS "WHERE " THEN
            pcWhere = filter.
        ELSE IF filter NE "" THEN
            pcWhere = "WHERE " + filter.
    	      
	     CREATE eebis.
	     ASSIGN eebis.receiptNotes = "john test"  .  
        /* TODO: Add code to get a set of records and return the
           resulting records to the client. */      
    END METHOD.*/
/*------------------------------------------------------------------------------
            Purpose:  gateway ping service                                                                    
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
	@openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="read", URI="/ping", alias="", mediaType="application/json"). 
    METHOD PUBLIC VOID ping (OUTPUT pcResult AS CHARACTER): 
     
    /* call RegisterMobex API */
    message "Calling API gateway ping service".
   
    /* output pcresult back to the device and comma separate the data - saves having to code for several return variables in OEMobile */
    ASSIGN
      pcResult = "Alive".
     
    END METHOD.
	
	 
          
END CLASS.