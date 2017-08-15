//Request

{
    "requestFrame": true,
    "channel": channelID
}

// Response

{
    "response", {
        {"request", "requestFrame"},
        {"status", status}, // "error" or "ok"
        {"error", errorMessage}
    }
}