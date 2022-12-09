class SyncsController < ApplicationController
  def index
    @syncs = Sync.ordered
  end

  def show
    @sync = Sync.find(params[:id])
  end
end
