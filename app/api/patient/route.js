import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
)

export async function POST(req) {
  const { name, email } = await req.json()

  const { data, error } = await supabase
    .from('patients')
    .insert([{ name, email }])
    .select()

  if (error) {
    return Response.json({ ok: false, error })
  }

  return Response.json({ ok: true, data })
}

export async function GET() {
  const { data, error } = await supabase
    .from('patients')
    .select('*')
    .order('created_at', { ascending: false })

  if (error) {
    return Response.json({ ok: false, error })
  }

  return Response.json({ ok: true, data })
}
