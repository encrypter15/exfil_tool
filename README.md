# Exfiltration Testing Tool

**Author:** encrypter15  
**Email:** encrypter15@gmail.com  
**Version:** 1.4  

## Description

This is a Ruby-based penetration testing exfiltration tool designed as a proof of concept for authorized security testing. It scans for open outbound ports on a target network, uses an AWS EC2 instance as a relay to surf the web (via HTTP/HTTPS), and demonstrates basic data exfiltration over HTTP. The tool leverages Nmap for port scanning, Net::HTTP for robust HTTP handling, and HTTParty for advanced proxying.

### Features
- **Port Scanning:** Uses ruby-nmap (if installed) or a fallback method to identify open ports.
- **Web Surfing:** Proxies HTTP/HTTPS requests through an AWS EC2 relay using Net::HTTP and HTTParty.
- **Data Exfiltration:** Proof-of-concept HTTP POST to exfiltrate data.
- **HTTPS Support:** Handles HTTPS URLs with SSL configuration.
- **Logging:** Logs all actions to `pentest.log` for persistence.
- **Error Handling:** Retries failed operations up to 3 times.

### Ethical Warning
**Authorized Use Only:** This tool should only be run in environments where you have explicit permission (e.g., your own network or a test lab).  
**Legal Compliance:** Penetration testing without consent is illegal in most jurisdictions.

## Installation

1. **Install Ruby:** Ensure Ruby is installed (`ruby -v`).
2. **Install Dependencies:**
   - Nmap: `sudo apt install nmap`
   - Gems: `gem install ruby-nmap httparty`
3. **Set Up AWS EC2 Relay:**
   - Launch an EC2 instance and configure a proxy (e.g., Squid) or netcat relay.
   - Update `AWS_RELAY` in the script with your EC2 public IP.

## Usage

```bash
ruby exfil_tool.rb <target_host> <web_url>
```

### Examples

1. **Scan ports and surf a website:**
   ```bash
   ruby $ exfil_tool.rb google.com https://example.com
   ```
   - Scans ports on google.com and proxies a request to https://example.com.

2. **Default run:**
   ```bash
   ruby exfil_tool.rb
   ```
   - Uses example.com and https://example.com as defaults.

## Output

Logs are written to `pentest.log`. Console output includes warnings, web responses, and status messages.

## FAQ

### Q: What if ruby-nmap or httparty isn’t installed?
**A:** The tool falls back to basic port scanning and skips advanced proxying, with warnings displayed.

### Q: How do I set up the EC2 relay for HTTPS?
**A:** Use Squid with SSL Bump or a similar proxy on port 8080. Update the security group to allow inbound traffic.

### Q: Why is SSL verification disabled?
**A:** For testing simplicity. In production, configure proper certificates on the relay.

### Q: Can I use a SOCKS prox# Exfiltration Testing Tool

**Author:** encrypter15  
**Email:** encrypter15@gmail.com  
**Version:** 1.4  

## Description

This is a Ruby-based penetration testing exfiltration tool designed as a proof of concept for authorized security testing. It scans for open outbound ports on a target network, uses an AWS EC2 instance as a relay to surf the web (via HTTP/HTTPS), and demonstrates basic data exfiltration over HTTP. The tool leverages Nmap for port scanning, Net::HTTP for robust HTTP handling, and HTTParty for advanced proxying.

### Features
- **Port Scanning:** Uses ruby-nmap (if installed) or a fallback method to identify open ports.
- **Web Surfing:** Proxies HTTP/HTTPS requests through an AWS EC2 relay using Net::HTTP and HTTParty.
- **Data Exfiltration:** Proof-of-concept HTTP POST to exfiltrate data.
- **HTTPS Support:** Handles HTTPS URLs with SSL configuration.
- **Logging:** Logs all actions to `pentest.log` for persistence.
- **Error Handling:** Retries failed operations up to 3 times.

### Ethical Warning
**Authorized Use Only:** This tool should only be run in environments where you have explicit permission (e.g., your own network or a test lab).  
**Legal Compliance:** Penetration testing without consent is illegal in most jurisdictions.

## Installation

1. **Install Ruby:** Ensure Ruby is installed (`ruby -v`).
2. **Install Dependencies:**
   - Nmap: `sudo apt install nmap`
   - Gems: `gem install ruby-nmap httparty`
3. **Set Up AWS EC2 Relay:**
   - Launch an EC2 instance and configure a proxy (e.g., Squid) or netcat relay.
   - Update `AWS_RELAY` in the script with your EC2 public IP.

## Usage

```bash
ruby exfil_tool.rb <target_host> <web_url>
```

### Examples

1. **Scan ports and surf a website:**
   ```bash
   ruby $ exfil_tool.rb google.com https://example.com
   ```
   - Scans ports on google.com and proxies a request to https://example.com.

2. **Default run:**
   ```bash
   ruby exfil_tool.rb
   ```
   - Uses example.com and https://example.com as defaults.

## Output

Logs are written to `pentest.log`. Console output includes warnings, web responses, and status messages.

## FAQ

### Q: What if ruby-nmap or httparty isn’t installed?
**A:** The tool falls back to basic port scanning and skips advanced proxying, with warnings displayed.

### Q: How do I set up the EC2 relay for HTTPS?
**A:** Use Squid with SSL Bump or a similar proxy on port 8080. Update the security group to allow inbound traffic.

### Q: Why is SSL verification disabled?
**A:** For testing simplicity. In production, configure proper certificates on the relay.

### Q: Can I use a SOCKS proxy instead?
**A:** Yes, set up a SOCKS5 server (e.g., Dante) on EC2 and use a Ruby SOCKS library like `socksify`.

## License

This tool is provided for educational purposes only. Use responsibly and legally.
y instead?
**A:** Yes, set up a SOCKS5 server (e.g., Dante) on EC2 and use a Ruby SOCKS library like `socksify`.

## License

This tool is provided for educational purposes only. Use responsibly and legally.
