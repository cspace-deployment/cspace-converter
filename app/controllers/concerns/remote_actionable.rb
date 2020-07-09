module RemoteActionable
  extend ActiveSupport::Concern

  def delete
    perform(:delete, params[:category])
  end

  def ping
    perform(:ping, params[:category])
  end

  def transfer
    perform(:transfer, params[:category])
  end

  def update
    perform(:update, params[:category])
  end

  private

  def perform(action_method, category)
    @object  = CollectionSpaceObject.where(category: category).where(id: params[:id]).first
    service  = RemoteActionService.new(@object)

    begin
      status = service.send(action_method)
      @object.transfer_statuses.create(
        transfer_status: status.success?,
        transfer_message: status.message
      )
    rescue Exception => ex
      logger.error("Connection error:\n#{ex.backtrace}")
      flash[:error] = "Connection error:\n#{ex.message}"
    end

    redirect_to send("#{category.downcase}_path".to_sym, @object)
  end
end
