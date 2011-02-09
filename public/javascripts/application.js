function resize(elem) {
	if (elem.width > elem.height) {
		if (elem.width > 100) {
			elem.width = 100;
		}
	} else {
		if (elem.height > 100) {
			elem.height = 100;
		}
	}
}

document.observe("dom:loaded", function() {
	$$('img.logo_img').each(function (image) {
		$(image).observe('load', function () {
			resize(image);
		})
	})
});