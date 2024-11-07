class SessoesController < ApplicationController
  def new
  end

  def create
    usuario = Usuario.find_by_username(params[:username])

    if usuario && usuario.authenticate(params[:password])
      session[:usuario_id] = usuario.id
      UsuarioLogin.create(usuario_id: usuario.id, remote_ip: request.remote_ip, data: Date.current, horario: Time.current)
      redirect_to root_path, notice: "Entrou!"
    else
      criar_erro_de_navegacao error_code: 401, mensagem: "Tentativa de login para usuario #{params[:username]} fracassada."
      flash.now.alert = "Usuário ou senha incorretos!"
      render "new"
    end
  end

  def destroy
    session[:usuario_id] = nil
    redirect_to root_path, notice: "Usuário saiu!"
  end
end
