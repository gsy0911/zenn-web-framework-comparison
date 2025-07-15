use serde::{Deserialize, Serialize};
use std::env;
use warp::Filter;

#[derive(Serialize, Deserialize)]
struct StatusResponse {
    status: String,
}

async fn get_user() -> Result<impl warp::Reply, warp::Rejection> {
    let response = StatusResponse {
        status: "success".to_string(),
    };
    Ok(warp::reply::json(&response))
}

async fn healthcheck() -> Result<impl warp::Reply, warp::Rejection> {
    let response = StatusResponse {
        status: "success".to_string(),
    };
    Ok(warp::reply::json(&response))
}

#[tokio::main]
async fn main() {
    let prefix = env::var("PREFIX").unwrap_or_default();
    
    // Define the routes
    let user_route = warp::path("user")
        .and(warp::get())
        .and_then(get_user);
    
    let health_route = warp::path("healthcheck")
        .and(warp::get())
        .and_then(healthcheck);
    
    let routes = user_route.or(health_route);
    
    // Apply prefix if set
    let final_routes = if prefix.is_empty() {
        routes.boxed()
    } else {
        // Parse prefix path segments
        let path_segments: Vec<&str> = prefix
            .trim_start_matches('/')
            .trim_end_matches('/')
            .split('/')
            .filter(|s| !s.is_empty())
            .collect();
        
        match path_segments.len() {
            0 => routes.boxed(),
            1 => warp::path(path_segments[0].to_string())
                .and(routes)
                .boxed(),
            2 => warp::path(path_segments[0].to_string())
                .and(warp::path(path_segments[1].to_string()))
                .and(routes)
                .boxed(),
            3 => warp::path(path_segments[0].to_string())
                .and(warp::path(path_segments[1].to_string()))
                .and(warp::path(path_segments[2].to_string()))
                .and(routes)
                .boxed(),
            _ => {
                // For more complex paths, build iteratively
                let mut filter = warp::path(path_segments[0].to_string()).boxed();
                for segment in &path_segments[1..] {
                    filter = filter.and(warp::path(segment.to_string())).boxed();
                }
                filter.and(routes).boxed()
            }
        }
    };
    
    println!("Starting Warp server on 0.0.0.0:8080");
    if !prefix.is_empty() {
        println!("Using prefix: {}", prefix);
    }
    
    warp::serve(final_routes)
        .run(([0, 0, 0, 0], 8080))
        .await;
}