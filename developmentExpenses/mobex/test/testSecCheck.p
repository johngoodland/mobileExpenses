def var pSecKey as char no-undo init "MobExOK".
def var lDebug as logical no-undo init true.
def var pUserID as char no-undo init "MPH".
def var pGUID as char no-undo init "".
def var lErrorFlag as logical no-undo.
def var cErrorText as char no-undo.

find first rscExtra no-lock
  where rscExtra.uuserid = pUserID
    and rscExtra.extraType = "MobEx GUID" no-error.

if avail rscExtra then do:
  pGuid = rscExtra.data1.
end.


run mobex/secCheck.p (pSecKey, lDebug, pGUID, pUserID,
                      output lErrorFlag, output cErrorText).

message "Failed? " lErrorFlag skip cErrorText
  view-as alert-box info buttons ok.
