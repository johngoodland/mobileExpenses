def var pSecKey as char no-undo init "MobExOK".
def var lDebug as logical no-undo init true.
def temp-table ttSettings no-undo
  field ttsName as char
  field ttsValue as char
  field ttsSpare1 as char
  field ttsSpare2 as char
  field ttsSpare3 as char
.
def var lErrorFlag as logical no-undo.
def var cErrorText as char no-undo.


run mobex/registerMobexFirst.p (pSecKey, lDebug, 
                           output table ttSettings,
                           output lErrorFlag, output cErrorText).

message "Failed? " lErrorFlag skip cErrorText skip 
  view-as alert-box info buttons ok.

for each ttSettings:
  disp ttsName format "x(30)" ttsValue format "x(30)".
end.
