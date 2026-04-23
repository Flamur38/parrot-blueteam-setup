# === Network analysis ===
alias sniff='sudo tcpdump -i any -n'
alias sniff-http='sudo tcpdump -i any -n port 80 or port 443'
alias sniff-dns='sudo tcpdump -i any -n port 53'
alias tshark-top='tshark -i any -q -z io,phs'
alias ports='ss -tulnp'
alias listen='ss -tlnp'

# === Wireshark ===
alias ws='wireshark &>/dev/null &'
alias ts='termshark'

# === Log analysis ===
alias jqp='jq -C . | less -R'
alias csvp='column -t -s,'
alias logs-auth='sudo tail -f /var/log/auth.log'
alias logs-sys='sudo tail -f /var/log/syslog'
alias logs-kern='sudo tail -f /var/log/kern.log'

# === CTF tools ===
alias hd='hexdump -C'
alias strings-all='strings -a'
alias exif='exiftool'
alias extract='binwalk -e'
alias entropy='binwalk -E'

# === Velociraptor ===
alias velociraptor='{{ tools_dir }}/velociraptor/velociraptor'

# === CyberChef ===
cyberchef() {
  xdg-open "{{ cyberchef_dir }}/CyberChef_"*.html 2>/dev/null || \
  firefox "{{ cyberchef_dir }}/CyberChef_"*.html 2>/dev/null &
}

# === Quick pcap analysis ===
pcap-summary() {
  local file="$1"
  if [[ -z "$file" ]]; then
    echo "Usage: pcap-summary <file.pcap>"
    return 1
  fi
  echo "[*] Protocol hierarchy:"
  tshark -r "$file" -q -z io,phs
  echo "\n[*] Top talkers:"
  tshark -r "$file" -q -z conv,ip
  echo "\n[*] DNS queries:"
  tshark -r "$file" -Y dns -T fields -e dns.qry.name 2>/dev/null | sort -u
}

# === Quick log search ===
logsearch() {
  local term="$1"
  local path="${2:-/var/log}"
  echo "[*] Searching for '$term' in $path"
  sudo grep -r --color=always "$term" "$path" 2>/dev/null | less -R
}
