# Arquitectura Terraform - Flota de Vehículos

Proyecto de infraestructura en Azure utilizando Terraform para la gestión de una flota de vehículos blindados con análisis de datos en tiempo real.

## 📋 Descripción del Proyecto

Este proyecto implementa una infraestructura completa en Azure usando Terraform para una empresa de seguridad y logística que lanza una aplicación de renta de vehículos blindados. La plataforma debe:

✅ Gestionar operaciones en tiempo real: reservas, contratos y estado de la flota
✅ Permitir analítica avanzada sin afectar las operaciones transaccionales
✅ Soportar dos cargas de trabajo separadas: OLTP (operacional) y OLAP (analítica)

## 🏗️ Diagrama de Arquitectura

![Arquitectura Terraform Flota Vehiculos](./images/arquitecturaTerraform.png)

---

## 📖 Guía Paso a Paso: Implementación del Proyecto

### Checklist de Preparación

Antes de comenzar, debemos tener instalado:

- ✅ Cuenta de Azure con suscripción activa
- ✅ Azure CLI instalado y configurado
- ✅ Terraform instalado (versión 1.0+)
- ✅ Git instalado
- ✅ Cuenta de GitHub
- ✅ Editor de código (VS Code recomendado)

---

## 🏛️ Justificación de Servicios

### Requisito 1: Base de Datos Transaccional
**Servicio:** Azure SQL Database

Base de datos relacional completamente administrada con alta disponibilidad (SLA 99.99%), escalado automático, respaldos integrados y baja latencia. Ideal para operaciones transaccionales de reservas y contratos en tiempo real.

### Requisito 2: Almacenamiento Analítico
**Servicio:** Azure Data Lake Storage Gen2 (ADLS Gen2)

Almacenamiento optimizado para Big Data con soporte nativo para archivos JSON, particionamiento jerárquico y alto rendimiento para análisis batch. Integración directa con servicios de procesamiento como Databricks y Synapse.

### Requisito 3: Orquestación de Datos
**Servicio:** Azure Data Factory

Servicio ETL/ELT serverless diseñado específicamente para pipelines batch programados. Permite copiar datos de SQL a Data Lake con transformaciones, monitoreo integrado y triggers temporales sin gestionar infraestructura.

### Requisito 4: Plataforma de Análisis
**Servicio:** Azure Databricks

Plataforma de análisis colaborativa con notebooks, soporte completo para Apache Spark, ideal para procesar telemetría compleja en JSON y realizar análisis avanzados de patrones de uso y rentabilidad.

### Requisito 5: Gestión de Secretos
**Servicio:** Azure Key Vault

Almacén seguro centralizado para credenciales, cadenas de conexión y secretos. Control de acceso mediante RBAC, auditoría completa e integración nativa con todos los servicios Azure.

---

## 📸 Evidencia de Despliegue

### 1️⃣ Comprobación de Cambios (terraform plan)

![Comprobacion de cambios](./images/Imagen2.png)

En esta captura se realiza la comprobación de los últimos cambios. Se muestra el resultado del comando `terraform plan`, que detalla todos los cambios finales a implementar para la arquitectura desplegada en Azure.

---

### 2️⃣ Ejecución de Apply (terraform apply)

![Ejecucion de Apply](./images/Imagen3.png)

Aquí se ejecuta la orden `terraform apply` para desplegar los cambios hacia Azure. La terminal muestra:
- ✅ La orden está formada y lista
- ⏳ Solicita confirmación (respuesta: `yes`)
- 📋 Breve descripción de los cambios que se realizarán
- 🔄 Qué servicios se modificarán y aplicarán en la estructura

---

### 3️⃣ Confirmación de Éxito (Apply Completado)

![Exito de Apply](./images/Imagen4.png)

Confirmación desde los servidores de Azure de que los cambios se completaron exitosamente. Se muestra:
- ✅ Estado: **Completado**
- 📊 Tipos de cambios realizados
- ⏱️ **Tiempo total:** 2 minutos 30 segundos (Databricks tardó ~10 minutos)

