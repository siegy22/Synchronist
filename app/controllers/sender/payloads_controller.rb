module Sender
  class PayloadsController < ApplicationController
    def index
      @payloads = Sender::Payload.ordered
    end
  end
end
