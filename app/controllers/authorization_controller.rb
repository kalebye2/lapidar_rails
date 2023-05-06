class AuthorizationController < ApplicationController
  before_action :authenticate_psicologo!, only: %i[ show edit update destroy new pdf]
end
