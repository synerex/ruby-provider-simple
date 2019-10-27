
require 'grpc'
require 'synerex_services_pb'
require 'nodeapi_services_pb'
require 'fleet_pb'
require 'optparse'
require 'logger'
require 'anyflake'
require 'google/protobuf/well_known_types'

include GRPC::Core::TimeConsts

# Globals Variables

$sxstub = nil
$nodeInfo = nil
$nodestub = nil
$threads = []
$updateCount = 0
$status = ""
$clientID = 0
$idgen = nil


module StdoutLogger
  def logger
    LOGGER
  end

  LOGGER = Logger.new(STDOUT)
end

GRPC.extend(StdoutLogger)

def make_Fleet(vehicle_id, status, lat, lon, angle, speed)
#  GRPC.logger.info("Start fleet")
  coord = Proto::Fleet::Fleet::Coord.new(lat: lat, lon: lon)
#  GRPC.logger.info("Make Coord #{coord.inspect}")
  mes = Proto::Fleet::Fleet.new(vehicle_id: vehicle_id,
                         status: status,
                         coord: coord,
                         angle: angle,
                         speed: speed,
                         services: nil,
                         demands: nil)

  GRPC.logger.info("Make fleet #{mes.inspect}")

  return mes
end


def do_notifyDemand(name,arg,msg)

  ts = Google::Protobuf::Timestamp.new
  p ts
  ts.from_time(Time.now)
  cdata = Api::Content.new(entity: msg)

  req = Api::Demand.new(id: generateIntID(),
                        sender_id: $clientID,
                        target_id: 0,
                        channel_type: 1,
                        demand_name: name,
                        ts: ts,
                        arg_json: arg,
                        mbus_id: 0,
                        cdata: cdata)
  
  GRPC.logger.info("NotifyDemand Call #{req.inspect}")
  resp = $sxstub.notify_demand(req)
  GRPC.logger.info("NotifyDemand Response #{resp.inspect}")
  
end

def keepAlive()
  while $nodeInfo['secret'] != 0 do
    sleep( $nodeInfo['keepalive_duration'])
    $updateCount += 1
    req = Nodeapi::NodeUpdate.new(node_id: $nodeInfo['node_id'],
                                  secret: $nodeInfo['secret'],
                                  update_count: $updateCount,
                                  node_status: 0,
                                  node_arg: $status)
    resp = $nodestub.keep_alive(req)
    GRPC.logger.info("Response #{resp.inspect}")
    
  end
end



def startKeepAlive()
  $threads << Thread.new { keepAlive() }
end



def do_registerNode(stub,name)
  GRPC.logger.info("Register Node")
  req = Nodeapi::NodeInfo.new(node_name: name,
                                node_type: Nodeapi::NodeType::PROVIDER,
                                server_info: "",
                                node_pbase_version: "0.1.1",
                                with_node_id: -1,
                                cluster_id: 0,
                                area_id: "Default",
                                channelTypes: [1])
  resp = stub.register_node(req)
  GRPC.logger.info("Answer: #{resp.inspect}")

  return resp
end

def generateIntID()
  return $idgen.next_id
end

def registerServ(nodesv,name)
  # connect to nodeserv
  $nodestub = Nodeapi::Node::Stub.new(nodesv, :this_channel_is_insecure, timeout: INFINITE_FUTURE)
  GRPC.logger.info(".. connecting insecurely on nodeserv #{nodesv}")
  $nodeInfo =  do_registerNode($nodestub,name)  # got server info
  
  service_epoch = Time.new(2010, 11, 4, 1, 42, 54).strftime('%s%L').to_i
  # may Twitter epoch of snowflake,
  # 1288834974657
  
  $idgen = AnyFlake.new(service_epoch, $nodeInfo.node_id)
  $clientID = generateIntID()
  
  GRPC.logger.info(".. connecting insecurely on synerex server to #{$nodeInfo['server_info']}")
  $sxstub = Api::Synerex::Stub.new($nodeInfo.server_info, :this_channel_is_insecure, timeout: INFINITE_FUTURE)

  startKeepAlive
    
end

# centrair

def getLat()
  latmin = 34.851
  latmax = 34.863
  
  rnd = rand(1000000)/100000.0
  lat = latmin + rnd*(latmax-latmin)
  return  lat
end

def getLon()
  lonmin = 136.808
  lonmax = 136.821

  rnd = rand(1000000)/100000.0
  lon = lonmin + rnd*(lonmax-lonmin)
  return  lon
end

def getAngle()
  

end

$fleets
$fleets_num

def do_generateRandomFleet(n)

  $fleets = []
  $fleets_num = n
  for i in 1..n
    $fleets << {
      vehicle_id: i,
      lat: getLat,
      lon: getLon,
      speed: 10,
      angle: 0
    }
  end
  GRPC.logger.info("Generated eet Move! #{$fleets}")
end

def do_fleetMove()
  GRPC.logger.info("Starting Fleet Move!")
  while true do
    for i in 1..$fleets_num
      f = $fleets[i-1]
      id = f.fetch(:vehicle_id)
      lat = f.fetch(:lat)
      lon= f.fetch(:lon)
      angle = f.fetch(:angle)
      speed =f.fetch(:speed)
      res = make_Fleet(id, 0, lat, lon, angle, speed)

      code = Proto::Fleet::Fleet.encode(res)
      do_notifyDemand("RandomFleet","{}",code)
    end
    sleep(3)
  end
end

  
def main
  options = {
    'nodeserv' => '127.0.0.1:9990'
  }

  OptionParser.new do |opts|
    opts.banner = 'Usage: [--nodeserv <hostname>:<port>]'
    opts.on('--nodeserv HOST', '<hostname>:<port>') do |v |
      options['nodeserv'] = v
    end
  end.parse!

  registerServ(options['nodeserv'],"Ruby-Provider")


  do_generateRandomFleet(10)
  
  
  #  $threads << Thread.new { do_fleetMove() }
  do_fleetMove() 
 

  $threads.each { |thr| thr.join}  #wait until all threads finished

end

main

