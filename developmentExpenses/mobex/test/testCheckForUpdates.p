def var lDebug as logical no-undo init true.
def var pUserID as char no-undo init "MPH".
def var pLastGroup as char no-undo init "20130404114346".
def var pLastType as char no-undo init "20130618114240".
def var oGroupsChanged as logical no-undo.
def var oMileageCalcLicensed as logical no-undo.
def var oTypesChanged as logical no-undo.
def var lErrorFlag as logical no-undo.
def var cErrorText as char no-undo.

run mobex/checkForUpdates.p (lDebug, pUserID, pLastGroup, pLastType,
                      output oMileageCalcLicensed, output oGroupsChanged, output oTypesChanged,
                      output lErrorFlag, output cErrorText).

message 
  "Mileage Calc Licensed? " oMileageCalcLicensed skip
  "Groups changed? " oGroupsChanged skip
  "Types changed? " oTypesChanged skip
  "Failed? " lErrorFlag skip cErrorText
  view-as alert-box info buttons ok.

