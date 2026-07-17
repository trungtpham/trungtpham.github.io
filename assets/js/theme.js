(function () {
  'use strict';

  var root = document.documentElement;
  var btn = document.getElementById('theme-toggle');
  if (!btn) return;

  var META_COLORS = { dark: '#0b0b0c', light: '#fafaf9' };
  var meta = document.querySelector('meta[name="theme-color"]');

  function setTheme(theme, persist) {
    root.setAttribute('data-theme', theme);
    if (meta) meta.setAttribute('content', META_COLORS[theme] || META_COLORS.dark);
    if (persist) {
      try { localStorage.setItem('theme', theme); } catch (e) {}
    }
  }

  // Site defaults to dark; users can override via the toggle (persisted).
  btn.addEventListener('click', function () {
    var current = root.getAttribute('data-theme') || 'dark';
    setTheme(current === 'dark' ? 'light' : 'dark', true);
  });
})();
