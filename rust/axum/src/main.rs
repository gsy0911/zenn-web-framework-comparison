use axum::{
    response::Json,
    routing::get,
    Router,
};
use serde::{Deserialize, Serialize};
use std::env;

#[derive(Serialize, Deserialize)]
struct StatusResponse {
    status: String,
}

async fn get_user() -> Json<StatusResponse> {
    Json(StatusResponse {
        status: "success".to_string(),
    })
}

async fn healthcheck() -> Json<StatusResponse> {
    Json(StatusResponse {
        status: "success".to_string(),
    })
}

#[tokio::main]
async fn main() {
    let prefix = env::var("PREFIX").unwrap_or_default();
    
    // Define the routes
    let app_routes = Router::new()
        .route("/user", get(get_user))
        .route("/healthcheck", get(healthcheck));
    
    // Apply prefix if set
    let app = if prefix.is_empty() {
        app_routes
    } else {
        // Remove leading/trailing slashes and create nested route
        let clean_prefix = prefix.trim_start_matches('/').trim_end_matches('/');
        Router::new().nest(&format!("/{}", clean_prefix), app_routes)
    };
    
    println!("Starting Axum server on 0.0.0.0:8080");
    if !prefix.is_empty() {
        println!("Using prefix: {}", prefix);
    }
    
    let listener = tokio::net::TcpListener::bind("0.0.0.0:8080")
        .await
        .unwrap();
    
    axum::serve(listener, app).await.unwrap();
}