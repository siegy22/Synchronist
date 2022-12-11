module Sender
  class PayloadsController < ApplicationController
    def index
      @payloads = Sender::Payload.ordered.limit(50)
    end
  end
end
