
var NanoTemplate = function () {

	var _templateData = {};
	var _templateFileName = '';

    var _templates = {};
    var _compiledTemplates = {};
	
	var _helpers = {};

    var init = function () {
        // We store templateData in the body tag, it's as good a place as any
		_templateData = $('body').data('templateData');
		_templateFileName = $('body').data('initialData')['config']['templateFileName'];

		if (_templateData == null)
		{
			alert('Error: Template data did not load correctly.');
		}

		loadAllTemplates();
    };

	var loadAllTemplates = function () {
		$.when($.ajax({
			url: _templateFileName,
			cache: false,
			dataType: 'json'
		}))
		.done(function(allTemplates) {
			
			for (var key in _templateData)
			{
				var templateMarkup = allTemplates[_templateData[key]];
				templateMarkup += '<div class="clearBoth"></div>';

				try
				{
					NanoTemplate.addTemplate(key, templateMarkup);
				}
				catch(error)
				{
					alert('ERROR: Loading template ' + key + '(' + _templateData[key] + ') failed with error: ' + error.message);
					return;
				}
				delete _templateData[key];
			}
			$(document).trigger('templatesLoaded');
		})
		.fail(function () {
			alert('ERROR: Failed to locate or parse templates file.');
		});
	};

    var compileTemplates = function () {

        for (var key in _templates) {
            try {
                _compiledTemplates[key] = doT.template(_templates[key], null, _templates)
            }
            catch (error) {
                alert('ERROR: Compiling template key "' + key + '" ("' + _templateData[key] + '") failed with error: ' + error);
            }
        }
    };

    return {
        init: function () {
            init();
        },
        addTemplate: function (key, templateString) {
            _templates[key] = templateString;
        },
        templateExists: function (key) {
            return _templates.hasOwnProperty(key);
        },
        parse: function (templateKey, data) {
            if (!_compiledTemplates.hasOwnProperty(templateKey) || !_compiledTemplates[templateKey]) {
                if (!_templates.hasOwnProperty(templateKey)) {
                    alert('ERROR: Template "' + templateKey + '" does not exist in _compiledTemplates!');
                    return '<h2>Template error (does not exist)</h2>';
                }
                compileTemplates();
            }
            if (typeof _compiledTemplates[templateKey] != 'function') {
                return '<h2>Template error (failed to compile)</h2>';
            }
            return _compiledTemplates[templateKey].call(this, data['data'], data['config'], _helpers);
        },
		addHelper: function (helperName, helperFunction) {
			if (!jQuery.isFunction(helperFunction)) {
				alert('NanoTemplate.addHelper failed to add ' + helperName + ' as it is not a function.');
				return;	
			}
			
			_helpers[helperName] = helperFunction;
		},
		addHelpers: function (helpers) {		
			for (var helperName in helpers) {
				if (!helpers.hasOwnProperty(helperName))
				{
					continue;
				}
				NanoTemplate.addHelper(helperName, helpers[helperName]);
			}
		},
		removeHelper: function (helperName) {
			if (helpers.hasOwnProperty(helperName))
			{
				delete _helpers[helperName];
			}	
		}
    }
}();
 

