
	$t.ExpenseJSONRow = $t.createClass(null, {
		
		init : function(requestOptions) {
			this.__requestOptions = $.extend({}, requestOptions);
		},
		
		process : function(settings) {
			if (this.__requestOptions.echo) {
				settings.success(this.__requestOptions.echo);
			} else {
				console.log('Reading expense form data extracting line to modify.');
                var theid =  localStorage.getItem("lv_tagId") ;  
                var expenseModify = [];  
                if (theid !== "")
                {
                 var expenseForm = localStorage.getItem("expenseRaw"); //convert back to a Javascript object
		   		 var parsed = JSON.parse(expenseForm);
       
    			 for (var i = 0; i < parsed.length; ++i)
      
           		  if (theid == parsed[i].expense_ID)
             	  {
                    var item = 
                    {
                     "expenseIndex": parsed[i].expenseIndex,
                     "expenseGroup": parsed[i].expenseGroup,
         		 	 "expenseDate": parsed[i].expenseDate,
        		 	 "expenseType": parsed[i].expenseType,
                 	 "expenseReason": parsed[i].expenseReason,
                 	 "expenseAmount": parsed[i].expenseAmount,
                 	 "expenseNotes": parsed[i].expenseNotes,
                  	 "expenseMilesClaim": parsed[i].expenseMilesClaim,
                	 "expenseMilesRate": parsed[i].expenseMilesRate,
                 	 "expenseFrom": parsed[i].expenseFrom,
                  	 "expenseTo": parsed[i].expenseTo,
                     "expenseImage": parsed[i].expenseImage,
                     "expense_ID": theid,
                     "expenseStatus": parsed[i].expenseStatus,
                     "expenseCharge": parsed[i].expenseCharge,
                     "expensePurpose": parsed[i].expensePurpose,
                     "expenseOOP": parsed[i].expenseOOP,
                     "expensePayee": parsed[i].expensePayee,
                     "expenseNoPeople": parsed[i].expenseNoPeople,
                     "expenseNoNights": parsed[i].expenseNoNights,
                     "expenseEveMeal": parsed[i].expenseEveMeal,
                     "expenseBreak": parsed[i].expenseBreak,
                     "expenseLunch": parsed[i].expenseLunch,
                     "expenseVisit": parsed[i].expenseVisit,
                     "expenseRound": parsed[i].expenseRound,
                     "expenseVehicle": parsed[i].expenseVehicle,
                     "expenseYTDMiles": parsed[i].expenseYTDMiles,
                     "expensePeople": parsed[i].expensePeople
                        
  				    };
                    localStorage.setItem("ModifyRow", i);  
                    expenseModify.push(item);
                   	console.log('Found data pushing to expenseModify storage.');
                    changeButtonType("Cancel");
            	   }
                  } 
                  else 
                  {
                    changeButtonType("Reject");
                      
                  }
                  settings.success(JSON.stringify({expenseForm: expenseModify})); 
                  status = 'success';
 
			}
			settings.complete('success');
		} 

	});
