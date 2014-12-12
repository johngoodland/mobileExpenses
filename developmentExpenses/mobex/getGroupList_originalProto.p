/*******************************************************************
  Program     : mobex/getGroupList.p
  Description : RESTful Web Service for getting the list of Expense Type GROUPS
              : written for use with Mobile Expenses App
              : 
  By          : Mick Hand
  Date        : 02/04/2013

********************************************************************
                         Modification History  
********************************************************************


********************************************************************

#Notes######

Purpose...
   To return a temp-table of valid Expense Type Groups
   nb. there are too many Expense Types and we want to use
   simpler Groups such as Hotel, Taxi, Meal etc
    
Parameters...
  lDebug 	logical
  pUserID
  output temp table of Expense Type Groups
	output lErrorFlag    logical
  output cErrorText

######Notes#                                                                    
  Security checks for MobEx Key and User/GUID should have been run via mobex/secCheck.p.
  Expense Types are set up as valItem records in eBIS
  Expense Type Groups are another form of valItem

**********************************************************************/

def input param lDebug as log no-undo.
def input param pUserID as character no-undo.
def temp-table ttGroups no-undo
  field ttGroup as char
  field ttDescription as char
.
def output param table for ttGroups.
def output param lErrorFlag as log no-undo init NO.
def output param cErrorText as char no-undo init "".

def buffer bExpGroup for valItem.
def var iGroups as integer no-undo.

def var dbug as logical no-undo.
{util/dbugChk.i &nomessage=nomessage}
if lDebug = true then dbug = true.

if dbug then output to logs/debug_mobex_getGroupList.log.

/* Fetch the list of Expense Type Groups and Expense Types */
for each bExpGroup no-lock
  where bExpGroup.valType = "ExpTypeGroup":
  create ttGroups.
  assign
    ttGroups.ttGroup = bExpGroup.valCode
    ttGroups.ttDescription = bExpGroup.description
    .
  iGroups = iGroups + 1.
end.

if dbug then message "Groups Returned = " iGroups skip.

finally:
  if dbug then message "reached the finally" skip.
  if dbug then output close.
end.




