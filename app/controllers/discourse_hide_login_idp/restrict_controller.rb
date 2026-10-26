# frozen_string_literal: true

class DiscourseHideLoginIdp::RestrictController < ::ApplicationController
  skip_before_action :redirect_to_login_if_required, raise: false
  skip_before_action :check_xhr, raise: false

  def show
    render json: {
      restrict: DiscourseHideLoginIdp::Decision.restrict?(
        ip: request.remote_ip,
        user: current_user,
        login_buttons: params[:login_buttons]
      ),
    }
    response.headers["Cache-Control"] = "private, no-store"
  end
end
