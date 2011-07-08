$(document).ready(function() {
	$(".deal-details").bind("ajax:beforeSend", function() {
		$("#deals > tbody").children().each(function () {
			$(this).removeClass("selected");
		})
		$(this).parent().parent().addClass("selected");
	})
})