// Get the canvas element from the dom
var canvas = document.getElementById('canvas-id');
// Get the 2d context of the canvas
var context = canvas.getContext('2d');

// Set brush color to red
context.strokeStyle = '#FF0000';

// Start a new path and move the cursor
// from start to end of the line to be drawn
context.beginPath();
context.moveTo(x, y);
context.lineTo(x + 100, y + 100);

// Finally actually draw the line on the canvas and end the path
context.stroke();