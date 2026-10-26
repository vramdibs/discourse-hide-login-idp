# frozen_string_literal: true

module DiscourseHideLoginIdp
  class Engine < ::Rails::Engine
    engine_name PLUGIN_NAME
    isolate_namespace DiscourseHideLoginIdp
  end
end
