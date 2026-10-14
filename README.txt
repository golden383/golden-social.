# GOLDEN — free iPhone setup

This is a starter web app, not yet a public, fully launched social network. You can set it up from Safari on your iPhone using free tiers. No Replit or paid app is required for the starter.

## What is included
- Email/password signup and login
- User profiles and bios
- Text posts and image-by-URL posts
- Likes and comments
- Basic user search and follow action
- Basic one-to-one text messaging
- Starter Supabase Row Level Security policies

## Step 1 — Create a free Supabase project
1. In Safari, open https://supabase.com and create an account.
2. Create a new project on the free plan. Save the database password somewhere private.
3. In your project, open SQL Editor, choose New query, paste all of `schema.sql`, and press Run.
4. Open Project Settings → API (or Connect). Copy the Project URL and the anon/public key. Do NOT copy or share the service_role/secret key.

## Step 2 — Connect the app
1. Open `index.html` in an editor that lets you edit text/code, or use GitHub's browser editor.
2. Find `PASTE_YOUR_SUPABASE_PROJECT_URL_HERE` and replace it with your Project URL inside the quotation marks.
3. Find `PASTE_YOUR_SUPABASE_ANON_PUBLIC_KEY_HERE` and replace it with the anon/public key inside the quotation marks.
4. Save the file. The public anon key is designed to be used in the browser, but security depends on the database policies.

## Step 3 — Put it online free
A practical free static-hosting route is GitHub Pages:
1. Open https://github.com in Safari and create/sign in to a free account.
2. Create a public repository named `golden-social` (or another name).
3. Add the edited `index.html` as the repository's `index.html` file and commit it.
4. In the repository, open Settings → Pages. Choose deploy from the `main` branch and `/ (root)`, then Save.
5. Wait for GitHub Pages to publish. Your site URL will look like `https://YOUR-USERNAME.github.io/golden-social/`.

## Step 4 — Test before inviting anyone
1. Open the hosted URL in Safari.
2. Create an account with an email you can access and confirm the email if asked.
3. Test a post, a like, a comment, profile edit, follow, and messages between two test accounts.

## Important limits and safety
- This starter has no native iOS/Android binaries; it is a mobile website that can be added to the iPhone Home Screen with Safari → Share → Add to Home Screen.
- It is not ready for a public launch. Blocking/reporting, notifications, secure image uploads, private profiles, robust moderation, account deletion, spam prevention, and full security testing are not yet implemented.
- Image posts currently accept public image URLs, not uploads.
- The messages page is a basic manual-refresh chat, not a complete real-time messenger.
- Supabase free-tier limits can change. GitHub Pages is free for public repositories, but hosting terms can change.
- Never put a Supabase service_role/secret key in this HTML. Do not publish private data or invite users until the missing safety features and policies are completed.
