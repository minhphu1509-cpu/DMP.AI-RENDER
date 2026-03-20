/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  images: {
    domains: ['oaidalleapiprodscus.blob.core.windows.net', 'replicate.delivery', 'pbxt.replicate.delivery'],
  },
  env: {
    NEXT_PUBLIC_APP_VERSION: '2.0.0',
  }
}

module.exports = nextConfig
