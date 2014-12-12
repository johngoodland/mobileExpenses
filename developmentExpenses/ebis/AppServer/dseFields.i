
/*------------------------------------------------------------------------
    File        : dseTypes.i
    Purpose     : 

    Syntax      : 

    Description : DataSet for eBIS Expense Types

    Author(s)   : John
    Created     : Thu Jul 11 13:28:24 BST 2013
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEFINE TEMP-TABLE eFields NO-UNDO 
    FIELD cGroup          AS CHARACTER 
    FIELD iFieldOrder     AS INTEGER 
    FIELD cFieldName      AS CHARACTER /* currently MILEAGE or blank */
    FIELD cFieldLabel     AS CHARACTER 
    FIELD cFieldDataType  AS CHARACTER
    FIELD cFieldMandatory AS CHARACTER /* O=Optional, M=Mandatory, D=Disabled */
    FIELD cFieldHidden    AS CHARACTER /* H=Hide S (or blank) =Show */
    INDEX Primary IS PRIMARY cGroup iFieldOrder cFieldName.

DEFINE DATASET dseFields  SERIALIZE-NAME "eFields"  FOR eFields.

{appServer/ebisexpensegroups.i}. 