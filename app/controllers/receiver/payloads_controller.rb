module Receiver
  class PayloadsController < ApplicationController
    def index
      @payloads = Receiver::Payload.ordered
    end
  end
end
