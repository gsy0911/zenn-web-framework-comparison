use rocket::serde::{Deserialize, Serialize};
use rocket::{get, launch, routes, Config, Route};
use std::env;

#[derive(Serialize, Deserialize)]
#[serde(crate = "rocket::serde")]
struct StatusResponse {
    status: String,
}

#[get("/user")]
fn get_user() -> rocket::serde::json::Json<StatusResponse> {
    rocket::serde::json::Json(StatusResponse {
        status: "success".to_string(),
    })
}

#[get("/healthcheck")]
fn healthcheck() -> rocket::serde::json::Json<StatusResponse> {
    rocket::serde::json::Json(StatusResponse {
        status: "success".to_string(),
    })
}

#[launch]
fn rocket() -> _ {
    let prefix = env::var("PREFIX").unwrap_or_default();
    
    let config = Config::figment()
        .merge(("address", "0.0.0.0"))
        .merge(("port", 8080));

    let mut routes: Vec<Route> = vec![];
    
    if prefix.is_empty() {
        routes.extend(routes![get_user, healthcheck]);
    } else {
        routes.extend(routes![get_user, healthcheck]);
    }

    rocket::custom(config)
        .mount(&prefix, routes)
}