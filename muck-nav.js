(function () {
  var el = document.getElementById('muck-nav-data');
  if (!el) return;
  var tree;
  try { tree = JSON.parse(el.textContent); } catch (e) { return; }

  // Normalize current path for comparison
  var cur = window.location.pathname.replace(/\/+$/, '') || '/';

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
        // Highlight active: exact root-relative match
        var nodePath = node.path.replace(/\/+$/, '');
        if (cur === nodePath) a.className = 'active';
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
