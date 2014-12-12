
/*------------------------------------------------------------------------
    File        : ttLines.i
    Purpose     : 

    Syntax      :

    Description : Returning temp table from fetch claim lines

    Author(s)   : 
    Created     : Mon Oct 21 15:37:39 BST 2013
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
def temp-table ttLines no-undo
  field ttlGroup as char
  field ttlType as char
  field ttlDate as char
  field ttlReason as char
  field ttlStatus as char /* "LOCKED" if it is on a claim, otherwise "FREE"  */
  field ttlAttachment as char /* relative path of file name */
  field ttlAmount as dec
  field ttlChkRecharge as log
  field ttlAdd_chkOutOfPolicy as log
  field ttlAdd_oopExplanation as char
  field ttlStoredJourney as char
  field ttlAdd_type as char
  field ttlAdd_visiting as char
  field ttlAdd_purpose as char
  field ttlAdd_fromLoc as char
  field ttlAdd_toLoc as char
  field ttlAdd_chkRoundtrip as log
  field ttlAdd_calcMiles as dec
  field ttlAdd_claimMiles as dec
  field ttlAdd_vehicle as char
  field ttlAdd_ytdMiles as dec
  field ttlAdd_people as char
  field ttlAdd_payee as char
  field ttlAdd_numPeople as int
  field ttlAdd_numNights as int
  field ttlAdd_chkIncEveMeal as log
  field ttlAdd_chkIncLunch as log
  field ttlAdd_chkIncBreakfast as log
  field ttlAdd_chkFlag as char
  field ttlAdd_value as dec
  field ttlAdd_resource as char
  field ttlAdd_proj as char
  field ttlChkNoReceipt as log
  field ttlUnique as char  /* objUnique */
  field ttlOnClaim as char /* objType / objID  */
.