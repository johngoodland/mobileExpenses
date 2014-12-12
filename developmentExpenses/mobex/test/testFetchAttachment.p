def var lDebug as logical no-undo init true.
def var pUserID as char no-undo init "MPH".
def var pGUID as char no-undo init "".
def var oFileName as char no-undo .
def var cTestFileName as char no-undo init "testMobexFetch.docx".
def var oContent as longchar no-undo.
def var myMemptr as memptr no-undo.

def var pLineGUID as char no-undo init "".

def var lErrorFlag as logical no-undo.
def var cErrorText as char no-undo.


find first objItem no-lock
  where objType = "ExpenseClaimLines" no-error.

if not avail objItem then do:
  message "Sorry no ExpenseClaimLines exist"
    view-as alert-box info buttons ok.
  return.
end.

pLineGUID = objItem.objUnique.

run mobex/fetchAttachment.p (lDebug, pUserID, pLineGUID,
                              output oFileName, output oContent, output lErrorFlag, output cErrorText).

message "Failed? " lErrorFlag skip cErrorText skip
  view-as alert-box info buttons ok.

if not lErrorFlag then do:
  myMemptr = base64-decode(oContent).
  /* output the binary data as a file */
  copy-lob from myMemptr to file cTestFileName no-error.
  set-size(myMemptr) = 0.
end.
