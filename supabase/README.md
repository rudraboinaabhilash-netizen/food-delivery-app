# Supabase setup
1. Create a Supabase project.
2. Run `schema.sql` in SQL Editor.
3. Run `seed.sql`.
4. In Authentication, enable Email provider.
5. Add Storage buckets: `restaurant-images`, `food-images`, `profile-images`.
6. Put project URL and anon key in `.env.local`.
7. Never expose `SUPABASE_SERVICE_ROLE_KEY` to client components.
8. For production, add storage RLS policies and role-management RPCs before opening owner/admin dashboards.
