def var lDebug as logical no-undo init true.
def var pUserID as char no-undo init "MPH".
def var pFree as char no-undo init "1111,222,333,444,201309200000000420".
def var pUsed as char no-undo init "111,222,333".
def var oFree as char no-undo.
def var oUsed as char no-undo.
def var oMissing as char no-undo.
def var lErrorFlag as logical no-undo.
def var cErrorText as char no-undo.

run mobex/checkClaimLines.p (lDebug, pUserID, pFree, pUsed,
                      output oFree, output oUsed, output oMissing,
                      output lErrorFlag, output cErrorText).

message 
  "Free: " oFree skip
  "Used: " oUsed skip
  "Miss: " oMissing skip
  "Failed? " lErrorFlag skip cErrorText
  view-as alert-box info buttons ok.

