# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: synerex.proto for package 'api'

require 'grpc'
require 'synerex_pb'

module Api
  module Synerex
    class Service

      include GRPC::GenericService

      self.marshal_class_method = :encode
      self.unmarshal_class_method = :decode
      self.service_name = 'api.Synerex'

      rpc :NotifyDemand, Demand, Response
      rpc :NotifySupply, Supply, Response
      rpc :ProposeDemand, Demand, Response
      rpc :ProposeSupply, Supply, Response
      rpc :SelectSupply, Target, ConfirmResponse
      rpc :SelectDemand, Target, ConfirmResponse
      rpc :Confirm, Target, Response
      rpc :SubscribeDemand, Channel, stream(Demand)
      rpc :SubscribeSupply, Channel, stream(Supply)
      rpc :SubscribeMbus, Mbus, stream(MbusMsg)
      rpc :SendMsg, MbusMsg, Response
      rpc :CloseMbus, Mbus, Response
      rpc :SubscribeGateway, GatewayInfo, stream(GatewayMsg)
      rpc :ForwardToGateway, GatewayMsg, Response
    end

    Stub = Service.rpc_stub_class
  end
end
