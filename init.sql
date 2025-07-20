-- ======================================
-- TIPOS ENUMERADOS PERSONALIZADOS
-- ======================================
DO $$ BEGIN
    CREATE TYPE sexo_tipo AS ENUM ('Masculino', 'Femenino', 'Otro');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE rol_departamento_enum AS ENUM ('Medico Regular', 'Jefe Departamento');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE estado_admision AS ENUM ('activo', 'cerrado');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- ======================================
-- TABLAS PRINCIPALES
-- ======================================
CREATE TABLE IF NOT EXISTS "Grupo_sanguineo" (
    id_grupo_sanguineo SERIAL PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS "Paciente" (
    numero_historia_clinica SERIAL PRIMARY KEY,
    dni CHAR(8) UNIQUE NOT NULL,
    correo VARCHAR(80) UNIQUE,
    contraseña VARCHAR(100) NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    apellido_paterno VARCHAR(60) NOT NULL,
    apellido_materno VARCHAR(30),
    fecha_nacimiento DATE NOT NULL,
    direccion VARCHAR(60),
    telefono VARCHAR(15),
    sexo sexo_tipo,
    id_grupo_sanguineo INTEGER REFERENCES "Grupo_sanguineo"(id_grupo_sanguineo),
    antecedentes_clinicos VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS "Departamento" (
    id_departamento SERIAL PRIMARY KEY,
    nombre VARCHAR(70) NOT NULL,
    ubicacion VARCHAR(80)
);

CREATE TABLE IF NOT EXISTS "Especialidad" (
    id_especialidad SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    concepto TEXT,
    img VARCHAR(100),
    id_departamento INTEGER REFERENCES "Departamento"(id_departamento)
);

CREATE TABLE IF NOT EXISTS "Medico" (
    id_medico SERIAL PRIMARY KEY,
    nombre VARCHAR(40) NOT NULL,
    apellido VARCHAR(60) NOT NULL,
    especialidad INTEGER NOT NULL REFERENCES "Especialidad"(id_especialidad),
    colegiatura VARCHAR(8) NOT NULL UNIQUE,
    telefono CHAR(9) UNIQUE,
    correo VARCHAR(80) UNIQUE,
    contraseña VARCHAR(100) NOT NULL,
    rol_departamento rol_departamento_enum DEFAULT 'Medico Regular'
);

CREATE TABLE IF NOT EXISTS "Consultorio" (
    num_habitacion SERIAL PRIMARY KEY,
    piso SMALLINT CHECK (piso > 0),
    pabellon CHAR(2),
    id_departamento INTEGER REFERENCES "Departamento"(id_departamento)
);

CREATE TABLE IF NOT EXISTS "Turno" (
    id_turno SERIAL PRIMARY KEY,
    nombre VARCHAR(20),
    dia VARCHAR(25) NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    id_departamento INTEGER REFERENCES "Departamento"(id_departamento)
);

CREATE TABLE IF NOT EXISTS "Medico_turno" (
    id_medico_turno SERIAL PRIMARY KEY,
    id_medico INTEGER NOT NULL REFERENCES "Medico"(id_medico),
    id_turno INTEGER NOT NULL REFERENCES "Turno"(id_turno),
    num_habitacion INTEGER NOT NULL REFERENCES "Consultorio"(num_habitacion)
);

CREATE TABLE IF NOT EXISTS "Sub_turno" (
    id_sub_turno SERIAL PRIMARY KEY,
    id_medico_turno INTEGER REFERENCES "Medico_turno"(id_medico_turno),
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL
);

CREATE TABLE IF NOT EXISTS "Admision" (
    id_admision SERIAL PRIMARY KEY,
    id_numero_historia_paciente INTEGER NOT NULL REFERENCES "Paciente"(numero_historia_clinica),
    id_medico INTEGER NOT NULL REFERENCES "Medico"(id_medico),
    sub_turno INTEGER REFERENCES "Sub_turno"(id_sub_turno),
    fecha_atencion DATE NOT NULL,
    motivo VARCHAR(300),
    fecha_generacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado estado_admision DEFAULT 'activo'
);

CREATE TABLE IF NOT EXISTS "Triaje" (
    id_triaje SERIAL PRIMARY KEY,
    peso NUMERIC(5, 2),
    temperatura NUMERIC(4, 1),
    presion_arterial VARCHAR(7),
    frecuencia_cardiaca INTEGER,
    frecuencia_respiratoria INTEGER,
    saturacion_oxigeno INTEGER,
    talla NUMERIC(5, 2) NOT NULL,
    id_grupo_sanguineo INTEGER REFERENCES "Grupo_sanguineo"(id_grupo_sanguineo),
    id_admision INTEGER REFERENCES "Admision"(id_admision)
);

CREATE TABLE IF NOT EXISTS "Citas_atendidas" (
    id_cita_atendida SERIAL PRIMARY KEY,
    id_admision INTEGER NOT NULL UNIQUE REFERENCES "Admision"(id_admision),
    hora_inicio TIME,
    hora_fin TIME
);

CREATE TABLE IF NOT EXISTS "Enfermedad" (
    id_enfermedad SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

CREATE TABLE IF NOT EXISTS "Reporte_admision" (
    id_reporte SERIAL PRIMARY KEY,
    id_cita_atendida INTEGER NOT NULL REFERENCES "Citas_atendidas"(id_cita_atendida),
    id_enfermedad INTEGER REFERENCES "Enfermedad"(id_enfermedad),
    diagnostico TEXT,
    tratamiento TEXT,
    observaciones TEXT,
    fecha_reporte TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ======================================
-- ÍNDICES RECOMENDADOS
-- ======================================
CREATE INDEX IF NOT EXISTS idx_paciente_grupo_sanguineo ON "Paciente"(id_grupo_sanguineo);
CREATE INDEX IF NOT EXISTS idx_paciente_dni ON "Paciente"(dni);

CREATE INDEX IF NOT EXISTS idx_especialidad_departamento ON "Especialidad"(id_departamento);
CREATE INDEX IF NOT EXISTS idx_medico_especialidad ON "Medico"(especialidad);

CREATE INDEX IF NOT EXISTS idx_consultorio_id_departamento ON "Consultorio"(id_departamento);
CREATE INDEX IF NOT EXISTS idx_turno_id_departamento ON "Turno"(id_departamento);

CREATE INDEX IF NOT EXISTS idx_medico_turno_id_medico ON "Medico_turno"(id_medico);
CREATE INDEX IF NOT EXISTS idx_medico_turno_id_turno ON "Medico_turno"(id_turno);
CREATE INDEX IF NOT EXISTS idx_medico_turno_num_habitacion ON "Medico_turno"(num_habitacion);

CREATE INDEX IF NOT EXISTS idx_sub_turno_id_medico_turno ON "Sub_turno"(id_medico_turno);

CREATE INDEX IF NOT EXISTS idx_admision_numero_historia ON "Admision"(id_numero_historia_paciente);
CREATE INDEX IF NOT EXISTS idx_admision_sub_turno ON "Admision"(sub_turno);
CREATE INDEX IF NOT EXISTS idx_admision_medico ON "Admision"(id_medico);
CREATE INDEX IF NOT EXISTS idx_admision_fecha ON "Admision"(fecha_atencion);

CREATE INDEX IF NOT EXISTS idx_triaje_grupo_sanguineo ON "Triaje"(id_grupo_sanguineo);
CREATE INDEX IF NOT EXISTS idx_triaje_admision ON "Triaje"(id_admision);

CREATE INDEX IF NOT EXISTS idx_reporte_admision_cita ON "Reporte_admision"(id_cita_atendida);
CREATE INDEX IF NOT EXISTS idx_reporte_admision_enfermedad ON "Reporte_admision"(id_enfermedad);

-- ======================================
-- FUNCIONES Y TRIGGERS PERSONALIZADOS
-- ======================================
-- Función para validar la fecha de nacimiento del paciente
CREATE OR REPLACE FUNCTION validar_fecha_nacimiento()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.fecha_nacimiento > CURRENT_DATE THEN
        RAISE EXCEPTION 'La fecha de nacimiento no puede estar en el futuro.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para aplicar la función en Paciente
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger WHERE tgname = 'tr_fecha_nacimiento_paciente'
    ) THEN
        CREATE TRIGGER tr_fecha_nacimiento_paciente
        BEFORE INSERT OR UPDATE ON "Paciente"
        FOR EACH ROW
        EXECUTE FUNCTION validar_fecha_nacimiento();
    END IF;
END;
$$;

-- ======================================
-- FIN DEL SCRIPT
-- ======================================
