
# 🚗 Arquitectura Terraform - Flota de Vehículos Blindados

Proyecto de infraestructura en Azure utilizando Terraform para la gestión de una flota de vehículos blindados con análisis de datos en tiempo real.

---

## 📋 Tabla de Contenidos

- [Descripción del Proyecto](#-descripción-del-proyecto)
- [Diagrama de Arquitectura](#-diagrama-de-arquitectura)
- [Justificación de Servicios](#-justificación-de-servicios)
- [Checklist de Preparación](#-checklist-de-preparación)
- [Guía de Instalación](#-guía-de-instalación)
- [Evidencia de Despliegue](#-evidencia-de-despliegue)
- [Reflexiones Finales](#-reflexiones-finales)
- [Estimación de Costos](#-estimación-de-costos)

---

## 📖 Descripción del Proyecto

Este proyecto implementa una infraestructura completa en Azure usando Terraform para una empresa de seguridad y logística que lanza una aplicación de renta de vehículos blindados.

### Objetivos

- ✅ Gestionar operaciones en tiempo real: reservas, contratos y estado de la flota  
- ✅ Permitir analítica avanzada sin afectar las operaciones transaccionales  
- ✅ Soportar dos cargas de trabajo separadas: **OLTP** (operacional) y **OLAP** (analítica)

---

## 🏗️ Diagrama de Arquitectura

![Arquitectura Terraform Flota Vehiculos](./images/arquitecturaTerraform.png)

---

## 🏛️ Justificación de Servicios

### Requisito 1: Base de Datos Transaccional

**Servicio:** Azure SQL Database

Base de datos relacional completamente administrada con:
- ✅ Alta disponibilidad (SLA 99.99%)
- ✅ Escalado automático
- ✅ Respaldos integrados
- ✅ Baja latencia para operaciones transaccionales
- ✅ Ideal para reservas y contratos en tiempo real

---

### Requisito 2: Almacenamiento Analítico

**Servicio:** Azure Data Lake Storage Gen2 (ADLS Gen2)

Almacenamiento optimizado para Big Data con:
- ✅ Soporte nativo para archivos JSON
- ✅ Particionamiento jerárquico
- ✅ Alto rendimiento para análisis batch
- ✅ Integración directa con Databricks y Synapse
- ✅ Ideal para históricos y telemetría

---

### Requisito 3: Orquestación de Datos

**Servicio:** Azure Data Factory

Servicio ETL/ELT serverless que permite:
- ✅ Pipelines batch programados
- ✅ Copiar datos de SQL a Data Lake
- ✅ Transformaciones de datos
- ✅ Monitoreo integrado
- ✅ Triggers temporales sin gestionar infraestructura

---

### Requisito 4: Plataforma de Análisis

**Servicio:** Azure Databricks

Plataforma de análisis colaborativa con:
- ✅ Notebooks interactivos
- ✅ Soporte completo para Apache Spark
- ✅ Procesamiento de telemetría compleja en JSON
- ✅ Análisis avanzados de patrones y rentabilidad
- ✅ Auto-escalado según demanda

---

### Requisito 5: Gestión de Secretos

**Servicio:** Azure Key Vault

Almacén seguro centralizado para:
- ✅ Credenciales
- ✅ Cadenas de conexión
- ✅ Secretos de aplicación
- ✅ Control de acceso mediante RBAC
- ✅ Auditoría completa

---

## 📸 Evidencia de Despliegue

### 1️⃣ Comprobación de Cambios

![Comprobacion de cambios](./images/Imagen2.png)

En esta captura se realiza la comprobación de los cambios mediante `terraform plan`. Se muestran todos los cambios finales a implementar para la arquitectura desplegada en Azure.

---

### 2️⃣ Ejecución de Apply

![Ejecucion de Apply](./images/Imagen3.png)

Aquí se ejecuta `terraform apply` para desplegar los cambios hacia Azure. La terminal muestra:
- ✅ La orden está formada y lista
- ⏳ Solicita confirmación (respuesta: `yes`)
- 📋 Breve descripción de los cambios
- 🔄 Qué servicios se modificarán y aplicarán

---

### 3️⃣ Confirmación de Éxito

![Exito de Apply](./images/Imagen4.png)

Confirmación desde los servidores de Azure de que los cambios se completaron exitosamente:
- ✅ Estado: **Completado**
- 📊 Tipos de cambios realizados
- ⏱️ **Tiempo total:** 2 minutos 30 segundos (Databricks tardó ~10 minutos)

---

### 4️⃣ Verificación en Azure Portal

![Azure](./images/Imagen5.png)

Confirmación visual desde la GUI de Azure:
- ✅ Todos los servicios se desplegaron exitosamente
- 📦 Los recursos configurados en Terraform están presentes
- 🏢 La arquitectura completa está operativa en Azure

---

## 💭 Reflexiones Finales

### Desafío Mayor: Dependencias Implícitas en Terraform

**Problema identificado:**

Terraform creó Key Vault antes que SQL Database, pero intentó almacenar el `sql-connection-string` simultáneamente, causando un error:
```
Error: secret cannot be created before vault is ready
```

**Solución implementada:**

Se agregó `depends_on = [azurerm_key_vault.kv]` en todos los secretos para forzar la secuencia:
1. Key Vault se crea completamente
2. SQL Database se crea
3. Secretos se almacenan

**Lección aprendida:**

Aunque Terraform infiere dependencias de variables (`azurerm_key_vault.kv.id`), las operaciones asíncronas de Azure pueden requerir dependencias explícitas para garantizar que el recurso esté "completamente listo".

---

### Separación OLTP/OLAP en Alquiler de Vehículos

**¿Por qué separar?**

| Aspecto | OLTP (SQL Database) | OLAP (Data Lake + Databricks) |
|---------|---------------------|-------------------------------|
| **Tipo de consultas** | Transacciones (INSERT/UPDATE) | Agregaciones complejas (GROUP BY, JOINs) |
| **Latencia** | Milisegundos | Segundos/minutos |
| **Volumen de datos** | Registros actuales | Históricos completos |
| **Usuarios** | Sistema de reservas | Analistas (5-10 usuarios) |

**Beneficios de la separación:**
- ✅ Las consultas analíticas no afectan el sistema de reservas
- ✅ El ETL nocturno copia datos cuando hay bajo tráfico
- ✅ La app mantiene latencias consistentes < 100ms
- ✅ Los analistas pueden ejecutar queries largas sin impacto

---

## 📊 Estimación de Costos

Recursos corriendo 24/7:

| Servicio | Tier | Costo Mensual |
|----------|------|--------------|
| SQL Database | S0 (10 DTU) | ~$15 USD |
| Storage Account | Standard LRS | ~$5 USD |
| Data Factory | Básico | ~$1 USD |
| Databricks | Sin cluster activo | ~$0 USD |
| Key Vault | Standard | ~$1 USD |
| **TOTAL** | - | **~$22 USD/mes** |

---
