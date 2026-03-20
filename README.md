# 🏗️ DMP AI Architectural Rendering Pro

Pure static HTML — **zero build step**. Deploy in 60 seconds.

## Tại sao static?
Next.js yêu cầu build step và đường dẫn cụ thể. File HTML này chạy trực tiếp không cần build.

## Deploy Vercel (60 giây)

### Cách 1 — Kéo thả (nhanh nhất)
1. Vào [vercel.com/new](https://vercel.com/new)
2. Kéo thả thư mục này vào → Deploy xong!

### Cách 2 — GitHub + Auto CI/CD
```bash
git init
git add .
git commit -m "init: DMP AI Render Pro"
git remote add origin https://github.com/YOUR_USER/dmp-render.git
git push -u origin main
```
Vào vercel.com → Import repo → **Framework: Other** → Deploy

Sau đó thêm GitHub Secret `VERCEL_TOKEN` để CI/CD tự động.

## Chạy local (không cần npm)
```bash
# Chỉ cần mở file
open index.html
# hoặc dùng server đơn giản
npx serve .
python3 -m http.server 3000
```

## API Keys
Nhập trực tiếp trong app (lưu localStorage) hoặc hardcode vào index.html.

| Provider | Lấy key tại |
|----------|-------------|
| OpenAI DALL·E 3 | platform.openai.com/api-keys |
| Stability AI | platform.stability.ai/account/keys |
| Replicate SDXL | replicate.com/account/api-tokens |
| Anthropic Claude | console.anthropic.com/keys |

## Lưu ý CORS
Một số provider (Stability AI, Replicate) không cho phép gọi API trực tiếp từ browser do CORS.
Nếu gặp lỗi CORS, dùng DALL·E 3 (OpenAI hỗ trợ CORS) hoặc deploy proxy đơn giản.
