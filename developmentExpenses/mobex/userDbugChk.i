/* check for a debug flag on a User Extra Setting Record */
if pUserID > "" then do:
  find first rscExtra no-lock
    where rscExtra.extraType = "Mobex Debug"
      and rscExtra.uuserid = pUserID no-error.
  if avail rscExtra then do:
    if rscExtra.data1 > "" then do:
      if cCheckForDbugFile matches "*" + rscExtra.data1 + "*" then do:
        dbug = true.
        cDbugParam = valItem.valData.
      end.
    end.
  end.
end.
