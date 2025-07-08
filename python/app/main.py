import make87
import logging

logging.basicConfig(level=logging.INFO)

def main():
    # Load config from environment using make87 SDK
    application_config = make87.config.load_config_from_env()
    config = application_config.config

    # Assertions for the test case
    assert config["username"] == "make87_user"
    assert config["password"] == "s3cr3t!"
    assert config["retry_count"] == 5
    assert abs(config["timeout_seconds"] - 10.5) < 1e-6
    assert config["enabled"] is True
    assert config["start_date"] == "2025-07-07"
    assert config["api_url"] == "https://api.make87.com/v1/data"

    assert config["ip_whitelist"] == ["192.168.1.1", "10.0.0.2"]

    assert config["features"]["core"] is True
    assert config["features"]["advanced"] is True
    assert config["features"]["experimental"] is False

    assert config["mode"] == "advanced"

    assert config["options"]["type"] == "url"
    assert config["options"]["link"] == "https://example.com/data.json"

    assert config["credentials"]["client_id"] == "my-client-id"
    assert config["credentials"]["client_secret"] == "abcd1234xyz"

    assert isinstance(config["nested_array"], list)
    assert config["nested_array"][0]["id"] == 1
    assert config["nested_array"][0]["tags"] == ["camera", "sensor"]

    assert config["nested_array"][1]["id"] == 2
    assert config["nested_array"][1]["tags"] == []

    # Conditional test: toggle_feature requires feature_config
    assert config["toggle_feature"] is True
    assert config["feature_config"]["level"] == "high"

    logging.info("✅ All config assertions passed successfully. Running forever now...")

    make87.run_forever()


if __name__ == "__main__":
    main()
