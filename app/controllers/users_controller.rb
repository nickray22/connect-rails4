class UsersController < ApplicationController

  def index
    render :index
  end

  def list
    @users = User.select(:email).all
    render :list
  end

  def show
    render :sign_out
  end

end
