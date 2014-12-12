def var lDebug as logical no-undo init true.
def var pUserID as char no-undo init "MPH".
def var pLastType as char no-undo.

def temp-table ttTypes no-undo
  field tttGroup as char
  field tttType as char
  field tttDescription as char
  field tttPrice as char /* currently MILEAGE or blank */
  field tttMax as char
  field tttRecModLast as char
.

def var lErrorFlag as logical no-undo.
def var cErrorText as char no-undo.

run mobex/getTypesList.p (lDebug, pUserID, pLastType,
                      output table ttTypes,
                      output lErrorFlag, output cErrorText).

message "Failed? " lErrorFlag skip cErrorText
  view-as alert-box info buttons ok.

for each ttTypes:
  disp 
    tttGroup format "x(10)"
    tttType format "x(10)"
    tttDescription  format "x(20)"
    tttPrice  format "x(10)"
    tttMax  format "x(10)"
    with frame f1 width 100 5 down title "Types".
end.
