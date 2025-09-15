class Admin::AdminController < ApplicationController

  def index
    if usuario_atual.nil? || !usuario_atual.informatica?
      erro403
      return
    end

    @table_name = params[:table]
    @limit = params[:limit] || 25
    @page = params[:page] || 0
    render template: "admin/index"
  end

  ActiveRecord::Base.connection.tables.each do |table_name|
    Admin.const_set "#{table_name.camelcase}Controller", Class.new(ApplicationController) do
      define_method :index do
      end
      
      define_method :teste do
        12
      end
    end
  end

  def update
    params_to_vars
    if @element.update(@attribute_params)
      redirect_to admin_root_path(table: @table, element_id: @element.id)
    else
      @errors = @element.errors
      redirect_to admin_root_path(table: @table, edit: @attribute, value: @value, id: @element.id, errors: @errors, element_id: @element.id)
    end
  end

  def new
    table = params[:table]
    klass = Object.const_get(table.classify)
    @object = klass
    render template: "admin/new", locals: {table_name: table, element: @object.new, klass: @object}
  end
  
  def create
    table_name = params[:table]
    klass = Object.const_get(table_name.classify)
    @element = klass.new(params[table_name.singularize.underscore].permit(klass.attribute_names))
    
    respond_to do |format|
      if @element.save
        format.html { redirect_to admin_root_path(table: table_name), notice: "Registro criado em #{table_name}" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    table_name = params[:table]
    @element = Object.const_get(table_name.classify).find(params[:id])&.destroy

    respond_to do |format|
      format.html do
        if hx_request?
          index
        else
          redirect_to admin_root_path(table: table_name, notice: "#{table_name.humanize} destruído com sucesso.")
        end
      end
    end
  end

  private

  def params_to_vars
    @table = params[:table]
    @klass = Object.const_get(@table.classify)
    @element = @klass.find(params[:id])
    @attribute_params = params[@table.classify.underscore].permit(@klass.attribute_names)
    @attribute = params[:edit].to_sym
    @value = params[:value]
  end

  def validar_usuario
    if usuario_atual.nil? || !usuario_atual.informatica?
      erro403
    end
  end
end
