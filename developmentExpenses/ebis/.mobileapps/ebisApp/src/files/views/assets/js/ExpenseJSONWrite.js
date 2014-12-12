
	$t.ExpenseJSONWrite = $t.createClass(null, {
		
		init : function(requestOptions) {
			this.__requestOptions = $.extend({}, requestOptions);
		},
		
		process : function(settings) {
			if (this.__requestOptions.echo) {
				settings.success(this.__requestOptions.echo);
			} else {
				console.log('Expenses Local Storage to JSON in use (write).');
                // save JSON data to local storage, this would be your original service call
		 	    var expenseForm = localStorage.getItem("expenseRaw");
				if (!expenseForm) 
                {
				  expenseForm = [];
				} else 
                {
				  expenseForm = JSON.parse(expenseForm);
				}
                var item = 
                {
                  "expenseIndex": "Unsent" + localStorage.getItem('lv_mobileDate'),
         		  "expenseDate": localStorage.getItem('lv_mobileDate'),
        		  "expenseType": localStorage.getItem('lv_mobileType'),
                  "expenseGroup": localStorage.getItem('lv_mobileGroup'),
                  "expenseReason": localStorage.getItem('lv_mobileReason'),
                  "expenseAmount": localStorage.getItem('lv_mobileAmount'),
                  "expenseNotes": localStorage.getItem('lv_mobileReason'),
                  "expenseMilesClaim": localStorage.getItem('lv_mobileMilesClaim'),
                  "expenseMilesRate": localStorage.getItem('lv_mobileMilesRate'),
                  "expenseFrom": localStorage.getItem('lv_mobileFrom'),
                  "expenseTo": localStorage.getItem('lv_mobileTo'),
                  "expenseImage": localStorage.getItem('lv_mobileImage'), 
                  "expense_ID": createUUID(),
                  "expenseStatus": 'Unsent', 
                  "expenseCharge": localStorage.getItem('lv_mobileCharge'),
                  "expensePurpose": localStorage.getItem('lv_mobilePurpose'),
                  "expenseOOP": localStorage.getItem('lv_mobileOOP'),
                  "expensePayee": localStorage.getItem('lv_mobilePayee'),
                  "expenseNoPeople": localStorage.getItem('lv_mobileNoPeople'),
                  "expenseNoNights": localStorage.getItem('lv_mobileNoNights'),
                  "expenseEveMeal": localStorage.getItem('lv_mobileEveMeal'),
                  "expenseBreak": localStorage.getItem('lv_mobileBreak'),
                  "expenseLunch": localStorage.getItem('lv_mobileLunch'),
                  "expenseVisit": localStorage.getItem('lv_mobileVisit'),
                  "expenseRound": localStorage.getItem('lv_mobileRound'),
                  "expenseVehicle": localStorage.getItem('lv_mobileVehicle'),
                  "expenseYTDMiles": localStorage.getItem('lv_mobileYTDMiles'),
                  "expensePeople": localStorage.getItem('lv_mobilePeople')
  				};
                // before pushing back is it a modified one? 
                var theid =  localStorage.getItem("lv_tagId") ; 
                if (theid !== "")
                {
                  expenseForm.splice(localStorage.getItem("ModifyRow"),1,
                                     item);
                }
                else
                {
				  expenseForm.push(item);
                  var Counter = isNaN(parseInt(localStorage.getItem('SendCounter'))) ? 0 : parseInt(localStorage.getItem('SendCounter'));
                  Counter++;
                  localStorage.setItem('SendCounter', Counter);
                }
                //alert("sorting");
                sortJSON(expenseForm,'expenseIndex', '321'); // 123 or 321
				//alert("2. After processing (0 to x if 123; x to 0 if 321): "+JSON.stringify(people2));
                myJSON = JSON.stringify({expenseForm: expenseForm});
         
                localStorage.setItem("expenseForm", myJSON);
                localStorage.setItem("expenseRaw", JSON.stringify(expenseForm));
				settings.success({});
			}
			settings.complete('success');
		} 

	});
 