class AtendimentoValoresController < ApplicationController
  require 'csv'

  before_action :set_atendimento_valor, only: %i[ show show_pdf edit delete ]
  before_action :validar_usuario

  def index
    # @de = if !params[:de].nil? then params[:de].to_date end || Date.today.beginning_of_month
    # @ate = if !params[:ate].nil? then params[:ate].to_date end || Date.today.end_of_month
    @de = params[:de]&.to_date || Date.today.beginning_of_month
    @ate = params[:ate]&.to_date || Date.today.end_of_month

    @profissional = nil
    @pessoa = nil
    @responsavel = nil

    if @atendimento_valores.blank?
      if usuario_atual.financeiro?
        @atendimento_valores = AtendimentoValor.do_periodo(@de..@ate)
      else
        @atendimento_valores = usuario_atual.profissional.atendimento_valores.do_periodo
      end
    end

    if params[:profissional].present?
      @atendimento_valores = @atendimento_valores.do_profissional_com_id(@profissional)
    end

    if params[:pessoa].present?
      @pessoa = params[:pessoa]
      @atendimento_valores = @atendimento_valores.query_pessoa_like_nome(@pessoa)
    end

    if params[:responsavel].present?
      @responsavel = params[:responsavel]
      @atendimento_valores = @atendimento_valores.query_responsavel_like_nome(@responsavel)
    end

    if params[:atendimento_tipo].present?
      @atendimento_valores = @atendimento_valores.do_tipo_de_atendimento_com_id(params[:atendimento_tipo])
    end

    if params[:realizado].present?
      if params[:realizado]
        @atendimento_valores = @atendimento_valores.de_atendimentos_realizados
      else
        @atendimento_valores = @atendimento_valores.de_atendimentos_nao_realizados
      end
    end

    @atendimento_valores = @atendimento_valores.em_ordem

    @profissional = @acompanhamento&.profissional || (Profissional.find(params[:profissional]) unless params[:profissional].blank?) || usuario_atual.profissional
    @responsavel = params[:responsavel]
    @params = params.permit(:de, :ate, :profissional, :atendimento_tipo, :realizado, :pessoa, :responsavel)

    respond_to do |format|
      format.html do
        if hx_request?
          render partial: "atendimento_valores/tabela", locals: {atendimento_valores: @atendimento_valores}
        end
      end

      format.csv do
        send_data AtendimentoValor.para_csv(@atendimento_valores), filename: "#{nome_do_site&.parameterize}-relatorio-valores-atendimentos_#{@de}_#{@ate}#{@profissional&.nome_completo&.parameterize&.insert(0, "#{@profissional&.funcao&.parameterize}-")&.insert(0, "_")}#{@pessoa&.parameterize&.insert(0, "_")}#{@responsavel&.parameterize&.insert(0, "_")}#{@acompanhamento&.tipo&.parameterize&.insert(0, "_")}#{params[:acompanhamento]}.csv", type: "text/csv"
      end
      format.xlsx do
        response.headers['Content-Disposition'] = "attachment; filename=#{Rails.application.class.module_parent_name.to_s}-relatorio-valores-atendimentos_#{@de}-#{@ate}#{@profissional&.nome_completo&.parameterize&.insert(0, "_")}#{@pessoa&.parameterize&.insert(0, "_")}#{@responsavel&.parameterize&.insert(0, "_")}.xlsx"
      end

      format.json
    end
  end

  def index_pdf
  end

  def show
  end

  def show_pdf
  end

  def new
    @atendimento_valor = AtendimentoValor.new
  end

  def create
    @atendimento_valor = AtendimentoValor.new(atendimento_valor_params)

    respond_to do |format|
      if @atendimento_valor.save
        format.html { redirect_to atendimento_valor_url(@atendimento_valor), notice: "pessoa devolutiva was successfully created." }
        format.json { render :show, status: :created, location: @atendimento_valor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @atendimento_valor.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @atendimento_valor.update(validar_params)
        format.html do
          if hx_request?
            render partial: "atendimento/atendimento-tabela-form", locals: {atendimento: @atendimento_valor.atendimento }
          else
            redirect_to atendimento_valor_url(@atendimento_valor), notice: "pessoa devolutiva was successfully updated."
          end
        end
        format.json { render :show, status: :ok, location: @atendimento_valor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @atendimento_valor.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
  end

  private

  def set_atendimento_valor
    @atendimento_valor = AtendimentoValor.find(params[:id])
  end

  def atendimento_valor_params
    params.require(:atendimento_valor).permit(:atendimento_id, :valor, :desconto, :taxa_porcentagem_interna, :taxa_porcentagem_externa)
  end

  def validar_params
    atendimento_valor_params.map { |k,v| {k => v&.to_s&.gsub(/\D/, "")&.to_i } }
  end

  def validar_usuario
    if usuario_atual.nil? || !(usuario_atual.corpo_clinico? || usuario_atual.financeiro?)
      render file: "#{Rails.root}/public/404.html", status: 403
      return
    end
  end
end
