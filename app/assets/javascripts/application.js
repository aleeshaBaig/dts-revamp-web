
// require jquery_ujs
//= require jquery
//= require rails-ujs

// require turbolinks
//= require toastr
//= require jquery_nested_form

// redirect
$('input[type=cancel]').on('click', function(){
	window.location.href= $(this).data('url');
});
// << Mark as Lab Patient >>
// $('#mark_as_lab_patient').on('click', function(){
//   var change_confirm = confirm("are you sure you want to change this?");
//   if(change_confirm){
//     $.ajax({
//       url: "/lab_patients/mark_as_zero_patient",
//       success: function(data) {
//         alert("successfully updated!");
//       }
//     });
//   }
// });
