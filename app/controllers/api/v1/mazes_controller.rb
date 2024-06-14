# frozen_string_literal: true

class Api::V1::MazesController < ApplicationController
  prepend_before_action :verify_authenticity_token, except: [:start, :search]

  def start
    result = Api::V1::Maze::Generator.new.execute(start_params[:name])
    if result[:success]
      render json: { success: true, data: result[:data] }
    else
      render json: { success: false, error: result[:error_message] }, status: :internal_server_error
    end
  rescue StandardError => e
    Rails.logger.error("ERROR:#{e.message}\n#{e.backtrace.join("\n")}")
  end

  def search
    result = Api::V1::Maze::Searcher.new.execute(search_params[:name])
    if result[:success]
      render json: { success: true, data: result[:data] }
    else
      render json: { success: false, error: result[:error_message] }, status: :internal_server_error
    end
  rescue StandardError => e
    Rails.logger.error("ERROR:#{e.message}\n#{e.backtrace.join("\n")}")
  end

  private

  def start_params
    params.permit(:name)
  end

  def search_params
    params.permit(:name)
  end
end
