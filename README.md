# 🏗️ DMP AI Architectural Rendering Pro

Ứng dụng AI diễn họa kiến trúc — chuyển ảnh 3D thô thành render chất lượng cao.

## Stack
- **Next.js 14** (App Router, `app/` ở root)
- **DALL·E 3** / **Stable Diffusion XL** / **Replicate SDXL**
- **Claude Vision** (Anthropic) – phân tích & tạo prompt
- **Vercel** + **GitHub Actions** CI/CD

## Cấu trúc
```
dmp-render/
├── app/
│   ├── layout.js
│   ├── page.js
│   ├── globals.css
│   └── api/
│       ├── generate/route.js       ← DALL-E / Stability / Replicate
│       └── validate-key/route.js   ← kiểm tra API key
├── .github/workflows/deploy.yml   ← CI/CD auto-deploy
├── next.config.js
├── package.json
└── vercel.json
```

## Deploy lên Vercel qua GitHub

### Bước 1 – Push GitHub
```bash
git init && git add . && git commit -m "init"
git remote add origin https://github.com/YOUR_USER/dmp-render.git
git push -u origin main
```

### Bước 2 – Import Vercel
[vercel.com](https://vercel.com) → Add New Project → Import repo → Deploy

### Bước 3 – Environment Variables (Vercel Dashboard)
```
ANTHROPIC_API_KEY = sk-ant-...
OPENAI_API_KEY    = sk-...
STABILITY_API_KEY = sk-...
REPLICATE_API_KEY = r8_...
```

### Bước 4 – GitHub Actions CI/CD
GitHub repo → Settings → Secrets:
- `VERCEL_TOKEN` — lấy từ vercel.com → Account → Tokens
- `VERCEL_ORG_ID` — chạy `vercel link`, xem `.vercel/project.json`
- `VERCEL_PROJECT_ID` — như trên

## Chạy local
```bash
npm install
cp .env.example .env.local   # điền keys
npm run dev                  # http://localhost:3000
```
