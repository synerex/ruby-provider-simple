# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: synerex.proto

require 'google/protobuf'

require 'google/protobuf/timestamp_pb'
require 'google/protobuf/duration_pb'
Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("synerex.proto", :syntax => :proto3) do
    add_message "api.Response" do
      optional :ok, :bool, 1
      optional :err, :string, 2
    end
    add_message "api.ConfirmResponse" do
      optional :ok, :bool, 1
      optional :mbus_id, :fixed64, 2
      optional :wait, :message, 3, "google.protobuf.Duration"
      optional :err, :string, 4
    end
    add_message "api.Content" do
      optional :entity, :bytes, 1
    end
    add_message "api.Supply" do
      optional :id, :fixed64, 1
      optional :sender_id, :fixed64, 2
      optional :target_id, :fixed64, 3
      optional :channel_type, :uint32, 4
      optional :supply_name, :string, 5
      optional :ts, :message, 6, "google.protobuf.Timestamp"
      optional :arg_json, :string, 7
      optional :mbus_id, :fixed64, 8
      optional :cdata, :message, 9, "api.Content"
    end
    add_message "api.Demand" do
      optional :id, :fixed64, 1
      optional :sender_id, :fixed64, 2
      optional :target_id, :fixed64, 3
      optional :channel_type, :uint32, 4
      optional :demand_name, :string, 5
      optional :ts, :message, 6, "google.protobuf.Timestamp"
      optional :arg_json, :string, 7
      optional :mbus_id, :fixed64, 8
      optional :cdata, :message, 9, "api.Content"
    end
    add_message "api.Target" do
      optional :id, :fixed64, 1
      optional :sender_id, :fixed64, 2
      optional :target_id, :fixed64, 3
      optional :channel_type, :uint32, 4
      optional :wait, :message, 5, "google.protobuf.Duration"
      optional :mbus_id, :fixed64, 6
    end
    add_message "api.Channel" do
      optional :client_id, :fixed64, 1
      optional :channel_type, :uint32, 2
      optional :arg_json, :string, 3
    end
    add_message "api.Mbus" do
      optional :client_id, :fixed64, 1
      optional :mbus_id, :fixed64, 2
      optional :arg_json, :string, 3
    end
    add_message "api.MbusMsg" do
      optional :msg_id, :fixed64, 1
      optional :sender_id, :fixed64, 2
      optional :target_id, :fixed64, 3
      optional :mbus_id, :fixed64, 4
      optional :msg_type, :uint32, 5
      optional :msg_info, :string, 6
      optional :arg_json, :string, 7
    end
    add_message "api.GatewayInfo" do
      optional :client_id, :fixed64, 1
      optional :gateway_type, :enum, 2, "api.GatewayType"
      repeated :channels, :uint32, 3
    end
    add_message "api.GatewayMsg" do
      optional :src_synerex_id, :fixed64, 1
      optional :msg_type, :enum, 2, "api.MsgType"
      oneof :msg_oneof do
        optional :demand, :message, 3, "api.Demand"
        optional :supply, :message, 4, "api.Supply"
        optional :target, :message, 5, "api.Target"
        optional :mbus, :message, 6, "api.Mbus"
        optional :mbus_msg, :message, 7, "api.MbusMsg"
      end
    end
    add_enum "api.GatewayType" do
      value :BIDIRECTIONAL, 0
      value :WRITE_ONLY, 1
      value :READ_ONLY, 2
    end
    add_enum "api.MsgType" do
      value :DEMAND, 0
      value :SUPPLY, 1
      value :TARGET, 2
      value :MBUS, 3
      value :MBUSMSG, 4
    end
  end
end

module Api
  Response = Google::Protobuf::DescriptorPool.generated_pool.lookup("api.Response").msgclass
  ConfirmResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("api.ConfirmResponse").msgclass
  Content = Google::Protobuf::DescriptorPool.generated_pool.lookup("api.Content").msgclass
  Supply = Google::Protobuf::DescriptorPool.generated_pool.lookup("api.Supply").msgclass
  Demand = Google::Protobuf::DescriptorPool.generated_pool.lookup("api.Demand").msgclass
  Target = Google::Protobuf::DescriptorPool.generated_pool.lookup("api.Target").msgclass
  Channel = Google::Protobuf::DescriptorPool.generated_pool.lookup("api.Channel").msgclass
  Mbus = Google::Protobuf::DescriptorPool.generated_pool.lookup("api.Mbus").msgclass
  MbusMsg = Google::Protobuf::DescriptorPool.generated_pool.lookup("api.MbusMsg").msgclass
  GatewayInfo = Google::Protobuf::DescriptorPool.generated_pool.lookup("api.GatewayInfo").msgclass
  GatewayMsg = Google::Protobuf::DescriptorPool.generated_pool.lookup("api.GatewayMsg").msgclass
  GatewayType = Google::Protobuf::DescriptorPool.generated_pool.lookup("api.GatewayType").enummodule
  MsgType = Google::Protobuf::DescriptorPool.generated_pool.lookup("api.MsgType").enummodule
end
