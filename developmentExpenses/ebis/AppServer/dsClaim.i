/** ****************************************************************************
  DataSet for Form data - groups, fields, rules 
**************************************************************************** **/
/*------------------------------------------------------------------------
    File        : dsFormData.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : 14 Nov 2013
    Notes       :
  ----------------------------------------------------------------------*/
 
DEFINE TEMP-TABLE eWrapper NO-UNDO 
    FIELD cGroup AS CHARACTER 
    FIELD cDescription AS CHARACTER 
    FIELD cType AS CHARACTER /* currently MILEAGE or blank */
    FIELD cPolicyLink AS CHARACTER 
    FIELD cRecModLast AS CHARACTER 
    INDEX Primary IS PRIMARY cGroup.

DEFINE TEMP-TABLE eClaims NO-UNDO  
    FIELD expenseDate       AS CHARACTER
    FIELD expenseGroup      AS CHARACTER 
    FIELD expenseType       AS CHARACTER  
    FIELD expenseReason     AS CHARACTER  
    FIELD expenseAmount     AS CHARACTER   
    FIELD expenseNotes      AS CHARACTER  
    FIELD expenseMilesClaim AS CHARACTER
    FIELD expenseMilesRate  AS CHARACTER
    FIELD expenseFrom       AS CHARACTER  
    FIELD expenseTo         AS CHARACTER  
    FIELD expenseImage      AS CLOB    
    FIELD expense_ID        AS CHARACTER
    FIELD expenseStatus     AS CHARACTER
    FIELD expenseCharge     AS CHARACTER
    FIELD expensePurpose    AS CHARACTER
    FIELD expenseOOP        AS CHARACTER
    FIELD expensePayee      AS CHARACTER
    FIELD expenseNoPeople   AS CHARACTER
    FIELD expenseNoNights   AS CHARACTER
    FIELD expenseEveMeal    AS CHARACTER
    FIELD expenseBreak      AS CHARACTER
    FIELD expenseLunch      AS CHARACTER
    FIELD expenseVisit      AS CHARACTER
    FIELD expenseRound      AS CHARACTER
    FIELD expenseVehicle    AS CHARACTER
    FIELD expenseYTDMiles   AS CHARACTER
    FIELD expensePeople     AS CHARACTER
    FIELD expenseStoredJny  AS CHARACTER
    FIELD expenseOOPFlag    AS CHARACTER
    FIELD expenseAddType    AS CHARACTER
    FIELD expenseAddChk     AS CHARACTER 
    FIELD expenseAddValue   AS CHARACTER 
    FIELD expenseAddResource AS CHARACTER
    FIELD expenseUserID     AS CHARACTER
    FIELD expenseFromDate   AS CHARACTER
    FIELD expenseToDate     AS CHARACTER
    FIELD expenseUnitPrice  AS CHARACTER 
    FIELD expenseNoReceipt  AS CHARACTER 
    FIELD expenseGUID       AS CHARACTER 
    FIELD expenseUsed       AS CHARACTER.
 
define dataset dsClaims for eWrapper, eClaims SERIALIZE-NAME "FeedParticipantResponse" .
	
