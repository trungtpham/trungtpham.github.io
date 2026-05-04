(function () {
  'use strict';

  var root = document.documentElement;
  var btn = document.getElementById('theme-toggle');
  if (!btn) return;

  function setTheme(theme, persist) {
    root.setAttribute('data-theme', theme);
    if (persist) {
      try { localStorage.setItem('theme', theme); } catch (e) {}
    }
  }

  btn.addEventListener('click', function () {
    var current = root.getAttribute('data-theme') || 'light';
    setTheme(current === 'dark' ? 'light' : 'dark', true);
  });

  // Track system preference changes — but only if the user hasn't set one explicitly.
  var mq = window.matchMedia('(prefers-color-scheme: dark)');
  var listener = function (e) {
    try {
      if (!localStorage.getItem('theme')) {
        setTheme(e.matches ? 'dark' : 'light', false);
      }
    } catch (err) {}
  };
  if (mq.addEventListener) {
    mq.addEventListener('change', listener);
  } else if (mq.addListener) {
    mq.addListener(listener);
  }
})();
