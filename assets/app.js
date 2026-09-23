(function () {
    'use strict';

    var root = document.documentElement;
    var metaTheme = document.querySelector('meta[name="theme-color"]');

    function getStoredTheme() {
        try {
            var saved = localStorage.getItem('sipas-theme');
            if (saved === 'dark' || saved === 'light') return saved;
        } catch (e) {}

        if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
            return 'dark';
        }
        return 'light';
    }

    function applyTheme(theme, persist) {
        root.setAttribute('data-theme', theme);
        if (metaTheme) metaTheme.setAttribute('content', theme === 'dark' ? '#0f1420' : '#2f4cff');

        var toggle = document.getElementById('themeToggle');
        if (toggle) {
            toggle.setAttribute('aria-pressed', theme === 'dark' ? 'true' : 'false');
            toggle.setAttribute('aria-label', theme === 'dark' ? 'Aktifkan tema terang' : 'Aktifkan tema gelap');
        }

        if (persist) {
            try { localStorage.setItem('sipas-theme', theme); } catch (e) {}
        }
    }

    applyTheme(getStoredTheme(), false);

    var themeToggle = document.getElementById('themeToggle');
    if (themeToggle) {
        themeToggle.addEventListener('click', function () {
            var current = root.getAttribute('data-theme') === 'dark' ? 'dark' : 'light';
            applyTheme(current === 'dark' ? 'light' : 'dark', true);
        });
    }

    /* Mobile sidebar */
    var mobileMenuBtn = document.querySelector('.mobile-menu');
    var sidebar = document.querySelector('.sidebar');

    if (mobileMenuBtn && sidebar) {
        var backdrop = document.createElement('div');
        backdrop.className = 'sidebar-backdrop';
        backdrop.hidden = true;
        document.body.appendChild(backdrop);

        function setMenu(open) {
            var isMobile = window.innerWidth <= 800;
            var shouldOpen = Boolean(open && isMobile);

            sidebar.classList.toggle('open', shouldOpen);
            backdrop.hidden = !shouldOpen;
            document.body.classList.toggle('menu-open', shouldOpen);
            mobileMenuBtn.setAttribute('aria-expanded', shouldOpen ? 'true' : 'false');
        }

        mobileMenuBtn.setAttribute('aria-expanded', 'false');
        mobileMenuBtn.addEventListener('click', function (event) {
            event.stopPropagation();
            setMenu(!sidebar.classList.contains('open'));
        });

        var closeButton = sidebar.querySelector('[data-sidebar-close]');
        if (closeButton) closeButton.addEventListener('click', function () { setMenu(false); });

        backdrop.addEventListener('click', function () { setMenu(false); });

        sidebar.querySelectorAll('a').forEach(function (link) {
            link.addEventListener('click', function () {
                if (window.innerWidth <= 800) setMenu(false);
            });
        });

        window.addEventListener('resize', function () {
            if (window.innerWidth > 800) {
                setMenu(false);
            } else {
                backdrop.hidden = !sidebar.classList.contains('open');
            }
        });

        document.addEventListener('keydown', function (event) {
            if (event.key === 'Escape' && sidebar.classList.contains('open')) setMenu(false);
        });
    }

    /* Responsive tables */
    function makeTablesResponsive() {
        if (window.innerWidth > 650) return;

        document.querySelectorAll('.table').forEach(function (table) {
            var headers = Array.from(table.querySelectorAll('thead th')).map(function (th) {
                return th.textContent.trim();
            });

            table.querySelectorAll('tbody tr').forEach(function (row) {
                Array.from(row.children).forEach(function (cell, index) {
                    if (!cell.hasAttribute('colspan')) cell.setAttribute('data-label', headers[index] || '');
                });
            });
        });
    }

    function clearResponsiveTables() {
        document.querySelectorAll('.table td[data-label]').forEach(function (cell) {
            cell.removeAttribute('data-label');
        });
        makeTablesResponsive();
    }

    makeTablesResponsive();
    window.addEventListener('resize', clearResponsiveTables);

    /* Password visibility */
    document.querySelectorAll('[data-password-toggle]').forEach(function (button) {
        button.addEventListener('click', function () {
            var id = button.getAttribute('aria-controls');
            var input = id ? document.getElementById(id) : null;
            if (!input) return;

            var visible = input.type === 'password';
            input.type = visible ? 'text' : 'password';
            button.classList.toggle('is-visible', visible);
            button.setAttribute('aria-pressed', visible ? 'true' : 'false');
            button.setAttribute('aria-label', visible ? 'Sembunyikan password' : 'Tampilkan password');
            input.focus();
        });
    });

    /* Password confirmation */
    document.querySelectorAll('[data-match]').forEach(function (input) {
        var target = document.querySelector(input.getAttribute('data-match'));
        var message = input.closest('.form-group') ? input.closest('.form-group').querySelector('[data-match-message]') : null;
        if (!target) return;

        function validateMatch() {
            var mismatch = input.value !== '' && input.value !== target.value;
            input.setCustomValidity(mismatch ? (input.getAttribute('data-match-error') || 'Isian tidak sama.') : '');
            input.classList.toggle('is-invalid', mismatch);
            input.setAttribute('aria-invalid', mismatch ? 'true' : 'false');

            if (message) {
                message.textContent = mismatch ? (input.getAttribute('data-match-error') || 'Isian tidak sama.') : '';
                message.hidden = !mismatch;
            }
        }

        input.addEventListener('input', validateMatch);
        target.addEventListener('input', validateMatch);
        input.addEventListener('blur', validateMatch);
    });

    /* Simple character counters */
    document.querySelectorAll('[data-count-target]').forEach(function (counter) {
        var target = document.getElementById(counter.getAttribute('data-count-target'));
        var max = parseInt(counter.getAttribute('data-max'), 10);
        if (!target || !max) return;

        function updateCount() {
            var length = target.value.length;
            counter.textContent = length + ' / ' + max + ' karakter';
            counter.setAttribute('aria-live', 'polite');
        }

        target.addEventListener('input', updateCount);
        updateCount();
    });

    /* Inline required-field feedback after leaving a field */
    document.querySelectorAll('input[required], textarea[required], select[required]').forEach(function (input) {
        input.addEventListener('blur', function () {
            var empty = input.value.trim() === '';
            input.setAttribute('aria-invalid', empty ? 'true' : 'false');
            input.classList.toggle('is-invalid', empty);

            var group = input.closest('.form-group');
            var message = group ? group.querySelector('[data-field-error-for="' + input.id + '"]') : null;
            if (message) {
                message.textContent = empty ? 'Wajib diisi.' : '';
                message.hidden = !empty;
            }
        });

        input.addEventListener('input', function () {
            if (input.value.trim() !== '') {
                input.setAttribute('aria-invalid', 'false');
                input.classList.remove('is-invalid');
                var group = input.closest('.form-group');
                var message = group ? group.querySelector('[data-field-error-for="' + input.id + '"]') : null;
                if (message) {
                    message.textContent = '';
                    message.hidden = true;
                }
            }
        });
    });

    /* Loading state / double-submit protection */
    document.querySelectorAll('form[data-loading]').forEach(function (form) {
        form.addEventListener('submit', function (event) {
            if (form.dataset.submitting === '1') {
                event.preventDefault();
                return;
            }

            form.dataset.submitting = '1';
            var buttons = form.querySelectorAll('button[type="submit"]');
            buttons.forEach(function (button) {
                if (!button.dataset.originalHtml) button.dataset.originalHtml = button.innerHTML;
                var label = button.getAttribute('data-loading-label');
                button.disabled = true;
                button.classList.add('is-loading');
                if (label) {
                    button.innerHTML = '<span class="loading-spinner" aria-hidden="true"></span><span>' + label + '</span>';
                }
                button.setAttribute('aria-busy', 'true');
            });
        });
    });

    /* Toasts */
    function closeToast(toast) {
        if (!toast) return;
        toast.classList.add('is-hiding');
        window.setTimeout(function () {
            if (toast.parentNode) toast.parentNode.removeChild(toast);
        }, 220);
    }

    document.querySelectorAll('[data-toast]').forEach(function (toast) {
        var close = toast.querySelector('[data-toast-close]');
        if (close) close.addEventListener('click', function () { closeToast(toast); });

        if (toast.getAttribute('data-toast-auto') === 'true') {
            window.setTimeout(function () { closeToast(toast); }, 4500);
        }
    });

    /* Accessible confirmation dialog for destructive actions */
    var confirmState = {
        overlay: null,
        title: null,
        detail: null,
        cancel: null,
        proceed: null,
        resolve: null,
        trigger: null
    };

    function createConfirmDialog() {
        if (confirmState.overlay) return;

        var overlay = document.createElement('div');
        overlay.className = 'confirm-overlay';
        overlay.hidden = true;
        overlay.innerHTML = '' +
            '<div class="confirm-dialog" role="dialog" aria-modal="true" aria-labelledby="confirmTitle" aria-describedby="confirmDetail">' +
                '<div class="confirm-icon" aria-hidden="true">!</div>' +
                '<h2 id="confirmTitle">Hapus data?</h2>' +
                '<p id="confirmDetail">Data yang sudah dihapus tidak dapat dikembalikan.</p>' +
                '<div class="confirm-actions">' +
                    '<button class="btn btn-secondary" type="button" data-confirm-cancel>Batal</button>' +
                    '<button class="btn btn-danger" type="button" data-confirm-proceed>Hapus</button>' +
                '</div>' +
            '</div>';
        document.body.appendChild(overlay);

        confirmState.overlay = overlay;
        confirmState.title = overlay.querySelector('#confirmTitle');
        confirmState.detail = overlay.querySelector('#confirmDetail');
        confirmState.cancel = overlay.querySelector('[data-confirm-cancel]');
        confirmState.proceed = overlay.querySelector('[data-confirm-proceed]');

        confirmState.cancel.addEventListener('click', function () { resolveConfirm(false); });
        confirmState.proceed.addEventListener('click', function () { resolveConfirm(true); });
        overlay.addEventListener('click', function (event) {
            if (event.target === overlay) resolveConfirm(false);
        });
        document.addEventListener('keydown', function (event) {
            if (!confirmState.overlay || confirmState.overlay.hidden) return;
            if (event.key === 'Escape') resolveConfirm(false);
        });
    }

    function openConfirm(options, resolve) {
        createConfirmDialog();
        confirmState.resolve = resolve;
        confirmState.trigger = document.activeElement;
        confirmState.title.textContent = options.title || 'Hapus data?';
        confirmState.detail.textContent = options.detail || options.message || 'Data yang sudah dihapus tidak dapat dikembalikan.';
        confirmState.overlay.hidden = false;
        document.body.classList.add('modal-open');
        window.setTimeout(function () { confirmState.cancel.focus(); }, 0);
    }

    function resolveConfirm(value) {
        if (!confirmState.overlay || confirmState.overlay.hidden) return;
        var resolve = confirmState.resolve;
        var trigger = confirmState.trigger;
        confirmState.resolve = null;
        confirmState.trigger = null;
        confirmState.overlay.hidden = true;
        document.body.classList.remove('modal-open');
        if (trigger && typeof trigger.focus === 'function') trigger.focus();
        if (resolve) resolve(value);
    }

    document.querySelectorAll('form[data-confirm]').forEach(function (form) {
        form.addEventListener('submit', function (event) {
            if (form.dataset.confirmed === '1') return;
            event.preventDefault();
            openConfirm({
                title: form.getAttribute('data-confirm-title'),
                detail: form.getAttribute('data-confirm-detail'),
                message: form.getAttribute('data-confirm')
            }, function (approved) {
                if (!approved) return;
                form.dataset.confirmed = '1';
                if (typeof form.requestSubmit === 'function') form.requestSubmit();
                else form.submit();
            });
        });
    });

    document.querySelectorAll('a[data-confirm]').forEach(function (link) {
        link.addEventListener('click', function (event) {
            event.preventDefault();
            var href = link.href;
            openConfirm({
                title: link.getAttribute('data-confirm-title'),
                detail: link.getAttribute('data-confirm-detail'),
                message: link.getAttribute('data-confirm')
            }, function (approved) {
                if (approved) window.location.href = href;
            });
        });
    });
})();
