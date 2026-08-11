#!/bin/bash
# test de velocidad LAN, en un mismo script lando servidor y test 
# requiere abrir un puerto en el lado servidor , por ejemplo 9999 
# en el lado servidor p.ej.:   sh test_lan.sh  sh test2.sh -s 9999 99999999
# en la lado clinete p.ej.: sh test_lan.sh -c 192.168.1.250 9999 9999999
# nos dara en el resumen la velodaidad en  MB/s y Mbps
# (R) hackingyseguridad.com 2025

#!/bin/bash
# speedtest-real.sh - Test de velocidad REAL para redes

PORT=${1:-9999}
DURATION=${2:-10}
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

run_server() {
    echo -e "${GREEN}[SERVER] Iniciando en puerto $PORT${NC}"
    echo -e "${YELLOW}[SERVER] Servidor activo por $DURATION segundos...${NC}"
    echo ""
    
    # Mostrar IP
    MY_IP=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -1)
    echo -e "${BLUE}Tu IP: ${GREEN}$MY_IP${NC}"
    echo -e "${YELLOW}Cliente debe conectar a: $MY_IP:$PORT${NC}"
    echo ""
    echo -e "${YELLOW}Esperando conexión...${NC}"
    
    # Servidor que recibe datos y los descarta
    # -q 0: cierra inmediatamente después de que el cliente se desconecte
    nc -l -p $PORT -q 1 > /dev/null 2>&1 &
    SERVER_PID=$!
    
    # Esperar la duración especificada
    sleep $DURATION
    
    # Terminar servidor
    kill $SERVER_PID 2>/dev/null
    echo -e "${GREEN}[SERVER] Prueba completada${NC}"
}

