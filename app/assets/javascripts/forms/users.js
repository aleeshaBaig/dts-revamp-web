$(".user_district").on('change', function(){
  var district_id = $(this).val();
  if(district_id != ''){
		$.ajax({
		  url: '/hospitals',
		  type: 'GET',
		  dataType: 'json',
		  data: {district_id:  district_id},
		  beforeSend: function (xhr) {
		      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
		  },
		  success: function(data_transport){
				$("select.user_hospital_list").removeAttr('disabled');
				$("select.user_hospital_list option").remove();

				// Fill sub category select 
				if (data_transport.length > 0){
				  var row = "<option value=\"" + "" + "\">" + "-Select-" + "</option>";
				  $(row).appendTo("select.user_hospital_list");
				  $.each(data_transport, function(i){
				    row = "<option value=\"" + data_transport[i].id + "\">" + data_transport[i].hospital_name + "</option>";
				    $(row).appendTo("select.user_hospital_list");
				  });
				}else{
				  var row = "<option value=\"" + "" + "\">" + "" + "</option>";
				  $(row).appendTo("select.user_hospital_list");
				}		  	
		  },
		  error: function(xhr, status, response) {/* your error callback */}
		});
  }
})

$(".user_lab").on('change', function(){
  var district_id = $(this).val();
  if(district_id != ''){
		$.ajax({
		  url: '/labs',
		  type: 'GET',
		  dataType: 'json',
		  data: {district_id:  district_id},
		  beforeSend: function (xhr) {
		      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
		  },
		  success: function(data_transport){
				$("select.user_lab_list").removeAttr('disabled');
				$("select.user_lab_list option").remove();

				// Fill sub category select 
				if (data_transport.length > 0){
				  var row = "<option value=\"" + "" + "\">" + "-Select-" + "</option>";
				  $(row).appendTo("select.user_lab_list");
				  $.each(data_transport, function(i){
				    row = "<option value=\"" + data_transport[i].id + "\">" + data_transport[i].lab_name + "</option>";
				    $(row).appendTo("select.user_lab_list");
				  });
				}else{
				  var row = "<option value=\"" + "" + "\">" + "" + "</option>";
				  $(row).appendTo("select.user_lab_list");
				}		  	
		  },
		  error: function(xhr, status, response) {/* your error callback */}
		});
  }
})

$(".user_district").on('change', function(){
  var district_id = $(this).val();
  if(district_id != ''){
		$.ajax({
		  url: '/labs',
		  type: 'GET',
		  dataType: 'json',
		  data: {district_id:  district_id},
		  beforeSend: function (xhr) {
		      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
		  },
		  success: function(data_transport){
				$("select.user_lab_list").removeAttr('disabled');
				$("select.user_lab_list option").remove();

				// Fill sub category select 
				if (data_transport.length > 0){
				  var row = "<option value=\"" + "" + "\">" + "-Select-" + "</option>";
				  $(row).appendTo("select.user_lab_list");
				  $.each(data_transport, function(i){
				    row = "<option value=\"" + data_transport[i].id + "\">" + data_transport[i].lab_name + "</option>";
				    $(row).appendTo("select.user_lab_list");
				  });
				}else{
				  var row = "<option value=\"" + "" + "\">" + "" + "</option>";
				  $(row).appendTo("select.user_lab_list");
				}		  	
		  },
		  error: function(xhr, status, response) {/* your error callback */}
		});
  }
})

$(".tehsil_user_district").on('change', function(){
	var district_id = $(this).val();
	if(district_id != ''){
		  $.ajax({
			url: '/tehsils',
			type: 'GET',
			dataType: 'json',
			data: {district_id:  district_id},
			beforeSend: function (xhr) {
				xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
			},
			success: function(data_transport){
				  $("select.user_tehsil_list").removeAttr('disabled');
				  $("select.user_tehsil_list option").remove();
  
				  // Fill sub category select 
				  if (data_transport.length > 0){
					var row = "<option value=\"" + "" + "\">" + "-Select-" + "</option>";
					$(row).appendTo("select.user_tehsil_list");
					$.each(data_transport, function(i){
					  row = "<option value=\"" + data_transport[i].id + "\">" + data_transport[i].tehsil_name + "</option>";
					  $(row).appendTo("select.user_tehsil_list");
					});
				  }else{
					var row = "<option value=\"" + "" + "\">" + "" + "</option>";
					$(row).appendTo("select.user_tehsil_list");
				  }		  	
			},
			error: function(xhr, status, response) {/* your error callback */}
		  });
	}
  })