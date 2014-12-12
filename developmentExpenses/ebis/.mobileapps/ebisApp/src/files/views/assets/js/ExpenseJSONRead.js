
	$t.ExpenseJSONRead = $t.createClass(null, {
		
		init : function(requestOptions) {
			this.__requestOptions = $.extend({}, requestOptions);
		},
	
		process : function(settings) {
     
			if (this.__requestOptions.echo) {
				settings.success(this.__requestOptions.echo);
			} else {
				console.log('Expenses Local Storage to JSON in use (read).');
                // load JSON data from local storage
                if (localStorage.getItem("expenseFilter") != "All")
                {
				var expenseForm = [];  
				var parsedFields = JSON.parse(localStorage.getItem("expenseForm"));
				var JSONFields = JSON.stringify(parsedFields.expenseForm);
 				var parsed = JSON.parse(JSONFields);
				for (var i = 0; i < parsed.length; ++i)

 				  if (localStorage.getItem("expenseFilter")  == parsed[i].expenseStatus)
   				  {
      			  var item = 
       			    { "expenseIndex": parsed[i].expenseIndex,
                      "expenseDate": parsed[i].expenseDate,
           		 	  "expenseType": parsed[i].expenseType,
          		      "expenseGroup": parsed[i].expenseGroup,
            		  "expenseReason": parsed[i].expenseReason,
            		  "expenseAmount": parsed[i].expenseAmount,
                      "expenseNotes": parsed[i].expenseNotes,
				   	  "expenseMilesClaim": parsed[i].expenseMilesClaim,
					  "expenseMilesRate": parsed[i].expenseMilesRate,
					  "expenseFrom": parsed[i].expenseFrom,
					  "expenseTo": parsed[i].expenseTo,
					  "expenseImage": parsed[i].expenseImage,
					  "expense_ID": parsed[i].expense_ID,
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
     		      expenseForm.push(item);  
  			   	  console.log('Found grid data pushing to JSONTypes storage.');
  	              };  
			     var cdata = JSON.stringify({expenseForm: expenseForm});
            	}
            	else 
                {
                  var cdata = localStorage.getItem("expenseForm");  
                }
				// pass the JSON to the service, for output mapping
				settings.success(cdata);
			}
			settings.complete('success');
		} 

	});
