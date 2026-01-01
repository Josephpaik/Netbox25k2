#!/bin/bash
#
# NetBox & MkDocs Server Startup Script
#
# Usage:
#   ./start.sh          # Start both servers
#   ./start.sh netbox   # Start NetBox only
#   ./start.sh docs     # Start MkDocs only
#   ./start.sh stop     # Stop all servers
#

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VENV_PYTHON="$SCRIPT_DIR/venv/bin/python"
VENV_MKDOCS="$SCRIPT_DIR/venv/bin/mkdocs"
NETBOX_DIR="$SCRIPT_DIR/netbox"
MKDOCS_CONFIG="$SCRIPT_DIR/mkdocs_ko.yml"

NETBOX_PORT=8000
MKDOCS_PORT=8001

# PID files
NETBOX_PID_FILE="/tmp/netbox_server.pid"
MKDOCS_PID_FILE="/tmp/mkdocs_server.pid"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_venv() {
    if [ ! -f "$VENV_PYTHON" ]; then
        print_error "Python venv not found at $VENV_PYTHON"
        print_status "Run: python3 -m venv venv && ./venv/bin/pip install -r requirements.txt"
        exit 1
    fi
}

start_netbox() {
    check_venv

    # Check if already running
    if [ -f "$NETBOX_PID_FILE" ] && kill -0 $(cat "$NETBOX_PID_FILE") 2>/dev/null; then
        print_warning "NetBox server is already running (PID: $(cat $NETBOX_PID_FILE))"
        return
    fi

    print_status "Starting NetBox server on http://127.0.0.1:$NETBOX_PORT ..."
    cd "$NETBOX_DIR"
    nohup "$VENV_PYTHON" manage.py runserver 0.0.0.0:$NETBOX_PORT > /tmp/netbox_server.log 2>&1 &
    echo $! > "$NETBOX_PID_FILE"
    sleep 2

    if kill -0 $(cat "$NETBOX_PID_FILE") 2>/dev/null; then
        print_status "NetBox server started (PID: $(cat $NETBOX_PID_FILE))"
        print_status "  - URL: http://127.0.0.1:$NETBOX_PORT"
        print_status "  - Log: /tmp/netbox_server.log"
    else
        print_error "Failed to start NetBox server. Check /tmp/netbox_server.log"
    fi
}

start_mkdocs() {
    check_venv

    # Check if already running
    if [ -f "$MKDOCS_PID_FILE" ] && kill -0 $(cat "$MKDOCS_PID_FILE") 2>/dev/null; then
        print_warning "MkDocs server is already running (PID: $(cat $MKDOCS_PID_FILE))"
        return
    fi

    print_status "Starting MkDocs server on http://127.0.0.1:$MKDOCS_PORT ..."
    cd "$SCRIPT_DIR"
    nohup "$VENV_MKDOCS" serve -f "$MKDOCS_CONFIG" -a 127.0.0.1:$MKDOCS_PORT > /tmp/mkdocs_server.log 2>&1 &
    echo $! > "$MKDOCS_PID_FILE"
    sleep 3

    if kill -0 $(cat "$MKDOCS_PID_FILE") 2>/dev/null; then
        print_status "MkDocs server started (PID: $(cat $MKDOCS_PID_FILE))"
        print_status "  - URL: http://127.0.0.1:$MKDOCS_PORT/ko/"
        print_status "  - Log: /tmp/mkdocs_server.log"
    else
        print_error "Failed to start MkDocs server. Check /tmp/mkdocs_server.log"
    fi
}

stop_servers() {
    print_status "Stopping servers..."

    if [ -f "$NETBOX_PID_FILE" ]; then
        if kill -0 $(cat "$NETBOX_PID_FILE") 2>/dev/null; then
            kill $(cat "$NETBOX_PID_FILE")
            print_status "NetBox server stopped"
        fi
        rm -f "$NETBOX_PID_FILE"
    else
        print_warning "NetBox server is not running"
    fi

    if [ -f "$MKDOCS_PID_FILE" ]; then
        if kill -0 $(cat "$MKDOCS_PID_FILE") 2>/dev/null; then
            kill $(cat "$MKDOCS_PID_FILE")
            print_status "MkDocs server stopped"
        fi
        rm -f "$MKDOCS_PID_FILE"
    else
        print_warning "MkDocs server is not running"
    fi
}

show_status() {
    echo ""
    echo "=== Server Status ==="

    if [ -f "$NETBOX_PID_FILE" ] && kill -0 $(cat "$NETBOX_PID_FILE") 2>/dev/null; then
        echo -e "NetBox:  ${GREEN}Running${NC} (PID: $(cat $NETBOX_PID_FILE)) - http://127.0.0.1:$NETBOX_PORT"
    else
        echo -e "NetBox:  ${RED}Stopped${NC}"
    fi

    if [ -f "$MKDOCS_PID_FILE" ] && kill -0 $(cat "$MKDOCS_PID_FILE") 2>/dev/null; then
        echo -e "MkDocs:  ${GREEN}Running${NC} (PID: $(cat $MKDOCS_PID_FILE)) - http://127.0.0.1:$MKDOCS_PORT/ko/"
    else
        echo -e "MkDocs:  ${RED}Stopped${NC}"
    fi
    echo ""
}

show_help() {
    echo "NetBox & MkDocs Server Management Script"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  (none)    Start both NetBox and MkDocs servers"
    echo "  netbox    Start NetBox server only"
    echo "  docs      Start MkDocs server only"
    echo "  stop      Stop all servers"
    echo "  status    Show server status"
    echo "  restart   Restart all servers"
    echo "  help      Show this help message"
    echo ""
    echo "Ports:"
    echo "  NetBox:   http://127.0.0.1:$NETBOX_PORT"
    echo "  MkDocs:   http://127.0.0.1:$MKDOCS_PORT/ko/"
}

# Main
case "$1" in
    netbox)
        start_netbox
        ;;
    docs|mkdocs)
        start_mkdocs
        ;;
    stop)
        stop_servers
        ;;
    status)
        show_status
        ;;
    restart)
        stop_servers
        sleep 1
        start_netbox
        start_mkdocs
        show_status
        ;;
    help|--help|-h)
        show_help
        ;;
    "")
        start_netbox
        start_mkdocs
        show_status
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
