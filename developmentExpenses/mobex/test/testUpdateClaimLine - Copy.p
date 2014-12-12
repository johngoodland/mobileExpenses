def var lDebug as logical no-undo init true.
def var pUserID as char no-undo init "MPH".
def var pGUID as char no-undo init "".

def var pLineGUID as char no-undo init "".
def var pDate as date no-undo init TODAY.
def var pGroup as char no-undo init "HOTEL".
def var pType as char no-undo.       /* leave blank in POC */
def var pReason as char no-undo init "This is a a reason".
def var pCompany as int no-undo.     /* leave as 0 in POC */
def var pDepartment as char no-undo. /* leave blank in POC */
def var pAmount as dec no-undo init 123.45.
def var pFromAddress as char no-undo init "WR11 4TL".
def var pToAddress as char no-undo init "NN4 7YE".
def var lRoundTrip as log no-undo init NO.
def var pTotalMiles as dec no-undo init 22.34.
def var pFromDate as date no-undo init TODAY.
def var pToDate as date no-undo init TODAY.
def var pNights as int no-undo init 1.
def var pNotes as char no-undo init "These are notes".

def var lErrorFlag as logical no-undo.
def var cErrorText as char no-undo.
def var oLineGUID as char no-undo.

find first rscExtra no-lock
  where rscExtra.uuserid = pUserID
    and rscExtra.extraType = "MobEx GUID" no-error.

if avail rscExtra then do:
  pGuid = rscExtra.data1.
end.

run mobex/updateClaimLine.p (lDebug, pUserID,
                          pLineGUID,
                          pDate,
                          pGroup,
                          pType,
                          pReason,
                          pCompany,
                          pDepartment,
                          pAmount,
                          pFromAddress,
                          pToAddress,
                          lRoundTrip,
                          pTotalMiles,
                          pFromDate,
                          pToDate,
                          pNights,
                          pNotes,
                          output lErrorFlag, output cErrorText, output oLineGUID).

message "Failed? " lErrorFlag skip cErrorText skip "objUnique=" oLineGUID
  view-as alert-box info buttons ok.
