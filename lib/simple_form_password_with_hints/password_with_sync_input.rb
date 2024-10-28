class PasswordWithSyncInput < ::SimpleForm::Inputs::Base
  enable :placeholder, :maxlength, :minlength

  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    merged_input_options[:class] << " js-sfpwh-input js-sfpwh-sync-input "
    input_wrapper_class = 'sfpwh-input-div'
    input_wrapper_class += ' sfpwh-input-div-invalid' if has_errors?
    if options[:compare_with_field]
      if merged_input_options[:data].nil?
        merged_input_options[:data] = { link_to: linked_field_name }
      else
        merged_input_options[:data][:link_to] = linked_field_name
      end
      ( template.content_tag(:div, '', class: input_wrapper_class) do
        [
          @builder.password_field(attribute_name, merged_input_options) +
          password_uncloaking_div
        ].compact.join.html_safe
      end ) + controls
    else
      @builder.password_field(attribute_name, merged_input_options)
    end
  end

  def controls
    template.content_tag(:div, '', class: 'sfpwh-controls js-sfpwh-controls') do
      template.content_tag(
        :span,
        t('simple_form_password_with_hints.test_fields_matching'),
        class: 'sfpwh-hint sfpwh-hint--invalid sfpwh-hint--match js-sfpwh-hint-match'
        )
    end
  end

  def password_uncloaking_div
    template.content_tag(
      :span,
      '',
      class: 'sfpwh-password-toggle js-sfpwh-password-toggle'
    ) if options[:allow_password_uncloaking]
  end

  def linked_field_name
    "#{@builder.object_name}[#{options[:compare_with_field]}]"
  end
end
