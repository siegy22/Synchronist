class ConfigsController < ApplicationController
  skip_before_action :check_configuration

  def edit
    @config_form = ConfigForm.current
  end

  def update
    @config_form = ConfigForm.new(config_params)
    if @config_form.save
      redirect_to root_path, notice: "Configuration saved!"
    else
      render 'configs/edit'
    end
  end

  private
  def config_params
    params.require(:config_form).permit(*Config::CONFIGS)
  end
end
