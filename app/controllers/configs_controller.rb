class ConfigsController < ApplicationController
  skip_before_action :check_configuration

  def edit
    @config_form = ConfigForm.current
  end

  def update
    @config_form = ConfigForm.new(config_params)
    if @config_form.save
      redirect_to root_path
    else
      render 'configs/edit'
    end
  end

  private
  def config_params
    params.require(:config_form).permit(
      :mode,
      :sender_payload_path,
      :sender_source_folder,
      :sender_send_folder,
      :receiver_payload_path,
      :receiver_storage_folder,
      :receiver_receive_folder
    )
  end
end
