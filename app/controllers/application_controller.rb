# @abstract Base class for all Coyote controllers
class ApplicationController < ActionController::Base
  include Pundit

  #after_action :verify_authorized, except: :index, unless: Rails.env.production?
  #after_action :verify_policy_scoped, only: :index, unless: Rails.env.production?
  
  helper_method :current_organization, :current_organization?, :organization_user

  protect_from_forgery :with => :exception
  protect_from_forgery :with => :null_session, if: ->(c) { c.request.format.json? }

  # HACK: the acts_as_token_authentication_handler_for gem doesn't let you opt out of using it in descendant controllers
  # see https://github.com/gonzalo-bulnes/simple_token_authentication/issues/268#issuecomment-318651424
  # TODO: investigate removing this gem, there are probably simpler ways of handling tokens
  looks_like_an_api_request = ->(controller) { controller.request.format.json? }

  before_action :authenticate_user!, unless: looks_like_an_api_request
  acts_as_token_authentication_handler_for User, if: looks_like_an_api_request

  skip_before_action :authenticate_user!, if: ->(controller) { controller.instance_of?(HighVoltage::PagesController) }

  analytical

  def search_params
    params[:q]
  end

  def clear_search_index
    if params[:search_cancel]
      params.delete(:search_cancel)
      if(!search_params.nil?)
        search_params.each do |key, param|
          search_params[key] = nil
        end
      end
    end
  end

  protected

  attr_accessor :users, :contexts

  # TODO: eventually we want to remove this action and use pundit's .authorize method; just leaving this in so that 
  # controllers that don't have pundit included can still be protected
  def authorize_admin!
    unless pundit_user.admin?
      redirect_to(current_organization,alert: "You are not authorized to perform that action")
    end
  end

  def organization_user
    @organization_user ||= Coyote::OrganizationUser.new(current_user,current_organization)
  end

  alias pundit_user organization_user

  def get_contexts
    self.contexts = Context.all.sort { |a,b| a.to_s <=> b.to_s } # TODO: needs to be moved into Context scope, sorted via SQL
  end

  def after_sign_in_path_for(user)
    if user.organizations.one?
      organization_path(user.organizations.first)
    else
      organizations_path
    end
  end

  def current_organization?
    current_user.organizations.exists?(current_organization_id)
  end

  def current_organization
    @current_organization ||= current_user.organizations.find(current_organization_id)
  end

  def current_organization_id
    params[:organization_id] # intended to be overridden in the OrganizationController
  end
end
