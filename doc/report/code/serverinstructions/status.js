{
    "status": "true"
}

// Response

{
    "response": {
        "request": "forceTrigger",
        "status": status, // "error" or "ok"
        "error": errorMessage,
        "data":{
            {
                {"memorySize", memeorySizeInBytes},
                {"baseAddress", physicalBaseAddress},
                {"currentAddress", currentPhysicalAddress},
                {"pre", pre},
                {"suf", suf},
                {"numberOfChannels", numberOfChannels},
                {"started", hasLoggerStarted},
                {"IRQack", wasIRQAckedActiveLow},
                {"errorCode", errorCode},
                {"faultyAddress", faultyPhysicalAddress},
                {"testMode", isTestModeActive},
                {"numberOfSamples", numberOfRecordedSamples},
                {"numberOfSamplesTimes", numberOfRecordedSamplesTimesFull},
                {"decimationRate", decimationRate},
            }
        }
    }
}