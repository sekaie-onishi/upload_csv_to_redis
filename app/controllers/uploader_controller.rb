class UploaderController < ApplicationController
  def index
  end
  def import
    importRedis = ImportRedis.new
    @text = importRedis.import(params[:file])
    redirect_to root_url, notice: "CSV imported."
  end
end