run_client() {
    local target_ip=$1
    local total_bytes=0
    local real_time=0
    
    echo -e "${GREEN}[CLIENT] Conectando a $target_ip:$PORT${NC}"
    echo ""
    
    # Verificar conexión
    echo -e "${YELLOW}[CHECK] Verificando servidor...${NC}"
    if ! nc -zv -w 3 $target_ip $PORT 2>/dev/null; then
        echo -e "${RED}✗ No se puede conectar al servidor${NC}"
        echo -e "${YELLOW}Asegúrate de ejecutar primero: $0 -s $PORT${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Servidor disponible${NC}"
    echo ""
    
    # Limitar duración para pruebas reales
    if [ $DURATION -gt 60 ]; then
        echo -e "${YELLOW}⚠️ Limitando duración a 60 segundos${NC}"
        DURATION=60
    elif [ $DURATION -lt 5 ]; then
        echo -e "${YELLOW}⚠️ Usando duración mínima de 5 segundos${NC}"
        DURATION=5
    fi
    
    # Calcular tamaño total (10MB/s para asegurar saturación)
    TOTAL_MB=$((DURATION * 10))
    TOTAL_BYTES=$((TOTAL_MB * 1048576))
    
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}📡 Prueba de velocidad REAL${NC}"
    echo -e "   Duración: ${BLUE}$DURATION segundos${NC}"
    echo -e "   Datos a enviar: ${BLUE}${TOTAL_MB} MB${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${YELLOW}Enviando datos...${NC}"
    
    # Crear archivo temporal con datos reales (no comprimibles)
    # Usar /dev/urandom para datos realistas
    TEMP_FILE="/tmp/speedtest_$$.dat"
    dd if=/dev/urandom of=$TEMP_FILE bs=1M count=$TOTAL_MB 2>/dev/null
    
    # Medir tiempo REAL de transferencia
    START_TIME=$(date +%s.%N)
    
    # Enviar archivo y medir tiempo
    nc $target_ip $PORT < $TEMP_FILE 2>/dev/null
    
    END_TIME=$(date +%s.%N)
    
    # Calcular tiempo real
    if command -v bc &> /dev/null; then
        REAL_TIME=$(echo "$END_TIME - $START_TIME" | bc)
        # Limitar a 2 decimales
        REAL_TIME=$(printf "%.2f" $REAL_TIME)
    else
        # Fallback si no hay bc
        END_INT=$(date +%s)
        START_INT=$(date +%s)
        REAL_TIME=$((END_INT - START_INT))
        if [ $REAL_TIME -eq 0 ]; then
            REAL_TIME=1
        fi
    fi
    
    # Limpiar archivo temporal
    rm -f $TEMP_FILE
    
    # Calcular velocidad REAL
    if command -v bc &> /dev/null; then
        # Velocidad en MB/s
        SPEED_MB=$(echo "scale=2; $TOTAL_MB / $REAL_TIME" | bc)
        # Velocidad en Mbps
        SPEED_MBPS=$(echo "scale=2; $SPEED_MB * 8" | bc)
        # Velocidad en KB/s para conexiones lentas
        SPEED_KB=$(echo "scale=0; $SPEED_MB * 1024" | bc)
    else
        # Cálculo entero sin bc
        REAL_TIME_INT=${REAL_TIME%.*}
        if [ -z "$REAL_TIME_INT" ] || [ "$REAL_TIME_INT" -eq 0 ]; then
            REAL_TIME_INT=1
        fi
        SPEED_MB=$((TOTAL_MB / REAL_TIME_INT))
        SPEED_MBPS=$((SPEED_MB * 8))
        SPEED_KB=$((SPEED_MB * 1024))
    fi
    
    # Mostrar resultados
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}           📊 RESULTADOS REALES${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "⏱️  Tiempo real: ${YELLOW}${REAL_TIME} segundos${NC}"
    echo -e "📦 Datos enviados: ${YELLOW}${TOTAL_MB} MB${NC}"
    echo -e "🚀 Velocidad: ${GREEN}${SPEED_MB} MB/s${NC}"
    echo -e "📈 Velocidad: ${BLUE}${SPEED_MBPS} Mbps${NC}"
    
    # Mostrar en KB/s si es lento
    if [ $(echo "$SPEED_MB < 1" | bc 2>/dev/null || echo "0") -eq 1 ]; then
        echo -e "📉 Velocidad: ${YELLOW}${SPEED_KB} KB/s${NC}"
    fi
    
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}📌 INTERPRETACIÓN PARA WIFI/LAN:${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Convertir a entero para comparar
    SPEED_INT=$(echo "$SPEED_MB" | cut -d. -f1)
    if [ -z "$SPEED_INT" ]; then
        SPEED_INT=0
    fi
    
    # Interpretación realista
    if [ $SPEED_INT -ge 100 ]; then
        echo -e "${GREEN}✅ EXCELENTE (${SPEED_MBPS} Mbps)${NC}"
        echo -e "   Velocidad de Gigabit Ethernet"
        echo -e "   Ideal para: Transferencias masivas, 4K/8K"
    elif [ $SPEED_INT -ge 50 ]; then
        echo -e "${GREEN}✅ MUY BUENA (${SPEED_MBPS} Mbps)${NC}"
        echo -e "   Velocidad de WiFi 6 o Gigabit"
        echo -e "   Ideal para: Gaming, streaming 4K"
    elif [ $SPEED_INT -ge 25 ]; then
        echo -e "${GREEN}✅ BUENA (${SPEED_MBPS} Mbps)${NC}"
        echo -e "   Velocidad de WiFi 5 (AC) buena señal"
        echo -e "   Ideal para: Streaming HD, trabajo remoto"
    elif [ $SPEED_INT -ge 10 ]; then
        echo -e "${YELLOW}⚠️ ACEPTABLE (${SPEED_MBPS} Mbps)${NC}"
        echo -e "   Velocidad de WiFi 4 (N) o WiFi 5 lejos"
        echo -e "   Ideal para: Navegación, YouTube HD"
    elif [ $SPEED_INT -ge 5 ]; then
        echo -e "${YELLOW}⚠️ REGULAR (${SPEED_MBPS} Mbps)${NC}"
        echo -e "   Velocidad WiFi baja o con interferencia"
        echo -e "   Puede tener problemas con video HD"
    elif [ $SPEED_INT -ge 1 ]; then
        echo -e "${RED}❌ LENTO (${SPEED_MBPS} Mbps)${NC}"
        echo -e "   Velocidad muy baja para uso moderno"
    else
        echo -e "${RED}❌ MUY LENTO (${SPEED_KB} KB/s)${NC}"
        echo -e "   Conexión extremadamente lenta"
    fi
    
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}💡 RECOMENDACIONES:${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if [ $SPEED_INT -ge 50 ]; then
        echo -e "${GREEN}✓ Excelente rendimiento para cualquier uso${NC}"
        echo -e "${GREEN}✓ Disfruta de tu conexión de alta velocidad${NC}"
    elif [ $SPEED_INT -ge 25 ]; then
        echo -e "${GREEN}✓ Buen rendimiento para la mayoría de usos${NC}"
        echo -e "${YELLOW}• Para gaming: Conecta por cable si es posible${NC}"
    elif [ $SPEED_INT -ge 10 ]; then
        echo -e "${YELLOW}• Considera mejorar la señal WiFi${NC}"
        echo -e "${YELLOW}• Acércate al router o cambia de canal${NC}"
        echo -e "${YELLOW}• Para gaming: Usa cable Ethernet${NC}"
    else
        echo -e "${RED}• ¡Conecta por cable Ethernet!${NC}"
        echo -e "${RED}• Revisa interferencias WiFi${NC}"
        echo -e "${RED}• Cambia de canal WiFi (1, 6, 11)${NC}"
        echo -e "${RED}• Considera un repetidor WiFi${NC}"
    fi
    
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}Prueba completada ✓${NC}"
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
