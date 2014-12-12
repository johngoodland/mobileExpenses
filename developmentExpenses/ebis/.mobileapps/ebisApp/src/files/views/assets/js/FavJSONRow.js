
	$t.FavJSONRow = $t.createClass(null, {
		
		init : function(requestOptions) {
			this.__requestOptions = $.extend({}, requestOptions);
		},
		
		process : function(settings) {
			if (this.__requestOptions.echo) {
				settings.success(this.__requestOptions.echo);
			} else {
				console.log('Reading fav form data extracting line to modify.');
                var theid =  localStorage.getItem("lv_favtagId") ;  
                var FavModify = [];  
                if (theid !== "")
                {
                 var favForm = localStorage.getItem("favRaw"); //convert back to a Javascript object
		   		 var parsed = JSON.parse(favForm);
       
    			 for (var i = 0; i < parsed.length; ++i)
      
           		  if (theid == parsed[i].Fav_ID)
             	  {
                    var item = 
                    {
                      "FavIndex": parsed[i].FavIndex,
        		      "FavType": parsed[i].FavType,
                      "FavGroup": parsed[i].FavGroup,
                      "FavReason": parsed[i].FavReason,
                      "FavAmount": parsed[i].FavAmount,
                      "FavMilesClaim": parsed[i].FavMilesClaim,
                      "FavMilesRate": parsed[i].FavMilesRate,
                      "FavFrom": parsed[i].FavFrom,
                      "FavTo": parsed[i].FavTo,
                      "Fav_ID": parsed[i].Fav_ID,
                      "FavNotes": parsed[i].FavNotes,       
                      "FavPurpose": parsed[i].FavPurpose,
                      "FavNoNights": parsed[i].FavNoNights,
                      "FavVisit": parsed[i].FavVisit,
                      "FavVehicle": parsed[i].FavVehicle
                        
  				    };
                    FavModify.push(item);
                   	console.log('Found data pushing to favModify storage.');
            	   }
                  } 
                  
                  settings.success(JSON.stringify({favForm: FavModify})); 
                  status = 'success';
 
			}
			settings.complete('success');
		} 

	});
