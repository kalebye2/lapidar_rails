class ProfissionalFinanceiroRepassesController < ApplicationController
  before_action :validar_usuario
  before_action :set_profissional_financeiro_repasse, only: %i[ update edit destroy show ]

  def index
    @repasses = repasses_por_periodo_params
    respond_to do |format|
      format.html do
        if params[:ajax].present?
          render partial: "profissional_financeiro_repasses/tabela-repasses", locals: {repasses: @repasses}
          return
        else
        end
      end
      format.csv do
        send_data ProfissionalFinanceiroRepasse.para_csv(collection: @repasses), filename: "#{Rails.application.class.module_parent_name.to_s}-relatorio-repasses_#{@de}_#{@ate}.csv", type: "text/csv"
      end
    end
  end

  def repasses_por_periodo_params
    set_de_ate

    if usuario_atual.financeiro?
      @repasses = ProfissionalFinanceiroRepasse.do_periodo(de: @de, ate: @ate)
    else
    end
  end

  def new
    @repasse = ProfissionalFinanceiroRepasse.new
    respond_to do |format|
      format.html do
        if params[:tabela].present?
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
        if params[:tabela].present?
          render partial: "profissional_financeiro_repasses/repasse-em-tabela", locals: {repasse: @repasse}        end
      end
    end
  end

  def edit
    respond_to do |format|
      format.html do
        if params[:ajax].present?
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
        index
        render "index"
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
    if usuario_atual.nil? || !usuario_atual.financeiro?
      render file: "#{Rails.root}/public/404.html", status: 403
    end
  end
end
