
	$t.FavJSONWrite = $t.createClass(null, {
		
		init : function(requestOptions) {
			this.__requestOptions = $.extend({}, requestOptions);
		},
		
		process : function(settings) {
			if (this.__requestOptions.echo) {
				settings.success(this.__requestOptions.echo);
			} else {
				console.log('Updating Fav list (Write)');
                // save JSON data to local storage, this would be your original service call
		 	    var favForm = localStorage.getItem("favRaw");
				if (!favForm) 
                {
				  favForm = [];
				} else 
                {
				  favForm = JSON.parse(favForm);
				}
                var item = 
                {
                  "FavIndex": localStorage.getItem('lv_mobileGroup') + localStorage.getItem('lv_mobileType'),
        		  "FavType": localStorage.getItem('lv_mobileType'),
                  "FavGroup": localStorage.getItem('lv_mobileGroup'),
                  "FavReason": localStorage.getItem('lv_mobileReason'),
                  "FavAmount": localStorage.getItem('lv_mobileAmount'),
                  "FavMilesClaim": localStorage.getItem('lv_mobileMilesClaim'),
                  "FavMilesRate": localStorage.getItem('lv_mobileMilesRate'),
                  "FavFrom": localStorage.getItem('lv_mobileFrom'),
                  "FavTo": localStorage.getItem('lv_mobileTo'),
                  "Fav_ID": createUUID(),
                  "FavNotes": localStorage.getItem('lv_mobileReason'),       
                  "FavPurpose": localStorage.getItem('lv_mobilePurpose'),
                  "FavNoNights": localStorage.getItem('lv_mobileNoNights'),
                  "FavVisit": localStorage.getItem('lv_mobileVisit'),
                  "FavVehicle": localStorage.getItem('lv_mobileVehicle')

  				};
                // before pushing back is it a modified one? 
                 var theid =  localStorage.getItem("lv_favtagId") ; 
                 if (theid !== "")
                 {
                   favForm.splice(localStorage.getItem("ModifyRow"),1,
                                     item);
                 }
                 else
                 {
				  favForm.push(item);
                //  var Counter = isNaN(parseInt(localStorage.getItem('SendCounter'))) ? 0 : parseInt(localStorage.getItem('SendCounter'));
                 // Counter++;
                  // localStorage.setItem('SendCounter', Counter);
                 }
                sortJSON(favForm,'FavIndex', '123'); // 123 or 321
                myJSON = JSON.stringify({favForm: favForm});
         
                localStorage.setItem("favForm", myJSON);
                localStorage.setItem("favRaw", JSON.stringify(favForm));
				settings.success({});
			}
			settings.complete('success');
		} 

	});