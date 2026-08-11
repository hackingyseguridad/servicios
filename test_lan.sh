#!/bin/bash
# test de velocidad LAN, en un mismo script lando servidor y test 
# requiere abrir un puerto en el lado servidor , por ejemplo 9999 
# en el lado servidor p.ej.:   sh test_lan.sh  sh test2.sh -s 9999 99999999
# en la lado clinete p.ej.: sh test_lan.sh -c 192.168.1.250 9999 9999999
# nos dara en el resumen la velodaidad en  MB/s y Mbps
# (R) hackingyseguridad.com 2025

PORT=${1:-9999}
DURATION=${2:-10}
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

show_help() {
    echo "Uso: $0 [OPCION]"
    echo "  -s [PUERTO] [DURACION]  - Modo servidor"
    echo "  -c IP [PUERTO] [DURACION] - Modo cliente"
    echo "  -h  - Ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0 -s 9999 30           # Servidor"
    echo "  $0 -c 192.168.1.250 9999 30  # Cliente"
}

check_connection() {
    local ip=$1
    local port=$2

    echo -e "${YELLOW}[CHECK] Verificando conectividad...${NC}"

    # 1. Verificar ping
    if ping -c 1 -W 2 $ip >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Ping a $ip exitoso${NC}"
    else
        echo -e "${RED}✗ No hay respuesta ping a $ip${NC}"
        echo -e "${YELLOW}  ¿El equipo está encendido y en la misma red?${NC}"
        return 1
    fi

    # 2. Verificar puerto
    if nc -zv -w 3 $ip $port 2>/dev/null; then
        echo -e "${GREEN}✓ Puerto $port está abierto en $ip${NC}"
        return 0
    else
        echo -e "${RED}✗ Puerto $port no accesible en $ip${NC}"
        echo -e "${YELLOW}  Posibles causas:${NC}"
        echo -e "${YELLOW}  1. El servidor no está ejecutándose${NC}"
        echo -e "${YELLOW}  2. Firewall bloqueando el puerto${NC}"
        echo -e "${YELLOW}  3. IP incorrecta${NC}"
        echo -e ""
        echo -e "${YELLOW}  En el servidor ejecuta:${NC}"
        echo -e "${GREEN}  nc -l -p $port${NC}"
        echo -e "${YELLOW}  O usa el script con -s:${NC}"
        echo -e "${GREEN}  $0 -s $port${NC}"
        return 1
    fi
}

run_server() {
    echo -e "${GREEN}[SERVER] Iniciando en puerto $PORT${NC}"
    echo -e "${YELLOW}[SERVER] Esperando conexión desde el cliente...${NC}"
    echo -e "${YELLOW}[SERVER] Presiona Ctrl+C para detener${NC}"
    echo ""

    # Mostrar IPs disponibles
    echo -e "${BLUE}IPs disponibles:${NC}"
    ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | while read ip; do
        echo -e "  ${GREEN}$ip${NC}"
    done
    echo ""

    # Servidor con timeout
    timeout $DURATION nc -l -p $PORT > /dev/null

    if [ $? -eq 124 ]; then
        echo -e "${GREEN}[SERVER] Prueba completada (tiempo expirado)${NC}"
    else
        echo -e "${GREEN}[SERVER] Servidor finalizado${NC}"
    fi
}

