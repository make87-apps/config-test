use make87::config::load_config_from_default_env;
use serde_json::Value;

fn main() -> Result<(), Box<dyn std::error::Error + Send + Sync + 'static>> {
    // Loads config from environment (e.g., MAKE87_CONFIG_YAML, secrets)
    let application_config = load_config_from_default_env()?;
    let config = &application_config.config;

    assert_eq!(config.get("username").and_then(Value::as_str), Some("make87_user"));
    assert_eq!(config.get("password").and_then(Value::as_str), Some("s3cr3t!"));
    assert_eq!(config.get("retry_count").and_then(Value::as_i64), Some(5));
    assert!((config.get("timeout_seconds").and_then(Value::as_f64).unwrap_or(0.0) - 10.5).abs() < 1e-6);
    assert_eq!(config.get("enabled").and_then(Value::as_bool), Some(true));
    assert_eq!(config.get("start_date").and_then(Value::as_str), Some("2025-07-07"));
    assert_eq!(config.get("api_url").and_then(Value::as_str), Some("https://api.make87.com/v1/data"));

    let ip_whitelist = config.get("ip_whitelist").and_then(Value::as_array).unwrap();
    assert_eq!(ip_whitelist, &vec![
        Value::String("192.168.1.1".to_string()),
        Value::String("10.0.0.2".to_string()),
    ]);

    let features = config.get("features").and_then(Value::as_object).unwrap();
    assert_eq!(features.get("core").and_then(Value::as_bool), Some(true));
    assert_eq!(features.get("advanced").and_then(Value::as_bool), Some(true));
    assert_eq!(features.get("experimental").and_then(Value::as_bool), Some(false));

    assert_eq!(config.get("mode").and_then(Value::as_str), Some("advanced"));

    let options = config.get("options").and_then(Value::as_object).unwrap();
    assert_eq!(options.get("type").and_then(Value::as_str), Some("url"));
    assert_eq!(options.get("link").and_then(Value::as_str), Some("https://example.com/data.json"));

    let credentials = config.get("credentials").and_then(Value::as_object).unwrap();
    assert_eq!(credentials.get("client_id").and_then(Value::as_str), Some("my-client-id"));
    assert_eq!(credentials.get("client_secret").and_then(Value::as_str), Some("abcd1234xyz"));

    let nested_array = config.get("nested_array").and_then(Value::as_array).unwrap();
    assert_eq!(nested_array[0].get("id").and_then(Value::as_i64), Some(1));
    assert_eq!(nested_array[0].get("tags").and_then(Value::as_array).unwrap(), &vec![
        Value::String("camera".to_string()),
        Value::String("sensor".to_string()),
    ]);
    assert_eq!(nested_array[1].get("id").and_then(Value::as_i64), Some(2));
    assert_eq!(nested_array[1].get("tags").and_then(Value::as_array).unwrap().len(), 0);

    assert_eq!(config.get("toggle_feature").and_then(Value::as_bool), Some(true));
    let feature_config = config.get("feature_config").and_then(Value::as_object).unwrap();
    assert_eq!(feature_config.get("level").and_then(Value::as_str), Some("high"));

    println!("✅ All config assertions passed successfully. Running forever now...");

    make87::run_forever();

    Ok(())
}