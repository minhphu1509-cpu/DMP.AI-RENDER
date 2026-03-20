-- ═══════════════════════════════════════════════════════════════════════════
-- DMP VISION — Supabase Database Schema
-- Run this in: Supabase Dashboard → SQL Editor → New query
-- ═══════════════════════════════════════════════════════════════════════════

-- ── PROJECTS TABLE ───────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.projects (
  id            BIGSERIAL PRIMARY KEY,
  user_id       UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  session_id    TEXT,                          -- anonymous session ID
  name          TEXT NOT NULL DEFAULT 'Untitled',
  mode          TEXT NOT NULL DEFAULT 'exterior'
                  CHECK (mode IN ('exterior','interior','moodboard','staging')),
  style         TEXT NOT NULL DEFAULT 'Minimalist',
  provider      TEXT,
  angles        INTEGER NOT NULL DEFAULT 1 CHECK (angles BETWEEN 1 AND 14),
  done_count    INTEGER NOT NULL DEFAULT 0 CHECK (done_count BETWEEN 0 AND 14),
  thumbnail_url TEXT,
  renders       JSONB DEFAULT '[]'::jsonb,
  custom_prompt TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── RENDER LOGS TABLE (analytics, no PII) ────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.render_logs (
  id           BIGSERIAL PRIMARY KEY,
  ip_hash      TEXT,                           -- hashed IP, not raw
  action       TEXT NOT NULL,
  provider     TEXT,
  prompt_length INTEGER,
  success      BOOLEAN NOT NULL DEFAULT TRUE,
  error_msg    TEXT,
  duration_ms  INTEGER,
  session_token TEXT,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── PROMPT LIBRARY TABLE ─────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.prompt_library (
  id          BIGSERIAL PRIMARY KEY,
  user_id     UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  session_id  TEXT,
  prompt      TEXT NOT NULL,
  mode        TEXT,
  style       TEXT,
  used_count  INTEGER NOT NULL DEFAULT 1,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── INDEXES ───────────────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_projects_user_id    ON public.projects(user_id);
CREATE INDEX IF NOT EXISTS idx_projects_session_id ON public.projects(session_id);
CREATE INDEX IF NOT EXISTS idx_projects_created_at ON public.projects(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_render_logs_created ON public.render_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_render_logs_ip      ON public.render_logs(ip_hash);
CREATE INDEX IF NOT EXISTS idx_prompts_user        ON public.prompt_library(user_id);

-- ── AUTO-UPDATE updated_at ────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$;
DROP TRIGGER IF EXISTS trg_projects_updated_at ON public.projects;
CREATE TRIGGER trg_projects_updated_at
  BEFORE UPDATE ON public.projects
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- ═══════════════════════════════════════════════════════════════════════════
-- ROW LEVEL SECURITY
-- ═══════════════════════════════════════════════════════════════════════════

-- ── PROJECTS RLS ─────────────────────────────────────────────────────────────
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;

-- Authenticated users: full CRUD on their own rows
CREATE POLICY "projects_select_own" ON public.projects
  FOR SELECT TO authenticated
  USING ((SELECT auth.uid()) = user_id);

CREATE POLICY "projects_insert_own" ON public.projects
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT auth.uid()) = user_id);

CREATE POLICY "projects_update_own" ON public.projects
  FOR UPDATE TO authenticated
  USING ((SELECT auth.uid()) = user_id)
  WITH CHECK ((SELECT auth.uid()) = user_id);

CREATE POLICY "projects_delete_own" ON public.projects
  FOR DELETE TO authenticated
  USING ((SELECT auth.uid()) = user_id);

-- Anonymous users: access by session_id only (server-side validated)
CREATE POLICY "projects_anon_select" ON public.projects
  FOR SELECT TO anon
  USING (user_id IS NULL AND session_id IS NOT NULL);

CREATE POLICY "projects_anon_insert" ON public.projects
  FOR INSERT TO anon
  WITH CHECK (user_id IS NULL AND session_id IS NOT NULL);

CREATE POLICY "projects_anon_delete" ON public.projects
  FOR DELETE TO anon
  USING (user_id IS NULL AND session_id IS NOT NULL);

-- ── RENDER LOGS RLS (write-only for service role) ────────────────────────────
ALTER TABLE public.render_logs ENABLE ROW LEVEL SECURITY;
-- Only service_role (server) can write logs; no client reads
CREATE POLICY "logs_service_only" ON public.render_logs
  FOR ALL TO service_role USING (true) WITH CHECK (true);

-- ── PROMPT LIBRARY RLS ───────────────────────────────────────────────────────
ALTER TABLE public.prompt_library ENABLE ROW LEVEL SECURITY;

CREATE POLICY "prompts_select_own" ON public.prompt_library
  FOR SELECT TO authenticated
  USING ((SELECT auth.uid()) = user_id);

CREATE POLICY "prompts_insert_own" ON public.prompt_library
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT auth.uid()) = user_id);

CREATE POLICY "prompts_delete_own" ON public.prompt_library
  FOR DELETE TO authenticated
  USING ((SELECT auth.uid()) = user_id);

-- Anon can manage own session prompts
CREATE POLICY "prompts_anon" ON public.prompt_library
  FOR ALL TO anon
  USING (user_id IS NULL AND session_id IS NOT NULL)
  WITH CHECK (user_id IS NULL AND session_id IS NOT NULL);

-- ═══════════════════════════════════════════════════════════════════════════
-- RATE LIMIT HELPER VIEW (for monitoring — service_role only)
-- ═══════════════════════════════════════════════════════════════════════════
CREATE OR REPLACE VIEW public.render_stats AS
SELECT
  DATE_TRUNC('hour', created_at) AS hour,
  COUNT(*) AS total_renders,
  COUNT(*) FILTER (WHERE success = TRUE)  AS successful,
  COUNT(*) FILTER (WHERE success = FALSE) AS failed,
  AVG(duration_ms) AS avg_duration_ms,
  COUNT(DISTINCT ip_hash) AS unique_ips
FROM public.render_logs
GROUP BY 1 ORDER BY 1 DESC;

-- Revoke public access to the view
REVOKE ALL ON public.render_stats FROM anon, authenticated;
GRANT SELECT ON public.render_stats TO service_role;

-- ═══════════════════════════════════════════════════════════════════════════
-- DONE ✓ 
-- After running this SQL, go to:
-- Authentication → Settings → Enable "Allow anonymous sign-ins" (optional)
-- ═══════════════════════════════════════════════════════════════════════════
