
/*------------------------------------------------------------------------
    File        : ebisexpensegroups.i
    Purpose     : 

    Syntax      :

    Description : Ebis temp tables for group/fields/rules

    Author(s)   : 
    Created     : Mon Sep 30 13:58:49 BST 2013
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
def temp-table ttGroups no-undo
  field ttgGroup as char
  field ttgDescription as char
  field ttgType as char /* currently MILEAGE or blank */
  field ttgPolicyLink as char
  field ttgRecModLast as char.
  
def temp-table ttRules no-undo
  field ttrGroup      as char
  FIELD ttrRule       AS CHARACTER
  FIELD ttrLeftSide     as CHARACTER
  FIELD ttrOperand      as CHARACTER
  FIELD ttrRightSide    as CHARACTER
  FIELD ttrMessage      AS CHARACTER
.

def temp-table ttFields no-undo
  field ttfGroup as char
  field ttfOrder as int
  field ttfName as char
  field ttfLabel as char
  field ttfType as char
  field ttfMandatory as char
  field ttfDefault as char.
  
def temp-table ttTypes no-undo
  field tttGroup as char
  field tttType as char
  field tttDescription as char
  field tttPrice as char /* default Unit Price */
  field tttMax as char
  field tttRecModLast as char