def var lDebug as logical no-undo init true.
def var pUserID as char no-undo init "MPH".
def var pGUID as char no-undo init "".
def var pFileName as char no-undo init "uploads/testMobexUpload099.docx".
def var cTestFileName as char no-undo init "testMobexUpload.docx".
def var pFileDesc as char no-undo init "this is a file description".
def var pMode as char no-undo init "ADD".
def var pContent as longchar no-undo.

def var pLineGUID as char no-undo init "".

def var lErrorFlag as logical no-undo.
def var cErrorText as char no-undo.

def var myMemptr as memptr no-undo.

if pMode = "DEL" then do:
  cTestFileName = "".
  pFileDesc = "".
  pFileName = "".
end.
else do:
  /* get the binary data from the file into a memptr */
  copy-lob from file cTestFileName to myMemptr.
  /* convert from memptr to longchar and base64-encode */
  pContent = base64-encode(myMemptr).

  set-size(myMemptr) = 0.
end.

find first objItem no-lock
  where objType = "ExpenseClaimLines" no-error.

if not avail objItem then do:
  message "Sorry no ExpenseClaimLines exist"
    view-as alert-box info buttons ok.
  return.
end.

pLineGUID = objItem.objUnique.

/*
def input param lDebug as log no-undo.
def input param pUserID as char no-undo.
def input param pLineGUID as char no-undo.
def input param pFileName as char no-undo. /* can be blank on a DEL */
def input param pFileDesc as char no-undo.
def input param pMode as char no-undo. /* ADD, MOD, DEL */
def input param pContent as longchar no-undo. /* can be blank on a DEL */
def output param lErrorFlag as log no-undo init NO.
def output param cErrorText as char no-undo init "".
*/

run mobex/updateAttachment.p (lDebug, pUserID, pLineGUID,
                              pFileName, pFileDesc, pMode, pContent,
                          output lErrorFlag, output cErrorText).

message "Failed? " lErrorFlag skip cErrorText skip
  view-as alert-box info buttons ok.
