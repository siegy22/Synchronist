module Receiver
  class PayloadsController < ApplicationController
    def index
      @payloads = Receiver::Payload.ordered.limit(50)
    end
  end
end
