class SessoesController < ApplicationController
  def new
  end

  def create
    usuario = Usuario.find_by_username(params[:username])

    if usuario && usuario.authenticate(params[:password])
      session[:usuario_id] = usuario.id
      redirect_to root_path, notice: "Entrou!"
    else
      flash.now.alert = "E-mail ou senha incorretos!"
      render "new"
    end
  end

  def destroy
    session[:usuario_id] = nil
    redirect_to root_path, notice: "Usuário saiu!"
  end
end
