use axum::{Json, extract::State, http::StatusCode};

use crate::paciente::services::paciente_service::PacienteService;

pub async fn listar_pacientes(
    State(service): State<PacienteService>,
) -> Result<Json<Vec<crate::paciente::models::paciente::Paciente>>, (StatusCode, String)> {
    service
        .listar_pacientes()
        .await
        .map(Json)
        .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, e))
}
