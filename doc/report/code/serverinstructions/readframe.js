// Request
{
    "readFrame": true,
    "channel": channelID
}
// Response
{
    "response", {
        {"request", "readFrame"},
        {"status", status}, // "error" or "ok"
        {"error", errorMessage}
    }
}
