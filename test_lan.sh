#!/bin/bash
# speedtest-verified.sh - Versión corregida

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

    # Limitar duración máxima para evitar problemas
    if [ $DURATION -gt 3600 ]; then
        echo -e "${YELLOW}⚠️ Duración muy larga, limitando a 3600 segundos (1 hora)${NC}"
        DURATION=3600
    fi

    echo ""
    echo -e "${YELLOW}[CLIENT] Iniciando prueba de $DURATION segundos...${NC}"
    echo -e "${YELLOW}[CLIENT] Enviando datos...${NC}"

    # Datos a enviar (10MB por segundo)
    DATA_SIZE_MB=$((DURATION * 10))

    # Medir tiempo con segundos enteros
    START_TIME=$(date +%s)

    # Enviar datos
    dd if=/dev/zero bs=1M count=$DATA_SIZE_MB 2>/dev/null | nc $target_ip $PORT > /dev/null

    END_TIME=$(date +%s)
    TOTAL_TIME=$((END_TIME - START_TIME))

    # Si el tiempo es 0, usar 1 para evitar división por cero
    if [ $TOTAL_TIME -eq 0 ]; then
        TOTAL_TIME=1
    fi

    # Calcular velocidad usando división de enteros
    SPEED_MB_S=$((DATA_SIZE_MB / TOTAL_TIME))

    # Obtener decimales manualmente
    SPEED_DECIMAL=$(( (DATA_SIZE_MB * 100) / TOTAL_TIME - SPEED_MB_S * 100 ))
    if [ $SPEED_DECIMAL -lt 10 ]; then
        SPEED_DECIMAL="0${SPEED_DECIMAL}"
    fi

    echo ""
    echo -e "${GREEN}=== RESUMEN DE PRUEBA ===${NC}"
    echo -e "📊 Tiempo total: ${YELLOW}${TOTAL_TIME}${NC} segundos"
    echo -e "📦 Datos enviados: ${YELLOW}${DATA_SIZE_MB}${NC} MB"
    echo -e "🚀 Velocidad de transferencia: ${GREEN}${SPEED_MB_S}.${SPEED_DECIMAL} MB/s${NC}"

    # Calcular Mbps
    SPEED_MBPS=$((SPEED_MB_S * 8))
    echo -e "📈 Velocidad en Mbps: ${BLUE}${SPEED_MBPS}.${SPEED_DECIMAL}${NC} Mbps"

    # Interpretación
    echo ""
    echo -e "${BLUE}Interpretación de velocidad:${NC}"
    if [ $SPEED_MB_S -ge 100 ]; then
        echo -e "${GREEN}✅ Excelente - Red de alta velocidad${NC}"
    elif [ $SPEED_MB_S -ge 50 ]; then
        echo -e "${GREEN}✅ Muy buena - Red Gigabit${NC}"
    elif [ $SPEED_MB_S -ge 10 ]; then
        echo -e "${YELLOW}⚠️ Buena - Red Fast Ethernet${NC}"
    elif [ $SPEED_MB_S -ge 1 ]; then
        echo -e "${YELLOW}⚠️ Aceptable - Red de velocidad media${NC}"
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

