def var lDebug as logical no-undo init true.
def var pUserID as char no-undo init "MPH".
def temp-table ttGroups no-undo
  field ttGroup as char
  field ttDescription as char
.
def var lErrorFlag as logical no-undo.
def var cErrorText as char no-undo.

run mobex/getGroupList.p (lDebug, pUserID, output table ttGroups,
                      output lErrorFlag, output cErrorText).

message "Failed? " lErrorFlag skip cErrorText
  view-as alert-box info buttons ok.

for each ttGroups:
  disp ttGroup ttDescription.
end.
