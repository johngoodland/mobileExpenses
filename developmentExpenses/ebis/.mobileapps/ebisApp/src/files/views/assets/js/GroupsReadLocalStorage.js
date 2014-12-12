
	$t.GroupsReadLocalStorage = $t.createClass(null, {
		
		init : function(requestOptions) {
			this.__requestOptions = $.extend({}, requestOptions);
		},
		
		process : function(settings) {
			if (this.__requestOptions.echo) {
				settings.success(this.__requestOptions.echo);
			} else {
				console.log('Access Groups Storage to JSON in use (read).');
                // load JSON data from local storage
				var cdata = localStorage.getItem("ResultGroups");
               
				// pass the JSON to the service, for output mapping
             
				settings.success(cdata);
			}
			settings.complete('success');
		} 

	});
