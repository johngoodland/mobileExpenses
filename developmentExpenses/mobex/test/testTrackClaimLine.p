def var lDebug as logical no-undo init true.
def var pUserID as char no-undo init "MPH".
def var pLineUnique as char no-undo init "201304030000006907".
def var oStatus as char no-undo.
def var lErrorFlag as logical no-undo.
def var cErrorText as char no-undo.

run mobex/trackClaimLine.p (lDebug, pUserID, pLineUnique, output oStatus,
                      output lErrorFlag, output cErrorText).

message 
  oStatus skip
  "Failed? " lErrorFlag skip cErrorText
  view-as alert-box info buttons ok.

