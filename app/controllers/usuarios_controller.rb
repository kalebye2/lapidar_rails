class UsuariosController < ApplicationController
  before_action :set_usuario, only: %i[ show edit update destroy ]

  def index
    @usuarios = Usuario.all
  end

  def new
    @usuario = Usuario.new
  end

  def create
    @usuario = Usuario.new(usuario_params)
    if @usuario.save!
      #session[:usuario_id] = @usuario.id
      #redirect_to root_url, notice: "Login realizado com sucesso!"
      redirect_to usuarios_path, notice: "Usuário criado para #{@usuario.profissional.nome_abreviado}!"
    else
      render "new"
    end
  end

  def update
    respond_to do |format|
      if @usuario.update(usuario_params)
        format.html { redirect_to usuario_url(@usuario), notice: "Usuário atualizado com sucesso!" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def destroy
  end

  private

  def set_usuario
    @usuario = Usuario.find(params[:id])
  end

  def usuario_params
    params.require(:usuario).permit(:profissional_id, :username, :password, :password_confirmation, :admin, :secretaria, :financeiro, :informatica, :corpo_clinico)
  end
end
