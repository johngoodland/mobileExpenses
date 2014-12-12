/*******************************************************************
  Program     : mobex/updateAttachment.p
  Description : Adding an Attachment to an ExpensesClaimLine
              : written for use with Mobile Expenses App
              : 
  By          : Mick Hand
  Date        : 04/04/2013

********************************************************************
                         Modification History  
********************************************************************


********************************************************************

#Notes######

Purpose...
   To add, modify or delete an attachment to an ExpensesClaimLine in eBIS
    
Parameters...
	lDebug 	logical
  pUserID
  
  params for each field in the Form
  
	output lErrorFlag    logical
  output cErrorText

######Notes#                                                                    
  Security checks for MobEx Key and User/GUID are to be called before running this.
  Will use the Form Code from the objItem, found via the pLineGUID which is objItem.objUnique
  Checks Folder is allowed for Uploads
  Updates the ExpenseClaimLine record with the File Name
  Checks for FTP requirement and calls ox_ftp if required.
  Should cope with Add, Mod or Delete
  If doing a MOD and there is no current File, turn into an ADD

**********************************************************************/

def input param lDebug as log no-undo.
def input param pUserID as char no-undo.
def input param pLineGUID as char no-undo.
def input param pFileName as char no-undo. /* can be blank on a DEL */
def input param pFileDesc as char no-undo.
def input param pMode as char no-undo. /* ADD, MOD, DEL */
def input param pContent as longchar no-undo. /* can be blank on a DEL */
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
def var cHistoryText as char no-undo.
def var cHistoryLevel as char no-undo.
def var cTime as char no-undo.

def var dbug as logical no-undo.
{util/dbugChk.i &nomessage=nomessage}
{mobex/userDbugChk.i}

if lDebug = true then dbug = true.

if dbug then output to logs/debug_mobex_updateAttachment.log.

FUNCTION fnGetHistoryLevel RETURNS CHARACTER
  (input pProcess as character,input pHistoryLevel as character) :
/*------------------------------------------------------------------------------
  Purpose: Returns logging level for an action.
  Notes:   If the default logging level is used for an action, find out what the default is.
           If none could be found then use a level of 3.
------------------------------------------------------------------------------*/
  def var cAction as char no-undo.

  /* If we already have a level defined use it */
  if pHistoryLevel <> "" then
    return pHistoryLevel.

  /* We are only intrested in the part of the process string that defines the action (move:entry) */
  cAction = entry(1,pProcess,":").

  /* If cAction ends with a number remove the field specific part of the action */
  /* addToFldxx,delFromFldxx,setFieldxx */
  cAction = right-trim(cAction,"0123456789").

  /* If no history level then find the default level from the repository (valItem)  */
  find first valItem no-lock
    where valItem.valType = "historyLevelDefaults"
      and valItem.valCode = cAction
    no-error.

  if avail valItem then
    return valItem.valCode2.

  /* Should never get here but use a default of 3 if no other level can be found */
  return "3".

END FUNCTION.

FUNCTION fnGetTime RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the date/time in the correct format for storing in the DB  
    Notes: Use fnDisplayTime to this into a viewable string
           copied from ox_super
------------------------------------------------------------------------------*/

  /* return a string with the format YYYYMMDDHHMMSS */
  
  def var cString as char no-undo.

  cString = string(year(today),"9999") + 
            string(month(today),"99") + 
            string(day(today),"99") + 
            replace(string(time,"HH:MM:SS"),":","").

  RETURN cString.   /* Function return value. */

END FUNCTION.


if pLineGUID = "" then do:
  lErrorFlag = true.
  cErrorText = "Blank Line Identifier".
  if dbug then message cErrorText skip.
  return.
end.

if pMode = "" then do:
  lErrorFlag = true.
  cErrorText = "Mode must be ADD, MOD or DEL".
  if dbug then message cErrorText skip.
  return.
end.

if pFileName = "" and pMode <> "DEL" then do:
  lErrorFlag = true.
  cErrorText = "Blank File Name not allowed for Mode:" + pMode.
  if dbug then message cErrorText skip.
  return.
end.

if pFileName <> "" and pMode = "DEL" then do:
  lErrorFlag = true.
  cErrorText = "File Name not allowed for Mode:" + pMode.
  if dbug then message cErrorText skip.
  return.
