class SyncsController < ApplicationController
  def index
    @syncs = Sync.ordered.limit(50)
  end

  def show
    @sync = Sync.find(params[:id])
  end
end
