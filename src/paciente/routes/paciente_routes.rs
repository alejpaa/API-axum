use axum::{routing::get, Router};

use crate::paciente::{
    controllers::paciente_controller as controller,
    services::paciente_service::PacienteService,
};

pub fn paciente_routes(service: PacienteService) -> Router {
    Router::new()
        .route("/pacientes", get(controller::listar_pacientes))
        .with_state(service)
}