---

### 4️⃣ Verificación en Azure Portal

![Azure](./images/Imagen5.png)

Confirmación visual desde la GUI de Azure. Se verifica que:
- ✅ Todos los servicios se desplegaron exitosamente
- 📦 Los recursos configurados en Terraform están presentes
- 🏢 La arquitectura completa está operativa en Azure


## 💭 Reflexiones Finales

### 1. Desafío Mayor: Dependencias Implícitas en Terraform

**Problema identificado:**  
Terraform creó Key Vault antes que SQL Database, pero intentó almacenar el `sql-connection-string` simultáneamente, causando un error de "secret cannot be created before vault is ready".

**Solución implementada:**  
Agregué `depends_on = [azurerm_key_vault.kv]` en todos los secretos para forzar la secuencia:
1. Key Vault se crea completamente
2. SQL Database se crea
3. Secretos se almacenan

**Lección aprendida:**  
Aunque Terraform infiere dependencias de variables (`azurerm_key_vault.kv.id`), las operaciones asíncronas de Azure pueden requerir dependencias explícitas para garantizar que el recurso esté "completamente listo".

### 2. Separación OLTP/OLAP en Alquiler de Vehículos

**¿Por qué separar?**

| Aspecto | OLTP (SQL Database) | OLAP (Data Lake + Databricks) |
|---------|---------------------|-------------------------------|
| **Tipo de consultas** | Transacciones puntuales (INSERT/UPDATE) | Agregaciones complejas (GROUP BY, JOINs masivos) |
| **Latencia** | Milisegundos | Segundos/minutos |
| **Volumen de datos** | Registros actuales (últimos 6 meses) | Históricos completos (años) |
| **Usuarios** | Sistema de reservas (miles de req/s) | Analistas (5-10 usuarios) |


# 🚗 Plataforma de Alquiler de Vehículos Blindados - Terraform Project

