
/*------------------------------------------------------------------------
    File        : dseBis.i
    Purpose     : 

    Syntax      :

    Description : Dataset definition for the eBIS Mobile

    Author(s)   : 
    Created     : Thu Aug 02 16:40:41 EDT 2012
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE TEMP-TABLE eeBis NO-UNDO  
  FIELD receiptDate       AS DATE      FORMAT "99/99/9999"
  FIELD receiptType       AS CHARACTER FORMAT "x(15)"
  FIELD receiptReason     AS CHARACTER FORMAT "x(30)"
  FIELD receiptAmount     AS DECIMAL   FORMAT ">>>>>>9.99"
  FIELD receiptNotes      AS CHARACTER FORMAT "X(150)"
  FIELD receiptMilesClaim AS INTEGER   FORMAT ">>>>>>9"
  FIELD receiptMilesRate  AS DECIMAL   FORMAT ">>9.99"
  FIELD receiptFrom       AS CHARACTER FORMAT "x(30)"
  FIELD receiptTo         AS CHARACTER FORMAT "x(30)"
  FIELD receiptReturnTrip AS LOGICAL   
  FIELD receiptFromDate   AS DATE      FORMAT "99/99/9999"
  FIELD receiptToDate     AS DATE      FORMAT "99/99/9999"
  FIELD receiptNoNights   AS INTEGER   FORMAT ">>9"
  INDEX primary IS PRIMARY receiptDate ReceiptType.

DEFINE DATASET dseBis SERIALIZE-NAME "eBIS"
    FOR eeBis .

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
