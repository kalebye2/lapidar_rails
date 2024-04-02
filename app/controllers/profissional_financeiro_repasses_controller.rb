class ProfissionalFinanceiroRepassesController < ApplicationController
  before_action :validar_usuario
  before_action :set_profissional_financeiro_repasse, only: %i[ update edit destroy show ]

  def index
    @repasses = repasses_por_periodo_params

    if params[:profissional].present?
      @repasses = @repasses.do_profissional_com_id(params[:profissional])
    end

    if params[:pagamento_modalidade].present?
      @repasses = @repasses.da_modalidade_com_id(params[:pagamento_modalidade])
    end

    @params = params.permit(:de, :ate, :profissional, :pagamento_modalidade)

    respond_to do |format|
      format.html do
        if hx_request?
          render partial: "profissional_financeiro_repasses/tabela-repasses", locals: {repasses: @repasses}
          return
        else
        end
      end
      format.csv do
        send_data ProfissionalFinanceiroRepasse.para_csv(collection: @repasses), filename: "#{Rails.application.class.module_parent_name.to_s}-relatorio-repasses_#{@de}_#{@ate}#{Profissional.find(params[:profissional]).nome_completo.parameterize.insert(0, "_") unless params[:profissional].blank?}#{PagamentoModalidade.find(params[:pagamento_modalidade]).modalidade.insert(0, "_") unless params[:pagamento_modalidade].blank?}.csv", type: "text/csv"
      end
    end
  end

  def repasses_por_periodo_params
    set_de_ate

    if usuario_atual.financeiro?
      @repasses = ProfissionalFinanceiroRepasse.do_periodo(@de..@ate)
    else
      @repassses = usuario_atual.profissional.profissional_financeiro_repasses.do_periodo(@de..@ate)
    end
  end

  def new
    @repasse = ProfissionalFinanceiroRepasse.new
    respond_to do |format|
      format.html do
        if hx_request?
          render partial: "profissional_financeiro_repasses/repasse-em-tabela-edit", locals: { repasse: @repasse }
        end
      end
    end
  end

  def create
    if !usuario_atual.financeiro?
      render file: "#{Rails.root}/public/404.html", status: 403
      return
    end
    @repasse = ProfissionalFinanceiroRepasse.new(profissional_financeiro_repasse_params)
    respond_to do |format|
      if @repasse.save
        format.html { redirect_to profissional_financeiro_repasses_path }
      else
        format.html { render text: "nada" }
      end
    end
  end

  def show
    respond_to do |format|
      format.html do
        if hx_request?
          render partial: "profissional_financeiro_repasses/repasse-em-tabela", locals: {repasse: @repasse}        end
      end
    end
  end

  def edit
    respond_to do |format|
      format.html do
        if hx_request?
          render partial: "profissional_financeiro_repasses/repasse-em-tabela-edit", locals: {repasse: @repasse}
        end
      end
    end
  end

  def update
    respond_to do |format|
      format.html do
        if !usuario_atual.financeiro?
          render file: "#{Rails.root}/public/404.html", status: 403
          return
        end
        if @repasse.update(profissional_financeiro_repasse_params)
          if params[:tabela].present?
            render partial: "profissional_financeiro_repasses/repasse-em-tabela", locals: {repasse: @repasse}
          end
        end
      end
    end
  end

  def destroy
    @repasse.destroy

    respond_to do |format|
      format.html do
        redirect_to profissional_financeiro_repasses_url, notice: "Repasse excluído com sucesso!"
      end
    end
  end

  private

  def set_profissional_financeiro_repasse
    @repasse = ProfissionalFinanceiroRepasse.find(params[:id])
    set_de_ate
  end

  def set_de_ate
    @de = params[:de] || Date.today.beginning_of_month
    @ate = params[:ate] || Date.today.end_of_month
  end

  def profissional_financeiro_repasse_params
    params.require(:profissional_financeiro_repasse).permit(:data, :profissional_id, :valor, :modalidade_id)
  end

  def validar_usuario
    if usuario_atual.nil? || !(usuario_atual.financeiro? || usuario_atual.corpo_clinico?)
      render file: "#{Rails.root}/public/404.html", status: 403
    end
  end
end
