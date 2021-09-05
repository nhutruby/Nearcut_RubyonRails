# frozen_string_literal: true

# Users Controller
class UsersController < ApplicationController
  def index
    @user = User.new
  end

  def create
    @results = User.import(params[:user][:file]) if params[:user] && params[:user][:file] != "undefined"
    respond_to do |format|
      format.json { render json: @results, status: :unprocessable_entity }
      format.js
    end
  end

  private

  def file_params
    params.require(:user).permit(:file)
  end
end
