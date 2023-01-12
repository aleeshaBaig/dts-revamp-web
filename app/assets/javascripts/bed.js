
//= require jquery
//= require rails-ujs

// require turbolinks
//= require toastr
// redirect
$('input[type=cancel]').on('click', function(){
	window.location.href= $(this).data('url');
});