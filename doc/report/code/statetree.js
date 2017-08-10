var appState = {
    scopes: [{
        ui: {
            prefPane: {
                open: true,
                width: 400,
            }
        },
        source: {
            id: 2,
            name: 'Source ' + 1,
            location: 'ws://localhost:50090',
            frameSize: 4096,
            samplingRate: 5000000,
            bits: 16,
            vpp: 2.1, // Volts per bit
            trigger: {
                type: 'risingEdge',
                level: 32768,
                channel: 1,
                hysteresis: 30,
                slope: 0
            },
            triggerTrace: 0,
            triggerPosition: 1 / 8,
            numberOfChannels: 2,
            mode: 'normal',
            activeTrace: 0,
            traces: [
                {
                    id: 4,
                    offset: { x: 0, y: 0 },
                    windowFunction: 'hann',
                    halfSpectrum: true,
                    SNRmode: 'auto',
                    info: {}, // Populated during runtime with math
                    name: 'Trace ' + 2,
                    channelID: 1,
                    type: 'FFTrace',
                    color: '#E8830C',
                    scaling: { x: 1, y: 1 },
                    markers: [
                        {
                            id: 'SNRfirst',
                            type: 'vertical',
                            x: 0,
                            dashed: true,
                            color: 'purple',
                            active: true,
                        }
                    ]
                }
            ],
        }
    }]
};