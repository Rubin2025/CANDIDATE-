CANDIDATE- — ANONYMOUS CENTRALIZED ELECTION

Candidates
----------
1. LIMBAYA DIEU DONNE (LIMBAX)
2. GEDEON BOBOTO MINGA

Rules
-----
- Maximum 30 votes.
- Each voter enters a name, but the name is NEVER stored with the ballot.
- Each voter receives one unique code.
- Each code can be used exactly once.
- Admin sees aggregate totals only.
- Admin cannot see who selected which candidate.
- Responsive on phones, tablets and computers.

DEPLOYMENT
----------
1. Create a NEW Supabase project.
2. Open Supabase SQL Editor and run schema.sql.
3. Set the Netlify environment variables:
   SUPABASE_URL = your Supabase project URL
   SUPABASE_SERVICE_ROLE_KEY = your Supabase service-role key
   ADMIN_PASSWORD = a strong private admin password
4. Deploy this repository to Netlify.
5. Voter page: /
6. Admin page: /admin.html

IMPORTANT
---------
Never commit SUPABASE_SERVICE_ROLE_KEY or ADMIN_PASSWORD to GitHub.
Keep this repository public only because it contains no secrets.
The 30 voter codes are in TOKENS.txt. Distribute exactly one code privately to each voter.
