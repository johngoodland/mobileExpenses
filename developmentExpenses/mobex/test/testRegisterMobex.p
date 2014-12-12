/*
def input param pSecKey as char no-undo.
def input param lDebug as log no-undo.
def input param pUserID as character no-undo.
def input param pEncodedPass as character no-undo.
def output param lErrorFlag as log no-undo init NO.
def output param cErrorText as char no-undo init "".
def output param pGUID as char no-undo.
*/
def var pSecKey as char no-undo init "MobExOK".
def var lDebug as logical no-undo init true.
def var pUserID as char no-undo init "MPH".
def var pEncodedPass as char no-undo init "abc".
def var lErrorFlag as logical no-undo.
def var cErrorText as char no-undo.
def var pGUID as char no-undo format "x(40)".

run mobex/registerMobex.p (pSecKey, lDebug, pUserID, pEncodedPass,
                           output lErrorFlag, output cErrorText, output pGUID).

message "Failed? " lErrorFlag skip cErrorText skip "GUID: " pGUID
  view-as alert-box info buttons ok.