![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

## 📋 Tabla de Contenidos

- [Descripción del Proyecto](#-descripción-del-proyecto)
- [Arquitectura de la Solución](#-arquitectura-de-la-solución)
- [Justificación de Servicios](#-justificación-de-servicios-azure)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Requisitos Previos](#-requisitos-previos)
- [Instrucciones de Despliegue](#-instrucciones-de-despliegue)
- [Evidencias de Despliegue](#-evidencias-de-despliegue)
- [Reflexiones Finales](#-reflexiones-finales)
- [Recursos y Referencias](#-recursos-y-referencias)

---

## 📖 Descripción del Proyecto

Este proyecto implementa una **infraestructura completa en Azure** usando **Terraform** para una empresa de seguridad y logística que lanza una aplicación de renta de vehículos blindados. La plataforma debe:

- ✅ Gestionar operaciones en tiempo real: reservas, contratos y estado de la flota
- ✅ Permitir analítica avanzada sin afectar las operaciones transaccionales
- ✅ Soportar dos cargas de trabajo separadas: **OLTP** (operacional) y **OLAP** (analítica)

---

## 🏗️ Arquitectura de la Solución

### Diagrama de Arquitectura

![Arquitectura](./diagrams/arquitectura-completa.svg)

### Componentes Principales

| Capa | Servicio Azure | Propósito |
|------|---------------|-----------|
| **OLTP** | Azure SQL Database | Base transaccional de alta disponibilidad |
| **OLAP** | Azure Data Lake Gen2 | Almacenamiento de históricos y telemetría |
| **Orquestación** | Azure Data Factory | Pipeline ETL batch programado |
| **Análisis** | Azure Databricks | Notebooks con Apache Spark |
| **Seguridad** | Azure Key Vault | Gestión centralizada de secretos |

### Flujo de Datos

```
┌─────────────────┐        ┌──────────────────┐        ┌─────────────────┐
│  Azure SQL DB   │──ETL──>│  Data Factory    │──Load─>│  Data Lake Gen2 │
│     (OLTP)      │        │   (Batch Job)    │        │     (OLAP)      │
└─────────────────┘        └──────────────────┘        └─────────────────┘
                                                                 │
                                                                 ▼
                                                        ┌─────────────────┐
                                                        │   Databricks    │
                                                        │   (Analytics)   │
                                                        └─────────────────┘
                           ┌──────────────────┐
                           │   Key Vault      │◄─────── Todos los servicios
                           │   (Secrets)      │         consultan secretos
                           └──────────────────┘
```

---

## 🎯 Justificación de Servicios Azure

### **Requisito 1: Base de Datos Transaccional**

**Servicio:** `Azure SQL Database`

**Justificación:**
- ✅ **Alta disponibilidad:** SLA de 99.99% con respaldos automáticos
- ✅ **Baja latencia:** Optimizada para operaciones CRUD transaccionales
- ✅ **Escalabilidad:** Permite ajustar DTUs según demanda
- ✅ **Seguridad:** Cifrado en tránsito y reposo, firewall integrado
- ✅ **Compatibilidad:** Soporte completo para SQL Server estándar

**Alternativas consideradas:**
- MySQL/PostgreSQL: Menor integración con el ecosistema Azure
- Cosmos DB: Sobrecosto para un modelo relacional estándar

---

### **Requisito 2: Almacenamiento Analítico**

**Servicio:** `Azure Data Lake Storage Gen2`

**Justificación:**
- ✅ **Optimizado para Big Data:** Diseñado para análisis masivos con Spark/Hadoop
- ✅ **Soporte JSON nativo:** Ideal para logs de telemetría sin transformaciones
- ✅ **Particionamiento jerárquico:** Organización eficiente de históricos
- ✅ **Integración perfecta:** Conexión directa con Databricks y Data Factory
- ✅ **Costo-efectivo:** Tier de acceso esporádico para datos históricos

**Alternativas consideradas:**
- Blob Storage estándar: Sin optimizaciones para análisis distribuido
- Azure Synapse (solo): Sobrecosto si no se requiere DWH completo

---

### **Requisito 3: Orquestación de Datos**

**Servicio:** `Azure Data Factory`

**Justificación:**
- ✅ **Serverless:** Sin gestión de infraestructura subyacente
- ✅ **Conectores nativos:** Copy Activity optimizada para SQL → Data Lake
- ✅ **Programación integrada:** Triggers temporales con cron-like expressions
- ✅ **Monitoreo y alertas:** Dashboard visual para seguimiento de pipelines
- ✅ **Transformaciones:** Data Flow para limpieza y conversión de datos

**Ventajas sobre scripts manuales:**
1. **Resiliencia:** Reintentos automáticos ante fallos
2. **Escalabilidad:** Paralelización automática de copias
3. **Auditoría:** Logs detallados de cada ejecución
4. **Mantenibilidad:** GUI para modificar pipelines sin código

**Alternativas consideradas:**
- Cron job en VM: Requiere gestionar infraestructura y monitoreo
- Azure Functions: No optimizado para transferencias masivas de datos

---

### **Requisito 4: Plataforma de Análisis**

**Servicio:** `Azure Databricks`

**Justificación:**
- ✅ **Apache Spark nativo:** Procesamiento distribuido de telemetría compleja
- ✅ **Notebooks colaborativos:** Múltiples analistas trabajando simultáneamente
- ✅ **Librerías ML:** Scikit-learn, TensorFlow para modelos predictivos
- ✅ **Integración Delta Lake:** ACID transactions sobre Data Lake
- ✅ **Auto-escalado:** Clusters elásticos según carga de trabajo

**Casos de uso específicos:**
- Análisis de patrones de uso (clustering de comportamientos)
- Predicción de mantenimiento preventivo (modelos de ML)
- Optimización de rutas y rentabilidad por vehículo

**Alternativas consideradas:**
- HDInsight: Menor integración y requiere más configuración manual
- Azure Synapse Spark: Válido, pero Databricks tiene mejor UX para data science

---

### **Requisito 5: Gestión de Secretos**

**Servicio:** `Azure Key Vault`

**Justificación:**
- ✅ **Centralización:** Un único punto para todas las credenciales
- ✅ **Control de acceso:** RBAC granular por servicio/usuario
- ✅ **Auditoría completa:** Logs de quién accedió a qué secreto y cuándo
- ✅ **Integración nativa:** Todos los servicios Azure soportan Key Vault
- ✅ **Rotación automática:** Políticas de renovación de credenciales

**Secretos almacenados:**
- Connection strings de SQL Database
- Access keys de Data Lake
- URLs de Databricks
- Credenciales de servicios externos

---

## 📁 Estructura del Proyecto

```
terraform-vehiculos-blindados/
├── main.tf                  # Recursos principales
├── variables.tf             # Declaración de variables
├── outputs.tf               # Salidas del despliegue
├── terraform.tfvars         # Valores de variables (NO subir a GitHub)
├── .gitignore              # Excluye archivos sensibles
├── README.md               # Este archivo
└── diagrams/
    └── arquitectura-completa.svg
```

### Descripción de Archivos

- **`main.tf`**: Define todos los recursos Azure (SQL, Data Lake, Data Factory, Databricks, Key Vault)
- **`variables.tf`**: Declara variables reutilizables con tipos y descripciones
- **`outputs.tf`**: Expone información clave tras el despliegue (endpoints, nombres)
- **`terraform.tfvars`**: Valores concretos para cada variable (agregar a `.gitignore`)

---

## ⚙️ Requisitos Previos

1. **Azure CLI** instalado y configurado:
   ```bash
   az login
   az account set --subscription "<SUBSCRIPTION_ID>"
   ```

2. **Terraform** instalado (v1.0+):
   ```bash
   terraform --version
   ```

3. **Permisos en Azure:**
   - Contributor en la suscripción
   - Permisos para crear Service Principals (Key Vault)

---

## 🚀 Instrucciones de Despliegue

### Paso 1: Clonar el Repositorio

```bash
git clone https://github.com/TU_USUARIO/terraform-vehiculos-blindados.git
cd terraform-vehiculos-blindados
```

### Paso 2: Configurar Variables

Edita `terraform.tfvars` con tus valores:

```hcl
resource_group_name       = "rg-vehiculos-prod"
location                  = "eastus"
sql_server_name          = "sql-vehiculos-2025"
storage_account_name     = "datalakeveh2025"  # ¡Debe ser único globalmente!
```

### Paso 3: Inicializar Terraform

```bash
terraform init
```

### Paso 4: Validar Configuración

```bash
terraform validate
terraform plan
```

### Paso 5: Desplegar Infraestructura

```bash
terraform apply
```

Confirma escribiendo `yes` cuando se solicite.

### Paso 6: Verificar Outputs

```bash
terraform output
```

Ejemplo de salida:
```
databricks_workspace_url = "https://adb-123456789.10.azuredatabricks.net"
sql_server_fqdn = "sql-vehiculos-2025.database.windows.net"
```

---

## 📸 Evidencias de Despliegue

### 1. Salida Exitosa de `terraform apply`

![Terraform Apply](./screenshots/terraform-apply.png)

**Explicación:**  
Captura mostrando la creación exitosa de todos los recursos:
- 12 recursos agregados (`12 added`)
- 0 cambios o destrucciones
- Tiempo de ejecución: ~8 minutos

---

### 2. Resource Group en Azure Portal

![Azure Resource Group](./screenshots/azure-resource-group.png)

**Explicación:**  
Vista del Resource Group `rg-alquiler-vehiculos` conteniendo:
- ✅ SQL Server + Database
- ✅ Storage Account (Data Lake Gen2)
- ✅ Data Factory
- ✅ Databricks Workspace
- ✅ Key Vault

---

### 3. Azure SQL Database Funcionando

![SQL Database](./screenshots/sql-database.png)

**Explicación:**  
Base de datos `VehiculosDB` en tier S0 con:
- Estado: Online
- Firewall: Configurado para servicios Azure
- Backups: Automáticos cada 7 días

---

### 4. Data Lake Gen2 con Contenedores

![Data Lake](./screenshots/data-lake-containers.png)

**Explicación:**  
Storage Account con Hierarchical Namespace habilitado:
- Contenedor `historicos`: Para datos transaccionales históricos
- Contenedor `telemetria`: Para logs JSON de vehículos

---

### 5. Data Factory con Linked Services

![Data Factory](./screenshots/data-factory.png)

**Explicación:**  
Azure Data Factory configurado con:
- Managed Identity habilitada
- Linked Service a SQL Database
- Linked Service a Data Lake Gen2
- Permisos de escritura en Data Lake asignados

---

### 6. Databricks Workspace Activo

![Databricks](./screenshots/databricks-workspace.png)

**Explicación:**  
Workspace de Databricks con:
- Tier: Standard
- Estado: Running
- URL: Guardada en Key Vault para acceso seguro

---

### 7. Key Vault con Secretos Almacenados

![Key Vault](./screenshots/key-vault-secrets.png)

**Explicación:**  
Key Vault conteniendo:
- `sql-connection-string`: Cadena de conexión a SQL
- `datalake-access-key`: Access key del Data Lake
- `databricks-workspace-url`: URL del workspace

---

## 💭 Reflexiones Finales

### 1. Desafío Mayor: Dependencias Implícitas en Terraform

**Problema identificado:**  
Terraform creó Key Vault antes que SQL Database, pero intentó almacenar el `sql-connection-string` simultáneamente, causando un error de "secret cannot be created before vault is ready".

**Solución implementada:**  
Agregué `depends_on = [azurerm_key_vault.kv]` en todos los secretos para forzar la secuencia:
1. Key Vault se crea completamente
2. SQL Database se crea
3. Secretos se almacenan

**Lección aprendida:**  
Aunque Terraform infiere dependencias de variables (`azurerm_key_vault.kv.id`), las operaciones asíncronas de Azure pueden requerir dependencias explícitas para garantizar que el recurso esté "completamente listo".

**Otro ejemplo crítico:**  
Data Factory necesita su Managed Identity **antes** de asignar el rol `Storage Blob Data Contributor`. Usamos:
```hcl
resource "azurerm_role_assignment" "adf_storage_access" {
  principal_id = azurerm_data_factory.adf.identity[0].principal_id
  # Terraform espera automáticamente a que .identity esté disponible
}
```

---

### 2. Separación OLTP/OLAP en Alquiler de Vehículos

**¿Por qué separar?**

| Aspecto | OLTP (SQL Database) | OLAP (Data Lake + Databricks) |
|---------|---------------------|-------------------------------|
| **Tipo de consultas** | Transacciones puntuales (INSERT/UPDATE) | Agregaciones complejas (GROUP BY, JOINs masivos) |
| **Latencia** | Milisegundos | Segundos/minutos |
| **Volumen de datos** | Registros actuales (últimos 6 meses) | Históricos completos (años) |
| **Usuarios** | Sistema de reservas (miles de req/s) | Analistas (5-10 usuarios) |

**Ejemplo práctico: ¿Qué pasa si NO separamos?**

Imagina que un analista ejecuta esta consulta sobre la BD de reservas:

```sql
SELECT vehiculo_id, AVG(duracion_alquiler), SUM(ingresos)
FROM reservas
WHERE fecha BETWEEN '2020-01-01' AND '2024-12-31'
GROUP BY vehiculo_id;
```

**Consecuencias:**
- ❌ **Bloqueos de tabla:** La consulta analítica compite con INSERTs de nuevas reservas
- ❌ **Latencia en la app:** Clientes experimentan tiempos de respuesta de 5-10 segundos
- ❌ **Consumo de recursos:** El DTU del SQL Database se satura al 100%
- ❌ **Posibles timeouts:** La aplicación web lanza excepciones de conexión

**Con separación OLTP/OLAP:**
- ✅ Las consultas analíticas se ejecutan en Databricks sobre Data Lake (sin afectar SQL)
- ✅ El ETL nocturno (3 AM) copia datos cuando hay bajo tráfico de reservas
- ✅ La app de reservas mantiene latencias < 100ms consistentemente
- ✅ Los analistas pueden ejecutar queries de horas sin impactar operaciones

---

### 3. Importancia de Azure Data Factory vs Script Manual

**Escenario sin orquestación:**  
Un script Python con `cron` ejecutándose en una VM:

```python
# script_manual.py
import pyodbc
import os

conn = pyodbc.connect(os.getenv("SQL_CONN_STRING"))
cursor = conn.cursor()
cursor.execute("SELECT * FROM reservas WHERE fecha > '2024-01-01'")
# ... copiar a CSV y subir a Blob Storage ...
```

**Problemas de este enfoque:**

| Problema | Impacto | Solución con Data Factory |
|----------|---------|---------------------------|
| **Fallos silenciosos** | Si el script falla a las 3 AM, nadie se entera hasta que un analista reporta datos faltantes | Alertas automáticas por email/Teams |
| **Sin reintentos** | Una desconexión de red transitoria detiene todo | Retry logic con backoff exponencial |
| **No escalable** | Copiar 10M de registros toma 2 horas | Paralelización automática con Copy Activity |
| **Mantenimiento de VM** | Actualizaciones de SO, parches de seguridad, monitoreo | Servicio completamente serverless |
| **Sin auditoría** | ¿Cuántos registros se copiaron? ¿En qué momento falló? | Dashboard con logs detallados |
| **Credenciales en código** | Connection strings en variables de entorno o peor, hardcoded | Integración con Key Vault |




---

## 🔧 Configurar Azure CLI

```bash
# Instalar Azure CLI 
# Windows: https://aka.ms/installazurecliwindows
# macOS: brew install azure-cli
# Linux: curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Iniciar sesión
az login

# Verificar la suscripción
az account show

# Establecer la suscripción correcta
az account list --output table
az account set --subscription "NOMBRE_O_ID_DE_TU_SUSCRIPCION"
```

---

## 🚀 Instalar Terraform

```bash
# Verificar si ya está instalado
terraform --version

# Si no está instalado:
# Windows: Descargar de https://www.terraform.io/downloads
# macOS: brew install terraform
# Linux: 
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

---

## 📦 Clonar Repositorio

```bash
git clone https://github.com/MiltonAlvarado/arquitectura_terraform_flota_vehiculos.git
cd arquitectura_terraform_flota_vehiculos
```

---

## ⚙️ Personalizar Variables

Editar `terraform.tfvars` con los valores únicos que se tengan:

```hcl
resource_group_name = " "
location            = " "
sql_server_name     = " "
storage_account_name = " "  # Único globalmente!
data_factory_name    = " "
databricks_workspace_name = " "
key_vault_name       = " "  
```

**Nota importante:** El `storage_account_name` debe:
- Ser único en todo Azure
- Contener solo letras minúsculas y números
- Tener entre 3-24 caracteres

---

## 🚢 Desplegar Infraestructura

```bash
# 1. Inicializar Terraform
terraform init

# 2. Validar sintaxis
terraform validate

# 3. Ver qué se va a crear 
terraform plan

# 4. Desplegar recursos 
terraform apply

# Cuando pregunte "Do you want to perform these actions?"
# Respuesta: yes
```

---

## 📊 Estimación de Costos

Recursos corriendo 24/7:

| Servicio        | Tier                | Costo Mensual (aprox.) |
|:---|:---|:---|
| SQL Database S0 | 10 DTU              | ~$15 USD               |
| Storage Account | Standard LRS        | ~$5 USD                |
| Data Factory    | Sin pipeline activo | ~$1 USD                |
| Databricks      | Sin cluster activo  | ~$0 USD                |
| Key Vault       | Standard            | ~$1 USD                |
| **TOTAL**       | -                   | **~$22 USD/mes**       |

---

## 📝 Licencia

Este proyecto es de uso educativo.

---

## 👨‍💻 Autor

Proyecto creado como parte del programa de Sistemas Expertos.


#   T e r r a f o r m F l o t a A p p  
 