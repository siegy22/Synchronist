class ReceivedFilesController < ApplicationController
  def index
    @received_files = ReceivedFile.ordered
  end
end