run_client() {
    local target_ip=$1
    
    echo -e "${GREEN}[CLIENT] Conectando a $target_ip:$PORT${NC}"
    echo ""

    # Verificar conexión antes de empezar
    if ! check_connection $target_ip $PORT; then
        exit 1
    fi

    # Limitar duración máxima
    if [ $DURATION -gt 3600 ]; then
        echo -e "${YELLOW}⚠️ Duración muy larga, limitando a 60 segundos${NC}"
        DURATION=60
    fi
    
    # Si la duración es muy corta, usar mínimo 5 segundos
    if [ $DURATION -lt 5 ]; then
        echo -e "${YELLOW}⚠️ Duración muy corta, usando 5 segundos${NC}"
        DURATION=5
    fi

    # Usar menos datos para evitar problemas de memoria
    DATA_SIZE_MB=$((DURATION * 10))
    
    echo ""
    echo -e "${YELLOW}[CLIENT] Iniciando prueba de $DURATION segundos...${NC}"
    echo -e "${YELLOW}[CLIENT] Enviando ${DATA_SIZE_MB}MB de datos...${NC}"
    echo ""

    # Medir tiempo
    START_TIME=$(date +%s)
    
    # Enviar datos (usar /dev/zero para evitar problemas de rendimiento)
    dd if=/dev/zero bs=1M count=$DATA_SIZE_MB 2>/dev/null | nc $target_ip $PORT > /dev/null 2>&1
    
    END_TIME=$(date +%s)
    TOTAL_TIME=$((END_TIME - START_TIME))
    
    # Si el tiempo es 0, usar 1
    if [ $TOTAL_TIME -eq 0 ]; then
        TOTAL_TIME=1
    fi
    
    # Calcular velocidad (entero)
    SPEED_MB_S=$((DATA_SIZE_MB / TOTAL_TIME))
    
    # Calcular decimales manualmente
    SPEED_DECIMAL=$(( (DATA_SIZE_MB * 100) / TOTAL_TIME - SPEED_MB_S * 100 ))
    if [ $SPEED_DECIMAL -lt 10 ]; then
        SPEED_DECIMAL="0${SPEED_DECIMAL}"
    fi
    
    # Calcular Mbps
    SPEED_MBPS=$((SPEED_MB_S * 8))
    SPEED_MBPS_DECIMAL=$((SPEED_DECIMAL * 8))
    if [ $SPEED_MBPS_DECIMAL -ge 100 ]; then
        SPEED_MBPS_EXTRA=$((SPEED_MBPS_DECIMAL / 100))
        SPEED_MBPS=$((SPEED_MBPS + SPEED_MBPS_EXTRA))
        SPEED_MBPS_DECIMAL=$((SPEED_MBPS_DECIMAL - SPEED_MBPS_EXTRA * 100))
    fi
    if [ $SPEED_MBPS_DECIMAL -lt 10 ]; then
        SPEED_MBPS_DECIMAL="0${SPEED_MBPS_DECIMAL}"
    fi
    
    echo ""
    echo -e "${GREEN}=== RESUMEN DE PRUEBA ===${NC}"
    echo -e "📊 Tiempo total: ${YELLOW}${TOTAL_TIME}${NC} segundos"
    echo -e "📦 Datos enviados: ${YELLOW}${DATA_SIZE_MB}${NC} MB"
    echo -e "🚀 Velocidad: ${GREEN}${SPEED_MB_S}.${SPEED_DECIMAL} MB/s${NC}"
    echo -e "📈 Velocidad: ${BLUE}${SPEED_MBPS}.${SPEED_MBPS_DECIMAL} Mbps${NC}"
    
    # Interpretación
    echo ""
    echo -e "${BLUE}Interpretación:${NC}"
    
    # Usar velocidad en Mbps para comparación
    SPEED_COMPARE=$SPEED_MB_S
    
    if [ $SPEED_COMPARE -ge 1000 ]; then
        echo -e "${GREEN}✅🚀 EXCEPCIONAL (10Gbps+)${NC}"
    elif [ $SPEED_COMPARE -ge 100 ]; then
        echo -e "${GREEN}✅ Excelente (10Gbps)${NC}"
    elif [ $SPEED_COMPARE -ge 50 ]; then
        echo -e "${GREEN}✅ Muy buena (Gigabit+)${NC}"
    elif [ $SPEED_COMPARE -ge 10 ]; then
        echo -e "${GREEN}✅ Buena (Gigabit)${NC}"
    elif [ $SPEED_COMPARE -ge 1 ]; then
        echo -e "${YELLOW}⚠️ Aceptable (Fast Ethernet)${NC}"
    else
        echo -e "${RED}❌ Lenta - Verificar conexión${NC}"
    fi
    
    echo -e "${GREEN}========================${NC}"
}

# Main
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

MODE=""
TARGET_IP=""

while [ $# -gt 0 ]; do
    case "$1" in
        -s|--server)
            MODE="server"
            shift
            if [ $# -gt 0 ] && [ "$1" -eq "$1" ] 2>/dev/null; then
                PORT=$1
                shift
            fi
            if [ $# -gt 0 ] && [ "$1" -eq "$1" ] 2>/dev/null; then
                DURATION=$1
                shift
            fi
            ;;
        -c|--client)
            MODE="client"
            shift
            if [ $# -eq 0 ]; then
                echo "Error: Falta IP del servidor"
                show_help
                exit 1
            fi
            TARGET_IP=$1
            shift
            if [ $# -gt 0 ] && [ "$1" -eq "$1" ] 2>/dev/null; then
                PORT=$1
                shift
            fi
            if [ $# -gt 0 ] && [ "$1" -eq "$1" ] 2>/dev/null; then
                DURATION=$1
                shift
            fi
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Error: Opción desconocida: $1"
            show_help
            exit 1
            ;;
    esac
done

case "$MODE" in
    server)
        run_server
        ;;
    client)
        run_client $TARGET_IP
        ;;
    *)
        echo "Error: Debes especificar -s o -c"
        show_help
        exit 1
        ;;
esac
