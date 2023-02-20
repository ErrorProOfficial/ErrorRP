$(function() {	
	window.addEventListener('message', function(event) {
		var v = event.data;
		if (v.action == 'show'){		
			document.getElementById('veh-mdl').innerHTML = v.label; 
			document.getElementById('plate').innerHTML = v.plate; 
			document.getElementById('engine-lvl').innerHTML = v.engineKit;  
			document.getElementById('brakes-lvl').innerHTML = v.brakeKit; 
			document.getElementById('transmission-lvl').innerHTML = v.transmissionKit;
			document.getElementById('suspension-lvl').innerHTML = v.suspensionKit;  
			document.getElementById('true').innerHTML = v.turbo;  
			if (v.turbo == 'ACTIVE'){
				document.getElementById('true').style.color = "#0dff00";
			}else if (v.turbo == 'INACTIVE'){
				document.getElementById('true').style.color = '#ff0000';
			} 
			$('#thebg').fadeIn();
		}
		
	});
	
	document.onkeyup = function(event) {
		if (event.key == 'Escape') {	
			$('#thebg').fadeOut();
			$.post('http://msl_vehinfo/exit');
		}
	};


});


function exit(){
	$('#thebg').fadeOut();
	$.post('http://msl_vehinfo/exit');
}






