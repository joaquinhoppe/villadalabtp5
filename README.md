# TP5 — Implementación de Redes Corporativas
### Instituto Técnico Salesiano Villada — Ciclo 2026
**Grupo 2 — Seguros del Centro S.A.**

---

## 📌 Guía de navegación del repositorio

Este repositorio contiene la entrega integral del Trabajo Práctico N°5, organizado en dos entornos complementarios:

| Componente | Descripción | Acceso Directo |
| :--- | :--- | :---: |
| 📄 **Informe Oficial** | Documento consolidado con la fundamentación teórica, direccionamiento VLSM, matrices de puertos y diseño de red. | [`tp5_Grupo2.pdf`](tp5_Grupo2.pdf) |
| 🔬 **Laboratorio Físico** | Guía maestra y validación empírica en hardware real (MikroTik hAP, Raspberry Pi, DHCP Failover, QoS y Netwatch). | [📂 Guía Laboratorio Físico](laboratorio-fisico/TP5_LAB_FISICO_GUIA_COMPLETA.md) |
| 💻 **Simulación GNS3** | Topología virtual multi-sitio (Casa Central, Sucursales, switches Cisco y MikroTik CHR). | [📂 Carpeta GNS3](gns3/) |
| ⚙️ **Configuraciones** | Scripts RouterOS (`.rsc`) utilizados en los routers virtuales de la simulación. | [📂 Ver Configuraciones](gns3/configs/) |
| 📸 **Evidencias GNS3** | Capturas de pantalla numeradas que verifican las consignas de la simulación virtual. | [📂 Ver Evidencias GNS3](gns3/imagenes/) |

> [!NOTE]
> **Proyecto ejecutable de GNS3:** El archivo [`tp5.gns3`](tp5.gns3) y la carpeta [`project-files/`](project-files/) se conservan juntos en la raíz del repositorio porque constituyen el proyecto ejecutable de GNS3 y sus dependencias de runtime asociadas (imágenes, discos y configuraciones de nodos).

---

## 🏛️ Estructura del proyecto

### 1. Laboratorio Físico (Hardware Real)
* **Objetivo:** Validación empírica de servicios de infraestructura en un entorno de hardware real y aislado.
* **Componentes:**
  * **MikroTik hAP ac lite:** Switching L2 con aislamiento de VLAN 80 (`ether2,3,4`), Gateway L3 `172.18.2.225/28`, uplink WAN Wi-Fi 4G (`wlan1`), NAT Masquerade, Simple Queue (2M/4M) y Netwatch con alertas por correo.
  * **Raspberry Pi 3B (`172.18.2.227`):** Servidor DHCP centralizado Primario con 10 scopes corporativos y clúster de alta disponibilidad.
  * **VM Linux (`172.18.2.228`):** Servidor DHCP Secundario en esquema de failover Primary/Secondary, sincronizado por TCP 647.
  * **Notebook Host (`172.18.2.229`):** Estación de administración con reserva estática determinística por MAC.
  * **Notebook Externa (`172.18.2.236`):** Cliente de prueba dinámico conectado en el puerto de acceso `ether4`.
  * **iPhone Hotspot:** Simulación de enlace WAN con salida real a Internet.
* **Documentación completa:** [`laboratorio-fisico/TP5_LAB_FISICO_GUIA_COMPLETA.md`](laboratorio-fisico/TP5_LAB_FISICO_GUIA_COMPLETA.md)

### 2. Simulación Corporativa (GNS3)
* **Objetivo:** Simulación de la topología corporativa completa de Seguros del Centro S.A.
* **Componentes:**
  * Switches multicapa Cisco (`SW-CC-MLS`, `SW-VA-MLS`, `SW-VCP-MLS`) y routers de sucursal.
  * Routers virtuales MikroTik CHR interconectados mediante troncal 802.1Q e interoperabilidad RSTP / PVST+.
  * Túnel VPN WireGuard sitio a sitio hacia VPS en la nube.
  * Políticas de DHCP Relay (`ip helper-address`), DHCP Snooping, BPDU Guard y listas de control de acceso (ACLs).
* **Archivos y capturas:** Ubicados en [`gns3/`](gns3/).
