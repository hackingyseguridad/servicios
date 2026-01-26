##
# Instalar y configurar DNSmasq
# Config de ejemplo para suplantar dominio 
# hackingyseguridad.com 2026
##

# Instalar 
apt-get install dnsmasq

# Configuracion para suplantar p.ej. DNS google.com 

cat > /tmp/dnsmasq.conf << EOF
# Interface y puerto
interface=eth0
listen-address=127.0.0.1
port=53
# Respuestas A
address=/google.com/127.0.0.1
address=/mail.google.com/127.0.0.1
# Registros TXT para email security
txt-record=google.com,"v=spf1 include:_spf.google.com ~all"
txt-record=_spf.google.com,"v=spf1 ip4:64.233.160.0/19 ip4:66.102.0.0/20 ip4:66.249.80.0/20 ~all"
txt-record=_dmarc.google.com,"v=DMARC1; p=none; rua=mailto:dmarc-reports@google.com"
txt-record=selector1._domainkey.google.com,"v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC4Ff+FZy1Fw..."
# Registros MX
mx-host=google.com,mail.google.com,10
EOF

# Ejecutar dnsmasq con la config anterior!
sudo dnsmasq -C /tmp/dnsmasq.conf --no-daemon

# arrancar servicio!
service dnsmasq start



