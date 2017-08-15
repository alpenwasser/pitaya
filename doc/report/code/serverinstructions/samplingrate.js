// Request

{
    "samplingRate": samplingRateInHz
}

// Response

{
    "response", {
        {"request", "samplingRate"},
        {"status", status}, // "error" or "ok"
        {"error", errorMessage}
    }
}