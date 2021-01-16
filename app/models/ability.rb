# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    @user ||= User.new # guest user (not logged in)
    can :read, :all

    if @user.admin?
      can :manage, :all
    else
      can [:update, :destroy], Recipe, user_id: @user.id
      can [:destroy], Comment, user_id: @user.id
      can [:update, :destroy], PhotoAlbum, user_id: @user.id
      can [:update, :destroy], Message, user_id: @user.id
    end
  end
end
