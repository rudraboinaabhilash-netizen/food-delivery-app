
"use client";

import { useState, type FormEvent } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { createClient } from "@supabase/supabase-js";

export default function SignupPage() {
  const router = useRouter();

  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [message, setMessage] = useState("");
  const [loading, setLoading] = useState(false);

  async function handleSignup(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setError("");
    setMessage("");

    if (!process.env.NEXT_PUBLIC_SUPABASE_URL ||
        !process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY) {
      setError("Supabase configuration is missing. Check your .env.local file.");
      return;
    }

    setLoading(true);

    try {
      const supabase = createClient(
        process.env.NEXT_PUBLIC_SUPABASE_URL!,
        process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
      );

      const { data, error } = await supabase.auth.signUp({
        email: email.trim(),
        password,
        options: {
          data: { name: name.trim() },
        },
      });

      if (error) {
        setError(error.message);
        return;
      }

      if (data.session) {
        router.replace("/");
        router.refresh();
      } else {
        setMessage(
          "Account created! Check your email for a confirmation link before logging in."
        );
      }
    } catch {
      setError("Unable to connect to Supabase. Check your configuration.");
    } finally {
      setLoading(false);
    }
  }

  return (
    <main className="flex min-h-screen items-center justify-center bg-orange-50 px-4 py-10">
      <form
        onSubmit={handleSignup}
        className="w-full max-w-md rounded-2xl bg-white p-8 shadow-xl"
      >
        <h1 className="text-center text-3xl font-extrabold text-orange-600">
          NANI Eats
        </h1>

        <h2 className="mt-6 text-2xl font-bold">Create your account</h2>
        <p className="mt-2 text-sm text-gray-500">
          Join NANI Eats and start ordering.
        </p>

        {error && (
          <p role="alert" className="mt-4 rounded-lg bg-red-50 p-3 text-sm text-red-700">
            {error}
          </p>
        )}

        {message && (
          <p role="status" className="mt-4 rounded-lg bg-green-50 p-3 text-sm text-green-700">
            {message}
          </p>
        )}

        <label className="mt-5 block text-sm font-semibold">
          Full name
          <input
            required
            autoComplete="name"
            value={name}
            onChange={(e) => setName(e.target.value)}
            className="mt-2 w-full rounded-lg border p-3"
            placeholder="Your full name"
          />
        </label>

        <label className="mt-4 block text-sm font-semibold">
          Email address
          <input
            required
            type="email"
            autoComplete="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="mt-2 w-full rounded-lg border p-3"
            placeholder="you@example.com"
          />
        </label>

        <label className="mt-4 block text-sm font-semibold">
          Password
          <input
            required
            type="password"
            minLength={6}
            autoComplete="new-password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="mt-2 w-full rounded-lg border p-3"
            placeholder="At least 6 characters"
          />
        </label>

        <button
          type="submit"
          disabled={loading}
          className="mt-6 w-full rounded-lg bg-orange-500 p-3 font-bold text-white hover:bg-orange-600 disabled:opacity-60"
        >
          {loading ? "Creating account..." : "Create account"}
        </button>

        <p className="mt-5 text-center text-sm text-gray-600">
          Already registered?{" "}
          <Link href="/login" className="font-bold text-orange-600">
            Login
          </Link>
        </p>
      </form>
    </main>
  );
}
