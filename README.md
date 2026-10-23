# NANI Eats

Modern food-delivery app starter built with Next.js, React, TypeScript, Tailwind CSS and Supabase.

## Run locally
1. Install Node.js 20+.
2. `npm install`
3. Copy `.env.local.example` to `.env.local`.
4. Add your Supabase URL and anon key.
5. Run `npm run dev`.
6. Open `http://localhost:3000`.

## Supabase
Run `supabase/schema.sql` and then `supabase/seed.sql` in the Supabase SQL editor. Configure email authentication and storage buckets (`restaurant-images`, `food-images`, `profile-images`) as needed.

## Important
The UI includes working local cart/order demonstration flows. Authentication and persistent database operations require the Supabase environment variables and the server/client integration to be wired to your project. Never expose the service-role key in browser code.

## Routes
/, /restaurants, /restaurants/[id], /cart, /checkout, /orders, /orders/[id], /login, /signup

The schema is designed for the broader customer, restaurant-owner, delivery-partner and admin roles described in the project specification.

## Full-stack structure
- Frontend: Next.js App Router + React + Tailwind
- Backend: Next.js Route Handlers under `app/api/*`
- Database/auth/realtime: Supabase PostgreSQL + Auth + Realtime
- Security: server-side Supabase client, middleware session refresh, database RLS
- Portals: `/admin`, `/restaurant-dashboard`, `/delivery-dashboard`
