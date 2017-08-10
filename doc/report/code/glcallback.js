// The register function is not named the same way in every browser
// Make sure this is the case
window.requestAnimationFrame = window.requestAnimationFrame
                            || window.webkitRequestAnimationFrame;

// Our callback we call for every frame drawn
export const draw = function() {
    // Draw anything needed

    // End draw

    // Register the callback again
    requestAnimationFrame(function(){
        // Execute our callback
        // We cannot hand this directly to the register function
        // since it is not yet known inside it's own definition
        draw();
    });
};

// Initially call the draw function
draw();