use serde::{Serialize};
use sqlx::FromRow;

#[derive(Debug, Serialize, FromRow)]
pub struct Paciente {
    pub numero_historia_clinica: i32,
    pub dni: String,
    pub correo: Option<String>,
    pub nombre: String,
    pub apellido_paterno: String,
    pub apellido_materno: Option<String>,
    pub fecha_nacimiento: sqlx::types::time::Date,
    pub direccion: Option<String>,
    pub telefono: Option<String>,
    pub sexo: Option<String>,
    pub id_grupo_sanguineo: Option<i32>,
    pub antecedentes_clinicos: Option<String>,
}
