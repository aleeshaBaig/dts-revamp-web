$("#patient_district_id").change(function() {
  console.log("ok")
  $.ajax({
    url:'/ajax/populate_tehsil?district='+this.value,
    dataType: 'json',
    success: function(transport) {
      // console.log(transport);
      // Clear all options from sub category select 
      $("select#patient_tehsil_id").removeAttr('disabled');
      $("select#patient_tehsil_id option").remove();

      // Fill sub category select 
      if (transport.length > 0){
        var row = "<option value=\"" + "" + "\">" + "Select" + "</option>";
        $(row).appendTo("select#patient_tehsil_id");
        //// Fill sub category select
        $.each(transport, function(i){
          row = "<option value=\"" + transport[i][1] + "\">" + transport[i][0] + "</option>";
          $(row).appendTo("select#patient_tehsil_id");
        });
      }else{
        var row = "<option value=\"" + "" + "\">" + "" + "</option>";
        $(row).appendTo("select#patient_tehsil_id");
      }
    },
  });
});    
$("#patient_tehsil_id").change(function() {
  $.ajax({
    url:'/ajax/populate_uc?town='+this.value,
    dataType: 'json',
    success: function(transport) {
      // console.log(transport);
      // Clear all options from sub category select 
      $("select#patient_uc_id").removeAttr('disabled');
      $("select#patient_uc_id option").remove();

      // Fill sub category select 
      if (transport.length > 0){
        var row = "<option value=\"" + "" + "\">" + "Select" + "</option>";
        $(row).appendTo("select#patient_uc_id");
        //// Fill sub category select
        $.each(transport, function(i){
          row = "<option value=\"" + transport[i][1] + "\">" + transport[i][0] + "</option>";
          $(row).appendTo("select#patient_uc_id");
        });
      }else{
        var row = "<option value=\"" + "" + "\">" + "" + "</option>";
        $(row).appendTo("select#patient_uc_id");
      }
    },
  });
});