(function () {
  if (typeof muck === 'undefined' || !muck.tree) return;
  var tree = muck.tree;
  var cur = (muck.current || window.location.pathname).replace(/\/+$/, '') || '/';

  function buildList(nodes) {
    var ul = document.createElement('ul');
    nodes.forEach(function (node) {
      var li = document.createElement('li');
      if (node.children) {
        li.className = 'nav-dir';
        var span = document.createElement('span');
        span.textContent = node.label;
        li.appendChild(span);
        li.appendChild(buildList(node.children));
      } else {
        var a = document.createElement('a');
        a.href = node.path;
        a.textContent = node.label;
        if (cur === node.path.replace(/\/+$/, '')) a.className = 'active';
        li.appendChild(a);
      }
      ul.appendChild(li);
    });
    return ul;
  }

  var nav = document.createElement('nav');
  nav.id = 'muck-nav';
  nav.appendChild(buildList(tree));
  document.body.insertBefore(nav, document.body.firstChild);
})();
