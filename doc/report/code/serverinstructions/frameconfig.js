// Request

{
    "frameConfiguration": {
        "frameSize": frameSize,
        "pre": minSamplesBeforeTrigger,
        "suf": minSamplesAfterTrigger
    }
}

// Response

{
    "response", {
        {"request", "frameConfiguration"},
        {"status", status}, // "error" or "ok"
        {"error", errorMessage}
    }
}