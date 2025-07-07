# Config Test

Use this as config json:

```
{
    "username": "make87_user",
    "password": "{{ secrets.USER_PASSWORD }}",
    "retry_count": 5,
    "timeout_seconds": 10.5,
    "enabled": True,
    "start_date": "2025-07-07",
    "api_url": "https://api.make87.com/v1/data",
    "ip_whitelist": [
        "192.168.1.1",
        "10.0.0.2"
    ],
    "features": {
        "core": True,
        "advanced": True,
        "experimental": False
    },
    "mode": "advanced",
    "options": {
        "type": "url",
        "link": "https://example.com/data.json"
    },
    "credentials": {
        "client_id": "my-client-id",
        "client_secret": "{{ secrets.CLIENT_SECRET }}"
    },
    "nested_array": [
        {
            "id": 1,
            "tags": ["camera", "sensor"]
        },
        {
            "id": 2,
            "tags": []
        }
    ],
    "toggle_feature": True,
    "feature_config": {
        "level": "high"
    }
}
```
