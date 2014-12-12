DEFINE TEMP-TABLE eGroup NO-UNDO 
    FIELD cGroup AS CHARACTER 
    FIELD cDescription AS CHARACTER 
    FIELD cType AS CHARACTER /* currently MILEAGE or blank */
    FIELD cPolicyLink AS CHARACTER 
    FIELD cRecModLast AS CHARACTER 
    INDEX Primary IS PRIMARY cGroup.

DEFINE DATASET dseGroup  SERIALIZE-NAME "eGroup"  FOR eGroup .

{appServer/ebisexpensegroups.i}. 
