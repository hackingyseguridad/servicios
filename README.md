# servicios

subrutinas, para instalar de forma automatica los servicios: SSHd, TelnetD, Apache web server, servidor VNC,  servidor RDP, servidor DNS Bind9, servidor Samba, NFS, SMTP postfix, OpenVAS ..

## Descripción

Este repositorio agrupa subrutinas independientes (una por servicio) que automatizan la instalación, arranque y habilitación en el inicio del sistema de los demonios de red más comunes: SSH, Telnet, Apache, DNS (Bind9 y dnsmasq), FTP, NFS, Samba, correo (Postfix), escritorio remoto (RDP/VNC), escáneres de vulnerabilidades (Nessus/OpenVAS) y scripts auxiliares de persistencia.

## Contenido del repositorio

### Servicios de acceso remoto

| Script | Servicio |
| --- | --- |
| `instalarssh.sh` | Instala y habilita el servidor SSH (`sshd`) |
| `instalartelnet.sh` | Instala y habilita el servidor Telnet |
| `instalarrdp.sh` | Instala y configura un servidor de escritorio remoto (RDP) |
| `instalarvnc.sh` | Instala un servidor VNC |
| `instalartigervnc.sh` | Instala un servidor VNC basado en TigerVNC |
| `finger.sh` | Instala y habilita el servicio Finger |

### Servicios web y DNS

| Script | Servicio |
| --- | --- |
| `instalarapache.sh` | Instala el servidor web Apache |
| `instalarapache2.sh` | Instala Apache2 (variante/alternativa del script anterior) |
| `httpd.sh` | Gestión/arranque del servicio HTTP |
| `instalarbind9.sh` | Instala y configura un servidor DNS con Bind9 |
| `instalardnsmasq.sh` | Instala y configura dnsmasq como servidor DNS/DHCP ligero |

### Ficheros, correo y directorio

| Script | Servicio |
| --- | --- |
| `instalarftpd` | Instala y habilita un servidor FTP |
| `instalarnfs.sh` | Instala y configura un servidor de ficheros NFS |
| `instalarsamba.sh` | Instala y configura un servidor Samba (compartición de ficheros SMB/CIFS) |
| `instalarpostfix.sh` | Instala y configura el servidor de correo SMTP Postfix |

### Auditoría y análisis de vulnerabilidades

| Script | Servicio |
| --- | --- |
| `instalarnessus.sh` | Instala el escáner de vulnerabilidades Nessus |
| `instalaropenvas.sh` | Instala la suite de análisis de vulnerabilidades OpenVAS |

### Persistencia y pruebas

| Script | Descripción |
| --- | --- |
| `persistencia.sh` | Script de ejemplo para técnicas de persistencia en entornos de laboratorio |
| `persistencia2.sh` | Variante adicional de técnicas de persistencia |
| `test.sh` | Script de pruebas |

### Otros

| Ruta | Descripción |
| --- | --- |
| `conf/` | Ficheros de configuración empleados por los distintos scripts de instalación |
| `LICENSE` | Licencia GPL-3.0 |

## Requisitos

- Distribución basada en **Debian** (Debian, Kali Linux, Ubuntu, etc.)
- Privilegios de administrador (`sudo`) para instalar paquetes y gestionar servicios (`systemctl`/`update-rc.d`)
- Conexión a Internet para la descarga de paquetes vía `apt-get`

## Uso

Clona el repositorio y da permisos de ejecución al script del servicio que quieras desplegar:

```bash
git clone https://github.com/hackingyseguridad/servicios.git
cd servicios
chmod +x instalarssh.sh
./instalarssh.sh
```

Cada script sigue el mismo patrón: instala el paquete correspondiente vía `apt-get`, arranca el servicio y lo habilita para que se inicie automáticamente en el arranque del sistema (`update-rc.d` / `systemctl enable`).

## Aviso legal y uso ético

Estos scripts están pensados para **entornos de laboratorio, formación y pruebas autorizadas** (pentesting, CTF, hardening, investigación en ciberseguridad). Algunos de ellos habilitan servicios inseguros por diseño (p. ej. Telnet, FTP sin cifrar) o técnicas de persistencia propias de escenarios de post-explotación.

No despliegues estos servicios en sistemas de producción ni en redes sin autorización expresa del propietario. El uso indebido de este material es responsabilidad exclusiva de quien lo ejecute.

## Licencia

Este proyecto se distribuye bajo licencia **GPL-3.0**. Consulta el fichero [`LICENSE`](LICENSE) para más detalles.

## Autor

[hackingyseguridad](https://github.com/hackingyseguridad) — [hackingyseguridad.com](http://www.hackingyseguridad.com/)

[www.hackingyseguridad.com](http://www.hackingyseguridad.com/)


## http://www.hackingyseguridad.com/

