<?php 
/**
 * FILE: views/layout/footer.php
 * FUNGSI: Template penutup layout bersama SIPAS.
 * ALUR KERJA: Menutup struktur layout/HTML yang dibuka oleh header agar halaman memiliki satu kerangka dokumen yang konsisten.
 * INPUT / OUTPUT: Input: struktur HTML yang telah dibuka header. Output: penutup markup.
 * FILE/TABEL TERKAIT: views/layout/header.php, seluruh view
 * KEAMANAN OUTPUT: Teks dinamis di konteks HTML menggunakan e() untuk meng-escape karakter khusus dan membantu mencegah XSS; ID yang ditampilkan sebagai angka dikonversi ke integer.
 * CATATAN PEMBELAJARAN: komentar ini menjelaskan kode yang ada; perilaku program sengaja dipertahankan.
 */
if ($role): ?>
        </section>
    </main>
</div>
<?php else: ?>
</div>
<?php endif; ?>
</body>
</html>
