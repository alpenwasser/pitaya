// A mithril component is a simple object that has at minimum a
// view() function that returns a vnode.
var HelloWorld = {
    view: function() {
        // Return the toplevel <div> vnode
        return m('', [
            // Create a <h1> vnode with the attribute class="title"
            m('h1', { class: 'title' }, 'A very interesting title!'),
            // Create a <p> vnode
            m('p', 'Hello World!'),
        ])
    }
}
// Get the root div and mount the HelloWorld component
var root = document.getElementById('root');
m.mount(root, HelloWorld)