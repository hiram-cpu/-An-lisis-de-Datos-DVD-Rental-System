# 🎬 Análisis de Datos: DVD Rental System

Este repositorio contiene un conjunto de consultas **SQL (DQL)** enfocadas en la explotación de la base de datos `dvdrental`. El objetivo es transformar datos operativos en información estratégica para la toma de decisiones, cubriendo desde la gestión de inventarios hasta el análisis financiero por sucursal.

## 🧠 Propósito del Análisis
Cada consulta ha sido diseñada para responder preguntas críticas del negocio:
* **Gestión de Inventario:** Identificación de stock inactivo y best sellers.
* **Inteligencia de Clientes:** Segmentación, lealtad y reactivación de usuarios inactivos.
* **Análisis de Rendimiento:** Productividad de actores y métricas de ventas por tienda.
* **Estrategia de Mercado:** Análisis de precios y clasificación de audiencia (rating).

## 🛠️ Tecnologías y Herramientas
* **Lenguaje:** SQL (DQL).
* **Motor:** Compatible con entornos SQL Server / T-SQL.
* **Enfoque:** Análisis de datos, joins complejos, funciones de agregación y CTEs (Common Table Expressions).

## 📊 Misiones Resueltas (Queries destacadas)
El script incluye 15 ejercicios clave, entre ellos:

1. **Productividad de Actores:** Clasificación de los actores más prolíficos (con más de 30 películas).
2. **Análisis Financiero:** Cálculo de ventas totales por tienda (`SUM`, `CAST`, `JOIN`).
3. **Lealtad de Clientes:** Uso de `CTE` (Common Table Expressions) para detectar clientes que rentan la misma película repetidamente.
4. **Detección de Inactividad:** Uso de `LEFT JOIN` para identificar películas y clientes con cero actividad.

## 📂 Estructura del Repositorio
* `dvdrental_analysis.sql`: Archivo principal que contiene todas las consultas documentadas.

---
*Desarrollado con rigor analítico para la gestión eficiente de bases de datos. Subiendo de nivel un query a la vez.* 🚀
