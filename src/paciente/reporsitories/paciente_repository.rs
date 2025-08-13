use sqlx::PgPool;
use crate::paciente::models::paciente::Paciente;

#[derive(Clone)]
pub struct PacienteRepository {
    pool: PgPool,
}

impl PacienteRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }

    pub async fn listar_pacientes(&self) -> Result<Vec<Paciente>, sqlx::Error> {
        sqlx::query_as!(
            Paciente,
            r#"
            SELECT 
                numero_historia_clinica,
                dni,
                correo,
                nombre,
                apellido_paterno,
                apellido_materno,
                fecha_nacimiento,
                direccion,
                telefono,
                sexo::TEXT as "sexo?",
                id_grupo_sanguineo,
                antecedentes_clinicos
            FROM "Paciente"
            "#
        )
        .fetch_all(&self.pool)
        .await
    }
}
