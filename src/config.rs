use anyhow::Result;
use axum::{Json, Router, http::StatusCode, routing::get};
use crate::paciente::{
    routes::paciente_routes::paciente_routes as paciente_routes,
    services::paciente_service::PacienteService as paciente_service,
    reporsitories::paciente_repository::PacienteRepository as paciente_repository};
use serde_json::{Value,json};
use sqlx::postgres::{PgPool, PgPoolOptions};
use std::env;
use tokio::net::TcpListener;

pub async fn get_database_pool() -> Result<PgPool> {
    // Leer DB_URL de .env
    let db_url = env::var("DB_URL")
        .map_err(|_| anyhow::anyhow!("❌ Variable 'DB_URL' no encontrada en .env"))?;

    println!(
        "🔍 Intentando conectar a: {}",
        db_url.split('@').next_back().unwrap_or("base de datos")
    );

    // Crear pool de pg con timeout y configuración mejorada
    let pool = PgPoolOptions::new()
        .max_connections(10)
        .acquire_timeout(std::time::Duration::from_secs(30))
        .connect(&db_url)
        .await
        .map_err(|e| anyhow::anyhow!("Error de conexión a PostgreSQL: {}", e))?;

    // Verificar la conexión
    match sqlx::query("SELECT 1").fetch_one(&pool).await {
        Ok(_) => {
            tracing::info!(
                "✅ Conexión a la base de datos verificada en: {}",
                db_url.split('@').next_back().unwrap_or("base de datos")
            );
            println!("✅ Pool de conexiones creado exitosamente");
        }
        Err(e) => {
            return Err(anyhow::anyhow!("❌ Error verificando conexión: {}", e));
        }
    }

    Ok(pool)
}

pub async fn get_app(pool: PgPool) -> Router {
    // Crear las instancias necesarias para paciente
    let paciente_repository = paciente_repository::new(pool.clone());
    let paciente_service = paciente_service::new(paciente_repository);

    // Combinar las rutas
    Router::new()
        .route("/", get(root))
        .nest("/api", paciente_routes(paciente_service))
}

pub async fn get_litener() -> TcpListener {
    let port = env::var("PORT").unwrap_or_else(|_| {
        eprintln!(
            "⚠️  WARNING: Variable de entorno no encontrada, API corriendo por defecto en 3000"
        );
        "3000".to_string()
    });
    TcpListener::bind(format!("127.0.0.1:{port}"))
        .await
        .unwrap()
}

// //funcion para mapear errores
// fn internal_error<E>(err: E) -> (StatusCode, String)
// where
//     E: std::error::Error,
// {
//     (StatusCode::INTERNAL_SERVER_ERROR, err.to_string())
// }

// async fn hello_world_pg(State(pool): State<PgPool>) -> Result<String, (StatusCode, String)> {
//     sqlx::query_scalar("select 'Hello world' as message")
//         .fetch_one(&pool)
//         .await
//         .map_err(internal_error)
// }

async fn root() -> Result<Json<Value>, StatusCode> {
    Ok(Json(json!({
        "message": "Api-ClinicaSM funcionando",
        "status": "Activate"
    })))
}
