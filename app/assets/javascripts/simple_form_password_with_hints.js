Element.prototype.parents = function (selector) {
    'use strict';

    var elements = [],
        // eslint-disable-next-line consistent-this
        elem = this,
        ishaveselector = typeof selector !== 'undefined';

    while ((elem = elem.parentElement) !== null) {
        if (elem.nodeType !== Node.ELEMENT_NODE) {
            continue;
        }

        if (!ishaveselector || elem.matches(selector)) {
            elements.push(elem);
        }
    }

    return elements;
};

Element.prototype.parent = function (selector) {
    'use strict';
    var elements = this.parents(selector);

    if (elements.length > 0) {
        return elements[0];
    } else {
        return null;
    }
};

(function () {
    'use strict';
    var initialized = false,
        simpleFormPasswordWithHints;

    simpleFormPasswordWithHints = {
        init: function () {
            var inputs = document.querySelectorAll('.js-sfpwh-hints-input'),
                togglers = document.querySelectorAll('.js-sfpwh-password-toggle'),
                syncInputs = document.querySelectorAll('.js-sfpwh-sync-input'),
                i = 0;

            if (initialized) {
                return false;
            }
            initialized = true;

            this.listen(inputs, 'input', this.onInput.bind(this));
            this.listen(togglers, 'click', this.onClickToggler);

            for (i = 0; i < syncInputs.length; i +=1) {
                this.bindEquality(syncInputs[i]);
            }
        },

        listen: function (elements, action, callback) {
            var i;
            for (i = 0; i < elements.length; i +=1) {
                elements[i].addEventListener(action, callback.bind(this, elements[i]));
            }
        },

        onInput: function (element) {
            var container = element.parent('.password_with_hints'),
                checks = ['length', 'uppercase', 'lowercase', 'number', 'special'],
                i;
            for (i = 0; i < checks.length; i += 1) {
                this.check(container, checks[i], element.value);
            }
        },

        check: function (container, key, value) {
            var check = container.querySelector('.js-sfpwh-hint-' + key),
                valid = true;

            if (!check) {
                return
            }

            switch (key) {
                case 'uppercase':
                    valid = new RegExp('[A-Z]').test(value);
                    break;
                case 'lowercase':
                    valid = new RegExp('[a-z]').test(value);
                    break;
                case 'number':
                    valid = new RegExp('[0-9]').test(value);
                    break;
                case 'length':
                    var min = check.getAttribute('data-minlength'),
                        max = check.getAttribute('data-maxlength');
                    valid = value.length >= min && value.length <= max;
                    break;
                case 'special':
                    valid = new RegExp('[^A-z0-9]').test(value);
                default:
                    break;
            }

            if (valid) {
                check.classList.remove('sfpwh-hint--invalid');
            } else {
                check.classList.add('sfpwh-hint--invalid');
            }
        },

        bindEquality: function (input) {
            var form = input.parent('form'),
                target = form.querySelector('input[name="' + input.getAttribute('data-link-to') + '"]');
            input.addEventListener('input', this.compare.bind(this, input, target));
            target.addEventListener('input', this.compare.bind(this, input, target));
        },

        compare: function (field, target) {
            var container = field.parent('.password_with_sync'),
                check;

            if (container) {
                check = container.querySelector('.js-sfpwh-hint-match');
            }

            if (field.value !== '' && field.value === target.value) {
                check.classList.remove('sfpwh-hint--invalid');
            } else {
                check.classList.add('sfpwh-hint--invalid');
            }
        },

        onClickToggler: function (element) {
            var container = element.parent('.password_with_hints, .password_with_sync'),
                input = container.querySelector('.js-sfpwh-input');

            element.classList.toggle('sfpwh-password-toggle-revealed');

            input.type = input.type === 'text' ? 'password' : 'text';
        },
    };

    if (document.readyState === 'complete' || document.readyState === 'interactive') {
        simpleFormPasswordWithHints.init();
    } else {
        window.addEventListener('DOMContentLoaded', () => {
            simpleFormPasswordWithHints.init();
        });
    }
}());
