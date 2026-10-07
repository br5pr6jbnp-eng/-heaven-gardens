# Heaven Gardens v2 — موقع كتالوج وطلبات

نسخة احترافية من الموقع القديم (ملف `index.html` واحد حجمه 3.3 MB) إلى مشروع Full-Stack.

## الهيكل واللغات
| الطبقة | اللغة / الأداة |
|---|---|
| الخادم (API + الصفحات + SEO) | TypeScript على Node 22 — بدون أي مكتبات خارجية |
| قاعدة البيانات | SQLite (SQL) بوضع WAL — الطلبات محفوظة على السيرفر |
| الواجهة | TypeScript (ES modules) + CSS |
| منطق الأسعار | TypeScript مشترك بين الواجهة والخادم (مصدر واحد للحقيقة) |
| تجهيز البيانات والصور | Python (`tools/extract.py`) → WebP |
| الاختبارات | node:test (TS) + Playwright (JS) + اختبار ضغط (JS) |
| النشر | Dockerfile + docker-compose + nginx (كاش وحماية) |

## التشغيل
```bash
npm install
npm run build
ADMIN_TOKEN=كلمة-سر-طويلة SITE_URL=https://your-domain.com npm start   # http://localhost:3000
npm test           # اختبارات الوحدة والـ API
npm run load       # اختبار ضغط (السيرفر لازم يكون شغال)
docker compose up -d --build
```

## متغيرات البيئة
`PORT` (3000) · `DB_PATH` · `SITE_URL` · `WHATSAPP_NUMBER` · `ADMIN_TOKEN` (بدونه لوحة الإدارة مقفولة) · `TRUST_PROXY=1` خلف nginx · `API_LIMIT_PER_MIN` · `MAX_CONNECTIONS`

## الإدارة (فواتير كل العملاء)
```bash
curl -H "Authorization: Bearer $ADMIN_TOKEN" $SITE/api/admin/orders        # آخر الطلبات
curl -H "Authorization: Bearer $ADMIN_TOKEN" $SITE/api/admin/customers     # إجمالي كل عميل
curl -H "Authorization: Bearer $ADMIN_TOKEN" $SITE/api/admin/orders.csv -o orders.csv   # يفتح في Excel
```

## تعديل المنتجات
عدّل `data/products.json` (الأسعار من `cartonPrice` و`piecePrice`) وضع الصور في `public/img/` بالأسماء `id-1.webp` و`id-1-sm.webp` ثم أعد تشغيل السيرفر.
