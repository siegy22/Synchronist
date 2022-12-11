class ReceivedFilesController < ApplicationController
  def index
    @received_files = ReceivedFile.ordered.limit(50)
  end
end
