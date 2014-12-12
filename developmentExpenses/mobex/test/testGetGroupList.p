def var lDebug as logical no-undo init true.
def var pUserID as char no-undo init "MPH".
def var pLastGroup as char no-undo.

def temp-table ttGroups no-undo
  field ttgGroup as char
  field ttgDescription as char
  field ttgType as char /* currently MILEAGE or blank */
  field ttgPolicyLink as char
  field ttgRecModLast as char
.

def temp-table ttRules no-undo
  field ttrGroup as char
  field ttrRule as char
  field ttrMessage as char
.

def temp-table ttFields no-undo
  field ttfGroup as char
  field ttfOrder as int
  field ttfName as char
  field ttfLabel as char
  field ttfType as char
  field ttfMandatory as char
  field ttfDefault as char
.

def var lErrorFlag as logical no-undo.
def var cErrorText as char no-undo.

run C:\advanced\eliv5080\app\mobex/getGroupList.p (lDebug, pUserID, pLastGroup,
                      output table ttGroups, output table ttRules, output table ttFields,
                      output lErrorFlag, output cErrorText).

message "Failed? " lErrorFlag skip cErrorText
  view-as alert-box info buttons ok.

for each ttGroups:
  disp 
    ttgGroup format "x(20)"
    ttgDescription  format "x(30)"
    ttgPolicyLink  format "x(30)"
    with frame f1 width 100 5 down title "Groups".
  for each ttRules where ttRules.ttrGroup = ttGroups.ttgGroup:
    disp
      ttrRule format "x(30)"
      ttrMessage  format "x(30)"
      with frame f2 width 100 10 down title "Rules".
  end.
  for each ttFields where ttFields.ttfGroup = ttGroups.ttgGroup:
    disp 
      ttfName format "x(20)" 
      ttfLabel format "x(30)" 
      ttfType format "x(10)" 
      ttfMandatory format "x(5)" 
      with frame f3 width 100 10 down title "Fields".
  end.
end.
