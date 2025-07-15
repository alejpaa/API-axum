mod config;
mod medico;
mod paciente;
use crate::config::{get_app, get_database_pool, get_litener};
use dotenv::dotenv;

#[tokio::main]
async fn main() {
    dotenv().ok();

    // Inicializar logging con más detalles
    tracing_subscriber::fmt()
        .with_env_filter(
            tracing_subscriber::EnvFilter::from_default_env()
                .add_directive("info".parse().unwrap()),
        )
        .init();

    println!("🚀 Iniciando API Clínica...");

    // Conectar a la base de datos con manejo de errores mejorado
    println!("📊 Conectando a la base de datos...");
    let pool = match get_database_pool().await {
        Ok(pool) => {
            println!("✅ Conexión a la base de datos exitosa!");
            pool
        }
        Err(e) => {
            eprintln!("❌ Error conectando a la base de datos: {e}");
            eprintln!("💡 Verifica tu archivo .env y que PostgreSQL esté corriendo");
            std::process::exit(1);
        }
    };

    // Get listener
    let listener = get_litener().await;

    // Get the port for logging
    let port = std::env::var("PORT").unwrap_or_else(|_| "3000".to_string());

    // Create app with the pool
    let app = get_app(pool).await;

    println!("Api corriendo en el puerto: {port}");
    axum::serve(listener, app).await.unwrap();
}
