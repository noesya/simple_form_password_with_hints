class PasswordWithHintsInput < SimpleForm::Inputs::Base
  enable :placeholder, :maxlength, :minlength

  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    merged_input_options[:class] << " js-sfpwh-input "
    # template.content_tag :div, class: 'sfpwh-container js-sfpwh-container' do
      @builder.password_field(attribute_name, merged_input_options) +
        password_uncloaking_div +
        template.content_tag(:div, '', class: 'sfpwh-controls js-sfpwh-controls') do
          [
            length_div,
            uppercase_div,
            lowercase_div,
            numeric_div,
            special_char_div
          ].compact.join.html_safe
        end
    # end
  end

  def password_uncloaking_div
    template.content_tag(
      :span,
      '',
      class: 'sfpwh-password-toggle js-sfpwh-password-toggle'
    ) if options[:allow_password_uncloaking]
  end

  def length_div
    template.content_tag(
      :span,
      t('simple_form_password_with_hints.test_chars', min_length: options[:validators][:length]),
      data: { length: options[:validators][:length] },
      class: 'sfpwh-hint sfpwh-hint--invalid sfpwh-hint--uppercase js-sfpwh-hint-length'
    ) if should_display?(:length)
  end

  def uppercase_div
    template.content_tag(
      :span,
      t('simple_form_password_with_hints.test_uppercase'),
      class: 'sfpwh-hint sfpwh-hint--invalid sfpwh-hint--uppercase js-sfpwh-hint-uppercase'
    ) if should_display?(:uppercase_char)
  end

  def lowercase_div
    template.content_tag(
      :span,
      t('simple_form_password_with_hints.test_lowercase'),
      class: 'sfpwh-hint sfpwh-hint--invalid sfpwh-hint--uppercase js-sfpwh-hint-lowercase'
    ) if should_display?(:lowercase_char)
  end

  def numeric_div
    template.content_tag(
      :span,
      t('simple_form_password_with_hints.test_numeric'),
      class: 'sfpwh-hint sfpwh-hint--invalid sfpwh-hint--uppercase js-sfpwh-hint-number'
    ) if should_display?(:numeric_char)
  end

  def special_char_div
    template.content_tag(
      :span,
      t('simple_form_password_with_hints.test_special_char'),
      data: { chars: options[:validators][:special_char] },
      class: 'sfpwh-hint sfpwh-hint--invalid sfpwh-hint--uppercase js-sfpwh-hint-special'
    ) if should_display?(:special_char)
  end

  private

  def should_display?(test)
    options.has_key?(:validators) && options[:validators].has_key?(test) && options[:validators][test] != false
  end

end
