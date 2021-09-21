/*global $, RegExp */
$(function () {
    'use strict';
    var getCheckRegex = function (key, $check) {
            var regex, min, chars;
            switch (key) {
            case 'uppercase':
                regex = '[A-Z]';
                break;
            case 'lowercase':
                regex = '[a-z]';
                break;
            case 'number':
                regex = '[0-9]';
                break;
            case 'special':
                // hyphen must be at the end
                chars = $check.data('chars');
                regex = '[' + chars + ']';
                break;
            case 'length':
                min = $check.data('length');
                regex = '.{' + min + ',128}';
                break;
            default:
                break;
            }
            return regex;
        },
        performCheck = function ($container, key, password) {
            var $check = $('.js-sfpwh-hint-' + key, $container),
                regexKey = getCheckRegex(key, $check),
                regex = new RegExp(regexKey);
            if ($check.length) {
                if (password.match(regex)) {
                    $check.removeClass('sfpwh-hint--invalid');
                } else {
                    $check.addClass('sfpwh-hint--invalid');
                }
            }
        };

    $('.js-sfpwh-input').on('input', function () {
        var $container = $(this).parents('.password_with_hints'),
            checks = ['length', 'uppercase', 'lowercase', 'number', 'special'],
            password = $(this).val(),
            i;
        for (i = 0; i < checks.length; i += 1) {
            performCheck($container, checks[i], password);
        }
    });
});
