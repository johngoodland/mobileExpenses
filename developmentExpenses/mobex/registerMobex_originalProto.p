/*******************************************************************
  Program     : mobex/registerMobEx.p
  Description : RESTful Web Service for registering the MobEx App for a specific User
              : written for use with Mobile Expenses App
              : 
  By          : Mick Hand
  Date        : 03/04/2013

********************************************************************
                         Modification History  
********************************************************************


********************************************************************

#Notes######

Purpose...
   To set a user Extra Setting for the User and return a GUID
    
Parameters...
  pSecKey
	lDebug 	logical
  pUserID
  pEncodedPass
	output lErrorFlag    logical
  output cErrorText
  output pGUID

######Notes#                                                                    
  Security checks for MobEx Key and User/Encoded Password and number of retries allowed.

**********************************************************************/

def input param pSecKey as char no-undo.
def input param lDebug as log no-undo.
def input param pUserID as character no-undo.
def input param pEncodedPass as character no-undo.
def output param lErrorFlag as log no-undo init NO.
def output param cErrorText as char no-undo init "".
def output param pGUID as char no-undo.

def var cPassword as char no-undo.
def var iFails as integer no-undo.
def var iMaxFails as integer no-undo init 3.

def var dbug as logical no-undo.
{util/dbugChk.i &nomessage=nomessage}
if lDebug = true then dbug = true.

if dbug then output to logs/debug_mobex_registerMobex.log.

/* check the pSecKey */
find first ssnVar no-lock
  where ssnvar.ssnUnique = "GLOBAL"
    and ssnVar.ssnVarName = "MobEx Key" no-error.
if not avail ssnVar then do:
  lErrorFlag = true.
  cErrorText = "Missing Global Setting MobEx Key".
  if dbug then message cErrorText skip.
  return.
end.
if ssnVar.ssnVarValue = "" then do:
  lErrorFlag = true.
  cErrorText = "Blank Global Setting MobEx Key".
  if dbug then message cErrorText skip.
  return.
end.
if ssnVar.ssnVarValue <> pSecKey then do:
  lErrorFlag = true.
  cErrorText = "Invalid MobEx Key".
  if dbug then message cErrorText skip.
  return.
end.

if dbug then message "MobEx Key is OK" skip.

/* check the UserID and Encoded Password */
if pUserID = "" then do:
  lErrorFlag = true.
  cErrorText = "Blank User ID".
  if dbug then message cErrorText skip.
  return.
end.
if pEncodedPass = "" then do:
  lErrorFlag = true.
  cErrorText = "Blank Password".
  if dbug then message cErrorText skip.
  return.
end.
find first rscMaster no-lock
  where rscMaster.uuserid = pUserID no-error.
if not avail rscMaster then do:
  lErrorFlag = true.
  cErrorText = "Invalid User".
  if dbug then message cErrorText skip.
  return.
end.

/* check for failed logins */
find first rscExtra no-lock
  where rscExtra.uuserid = pUserID 
    and rscExtra.extraType = "MobEx Login Fails" no-error.
if avail rscExtra then do:
  iFails = int(rscExtra.data1) no-error.
end.

if iFails > 1 then do:
  find first ssnVar no-lock
    where ssnVar.ssnUnique = "GLOBAL"
      and ssnVar.ssnVarName = "MobEx Logion Fails" no-error.
  if avail ssnVar then do:
    iMaxFails = int(ssnVar.ssnVarValue) no-error.
    if iMaxFails = 0 then iMaxFails = 3.
  end.
  if iFails >= iMaxFails then do:
    lErrorFlag = true.
    cErrorText = "Too many failed attempts - please contact System Administrator".
    if dbug then message cErrorText skip.
    return.
  end.
end.


/* TODO: needs de-coding algorithm - for now just using plain text pass */
cPassword = pEncodedPass.

if rscMaster.passwd <> encode(cPassword) then do:
  lErrorFlag = true.
  cErrorText = "Invalid Password".
  if dbug then message cErrorText skip.
  /* update number of fails */
  find first rscExtra EXCLUSIVE-LOCK
    where rscExtra.uuserid = pUserID 
      and rscExtra.extraType = "MobEx Login Fails" no-error.
  if not avail rscExtra then do:
    create rscExtra.
    assign
      rscExtra.uuserid = pUserID
      rscExtra.extraType = "MobEx Login Fails"
    .

  end.
  if avail rscExtra then do:
    iFails = int(rscExtra.data1) no-error.
    iFails = iFails + 1.
    rscExtra.data1 = string(iFails) no-error.
  end.
  
  return.
end.

find first rscExtra EXCLUSIVE-LOCK
  where rscExtra.uuserid = pUserID 
    and rscExtra.extraType = "MobEx GUID" no-wait no-error.
if locked rscExtra then do:
  lErrorFlag = true.
  cErrorText = "GUID record locked for User" + pUserID.
  if dbug then message cErrorText skip.
  return.
end.
if avail rscExtra then do:
  pGuid = rscExtra.data1.
  if dbug then message "Found existing GUID for User:" pUserID " GUID:" pGuid skip.
end.
else do:
  pGUID = GUID.
  create rscExtra.
  assign
    rscExtra.uuserid = pUserID
    rscExtra.extraType = "MobEx GUID"
    rscExtra.data1 = pGUID.
  if dbug then message "Created new GUID for User:" pUserID " GUID:" pGuid skip.
end.

/* successful registration - re-set the number of Fails to zero */
find first rscExtra EXCLUSIVE-LOCK
  where rscExtra.uuserid = pUserID 
    and rscExtra.extraType = "MobEx Login Fails" no-wait no-error.
if avail rscExtra then do:
  rscExtra.data1 = "0" no-error.
end.

finally:
  if dbug then message "reached the finally" skip.
  if dbug then output close.
end.
