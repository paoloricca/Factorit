function loadTemplate(container, templateName) {
	try {
		var URL = appConfig.appName + 'templates';
		if (templateName != null) {
			URL += '/' + templateName;
		}
		return container.load(URL + '.html');
	}
	catch (err) {
		printError(getDelegateName(arguments), err.message);
		console.log(getDelegateName(arguments), err.message);
	}
}
function loadTemplate(container, fncName, tmpName) {
	try {
		var URL = appConfig.appName + 'templates';
		if (fncName != null) {
			URL += '/' + fncName;
		}
		if (tmpName != null) {
			URL += '/' + tmpName;
		}
		return container.load(URL + '.html');
	}
	catch (err) {
		printError(getDelegateName(arguments), err.message);
		console.log(getDelegateName(arguments), err.message);
	}
}
$.fn.extend({
	treed: function () {
		return this.each(function () {
			//initialize each of the top levels
			var tree = $(this);
			tree.addClass("tree");
			tree.find('li').has("ul").each(function () {
				var branch = $(this); //li with children ul
				branch.prepend("<i class='indicator fa fa-minus-square-o'></i>");
				branch.addClass('branch');
				branch.on('click', function (e) {
					if (this == e.target) {
						var icon = $(this).children('i:first');
						icon.toggleClass("fa fa-minus-square-o fa fa-plus-square-o");
						$(this).children().children().toggle();
					}
				})
				//branch.children().children().toggle();
			});
			//fire event from the dynamically added icon
			$('.branch .indicator').on('click', function () {
				$(this).closest('li').click();
			});
			//fire event to open branch if the li contains an anchor instead of text
			//$('.branch a').on('click', function (e) {
			//	$(this).closest('li').click();
			//	e.preventDefault();
			//});
			//fire event to open branch if the li contains a button instead of text
			$('.branch button').on('click', function (e) {
				$(this).closest('li').click();
				e.preventDefault();
			});
		});
	}
});
