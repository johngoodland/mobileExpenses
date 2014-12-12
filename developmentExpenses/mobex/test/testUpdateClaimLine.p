def var lDebug as logical no-undo init true.
def var pUserID as char no-undo init "MPH".
def var pGUID as char no-undo init "".

def var pLineGUID as char no-undo init "".
def var pDate as date no-undo init TODAY.
def var pGroup as char no-undo init "HOTEL".
def var pType as char NO-UNDO INIT "HOTELTYPE".       /* leave blank in POC */
def var pReason as char no-undo init "This is a a reason".
def var pCompany as int no-undo.     /* leave as 0 in POC */
def var pDepartment as char no-undo. /* leave blank in POC */
def var pAmount as dec no-undo init 123.45.
def var pRecharge as log no-undo init true.
def var pStoredJourney as char no-undo init "WR11 4TL|NN4 7YE|134.32".
def var pAdd_chkOutOfPolicy as log no-undo init true.
def var pAdd_oopExplanation as char no-undo init "because it is".
def var pAdd_type as char no-undo init "type".
def var pAdd_visiting as char no-undo init "vis".
def var pAdd_purpose as char no-undo init "purp".
def var pAdd_fromLoc as char no-undo init "WR11 4TL".
def var pAdd_toLoc as char no-undo init "NN4 7YE".
def var pAdd_chkRoundtrip as log no-undo init true.
def var pAdd_calcMiles as dec no-undo init 134.32.
def var pAdd_claimMiles as dec no-undo init 135.
def var pAdd_vehicle as char no-undo init "veh".
def var pAdd_ytdMiles as dec no-undo init 2345.
def var pAdd_people as char no-undo init "pugh,pugh".
def var pAdd_payee as char no-undo init "Mick Hand".
def var pAdd_numPeople as int no-undo init 2.
def var pAdd_numNights as int no-undo init 3.
def var pAdd_chkIncEveMeal as log no-undo.
def var pAdd_chkIncLunch as log no-undo.
def var pAdd_chkIncBreakfast as log no-undo init true.
def var pAdd_chkFlag as char no-undo init "flag".
def var pAdd_value as dec no-undo init 345.67.
def var pAdd_resource as char no-undo init "res".

def var lErrorFlag as logical no-undo.
def var cErrorText as char no-undo.
def var oLineGUID as char no-undo.

find first rscExtra no-lock
  where rscExtra.uuserid = pUserID
    and rscExtra.extraType = "MobEx GUID" no-error.

if avail rscExtra then do:
  pGuid = rscExtra.data1.
end.

run mobex/updateClaimLine.p (lDebug, pUserID,
                          pLineGUID,
                          pDate,
                          pGroup,
                          pType,
                          pReason,
                          pCompany,
                          pDepartment,
                          pAmount,
                          pRecharge,
                          pStoredJourney,
                          pAdd_chkOutOfPolicy,
                          pAdd_oopExplanation,
                          pAdd_type,
                          pAdd_visiting,
                          pAdd_purpose,
                          pAdd_fromLoc,
                          pAdd_toLoc,
                          pAdd_chkRoundtrip,
                          pAdd_calcMiles,
                          pAdd_claimMiles,
                          pAdd_vehicle,
                          pAdd_ytdMiles,
                          pAdd_people,
                          pAdd_payee,
                          pAdd_numPeople,
                          pAdd_numNights,
                          pAdd_chkIncEveMeal,
                          pAdd_chkIncLunch,
                          pAdd_chkIncBreakfast,
                          pAdd_chkFlag,
                          pAdd_value,
                          pAdd_resource,
                          output lErrorFlag, output cErrorText, output oLineGUID).

message "Failed? " lErrorFlag skip cErrorText skip "objUnique=" oLineGUID
  view-as alert-box info buttons ok.
