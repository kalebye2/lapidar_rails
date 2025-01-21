class Admin::AdminController < ApplicationController

  def index
    @table_name = params[:table]
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
      redirect_to admin_root_path(table: @table)
    else
      @errors = @element.errors
      redirect_to admin_root_path(table: @table, edit: @attribute, value: @value, id: @element.id, errors: @errors)
    end
  end

  def new
    table = params[:table]
    klass = Object.const_get(table.classify)
    @object = klass
  end
  
  def create
    
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

end
