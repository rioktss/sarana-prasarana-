(function () {
    'use strict';

    const mobileMenuBtn = document.querySelector('.mobile-menu');
    const sidebar = document.querySelector('.sidebar');

    if (mobileMenuBtn && sidebar) {
        const backdrop = document.createElement('div');
        backdrop.className = 'sidebar-backdrop';
        backdrop.hidden = true;
        document.body.appendChild(backdrop);

        function setMenu(open) {
            sidebar.classList.toggle('open', open);
            backdrop.hidden = !open || window.innerWidth > 800;
            document.body.classList.toggle('menu-open', open);
            mobileMenuBtn.setAttribute('aria-expanded', open ? 'true' : 'false');
        }

        mobileMenuBtn.setAttribute('aria-expanded', 'false');
        mobileMenuBtn.addEventListener('click', function (event) {
            event.stopPropagation();
            setMenu(!sidebar.classList.contains('open'));
        });

        backdrop.addEventListener('click', function () {
            setMenu(false);
        });

        sidebar.querySelectorAll('a').forEach(function (link) {
            link.addEventListener('click', function () {
                if (window.innerWidth <= 800) setMenu(false);
            });
        });

        window.addEventListener('resize', function () {
            if (window.innerWidth > 800) setMenu(false);
            else backdrop.hidden = !sidebar.classList.contains('open');
        });
    }

    // Pada layar kecil, ubah tabel menjadi kartu agar tidak perlu scroll ke samping.
    function makeTablesResponsive() {
        if (window.innerWidth > 650) return;
        document.querySelectorAll('.table').forEach(function (table) {
            const headers = Array.from(table.querySelectorAll('thead th')).map(function (th) {
                return th.textContent.trim();
            });
            table.querySelectorAll('tbody tr').forEach(function (row) {
                Array.from(row.children).forEach(function (cell, index) {
                    cell.setAttribute('data-label', headers[index] || '');
                });
            });
        });
    }

    function clearResponsiveTables() {
        if (window.innerWidth > 650) {
            document.querySelectorAll('.table td[data-label]').forEach(function (cell) {
                cell.removeAttribute('data-label');
            });
        } else {
            makeTablesResponsive();
        }
    }

    makeTablesResponsive();
    window.addEventListener('resize', clearResponsiveTables);

    document.querySelectorAll('[data-confirm]').forEach(function (el) {
        el.addEventListener('click', function (e) {
            const message = el.getAttribute('data-confirm');
            if (!confirm(message)) e.preventDefault();
        });
    });
})();
