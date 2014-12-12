
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
DEFINE TEMP-TABLE eTypes NO-UNDO 
    FIELD cGroup          AS CHARACTER 
    FIELD cType           AS CHARACTER 
    FIELD cDescription    AS CHARACTER 
    FIELD cTypePrice      AS CHARACTER 
    FIELD cTypeMax        AS CHARACTER
    FIELD cRecModLast     AS CHARACTER 
    INDEX Primary IS PRIMARY cGroup cType.

DEFINE DATASET dseTypes  SERIALIZE-NAME "eTypes"  FOR eTypes.

def temp-table ttTypes no-undo
  field tttGroup as char
  field tttType as char
  field tttDescription as char
  field tttPrice as char /* default Unit Price */
  field tttMax as char
  field tttRecModLast as char
.
 