class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessible_entity

  private

  def render_unprocessible_entity(invalid)
    render json: { errors: invalid.record.errors }, status: :unprocessable_entity
  end
end
