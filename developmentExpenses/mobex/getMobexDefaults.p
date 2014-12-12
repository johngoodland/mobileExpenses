/*******************************************************************
  Program     : mobex/getMobExDefaults.p
  Description : RESTful Web Service for checking the Mobex Key is OK then returning a set of Default Settings
              : written for use with Mobile Expenses App
              : 
  By          : Mick Hand
  Date        : 20/06/2013

********************************************************************
                         Modification History  
********************************************************************


********************************************************************

#Notes######

Purpose...
   To check that the Security Key is OK and return a set of Default Settings for the site
    
Parameters...
  pSecKey
	lDebug 	logical
  temp-table of Default Settings (using a temp-table so we can extend easily)
	output lErrorFlag    logical
  output cErrorText

######Notes#                                                                    
  Security checks for MobEx Key.
  Returns values from a set of valItem records of type "MobexSetting" plus a setting to indicate the Mileage Calc is licensed

**********************************************************************/

def input param pSecKey as char no-undo.
def input param lDebug as log no-undo.
def temp-table ttSettings no-undo
  field ttsName as char
  field ttsValue as char
  field ttsSpare1 as char
  field ttsSpare2 as char
  field ttsSpare3 as char
.
def output param table for ttSettings.
def output param lErrorFlag as log no-undo init NO.
def output param cErrorText as char no-undo init "".

def buffer bSetting for valItem.

def var dbug as logical no-undo.
{util/dbugChk.i &nomessage=nomessage}

def var pUserID as char no-undo init "SYSTEM".
{mobex/userDbugChk.i}

if lDebug = true then dbug = true.

if dbug then output to logs/debug_mobex_getMobexDefaults.log.

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

for each bSetting no-lock
  where bSetting.valType = "MobexSetting":

  create ttSettings.
  assign
    ttsName = bSetting.valCode
    ttsValue = bSetting.valData
    .

end.

/* TODO: Add a license check for the Mileage Calculation and output a ttSettings record for it
         check that they have not added one manually via the Repository
         For our initial testing, we will just add it manually as a repository setting "CALCULATE MILES" = "YES" */


finally:
  if dbug then message "reached the finally" skip.
  if dbug then output close.
end.
