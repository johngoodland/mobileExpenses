/*******************************************************************
  Program     : mobex/checkClaimLines.p
  Description : RESTful Web Service for checking whether the status of Claim Lines has changed
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
   To return a temp-table of the lines that have changed status 
   ie. have they been put onto a Claim or not
    
Parameters...
  lDebug 	logical
  pFree
  pUsed
  oFree (output list of the ones no longer on claims)
  oUsed (output list of the ones now on claims )
  oMissing (output list of ones that don't exist on the Server)
	output lErrorFlag    logical
  output cErrorText

######Notes#                                                                    
  Security checks for MobEx Key and User/GUID should have been run via mobex/secCheck.p.

**********************************************************************/

def input param lDebug as log no-undo.
def input param pUserID as character no-undo.
def input  parameter pFree as character no-undo.
def input  parameter pUsed as character no-undo.
def output param oFree as char no-undo init "".
def output param oUsed as char no-undo init "".
def output param oMissing as char no-undo init "".
def output param lErrorFlag as log no-undo init NO.
def output param cErrorText as char no-undo init "".

def var i as integer no-undo.
def var iFree as integer no-undo.
def var iUsed as integer no-undo.
def var iMissing as integer no-undo.
def var cLineUnique as char no-undo.

def var dbug as logical no-undo.
{util/dbugChk.i &nomessage=nomessage}
{mobex/userDbugChk.i}

if lDebug = true then dbug = true.

if dbug then output to logs/debug_mobex_checkClaimLines.log.

if dbug then message "Checking Free Items:" pFree skip.

LOOP_FREE:
do i = 1 to num-entries(pFree):

  cLineUnique = entry(i,pFree) no-error.
  if cLineUnique = "" then next LOOP_FREE.
  find first objItem no-lock
    where objItem.objUnique = cLineUnique no-error.
  if not avail objItem then do:
    oMissing = (if oMissing > "" then oMissing + "," else "") + cLineUnique.
    iMissing = iMissing + 1.
    next LOOP_FREE.
  end.
  if objItem.key6 > "" then do:
    oUsed = (if oUsed > "" then oUsed + "," else "") + cLineUnique.
    iUsed = iUsed + 1.
    next LOOP_FREE.
  end.

end. /* LOOP_FREE */

if dbug then message "Checking Used Items:" pFree skip.

LOOP_USED:
do i = 1 to num-entries(pUsed):

  cLineUnique = entry(i,pUsed) no-error.
  if cLineUnique = "" then next LOOP_USED.
  find first objItem no-lock
    where objItem.objUnique = cLineUnique no-error.
  if not avail objItem then do:
    oMissing = (if oMissing > "" then oMissing + "," else "") + cLineUnique.
    iMissing = iMissing + 1.
    next LOOP_USED.
  end.
  if objItem.key6 = "" then do:
    oFree = (if oFree > "" then oFree + "," else "") + cLineUnique.
    iFree = iFree + 1.
    next LOOP_USED.
  end.

end. /* LOOP_USED */

finally:
  if dbug then message "reached the finally" skip 
    "Free:" iFree " oFree:" oFree skip
    "Used:" iUsed " oUsed:" oUsed skip
    "Miss:" iMissing " oMissing:" oMissing skip.
  if dbug then output close.
end.




