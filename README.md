# 🏗️ DMP AI Architectural Rendering Pro

AI diễn họa kiến trúc — chuyển ảnh 3D thô thành render chất lượng cao.

## Stack
- Next.js 14 (App Router)
- DALL·E 3 / Stable Diffusion XL / Replicate SDXL
- Claude Vision (phân tích & tạo prompt)
- Vercel + GitHub Actions CI/CD

## Cấu trúc
```
app/                          ← Next.js App Router (ở ROOT)
  layout.js
  page.js
  globals.css
  api/generate/route.js       ← DALL-E / Stability / Replicate
  api/validate-key/route.js   ← kiểm tra API key
.github/workflows/deploy.yml  ← CI/CD
next.config.js
package.json
vercel.json
```

## Deploy lên Vercel qua GitHub

### Bước 1 – Giải nén đúng cách
```bash
unzip dmp-render-pro.zip -d myproject
cd myproject
ls    # phải thấy: app/  next.config.js  package.json
```

### Bước 2 – Push GitHub
```bash
git init
git add .
git commit -m "init: DMP AI Render Pro"
git remote add origin https://github.com/YOUR_USER/dmp-render.git
git push -u origin main
```

### Bước 3 – Import Vercel
- Vào vercel.com → Add New Project → Import repo
- **Root Directory: để TRỐNG** (không điền gì)
- Framework: Next.js (tự detect)
- Nhấn Deploy

### Bước 4 – Environment Variables (Vercel Dashboard → Settings → Env Vars)
```
ANTHROPIC_API_KEY = sk-ant-...
OPENAI_API_KEY    = sk-...
STABILITY_API_KEY = sk-...
REPLICATE_API_KEY = r8_...
```

### Bước 5 – GitHub Actions CI/CD (tự động deploy khi push)
GitHub repo → Settings → Secrets → Actions:
- VERCEL_TOKEN      (vercel.com → Account → Tokens)
- VERCEL_ORG_ID     (chạy `vercel link`, xem .vercel/project.json)
- VERCEL_PROJECT_ID (như trên)

## Chạy local
```bash
npm install
cp .env.example .env.local
# điền API keys vào .env.local
npm run dev
# mở http://localhost:3000
```

## Lấy API Keys
| Provider | URL |
|----------|-----|
| OpenAI (DALL·E 3) | platform.openai.com/api-keys |
| Stability AI | platform.stability.ai/account/keys |
| Replicate | replicate.com/account/api-tokens |
| Anthropic | console.anthropic.com/keys |
