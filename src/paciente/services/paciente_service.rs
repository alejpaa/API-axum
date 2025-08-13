use crate::paciente::{models::paciente::Paciente, reporsitories::paciente_repository::PacienteRepository};

#[derive(Clone)]
pub struct PacienteService {
    repository: PacienteRepository,
}

impl PacienteService {
    pub fn new(repository: PacienteRepository) -> Self {
        Self { repository }
    }

    pub async fn listar_pacientes(&self) -> Result<Vec<Paciente>, String> {
        self.repository
            .listar_pacientes()
            .await
            .map_err(|e| e.to_string())
    }
}
