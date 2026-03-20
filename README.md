# 🏗️ DMP AI Architectural Rendering Pro

Ứng dụng AI diễn họa kiến trúc chuyên nghiệp – chuyển đổi ảnh 3D thô thành hình ảnh diễn họa chất lượng cao sử dụng DALL·E 3, Stable Diffusion XL, Replicate, và Claude AI.

---

## ✨ Tính năng

- **Đa nền tảng AI** – DALL·E 3 (OpenAI), Stable Diffusion XL (Stability AI), SDXL (Replicate)
- **Claude Vision** – Phân tích mô hình 3D và tạo prompt chuyên nghiệp
- **14 góc nhìn camera** – Từ mặt chính đến hoàng hôn, ban đêm, marketing
- **Quản lý API Keys** – Lưu cục bộ, validate, chuyển đổi provider ngay trong app
- **img2img** – Stability AI và Replicate giữ nguyên hình khối gốc
- **Lịch sử dự án** – Lưu tự động 30 dự án gần nhất
- **Deploy Vercel** – CI/CD tự động qua GitHub Actions

---

## 🚀 Hướng dẫn Deploy lên Vercel qua GitHub

### Bước 1 – Tạo repo GitHub

```bash
# Khởi tạo git
cd dmp-render
git init
git add .
git commit -m "feat: initial DMP AI Render Pro"

# Tạo repo mới trên github.com rồi push
git remote add origin https://github.com/YOUR_USERNAME/dmp-render.git
git branch -M main
git push -u origin main
```

### Bước 2 – Kết nối Vercel với GitHub

1. Truy cập [vercel.com](https://vercel.com) → **Add New Project**
2. Import repo `dmp-render` từ GitHub
3. Framework: **Next.js** (tự động detect)
4. Nhấn **Deploy**

### Bước 3 – Cấu hình Environment Variables trên Vercel

Vào **Project Settings → Environment Variables**, thêm:

| Key | Value | Environment |
|-----|-------|-------------|
| `ANTHROPIC_API_KEY` | `sk-ant-...` | Production |
| `OPENAI_API_KEY` | `sk-...` | Production |
| `STABILITY_API_KEY` | `sk-...` | Production |
| `REPLICATE_API_KEY` | `r8_...` | Production |

> **Lưu ý:** Nếu không muốn set server-side, user có thể nhập key trực tiếp trong app (lưu localStorage).

### Bước 4 – Cấu hình GitHub Actions (CI/CD tự động)

Lấy các secrets từ Vercel:

```bash
# Cài Vercel CLI
npm i -g vercel
vercel login
vercel link  # → lấy Project ID và Org ID
```

Vào **GitHub repo → Settings → Secrets and variables → Actions**, thêm:

| Secret | Cách lấy |
|--------|----------|
| `VERCEL_TOKEN` | vercel.com → Account Settings → Tokens |
| `VERCEL_ORG_ID` | `.vercel/project.json` → `orgId` |
| `VERCEL_PROJECT_ID` | `.vercel/project.json` → `projectId` |

Sau đó mỗi lần `git push origin main` → **tự động deploy Vercel** 🎉

---

## 💻 Chạy Local

```bash
# Clone
git clone https://github.com/YOUR_USERNAME/dmp-render.git
cd dmp-render

# Cài packages
npm install

# Tạo file env
cp .env.example .env.local
# → Điền API keys vào .env.local

# Chạy dev
npm run dev
# → http://localhost:3000
```

---

## 🔑 API Keys – Hướng dẫn lấy

| Provider | URL | Ghi chú |
|----------|-----|---------|
| **OpenAI (DALL·E 3)** | [platform.openai.com/api-keys](https://platform.openai.com/api-keys) | Cần nạp credit |
| **Stability AI** | [platform.stability.ai/account/keys](https://platform.stability.ai/account/keys) | Free tier có sẵn |
| **Replicate** | [replicate.com/account/api-tokens](https://replicate.com/account/api-tokens) | Pay per use |
| **Anthropic (Claude)** | [console.anthropic.com/keys](https://console.anthropic.com/keys) | Dùng để phân tích |

---

## 📁 Cấu trúc dự án

```
dmp-render/
├── app/
│   ├── page.js              # Main UI
│   ├── page.module.css      # Styles
│   ├── layout.js            # Root layout
│   ├── globals.css          # Global CSS
│   └── api/
│       ├── generate/
│       │   └── route.js     # Image generation (DALL·E 3, Stability, Replicate)
│       └── validate-key/
│           └── route.js     # API key validation
├── .github/
│   └── workflows/
│       └── deploy.yml       # GitHub Actions CI/CD
├── .env.example             # Template env file
├── vercel.json              # Vercel config (region: sin1)
├── next.config.js
└── package.json
```

---

## 🛠️ Tech Stack

- **Framework:** Next.js 14 (App Router)
- **Styling:** CSS Modules
- **AI Image:** DALL·E 3, Stable Diffusion XL, SDXL via Replicate
- **AI Analysis:** Claude claude-opus-4-5 (Anthropic)
- **Deploy:** Vercel + GitHub Actions
- **Storage:** localStorage (API keys & history)

---

## 📄 License

MIT © DMP Architecture Studio
