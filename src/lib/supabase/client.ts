import { createBrowserClient } from "@supabase/ssr";

export function createClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  return createBrowserClient(
    url && url.startsWith("http") ? url : "https://placeholder.supabase.co",
    key && key !== "your-supabase-anon-key-here" ? key : "placeholder-key"
  );
}
