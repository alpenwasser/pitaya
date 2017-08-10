// Open a new socket
this.socket = new WebSocket('ws://localhost');
// Make sure the binary data transmitted
// is interpreted as an ArrayBuffer
// More on ArrayBuffers and Blobs in:
// - https://developer.mozilla.org/en/docs/Web/API/Blob
// - https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer
this.socket.binaryType = 'arraybuffer';

// Define all the callback handlers
connection.onopen = function () {
    // The connection was established; send some regards.
    connection.send('Hello World!');
};

connection.onerror = function (error) {
    // An error has occurred; print it to the console.
    console.log('WebSocket Error: ' + error);
};

connection.onmessage = function (e) {
    if (typeof e.data == 'string') {
        // If a text type message was received, print it out.
        console.log('Text message received: ' + e.data);
    } else {
        // A binary type message was received.
        // Interpret the values as 16 bit uints.
        var arr = new Uint16Array(e.data);
        // Plot the data.
        plot(arr);
    }
};