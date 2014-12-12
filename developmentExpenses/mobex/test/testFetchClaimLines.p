def var lDebug as logical no-undo init true.
def var pUserID as char no-undo init "MPH".
def var pFilterGroup as char no-undo.
def var pFilterStatus as char no-undo init "". /* ALL (also blank), FREE or USED */
def var pFilterDate as char no-undo. /* CCYY-MM-DD */

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
  field ttlUnique as char  /* objUnique */
  field ttlOnClaim as char /* objType / objID  */
.

def var lErrorFlag as logical no-undo.
def var cErrorText as char no-undo.

run mobex/fetchClaimLines.p (lDebug, pUserID,
                             pFilterGroup, pFilterStatus, pFilterDate,
                      output table ttLines, 
                      output lErrorFlag, output cErrorText).

message "Failed? " lErrorFlag skip cErrorText
  view-as alert-box info buttons ok.

for each ttLines:
  disp 
    ttlGroup format "x(6)"
    ttlType  format "x(6)"
    ttlDate  format "x(12)"
    ttlReason  format "x(10)"
    ttlStatus  format "x(10)"
    ttlOnClaim  format "x(10)"
    ttlUnique  format "x(20)"
    ttlAttachment  format "x(30)"
    with frame f1 width 100 10 down title "Claim Lines".
end.
