module Receiver
  class SendPayloadJob < ApplicationJob
    def perform
      Receiver::Payload.send!
    end
  end
end
