# frozen_string_literal: true

class ApplicationPolicy
  include LinkedRails::Policy

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  attr_reader :message
  delegate :pod_owner?, to: :user_context

  def create?
    pod_owner?
  end

  def show?
    pod_owner?
  end

  def update?
    pod_owner?
  end

  def destroy?
    pod_owner?
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  def delete?
    destroy?
  end

  private

  def forbid_with_message(message)
    @message = message
    false
  end
end
