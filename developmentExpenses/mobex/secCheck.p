/*******************************************************************
  Program     : mobex/secCheck.p
  Description : RESTful Web Service for doing a security check from RESTful appserver
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
   To check the input comes from a registered Mobile App
    
Parameters...
  pSecKey
	lDebug 	logical
  pGUID
  pUserID
  output lErrorFlag    logical
  output cErrorText

######Notes#                                                                    
  Security checks for MobEx Key and User/GUID.

**********************************************************************/

def input param pSecKey as char no-undo.
def input param lDebug as log no-undo.
def input param pGUID as char no-undo.
def input param pUserID as character no-undo.
def output param lErrorFlag as log no-undo init NO.
def output param cErrorText as char no-undo init "".

def var dbug as logical no-undo.
{util/dbugChk.i &nomessage=nomessage}
{mobex/userDbugChk.i}

if lDebug = true then dbug = true.

if dbug then output to logs/debug_mobex_secCheck.log.

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

/* check the UserID and GUID */
if pUserID = "" then do:
  lErrorFlag = true.
  cErrorText = "Blank User ID".
  if dbug then message cErrorText skip.
  return.
end.
if pGUID = "" then do:
  lErrorFlag = true.
  cErrorText = "Blank User GUID".
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
find first rscExtra no-lock
  where rscExtra.uuserid = pUserID 
    and rscExtra.extraType = "MobEx GUID" no-error.
if not avail rscExtra then do:
  lErrorFlag = true.
  cErrorText = "Missing User GUID".
  if dbug then message cErrorText skip.
  return.
end.
if rscExtra.data1 = "" then do:
  lErrorFlag = true.
  cErrorText = "Blank User GUID".
  if dbug then message cErrorText skip.
  return.
end.
if rscExtra.data1 <> pGUID then do:
  lErrorFlag = true.
  cErrorText = "Invalid User GUID".
  if dbug then message cErrorText skip.
  return.
end.
if dbug then message "User GUID is OK" skip.

finally:
  if dbug then message "reached the finally" skip.
  if dbug then output close.
end.





