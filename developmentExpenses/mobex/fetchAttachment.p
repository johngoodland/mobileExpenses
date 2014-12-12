/*******************************************************************
  Program     : mobex/fetchAttachment.p
  Description : Fetching an Attachment from an ExpensesClaimLine
              : written for use with Mobile Expenses App
              : 
  By          : Mick Hand
  Date        : 18/09/2013

********************************************************************
                         Modification History  
********************************************************************


********************************************************************

#Notes######

Purpose...
   To fetch an attachment from an ExpensesClaimLine in eBIS
    
Parameters...
	lDebug 	logical
  pUserID
  pLineGUID
  output oFileName
  output oContent (longchar)
	output lErrorFlag    logical
  output cErrorText

######Notes#                                                                    
  Security checks for MobEx Key and User/GUID are to be called before running this.

**********************************************************************/

def input param lDebug as log no-undo.
def input param pUserID as char no-undo.
def input param pLineGUID as char no-undo.
def output param oFileName as char no-undo. 
def output param oContent as longchar no-undo. 
def output param lErrorFlag as log no-undo init NO.
def output param cErrorText as char no-undo init "".

def var cFormCode as char no-undo.
def var cTargetFileName as char no-undo.
def var cTargetFileNameFull as char no-undo.
def var cTargetFolder as char no-undo.
def var cCurrentFileName as char no-undo.
def var cCurrentFileNameFull as char no-undo.
def var cCurrentDocItem as char no-undo.
def var lOK as logical no-undo.
def var myMemptr as memptr no-undo.

def var dbug as logical no-undo.
{util/dbugChk.i &nomessage=nomessage}
{mobex/userDbugChk.i}

if lDebug = true then dbug = true.

if dbug then output to logs/debug_mobex_fetchAttachment.log.

if pLineGUID = "" then do:
  lErrorFlag = true.
  cErrorText = "Blank Line Identifier".
  if dbug then message cErrorText skip.
  return.
end.

find first objItem no-lock
  where objItem.objUnique = pLineGUID no-error.
if not avail objItem then do:
  lErrorFlag = true.
  cErrorText = "Line record cannot be found for ID:" + pLineGUID.
  if dbug then message cErrorText skip.
  return.
end.

cFormCode = objItem.objType.
cCurrentFileName = objItem.fld07. 

cTargetFileNameFull = search(cCurrentFileName).
if cTargetFileNameFull = ? then do:
  lErrorFlag = true.
  cErrorText = "File not found:" + cCurrentFileName.
  if dbug then message cErrorText skip.
  return.
end.

oFileName = cCurrentFileName.

run ipFetchFile.

finally:
  if dbug then message "reached the finally" skip.
  if dbug then output close.
end.

procedure ipFetchFile:
  
  copy-lob from file cTargetFileNameFull to myMemptr no-error.
  if error-status:error then do: 
    cErrorText = "Error reading File:" + oFileName. 
    lErrorFlag = true.
    message cErrorText skip.
    message error-status:get-message(1) skip.
    return.
  end.

  oContent = base64-encode(myMemptr).
  set-size(myMemptr) = 0.

end procedure. /* ipFetchFile */
