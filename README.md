# API Clínica - Backend en Rust con Axum

Este proyecto es una API REST para un sistema de gestión de clínica médica, implementado en Rust utilizando el framework Axum.

## 🚀 Características

- CRUD completo para:
  - Pacientes
  - Médicos
  - Departamentos
  - Especialidades
  - Admisiones
  - Citas
  - Triajes
  - Reportes médicos
- Autenticación y autorización
- Manejo de roles (Médico Regular, Jefe de Departamento)
- Gestión de turnos y consultorios
- Historial clínico de pacientes

## 🛠️ Tecnologías Utilizadas

- **Rust** - Lenguaje de programación
- **Axum** - Framework web
- **SQLx** - ORM y kit de herramientas para bases de datos
- **PostgreSQL** - Base de datos
- **Tokio** - Runtime asíncrono
- **Serde** - Serialización/Deserialización

## 📋 Prerrequisitos

- Rust (última versión estable)
- PostgreSQL 12 o superior
- SQLx CLI

```bash
# Instalar SQLx CLI
cargo install sqlx-cli
```

## 🔧 Configuración

1. Clonar el repositorio:
```bash
git clone https://github.com/Mapach33/API-axum.git
cd API-axum
```

2. Configurar la base de datos:
```bash
# Crear la base de datos
psql -U postgres -c "CREATE DATABASE clinica"

# Ejecutar las migraciones
sqlx database create
sqlx migrate run
```

3. Configurar variables de entorno:
```bash
# Crear archivo .env
cp .env.example .env

# Editar las variables según tu configuración
PORT=3000
DATABASE_URL=postgresql://usuario:contraseña@localhost:5432/clinica
```

## 🚀 Ejecución

```bash
# Ejecutar en modo desarrollo
cargo run

# Compilar y ejecutar en modo release
cargo build --release
./target/release/api-axum
```

## 📌 Endpoints

### Pacientes
- `GET /pacientes` - Listar todos los pacientes
- `GET /pacientes/{id}` - Obtener un paciente
- `POST /pacientes` - Crear un paciente
- `PUT /pacientes/{id}` - Actualizar un paciente
- `DELETE /pacientes/{id}` - Eliminar un paciente

### Médicos
- `GET /medicos` - Listar todos los médicos
- `GET /medicos/{id}` - Obtener un médico
- `POST /medicos` - Crear un médico
- `PUT /medicos/{id}` - Actualizar un médico
- `DELETE /medicos/{id}` - Eliminar un médico

[Documentación completa de endpoints](docs/api.md)


## 📦 Estructura del Proyecto

```
src/
├── config.rs       # Configuración de la aplicación
├── main.rs         # Punto de entrada
├── medico/         # Módulo de médicos
│   ├── models/
│   └── routes/
├── paciente/       # Módulo de pacientes
│   ├── models/
│   └── routes/
└── ...
```
