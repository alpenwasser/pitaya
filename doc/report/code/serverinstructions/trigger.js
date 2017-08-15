// Request

{
    "triggerOn": {
        "type": "risingEdge",
        "channel": channel,
        "level": levelConvertedToUnsigned,
        "slope": minimalSlope,
        "hysteresis": hysteresis
    }
}

// Response

{
    "response", {
        {"request", "triggerOn"},
        {"status", status}, // "error" or "ok"
        {"error", errorMessage}
    }
}