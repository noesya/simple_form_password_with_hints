class PasswordWithHintsInput < SimpleForm::Inputs::Base
  enable :placeholder, :maxlength, :minlength

  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    merged_input_options[:class] << " js-password-with-hints-input "
    template.content_tag :div, class: 'password-with-hints user-select-none js-password-with-hints' do
      @builder.password_field(attribute_name, merged_input_options) +
        password_uncloaking_div +
        template.content_tag(:div, '', class: 'js-password-controls') do
          [
            length_div,
            uppercase_div,
            lowercase_div,
            numeric_div,
            special_char_div
          ].compact.join.html_safe
        end
    end
  end

  def password_uncloaking_div
    template.content_tag(:i, '', class: 'far fa-eye password-toggle js-password-toggle') if options[:allow_password_uncloaking]
  end

  def length_div
    if should_display?(:length)
      template.content_tag(:span, t('simple_form_password_with_hints.test_chars', length: options[:validators][:length]), class: 'password-hint password-hint--invalid password-hint-uppercase j-password-controls-length')
    end
  end

  def uppercase_div
    if should_display?(:uppercase_char)
      template.content_tag(:span, t('simple_form_password_with_hints.test_uppercase'), class: 'password-hint password-hint--invalid password-hint-uppercase j-password-controls-uppercase')
    end
  end

  def lowercase_div
    if should_display?(:lowercase_char)
      template.content_tag(:span, t('simple_form_password_with_hints.test_lowercase'), class: 'password-hint password-hint--invalid password-hint-lowercase j-password-controls-lowercase')
    end
  end

  def numeric_div
    if should_display?(:numeric_char)
      template.content_tag(:span, t('simple_form_password_with_hints.test_numeric'), class: 'password-hint password-hint--invalid password-hint-number j-password-controls-number')
    end
  end

  def special_char_div
    if should_display?(:special_char)
      template.content_tag(:span, t('simple_form_password_with_hints.test_special_char'), class: 'password-hint password-hint--invalid password-hint-special j-password-controls-special')
    end
  end

  private

  def should_display?(test)
    options.has_key?(:validators) && options[:validators].has_key?(test) && options[:validators][test] != false
  end

end
