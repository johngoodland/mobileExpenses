/*******************************************************************
  Program     : mobex/trackClaimLine.p
  Description : RESTful Web Service for checking which Claim a Line is attached to and where that claim is in the workflow
              : written for use with Mobile Expenses App
              : 
  By          : Mick Hand
  Date        : 19/06/2013

********************************************************************
                         Modification History  
********************************************************************


********************************************************************

#Notes######

Purpose...
   To return a message about where that individual Line is.
    
Parameters...
  lDebug 	logical
  pUnique
  oStatus 
	output lErrorFlag    logical
  output cErrorText

######Notes#                                                                    
  Security checks for MobEx Key and User/GUID should have been run via mobex/secCheck.p.

**********************************************************************/

def input param lDebug as log no-undo.
def input param pUserID as character no-undo.
def input param pLineUnique as character no-undo.
def output param oStatus as char no-undo init "".
def output param lErrorFlag as log no-undo init NO.
def output param cErrorText as char no-undo init "".

def buffer bClaim for objItem.

def var cClaimUnique as char no-undo.
def var cOwner as char no-undo.

def var dbug as logical no-undo.
{util/dbugChk.i &nomessage=nomessage}
{mobex/userDbugChk.i}

if lDebug = true then dbug = true.

if dbug then output to logs/debug_mobex_trackClaimLine.log.

if dbug then message "Checking Item:" pLineUnique skip.

find first objItem no-lock
  where objItem.objUnique = pLineUnique no-error.
if not avail objItem then do:
  oStatus = "This Line cannot be located on the Server".
  return.
end.
if objItem.key6 = "" then do:
  oStatus = "This line is not included on a Claim".
  return.
end.

cClaimUnique = objItem.fld22.
if cClaimUnique = "" then do:
  oStatus = "Error: Line not correctly linked to claim".
  return.
end.
find first bClaim no-lock
  where bClaim.objUnique = cClaimUnique no-error.
if not avail bClaim then do:
  oStatus = "Error: Line linked to missing claim".
  return.
end.

find first objType no-lock
  where objType.objType = bClaim.objType no-error.
if not avail objType then do:
  oStatus = "Error: Claim is an invalid type".
  return.
end.

if bClaim.uuserID > "" then cOwner = bClaim.uuserID.
else if bClaim.groupID > "" then cOwner = bClaim.groupID + "/" + bClaim.roleID.
else cOwner = "ALL".

oStatus = objType.description + "/" + string(objItem.objID) + " is in the Stage:" + bClaim.rtgStageName
        + " and is currently owned by " + cOwner.

finally:
  if dbug then message "reached the finally" skip 
    "Status:" oStatus skip.
  if dbug then output close.
end.




