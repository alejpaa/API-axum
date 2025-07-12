use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize)]
pub struct Paciente {
    pub id: i32,
    pub dni: String,
    pub nombre: String,
    pub apellido: String,
    pub email: String,
    pub telefono: String,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct CreatePacienteRequest {
    pub dni: i32,
    pub nombre: String,
    pub apellido: String,
    pub email: String,
    pub telefono: String,
    pub fecha_nacimiento: String,
    pub direccion: String,
}