end.

if pContent = "" and pMode <> "DEL" then do:
  lErrorFlag = true.
  cErrorText = "Blank File Content not allowed for Mode:" + pMode.
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

if pMode = "MOD" and cCurrentFileName = "" then do:
  pMode = "ADD".
  if dbug then message "MOD - no current Filename, switching to ADD" skip.
end.

/*
if pMode = "DEL" then do:
  /* just to avoid deleting any files not in valid folders */
  run ipCheckValidFolder (cCurrentFileName, output lOK).
  if not lOK then do:
    lErrorFlag = true.
    cErrorText = "Folder of current file not allowed for Uploads:" + pFileName.
    if dbug then message cErrorText skip.
    return.
  end.
end.
  */
if pMode = "MOD" then do:
  /* just to avoid deleting any files not in valid folders */
  run ipCheckValidFolder (cCurrentFileName, output lOK).
  if not lOK then do:
    lErrorFlag = true.
    cErrorText = "Folder of current file not allowed for Uploads:" + pFileName.
    if dbug then message cErrorText skip.
    return.
  end.
  run ipCheckValidFolder (pFileName, output lOK).
  if not lOK then do:
    lErrorFlag = true.
    cErrorText = "Folder not allowed for Uploads:" + pFileName.
    if dbug then message cErrorText skip.
    return.
  end.
end.
/*
if pMode = "ADD" or pMode = "MOD" then do:
  run ipCheckValidFolder (pFileName, output lOK).
  if not lOK then do:
    lErrorFlag = true.
    cErrorText = "Folder not allowed for Uploads:" + pFileName.
    if dbug then message cErrorText skip.
    return.
  end.
end.
*/

if pMode = "MOD" then do:
  run ipProcessMOD (output lOK).

  if not lOK then do:
    lErrorFlag = true.
    return.
  end.
  pMode = "ADD".
end.

if pMode = "DEL" then do:
  run ipDeleteCurrentFile (cCurrentFileName, output lOK).
  if not lOK then do:
    lErrorFlag = true.
    return.
  end.
end.

if pMode = "ADD" then do:
  run ipAddFile (output lOK).
  if not lOK then do:
    return.
  end.
end.

cTime = fnGetTime().

/* update the objItem record */
/* set/unset the fld07, docITem, docUpTime docUpUser */
/* update the item's History */
/* TODO: decide whether to do the record updating earlier so we can undo the transaction if any of the file operations fails ? */
do TRANSACTION:
  find first objItem EXCLUSIVE-LOCK
    where objItem.objUnique = pLineGUID no-wait no-error.
  if locked objItem then do:
    lErrorFlag = true.
    cErrorText = "Item record is LOCKED".
    message "SERIOUS ERROR: Item Record is LOCKED ObjU=" pLineGUID skip.
    return.
  end.
  if not avail objItem then do:
    lErrorFlag = true.
    cErrorText = "Item record has VANISHED".
    message "SERIOUS ERROR: Item Record has VANISHED ObjU=" pLineGUID skip.
    return.
  end.
  if pMode = "DEL" then do:
    assign
      objItem.fld07 = ""  
      objItem.docItem = ""
      cHistoryText = "Mobex - Attachment Deleted"
      objItem.docUpUser = pUserID
      objItem.docUpTime = cTime
      objItem.recModTime = cTime
      objItem.recModUser = pUserID
    .
  end.
  if pMode = "MOD" then do:
    assign
      objItem.fld07 = pFileName
      objItem.docItem = pFileName
      cHistoryText = "Mobex - Attachment Changed"
      objItem.docUpUser = pUserID
      objItem.docUpTime = cTime
      objItem.recModTime = cTime
      objItem.recModUser = pUserID
    .
  end.
  if pMode = "ADD" then do:
    assign
      objItem.fld07 = pFileName  
      objItem.docItem = pFileName
      cHistoryText = "Mobex - Attachment Added"
      objItem.docUpUser = pUserID
      objItem.docUpTime = cTime
      objItem.recModTime = cTime
      objItem.recModUser = pUserID
    .
  end.

  /* recalculate the Key Fields, incase the Attachment Name is one of them */
  run util/rekey.p (objItem.objType, objItem.objUnique).

  cHistoryLevel = fnGetHistoryLevel("upload","").
  run ipAddHistory(cHistoryText,cHistoryLevel).  

