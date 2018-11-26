module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups
    module Icons
      # Name of the component method
      def fa_icon(wrapper_options = nil)
        @icon ||= begin
          if options[:fa_icon].present?
            options[:fa_icon] = "<i class='fa fa-#{options[:fa_icon]}'></i>".to_s.html_safe
          end
        end
      end
      def has_fa_icon?
        fa_icon.present?
      end
    end
  end
end
SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Icons)