end. /* TRANSACTION */


/*
if not dbug then do:
  os-delete value(cXMLTemplateFileTemp).  
end.
*/

finally:
  if dbug then message "reached the finally" skip.
  if dbug then output close.
end.


procedure ipCheckValidFolder:
/* this code copied from util/validateUploadPath.p
   because it expected a session parameter as usually run from an eBIS Agent
   modified to use hard-coded "ebis.admin"
   modified to return a logical instead of an integer
*/
def input param pValue as char no-undo.   /* The path/filename */
def output param pRes as log.             /* in standard version this was an integer !  result 0 = no 1 =yes */
  
  def var iPos as int no-undo.            /* Used to store the position of a char in a string */
  def var cPath as char no-undo.          /* The path we are validating */
  def var cTempString as char no-undo.    /* Temport string for building the list */
  def var cValidPathList as char no-undo. /* A semi colon sepearted list of valid dirs */
  def var cFileName as char no-undo.      /* The filename that holds all the valid dirs */
  def var i as int no-undo.               /* Loop counter */
  def var cSsnName as char no-undo.       /* Holds the name of the prameter used to name all startup files e.g oxdev.admin oxdev.ini */

  /* Remove the filename from the end of the value */
  if opsys = "UNIX" then do:
    cPath = replace(pValue,"~\","/").  /* %%V30-1011 TDM 04/02/2009 */
    iPos = r-index(cPath,"/").
    if iPos > 0  then
      cPath = substring(cPath,1,iPos).
  end.
  else do:
    cPath = replace(pValue,"/","~\").     /* %%V30-1011 TDM 04/02/2009 */
    iPos = r-index(cPath,"~\").           /* %%V30-1011 TDM 04/02/2009 */
    if iPos > 0  then
      cPath = substring(cPath,1,iPos).
  end.

  /* %%V10-0201 TDM 10/12/2001 START */
  /* Check that this directory exists */           
  file-info:filename = substring(cPath,1,length(cPath) - 1).
  if file-info:file-type = ? then do:
    message("Error - upload directory " + substring(cPath,1,length(cPath) - 1) + " does not exist.").
    pRes = false.
	pRes = true.
    return.
  end.
  /* %%V10-0201 TDM 10/12/2001 END*/

  cSsnName = "ebis". /* in std version this was session:parameter */
/*
  if search( cSsnName + ".admin") <> ? then do:
    cFileName = search(cSsnName + ".admin").
    if dbug then message "validateUploadPath: cFileName=" cFileName skip.

    /* Read the ebis.admin file into a string */
    /* run ipCheckFixEOF(cFileName). removed for mobex as this was in util/ox_super.p */

    input from value(cFileName).
    repeat:
      import unformatted cTempString.
      cValidPathList = cValidPathList + cTempString.
      if dbug then message "validateUploadPath: cValidPathList=" cValidPathList skip.
    end.
    input close.

    /* See if the path begins with any of the valid paths */
    do i = 1 to num-entries(cValidPathList,";") :
      if index(cPath,entry(i,cValidPathList,";")) = 1 then do:
        if dbug then message "validateUploadPath: i=" i " cPath=" cPath 
          " entry=" entry(i,cValidPathList,";") skip.
        pRes = true. /* this is a valid directory */
        return.
      end.
    end.
    if dbug then message "Error - upload directory " + cPath + " could not be found in " + cSsnName +  ".admin" skip.  /* %%V10-0201 TDM 10/12/2001 */
    pRes = false.
  end.
  else do:
    if dbug then message "Error - " + cSsnName +  ".admin could not be found." skip.
    pRes = false.  /* This is not a valid upload directory */
  end.
*/
end procedure. /* ipCheckValidFolder */

procedure ipDeleteCurrentFile:
def input  parameter pCurrentFile as character no-undo.
def output parameter lOK as logical no-undo.
  
  def var iErrStatus as integer no-undo.

  cCurrentFileNameFull = search(pCurrentFile).
  if cCurrentFileNameFull = ? then do:
    if dbug then message "Warning - Current File did not exist" skip.
    lOK = true.
    return.
  end.
  /* check for DELETE permission first ? */
  file-info:file-name = cCurrentFileNameFull.
  if index(file-info:file-type,"W") = 0 then do:
    lOK = false.
    cErrorText = "No WRITE permission for existing file " + cCurrentFileNameFull.
    if dbug then message cErrorText skip.
    return.
  end.

  os-delete value(cCurrentFileNameFull).  
  iErrStatus = OS-ERROR.
  if iErrStatus <> 0 then do: 
    case iErrStatus:  
      when 1 then do: 
        cErrorText = "You are not the owner of this file".  
        lOK = false.
      end.
      when 2 then do:
        cErrorText = "The file you want to delete does not exist".   
        lOK = true.
      end.
      otherwise do:
        cErrorText = "OS Error #" + string(iErrStatus).
        lOK = false.
      end.
    end case.
  end.
  else do:
    lOK = true.
  end.

  /* TODO: delete from Virtual via FTP if necessary */

end procedure. /* ipDeleteCurrentFile */

procedure ipAddFile:
def output parameter lOK as logical no-undo.
  
  def var iErrStatus as integer no-undo.
  def var myMemptr as memptr no-undo.

  cTargetFileNameFull = search(pFileName).
  if cTargetFileNameFull <> ? then do:
    if dbug then message "Warning - File already exists, overwriting:" + cTargetFileNameFull skip.
    lOK = true.
    return.
  end.
  /* TODO: check for WRITE permission first ? Or just run ipDeleteCurrentFile ? */

  /* decode the base64 from the longchar to a memptr */
  myMemptr = base64-decode(pContent).
  
  /* output the binary data as a file */
  copy-lob from myMemptr to file pFileName no-error.
  if error-status:error then do: 
    set-size(myMemptr) = 0.
    cErrorText = "Error creating File:" + pFileName. 
    message cErrorText skip.
    message error-status:get-message(1) skip.
    lOK = false.
    return.
  end.
  else do:
    set-size(myMemptr) = 0.
    lOK = true.
  end.

  /* TODO: copy to Virtual via FTP if necessary */

end procedure. /* ipAddFile */


procedure ipProcessDEL:
def output parameter lOK as logical no-undo.

  run ipDeleteCurrentFile (cCurrentFileName, output lOK).
  if not lOK then do:
    return.
  end.

end procedure. /* ipProcessDEL */

procedure ipProcessMOD:
def output parameter lOK as logical no-undo.

  run ipDeleteCurrentFile (cCurrentFileName, output lOK).
  if not lOK then do:
    return.
  end.
  run ipAddFile (output lOK).
  if not lOK then do:
    return.
  end.

end procedure. /* ipProcessMOD */

procedure ipProcessADD:
  def output parameter lOK as logical no-undo.
  run ipAddFile (output lOK).
  if not lOK then do:
    return.
  end.

end procedure. /* ipProcessADD */


procedure ipAddHistory:

/*------------------------------------------------------------------------------
  Purpose:  adds a record to the objHistory table     
  Parameters:  <none>
  Notes: based loosely on ox_super procedure ipUdateObjHistory
------------------------------------------------------------------------------*/  
def input parameter pText      as char no-undo.
def input parameter pHistoryLevel as char no-undo. 
  
  def var cTime as char no-undo.

  if pHistoryLevel <> "0" then do:    /* Do not write any history if level is 0 (zero) */ 
    cTime = fnGetTime().
    /* Add the History */
    create objHistory.
    assign 
      objHistory.uuserid = pUserID
      objHistory.historyDateTime = cTime
      objHistory.genType = objItem.genType
      objHistory.objType = objItem.objType
      objHistory.objID = string(objItem.objID)
      objHistory.rtgStageName = objItem.rtgStageName
      objHistory.historyText = pText + " (batch)"   
      objHistory.objUnique = objItem.objUnique
      objHistory.recModTime = "" 
      objHistory.historySeq = 4   /* to miss out the updates from Adding the record in the first place */ 
      objHistory.groupID = "" 
      objHistory.roleID = ""   
      objHistory.historyLevel = pHistoryLevel
      .
  end.

end procedure. /* ipAddHistory */
